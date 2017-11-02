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
  res <- tryCatch(cli$get(disk = path, ...), error = function(e) e)
  if (!res$success()) {
    unlink(path)
    res$raise_for_status()
  }
  return(res)
}

lcd_base <- function() {
  "https://www.ncei.noaa.gov/data/global-hourly/access"
}

lcd_key <- function(station, year) {
  file.path(lcd_base(), year, paste0(station, ".csv"))
}
