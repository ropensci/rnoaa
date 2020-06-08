#' Get all GHCND data from a single weather site
#'
#' This function uses ftp to access the Global Historical Climatology Network
#' daily weather data from NOAA's FTP server for a single weather site. It
#' requires the site identification number for that site and will pull the
#' entire weather dataset for the site.
#'
#' @export
#' @param stationid (character) A character string giving the identification of
#' the weather station for which the user would like to pull data. To get a full
#' and current list of stations, the user can use the \code{\link{ghcnd_stations}}
#' function. To identify stations within a certain radius of a location, the
#' user can use the \code{\link{meteo_nearby_stations}} function.
#' @param path (character) a path to a file with a \code{.dly} extension - already
#' downloaded on your computer
#' @param refresh (logical) If \code{TRUE} force re-download of data.
#' Default: \code{FALSE}
#' @param ... In the case of \code{ghcnd} additional curl options to pass
#' through to \code{\link[crul]{HttpClient}}. In the case of \code{ghcnd_read}
#' further options passed on to \code{read.csv}
#'
#' @return A tibble (data.frame) which contains data pulled from NOAA's FTP
#' server for the queried weather site. A README file with more information
#' about the format of this file is available from NOAA
#' (\url{http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/readme.txt}).
#' This file is formatted so each line of the file gives the daily weather
#' observations for a single weather variable for all days of one month of
#' one year. In addition to measurements, columns are included for certain
#' flags, which add information on observation sources and quality and are
#' further explained in NOAA's README file for the data.
#'
#' @details  This function saves the full set of weather data for the queried
#' site locally in the directory specified by the \code{path} argument.
#'
#' You can access the path for the cached file via \code{attr(x, "source")}
#'
#' You can access the last modified time for the cached file via
#' \code{attr(x, "file_modified")}
#'
#' Messages are printed to the console about file path and file last modified time
#' which you can suppress with \code{suppressMessages()}
#'
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com},
#' Adam Erickson \email{adam.erickson@@ubc.ca}
#'
#' @seealso To generate a weather dataset for a single weather site that has
#' been cleaned to a tidier weather format, the user should use the
#' \code{\link{ghcnd_search}} function, which calls \code{\link{ghcnd}} and then
#' processes the output, or \code{\link{meteo_tidy_ghcnd}}, which wraps the
#' \code{\link{ghcnd_search}} function to output a tidy dataframe. To pull
#' GHCND data from multiple monitors, see \code{\link{meteo_pull_monitors}}.
#' @note See [ghcnd_cache] for managing cached files
#' @examples \dontrun{
#' # Get data
#' ghcnd(stationid = "AGE00147704")
#'
#' stations <- ghcnd_stations()
#' ghcnd(stations$id[40])
#'
#' library("dplyr")
#' ghcnd(stations$id[80300]) %>% select(id, element) %>% slice(1:3)
#'
#' # manipulate data
#' ## using built in fxns
#' dat <- ghcnd(stationid = "AGE00147704")
#' (alldat <- ghcnd_splitvars(dat))
#'
#' ## using dplyr
#' library("dplyr")
#' dat <- ghcnd(stationid = "AGE00147704")
#' filter(dat, element == "PRCP", year == 1909)
#'
#' # refresh the cached file
#' ghcnd(stationid = "AGE00147704", refresh = TRUE)
#'
#' # Read in a .dly file you've already downloaded
#' path <- system.file("examples/AGE00147704.dly", package = "rnoaa")
#' ghcnd_read(path)
#' }
ghcnd <- function(stationid, refresh = FALSE, ...) {
  out <- lapply(stationid, function(stationid) {
    csvpath <- ghcnd_local(stationid)
    if (!is_ghcnd(x = csvpath) || refresh) {
      res <- ghcnd_GET(stationid, ...)
    } else {
      cache_mssg(csvpath)
      res <- read.csv(csvpath, stringsAsFactors = FALSE,
                      colClasses = ghcnd_col_classes)
    }
    fi <- file.info(csvpath)
    res <- remove_na_row(res) # remove trailing row of NA's
    res <- tibble::as_tibble(res)
    attr(res, 'source') <- csvpath
    attr(res, 'file_modified') <- fi[['mtime']]
    return(res)
  })
  
  res <- tibble::as_tibble(data.table::rbindlist(out))
  attr(res, 'source') <- unlist(lapply(out, function(x) attr(x, "source")))
  attr(res, 'file_modified') <- unlist(lapply(out, function(x) attr(x, "file_modified")))
  res
}


#' @export
#' @rdname ghcnd
ghcnd_read <- function(path, ...) {
  if (!file.exists(path)) stop("file does not exist")
  if (!grepl("\\.dly", path)) {
    warning(".dly extension not detected; file may not be read correctly")
  }
  res <- read.csv(path, stringsAsFactors = FALSE,
                  colClasses = ghcnd_col_classes, ...)
  res <- tibble::as_tibble(res)
  attr(res, 'source') <- path
  return(res)
}

