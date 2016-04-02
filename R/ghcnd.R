#' Get all GHCND data from a single weather site
#'
#' This function uses ftp to access the Global Historical Climatology Network
#' daily weather data from NOAA's FTP server for a single weather site. It
#' requires the site identification number for that site and will pull the
#' entire weather dataset for the site.
#'
#' To generate a weather dataset for a single weather site that has been
#' cleaned to a tidier weather format, the user should use the
#' \code{\link{ghcnd_search}} function, which calls \code{\link{ghcnd}} and then
#' processes the output rather than using this function directly.
#'
#' @param stationid A character vector giving the identification of the weather
#'    station for which the user would like to pull data. To get a full and
#'    current list of stations, the user can use the \code{\link{ghcnd_stations}}
#'    function.
#' @param path A character vector giving the path to the directory to cache
#'    the files locally. By default, the function uses \code{~/.rnoaa/isd}.
#' @param ... Additional curl options to pass through to \code{\link[httr]{GET}}.
#'
#' @return A list object with a single slot, \code{data}, which contains the
#'    dataframe pulled from NOAA's FTP for the queried weather site. A README
#'    file with more information about the format of this file is available
#'    from NOAA (\url{http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/readme.txt}).
#'    This file is formatted so each line of the file gives the daily weather
#'    observations for a single weather variable for all days of one month of
#'    one year. In addition to measurements, columns are included for certain
#'    flags, which add information on observation sources and quality and are
#'    further explained in NOAA's README file for the data.
#'
#' @note This function saves the full set of weather data for the queried
#' site locally and [more about caching magic here and what the user should
#' do, if anything, to clean up after running].
#'
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com},
#' Adam Erickson \email{adam.erickson@@ubc.ca}
#'
#' @references
#'
#' The following reference has more information on this data:
#'
#' Menne, M.J., I. Durre, R.S. Vose, B.E. Gleason, and T.G. Houston, 2012:
#' An overview of the Global Historical Climatology Network-Daily Database.
#' Journal of Atmospheric and Oceanic Technology, 29, 897-910,
#' doi:10.1175/JTECH-D-11-00103.1.
#'
#' @seealso \code{\link{ghcnd_search}}
#'
#' @examples
#' \dontrun{
#' # Get data
#' ghcnd(stationid = "AGE00147704")
#'
#' stations <- ghcnd_stations()
#' ghcnd(stations$data$id[40])
#' ghcnd(stations$data$id[4000])
#' ghcnd(stations$data$id[10000])
#' ghcnd(stations$data$id[80000])
#' ghcnd(stations$data$id[80300])
#'
#' library("dplyr")
#' ghcnd(stations$data$id[80300])$data %>% select(id, element) %>% head
#'
#' # manipulate data
#' ## using built in fxns
#' dat <- ghcnd(stationid="AGE00147704")
#' (alldat <- ghcnd_splitvars(dat))
#' library("ggplot2")
#' ggplot(subset(alldat$tmax, tmax >= 0), aes(date, tmax)) + geom_point()
#'
#' ## using dplyr
#' library("dplyr")
#' dat <- ghcnd(stationid="AGE00147704")
#' dat$data %>%
#'  filter(element == "PRCP", year == 1909)
#'
#' }
#'
#' @export
ghcnd <- function(stationid, path = "~/.rnoaa/ghcnd", ...){
  csvpath <- ghcnd_local(stationid, path)
  if (!is_ghcnd(x = csvpath)) {
    structure(list(data = ghcnd_GET(path, stationid, ...)), class = "ghcnd", source = csvpath)
  } else {
    structure(list(data = read.csv(csvpath, stringsAsFactors = FALSE)), class = "ghcnd", source = csvpath)
  }
}

#' Get GHCND daily data from NOAA FTP server
#'
#' @export
#'
#' @param stationid Stationid to get
#' @param path (character) A path to store the files, Default: \code{~/.rnoaa/isd}
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @param n Number of rows to print
#' @param x Input object to print methods. For \code{ghcnd_splitvars()}, the output of a call
#' to \code{ghcnd()}.
#' @param date_min,date_max (character) Minimum and maximum dates. Use together to get a
#' date range
#' @param var (character) Variable to get, defaults to "all", which gives back all variables
#' in a list. To see what variables are available for a dataset, look at the dataset returned
#' from \code{ghcnd()}.
#'
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com},
#' Adam Erickson \email{adam.erickson@@ubc.ca}
#'
#' @details Functions:
#' \itemize{
#'  \item \code{ghcnd_version} - Get current version of GHCND data
#'  \item \code{ghcnd_stations} - Get GHCND stations and their metadata
#'  \item \code{ghcnd_states} - Get US/Canada state names and 2-letter codes
#'  \item \code{ghcnd_countries} - Get country names and 2-letter codes
#'  \item \code{ghcnd_search} - Search GHCND data
#'  \item \code{ghcnd} - Get GHCND data
#'  \item \code{ghcnd_splitvars} - Split variables in data returned from \code{ghcnd}
#'  \item \code{ghcnd_clear_cache} - Clear cache of locally stored files
#' }
#'
#' @examples \dontrun{
#' # Get metadata
#' ghcnd_states()
#' ghcnd_countries()
#' ghcnd_version()
#'
#' # Get stations, ghcnd-stations and ghcnd-inventory merged
#' (stations <- ghcnd_stations())
#'
#' # Search based on variable and/or date
#' ghcnd_search("AGE00147704", var = "PRCP")
#' ghcnd_search("AGE00147704", var = "PRCP", date_min = "1920-01-01")
#' ghcnd_search("AGE00147704", var = "PRCP", date_max = "1915-01-01")
#' ghcnd_search("AGE00147704", var = "PRCP", date_min = "1920-01-01", date_max = "1925-01-01")
#' ghcnd_search("AGE00147704", date_min = "1920-01-01", date_max = "1925-01-01")
#' ghcnd_search("AGE00147704", var = c("PRCP","TMIN"))
#' ghcnd_search("AGE00147704", var = c("PRCP","TMIN"), date_min = "1920-01-01")
#' ghcnd_search("AGE00147704", var="adfdf")
#' }
#' @export
ghcnd_search <- function(stationid, date_min = NULL, date_max = NULL, var = "all",
                         path = "~/.rnoaa/ghcnd", ...){

  dat <- ghcnd_splitvars(ghcnd(stationid, path = path))
  possvars <- paste0(names(dat), collapse = ", ")

  if (any(var != "all")) {
    vars_null <- sort(tolower(var))[!sort(tolower(var)) %in% sort(names(dat))]
    dat <- dat[tolower(var)]
  }
  if (any(sapply(dat, is.null))) {
    dat <- noaa_compact(dat)
    warning(sprintf("%s not in the dataset\nAvailable variables: %s", paste0(vars_null, collapse = ", "), possvars), call. = FALSE)
  }
  if (!is.null(date_min)) {
    dat <- lapply(dat, function(z) z %>% dplyr::filter(date > date_min))
  }
  if (!is.null(date_max)) {
    dat <- lapply(dat, function(z) z %>% dplyr::filter(date < date_max))
  }
  dat
}

#' @export
print.ghcnd <- function(x, ..., n = 10){
  cat("<GHCND Data>", sep = "\n")
  cat(sprintf("Size: %s X %s", NROW(x$data), NCOL(x$data)), sep = "\n")
  cat(sprintf("Source: %s\n", attr(x, "source")), sep = "\n")
  trunc_mat_(x$data, n = n)
}

fm <- function(n) {
  gsub("\\s", "0", n)
}

#' @export
#' @rdname ghcnd
ghcnd_splitvars <- function(x){
  tmp <- x$data
  tmp <- tmp[!is.na(tmp$id), ]
  out <- lapply(as.character(unique(tmp$element)), function(y){
    ydat <- tmp[ tmp$element == y, ]

    dd <- ydat %>%
      dplyr::select(-contains("FLAG")) %>%
      tidyr::gather(var, value, -id, -year, -month, -element) %>%
      dplyr::mutate(day = strex(var), date = as.Date(sprintf("%s-%s-%s", year, month, day), "%Y-%m-%d")) %>%
      dplyr::filter(!is.na(date)) %>%
      dplyr::select_(quote(-element), quote(-var), quote(-year), quote(-month), quote(-day))
    dd <- setNames(dd, c("id", tolower(y), "date"))

    mflag <- ydat %>%
      dplyr::select(-contains("VALUE"), -contains("QFLAG"), -contains("SFLAG")) %>%
      tidyr::gather(var, value, -id, -year, -month, -element) %>%
      dplyr::mutate(day = strex(var), date = as.Date(sprintf("%s-%s-%s", year, month, day), "%Y-%m-%d")) %>%
      dplyr::filter(!is.na(date)) %>%
      dplyr::select(value) %>%
      dplyr::rename(mflag = value)

    qflag <- ydat %>%
      dplyr::select(-contains("VALUE"), -contains("MFLAG"), -contains("SFLAG")) %>%
      tidyr::gather(var, value, -id, -year, -month, -element) %>%
      dplyr::mutate(day = strex(var), date = as.Date(sprintf("%s-%s-%s", year, month, day), "%Y-%m-%d")) %>%
      dplyr::filter(!is.na(date)) %>%
      dplyr::select(value) %>%
      dplyr::rename(qflag = value)

    sflag <- ydat %>%
      dplyr::select(-contains("VALUE"), -contains("QFLAG"), -contains("MFLAG")) %>%
      tidyr::gather(var, value, -id, -year, -month, -element) %>%
      dplyr::mutate(day = strex(var), date = as.Date(sprintf("%s-%s-%s", year, month, day), "%Y-%m-%d")) %>%
      dplyr::filter(!is.na(date)) %>%
      dplyr::select(value) %>%
      dplyr::rename(sflag = value)

    dplyr::tbl_df(cbind(dd, mflag, qflag, sflag))
  })
  setNames(out, tolower(unique(tmp$element)))
}

