#' Get all GHCND data from a single weather site
#'
#' This function uses ftp to access the Global Historical Climatology Network
#' daily weather data from NOAA's FTP server for a single weather site. It
#' requires the site identification number for that site and will pull the
#' entire weather dataset for the site.
#'
#' @export
#' @param stationid (character) A character vector giving the identification of
#' the weather stations for which the user would like to pull data. To get a full
#' and current list of stations, the user can use the [ghcnd_stations()]
#' function. To identify stations within a certain radius of a location, the
#' user can use the [meteo_nearby_stations()] function.
#' @param path (character) a path to a file with a \code{.dly} extension - already
#' downloaded on your computer
#' @param refresh (logical) If `TRUE` force re-download of data.
#' Default: `FALSE`
#' @param ... In the case of `ghcnd()` additional curl options to pass
#' through to [crul::HttpClient]. In the case of `ghcnd_read`
#' further options passed on to `read.csv`
#'
#' @return A tibble (data.frame) which contains data pulled from NOAA's FTP
#' server for the queried weather site. A README file with more information
#' about the format of this file is available from NOAA
#' (https://www1.ncdc.noaa.gov/pub/data/ghcn/daily/readme.txt).
#' This file is formatted so each line of the file gives the daily weather
#' observations for a single weather variable for all days of one month of
#' one year. In addition to measurements, columns are included for certain
#' flags, which add information on observation sources and quality and are
#' further explained in NOAA's README file for the data.
#' 
#' @section Base URL:
#' The base url for data requests can be changed. The allowed urls are:
#' https://www1.ncdc.noaa.gov/pub/data/ghcn/daily/all (default),
#' https://ncei.noaa.gov/pub/data/ghcn/daily/all
#' 
#' You can set the base url using the `RNOAA_GHCND_BASE_URL` environment
#' variable; see example below.
#' 
#' The reason for this is that sometimes one base url source is temporarily
#' down, but another base url may work. It doesn't make sense to allow 
#' an arbitrary base URL; open an issue if there is another valid 
#' base URL for GHNCD data that we should add to the allowed set of base urls.
#'
#' @details  This function saves the full set of weather data for the queried
#' site locally in the directory specified by the `path` argument.
#'
#' You can access the path for the cached file via `attr(x, "source")`
#'
#' You can access the last modified time for the cached file via
#' `attr(x, "file_modified")`
#'
#' Messages are printed to the console about file path and file last modified time
#' which you can suppress with \code{suppressMessages()}
#' 
#' For those station ids that are not found, we will delete the file locally
#' so that a bad station id file is not cached. The returned data for a bad
#' station id will be an empty data.frame and the attributes are empty strings.
#'
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com},
#' Adam Erickson \email{adam.erickson@@ubc.ca}
#'
#' @seealso To generate a weather dataset for a single weather site that has
#' been cleaned to a tidier weather format, the user should use the
#' [ghcnd_search()] function, which calls `ghcnd()` and then
#' processes the output, or [meteo_tidy_ghcnd()], which wraps the
#' [ghcnd_search()] function to output a tidy dataframe. To pull
#' GHCND data from multiple monitors, see [meteo_pull_monitors()]
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
#' 
#' # change the base url for data requests
#' Sys.setenv(RNOAA_GHCND_BASE_URL =
#'   "https://ncei.noaa.gov/pub/data/ghcn/daily/all")
#' ghcnd(stations$id[45], verbose = TRUE)
#' ## must be in the allowed set of urls
#' # Sys.setenv(RNOAA_GHCND_BASE_URL = "https://google.com")
#' # ghcnd(stations$id[58], verbose = TRUE)
#' }
ghcnd <- function(stationid, refresh = FALSE, ...) {
  out <- lapply(stationid, function(this_station) {
    csvpath <- ghcnd_local(this_station)
    if (!is_ghcnd(x = csvpath) || refresh) {
      res <- ghcnd_GET(this_station, ...)
    } else {
      cache_mssg(csvpath)
      res <- read.csv(csvpath, stringsAsFactors = FALSE,
                      colClasses = ghcnd_col_classes)
    }
    fi <- file.info(csvpath)
    if (!is.na(fi$size)) res <- remove_na_row(res)
    res <- tibble::as_tibble(res)
    attr(res, 'source') <- if (!is.na(fi$size)) csvpath else ""
    attr(res, 'file_modified') <- 
      if (!is.na(fi$size)) as.character(fi[['mtime']]) else ""
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

#' Split variables in data returned from `ghcnd`
#'
#' This function is a helper function for [ghcnd_search()]. It helps
#' with cleaning up the data returned from [ghcnd()], to get it in a
#' format that is easier to work with.
#' @param x An object returned from [ghcnd()]
#' @author Scott Chamberlain, Adam Erickson, Elio Campitelli
#' @note See [ghcnd()] examples
#' @export
ghcnd_splitvars <- function(x){
  if (!inherits(x, "data.frame")) stop("input must be a data.frame", call. = FALSE)
  if (!"id" %in% names(x)) stop("input not of correct format", call. = FALSE)
  x <- x[!is.na(x$id), ]
  patterns <- NULL
  mflag <- NULL
  qflag <- NULL
  sflag <- NULL
  
  out <- data.table::melt(data.table::as.data.table(x), id.vars = c("id", "year", "month", "element"),
                          variable.name = "day",
                          measure.vars = patterns(value = "VALUE",
                                                  mflag = "MFLAG",
                                                  qflag = "QFLAG",
                                                  sflag = "SFLAG")) %>% 
    dplyr::as_tibble() %>% 
    dplyr::mutate(date = as.Date(sprintf("%s-%s-%s", year, month, day), "%Y-%m-%d"))  %>% 
    dplyr::filter(!is.na(date)) %>% 
    dplyr::select(-day, -month, -year) %>% 
    dplyr::mutate(element = tolower(element)) %>% 
    dplyr::select(id, value, date, mflag, qflag, sflag, element)
  
  out <- split(out, out$element, drop = TRUE)
  out <- lapply(out, function(y) {
    colnames(y)[colnames(y) == "value"] <- unique(y$element)
    dplyr::select(y, -element)
  })
  
  return(out[tolower(unique(x$element))])
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
  if (!res$success()) return(data.frame())
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

ghcnd_allowed_urls <- c(
  "https://www1.ncdc.noaa.gov/pub/data/ghcn/daily/all",
  "https://ncei.noaa.gov/pub/data/ghcn/daily/all"
)
ghcndbase <- function() {
  x <- Sys.getenv("RNOAA_GHCND_BASE_URL", "")
  if (identical(x, "")) {
    x <- ghcnd_allowed_urls[1]
  }
  if (!x %in% ghcnd_allowed_urls) {
    stop("the RNOAA_GHCND_BASE_URL environment variable must be in set:\n",
      paste0(ghcnd_allowed_urls, collapse = "  \n"))
  }
  return(x)
}
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

.datatable.aware = TRUE