#' Split variables in data returned from \code{ghcnd}
#'
#' This function is a helper function for \code{\link{ghcnd_search}}. It helps
#' with cleaning up the data returned from \code{\link{ghcnd}}, to get it in a
#' format that is easier to work with.
#' @param x An object returned from \code{\link{ghcnd}}.
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com},
#' Adam Erickson \email{adam.erickson@@ubc.ca}
#' @note See [ghcnd()] examples
#' @export
ghcnd_splitvars <- function(x){
  if (!inherits(x, "data.frame")) stop("input must be a data.frame", call. = FALSE)
  if (!"id" %in% names(x)) stop("input not of correct format", call. = FALSE)
  x <- x[!is.na(x$id), ]
  out <- lapply(as.character(unique(x$element)), function(y){
    ydat <- x[ x$element == y, ]

    dd <- ydat %>%
      dplyr::select(-dplyr::contains("FLAG")) %>%
      tidyr::gather(var, value, -id, -year, -month, -element) %>%
      dplyr::mutate(
        day = strex(var),
        date = as.Date(sprintf("%s-%s-%s", year, month, day), "%Y-%m-%d")) %>%
      dplyr::filter(!is.na(date)) %>%
      dplyr::select(
        -element,
        -var,
        -year,
        -month,
        -day)
    dd <- stats::setNames(dd, c("id", tolower(y), "date"))

    mflag <- ydat %>%
      dplyr::select(-dplyr::contains("VALUE"), -dplyr::contains("QFLAG"),
                    -dplyr::contains("SFLAG")) %>%
      tidyr::gather(var, value, -id, -year, -month, -element) %>%
      dplyr::mutate(
        day = strex(var),
        date = as.Date(sprintf("%s-%s-%s", year, month, day), "%Y-%m-%d")) %>%
      dplyr::filter(!is.na(date)) %>%
      dplyr::select(value) %>%
      dplyr::rename(mflag = value)

    qflag <- ydat %>%
      dplyr::select(-dplyr::contains("VALUE"), -dplyr::contains("MFLAG"),
                    -dplyr::contains("SFLAG")) %>%
      tidyr::gather(var, value, -id, -year, -month, -element) %>%
      dplyr::mutate(
        day = strex(var),
        date = as.Date(sprintf("%s-%s-%s", year, month, day), "%Y-%m-%d")) %>%
      dplyr::filter(!is.na(date)) %>%
      dplyr::select(value) %>%
      dplyr::rename(qflag = value)

    sflag <- ydat %>%
      dplyr::select(-dplyr::contains("VALUE"), -dplyr::contains("QFLAG"),
                    -dplyr::contains("MFLAG")) %>%
      tidyr::gather(var, value, -id, -year, -month, -element) %>%
      dplyr::mutate(
        day = strex(var),
        date = as.Date(sprintf("%s-%s-%s", year, month, day), "%Y-%m-%d")) %>%
      dplyr::filter(!is.na(date)) %>%
      dplyr::select(value) %>%
      dplyr::rename(sflag = value)

    tibble::as_tibble(cbind(dd, mflag, qflag, sflag))
  })
  stats::setNames(out, tolower(unique(x$element)))
}

## helpers -------
ghcnd_col_classes <- c(
  "character", "integer", "integer", "character",
  rep(c("integer", "character", "character", "character"), times = 31)
)

remove_na_row <- function(x) {
  if (!any(x[,1] == "NA") && !any(is.na(x[,1]))) return(x)
  return(x[!as.character(x[,1]) %in% c("NA", NA_character_), ])
}

strex <- function(x) str_extract_(x, "[0-9]+")
as_tc <- function(x) textConnection(enc2utf8(rawToChar(x)))
as_tc_p <- function(x) textConnection(x$parse("latin1"))

ghcnd_GET <- function(stationid, ...){
  ghcnd_cache$mkdir()
  fp <- ghcnd_local(stationid)
  cli <- crul::HttpClient$new(ghcnd_remote(stationid), opts = list(...))
  res <- suppressWarnings(cli$get())
  tt <- res$parse("UTF-8")
  vars <- c("id","year","month","element",
            do.call("c",
      lapply(1:31, function(x) paste0(c("VALUE","MFLAG","QFLAG","SFLAG"), x))))
  df <- read.fwf(textConnection(tt), c(11,4,2,4,rep(c(5,1,1,1), 31)),
                 na.strings = "-9999")
  df[] <- Map(function(a, b) {
    if (b == "integer") {
      a <- as.character(a)
    }
    suppressWarnings(eval(parse(text = paste0("as.", b)))(a))
  }, df, ghcnd_col_classes)
  dat <- stats::setNames(df, vars)
  write.csv(dat, fp, row.names = FALSE)
  return(dat)
}

ghcndbase <- function() "ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/all"
ghcnd_remote <- function(stationid) {
  file.path(ghcndbase(), paste0(stationid, ".dly"))
}
ghcnd_local <- function(stationid) {
  file.path(ghcnd_cache$cache_path_get(), paste0(stationid, ".dly"))
}
is_ghcnd <- function(x) if (file.exists(x)) TRUE else FALSE
str_extract_ <- function(string, pattern) {
  regmatches(string, regexpr(pattern, string))
}
str_extract_all_ <- function(string, pattern) {
  regmatches(string, gregexpr(pattern, string))
}