strex <- function(x) str_extract_(x, "[0-9]+")

# ghcnd_mergevars <- function(x){
#   merge(x[[2]], x[[3]] %>% select(-id), by='date')
# }

#' @export
#' @rdname ghcnd
ghcnd_stations <- function(..., n = 10){
  sta <- get_stations(...)
  inv <- get_inventory(...)
  structure(list(data = merge(sta, inv[,-c(2,3)], by = "id")), class = "ghcnd_stations")
}

#' @export
print.ghcnd_stations <- function(x, ..., n = 10){
  cat("<GHCND Station Data>", sep = "\n")
  cat(sprintf("Size: %s X %s\n", NROW(x$data), NCOL(x$data)), sep = "\n")
  trunc_mat_(x$data, n = n)
}

get_stations <- function(...){
  res <- GET_retry("ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-stations.txt", ...)
  df <- read.fwf(textConnection(utcf8(res)), widths = c(11, 9, 11, 7, 33, 5, 10),
                 header = FALSE, strip.white = TRUE, comment.char = "", stringsAsFactors = FALSE)
  nms <- c("id","latitude", "longitude", "elevation", "name", "gsn_flag", "wmo_id")
  setNames(df, nms)
}

get_inventory <- function(...){
  res <- GET_retry("ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-inventory.txt", ...)
  df <- read.fwf(textConnection(utcf8(res)), widths = c(11, 9, 10, 5, 5, 5),
                 header = FALSE, strip.white = TRUE, comment.char = "", stringsAsFactors = FALSE)
  nms <- c("id","latitude", "longitude", "element", "first_year", "last_year")
  setNames(df, nms)
}

#' @export
#' @rdname ghcnd
ghcnd_states <- function(...){
  # res <- suppressWarnings(GET("ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-states.txt", ...))
  res <- GET_retry("ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-states.txt", ...)
  df <- read.fwf(textConnection(utcf8(res)), widths = c(2, 27),
                 header = FALSE, strip.white = TRUE, comment.char = "",
                 stringsAsFactors = FALSE, col.names = c("code","name"))
  df[ -NROW(df) ,]
}

GET_retry <- function(url, ..., times = 3) {
  res <- suppressWarnings(GET(url, ...))
  if (res$status_code > 226) {
    message("Request failed - Retrying")
    stat <- 500
    i <- 0
    while (stat > 226 && i <= times) {
      i <- i + 1
      res <- suppressWarnings(GET(url, ...))
      stat <- res$status_code
    }
    if (res$status_code > 226) stop("Request failed, try again", call. = FALSE)
  }
  return(res)
}

#' @export
#' @rdname ghcnd
ghcnd_countries <- function(...){
  res <- GET_retry("ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-countries.txt", ...)
  df <- read.fwf(textConnection(utcf8(res)), widths = c(2, 47),
                 header = FALSE, strip.white = TRUE, comment.char = "",
                 stringsAsFactors = FALSE, col.names = c("code","name"))
  df[ -NROW(df) ,]
}

#' @export
#' @rdname ghcnd
ghcnd_version <- function(...){
  res <- GET_retry("ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-version.txt", ...)
  utcf8(res)
}

ghcnd_zip <- function(x){
  "adf"
}

ghcnd_GET <- function(bp, stationid, ...){
  dir.create(bp, showWarnings = FALSE, recursive = TRUE)
  fp <- ghcnd_local(stationid, bp)
  res <- suppressWarnings(httr::GET(ghcnd_remote(stationid), ...))
  tt <- utcf8(res)
  vars <- c("id","year","month","element",do.call("c", lapply(1:31, function(x) paste0(c("VALUE","MFLAG","QFLAG","SFLAG"), x))))
  df <- read.fwf(textConnection(tt), c(11,4,2,4,rep(c(5,1,1,1), 31)),
                 na.strings = "-9999")
  dat <- setNames(df, vars)
  write.csv(dat, fp, row.names = FALSE)
  return(dat)
}

ghcnd_remote <- function(stationid) file.path(ghcndbase(), paste0(stationid, ".dly"))
ghcnd_local <- function(stationid, path) file.path(path, paste0(stationid, ".dly"))
is_ghcnd <- function(x) if (file.exists(x)) TRUE else FALSE
ghcndbase <- function() "ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/all"
str_extract_ <- function(string, pattern) regmatches(string, regexpr(pattern, string))
