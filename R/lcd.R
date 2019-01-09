#' Local Climitalogical Data from NOAA
#'
#' @export
#' @param station (character) station code, e.g., "02413099999". we will
#' allow integer/numeric passed here, but station ids can have leading
#' zeros, so it's a good idea to keep stations as character class
#' @param year (integer) year, e.g., 2017
#' @param ... curl options passed on to \code{\link[crul]{HttpClient}}
#' @return a data.frame, with many columns, and variable rows
#' depending on how frequently data was collected in the given year
#'
#' @references \url{https://www.ncdc.noaa.gov/cdo-web/datatools/lcd}
#' \url{https://www1.ncdc.noaa.gov/pub/data/cdo/documentation/LCD_documentation.pdf}
#' 
#' @note Beware that there are multiple columns with comma-delimited data 
#' joined together. In the next version of this package we'll try to have the
#' data cleaning done for you. 
#' 
#' @return a data.frame with many columns. the first 10 are metadata:
#' 
#' \itemize{
#'  \item station
#'  \item date
#'  \item source
#'  \item latitude
#'  \item longitude
#'  \item elevation
#'  \item name
#'  \item report_type
#'  \item call_sign
#'  \item quality_control
#' }
#' 
#' And the rest should be all data columns. See Note about data joined
#' together.
#'
#' @examples \dontrun{
#' lcd(station = "01338099999", year = "2017")
#' lcd(station = "01338099999", year = "2015")
#'
#' lcd(station = "02413099999", year = "2009")
#' lcd(station = "02413099999", year = "2001")
#'
#' # pass curl options
#' lcd(station = "02413099999", year = "2002", verbose = TRUE)
#' }
lcd <- function(station, year, ...) {
  assert(station, c("character", "numeric", "integer"))
  assert(year, c("character", "numeric", "integer"))
  assert_range(year, 1901:format(Sys.Date(), "%Y"))

  path <- lcd_get(station = station, year = year, ...)
  tmp <- read.csv(path, header = TRUE, sep = ",", stringsAsFactors = FALSE)
  names(tmp) <- tolower(names(tmp))
  tibble::as_data_frame(tmp)
}

lcd_get <- function(station, year, overwrite = FALSE, ...) {
  lcd_cache$mkdir()
  key <- lcd_key(station, year)
  file <- file.path(lcd_cache$cache_path_get(),
    sprintf("%s_%s.csv", year, station))
  if (!file.exists(file)) {
    suppressMessages(lcd_GET_write(key, file, overwrite, ...))
  }
  return(file)
}

lcd_GET_write <- function(url, path, overwrite = TRUE, ...) {
  cli <- crul::HttpClient$new(url = url, opts = list(...))
  if (!overwrite) {
    if (file.exists(path)) {
      stop("file exists and ovewrite != TRUE", call. = FALSE)
    }
  }
  res <- tryCatch(cli$get(disk = path), error = function(e) e)
  if (!res$success()) {
    on.exit(unlink(path), add = TRUE)
    res$raise_for_status()
  }
  # government shutdown check
  if (any(grepl("shutdown", unlist(res$response_headers_all)))) {
    on.exit(unlink(path), add = TRUE)
    stop("there's a government shutdown; check back later")
  }
  return(res)
}

lcd_base <- function() {
  "https://www.ncei.noaa.gov/data/global-hourly/access"
}

lcd_key <- function(station, year) {
  file.path(lcd_base(), year, paste0(station, ".csv"))
}
