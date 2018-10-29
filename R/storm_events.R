storm_events_env <- new.env()

#' NOAA Storm Events data
#'
#' @name storm_events
#' @param year (numeric) a four digit year. see output of `se_files()` 
#' for available years. required.
#' @param type (character) one of details, fatalities, locations, or
#' legacy. required.
#' @param overwrite (logical) To overwrite the path to store files in or not,
#' Default: \code{TRUE}
#' @param ... Curl options passed on to \code{\link[crul]{HttpClient}} 
#' (optional)
#' @return A tibble (data.frame)
#' @section File storage:
#' We use \pkg{rappdirs} to store files, see
#' \code{\link[rappdirs]{user_cache_dir}} for how
#' we determine the directory on your machine to save files to, and run
#' \code{rappdirs::user_cache_dir("rnoaa/stormevents")} to get that directory.
#' @references \url{https://www.ncdc.noaa.gov/stormevents/}
#'
#' @examples \dontrun{
#' # get list of files and their urls
#' res <- se_files()
#' res
#' tail(res)
#' 
#' # get data
#' x <- se_data(year = 2013, type = "details")
#' x
#' 
#' z <- se_data(year = 1988, type = "fatalities")
#' z
#' 
#' w <- se_data(year = 2003, type = "locations")
#' w
#' 
#' leg <- se_data(year = 2003, type = "legacy")
#' leg
#' }

#' @export
#' @rdname storm_events
se_data <- function(year, type, overwrite = TRUE, ...) {
  if (missing(year)) stop("'year' missing; it's required", 
    call. = FALSE)
  assert(year, c("numeric", "integer"))
  if (missing(type)) stop("'type' missing; it's required", 
    call. = FALSE)
  assert(type, "character")
  # if no cached storm events files df, retrieve it
  if (is.null(storm_events_env$files)) {
    storm_events_env$files <- se_files()
  }
  path <- file.path(rnoaa_cache_dir(), "stormevents")
  assert_range(year, unique(sort(storm_events_env$files$year)))
  if (!type %in% c("details", "fatalities", "locations", "legacy")) {
    stop("'type' must be one of: details, fatalities, locations, legacy")
  }
  csvpath <- se_csv_local(year, type, path)
  if (!is_se(x = csvpath)) {
    csvpath <- se_GET(path, year, type, overwrite, ...)
  }
  message(sprintf("<path>%s", csvpath), "\n")
  tmp <- read.csv(csvpath, header = TRUE, sep = ",", 
    stringsAsFactors = FALSE)
  names(tmp) <- tolower(names(tmp))
  tibble::as_data_frame(tmp)
}

#' @export
#' @rdname storm_events
se_files <- function(...) {
  dplyr::bind_rows(se_main_dir(...), se_legacy_dir(...))
}



# helpers -----------
se_get <- function(x, disk = NULL, ...) {
  cli <- crul::HttpClient$new(url = x, opts = list(...))
  res <- cli$get(disk = disk)
  res$raise_for_status()
  res
}

se_main_dir <- function(...) {
  html <- xml2::read_html(se_get(se_base, ...)$parse("UTF-8"))
  x <- xml2::xml_find_all(html, '//a[contains(@href, "StormEvents_")]')
  hrefs <- xml2::xml_attr(x, "href")
  dplyr::bind_rows(lapply(hrefs, function(z) {
    zz <- gsub("StormEvents_|.csv.gz", "", z)
    brk <- strsplit(zz, "-")[[1]][1]
    year <- as.numeric(sub("d", "", str_extract_(zz, "d[0-9]{4}")))
    created <- as.numeric(sub("c", "", str_extract_(zz, "c[0-9]+")))
    url <- file.path(se_base, z)
    list(type = brk, year = year, created = created, url = url)
  }))
}

se_legacy_dir <- function(...) {
  html <- xml2::read_html(
    se_get(file.path(se_base, "legacy"), ...)$parse("UTF-8")
  )
  x <- xml2::xml_find_all(html, '//a[contains(@href, "data_")]')
  hrefs <- xml2::xml_attr(x, "href")
  dplyr::bind_rows(lapply(hrefs, function(z) {
    year <- as.numeric(str_extract_(z, "[0-9]{4}"))
    url <- file.path(se_base, "legacy", z)
    list(type = "legacy", year = year, url = url)
  }))
}

se_GET <- function(bp, year, type, overwrite, ...){
  dir.create(bp, showWarnings = FALSE, recursive = TRUE)
  fp <- se_csv_local(year, type, bp)
  if (!overwrite) {
    if (file.exists(fp)) {
      stop("file exists and ovewrite != TRUE", call. = FALSE)
    }
  }
  res <- se_get(se_csv_remote(year, type), disk = fp, ...)
  res$content
}

se_fileext <- function(year, type, url = FALSE) {
  df <- storm_events_env$files
  # filter by type
  df <- df[grep(type, df$url),]
  # filter by year
  df <- df[year == df$year,]
  # should be length 1
  if (NROW(df) > 1) {
    stop("more than 1 match found, refine your query:")
  }
  if (url) return(df$url)
  basename(df$url)
}

se_csv_remote <- function(year, type) {
  se_fileext(year, type, TRUE)
}
se_csv_local <- function(year, type, path) {
  file.path(path, se_fileext(year, type))
}

is_se <- function(x) if (file.exists(x)) TRUE else FALSE

se_base <- "https://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles"