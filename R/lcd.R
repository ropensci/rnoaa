#' Local Climitalogical Data from NOAA
#'
#' @export
#' @param station (character) station code, e.g., "02413099999". we will
#' allow integer/numeric passed here, but station ids can have leading
#' zeros, so it's a good idea to keep stations as character class. required
#' @param year (integer) year, e.g., 2017. required
#' @param ... curl options passed on to [crul::verb-GET]
#' @return a data.frame, with many columns, and variable rows
#' depending on how frequently data was collected in the given year
#' @seealso lcd_cache
#' @references
#' Docs: 
#' <https://www.ncei.noaa.gov/data/local-climatological-data/doc/LCD_documentation.pdf>
#' Data comes from:
#' <https://www.ncei.noaa.gov/data/local-climatological-data/access>
#' 
#' @return a data.frame with many columns. the first 10 are metadata:
#' 
#' - station
#' - date
#' - latitude
#' - longitude
#' - elevation
#' - name
#' - report_type
#' - source
#' 
#' And the rest should be all data columns. The first part of many column
#' names is the time period, being one of:
#' 
#' - hourly
#' - daily
#' - monthly
#' - shortduration
#' 
#' So the variable you are looking for may not be the first part of the
#' column name
#'
#' @examples \dontrun{
#' x = lcd(station = "01338099999", year = 2017)
#' lcd(station = "01338099999", year = 2015)
#' lcd(station = "02413099999", year = 2009)
#' lcd(station = "02413099999", year = 2001)
#'
#' # pass curl options
#' lcd(station = "02413099999", year = 2002, verbose = TRUE)
#' }
lcd <- function(station, year, ...) {
  assert(station, c("character", "numeric", "integer"))
  assert(year, c("character", "numeric", "integer"))
  assert_range(year, 1901:format(Sys.Date(), "%Y"))

  path <- lcd_get(station = station, year = year, ...)
  tmp <- safe_read_csv(path)
  names(tmp) <- tolower(names(tmp))
  df <- tibble::as_tibble(tmp)
  structure(df, class = c(class(df), "lcd"))
}

lcd_get <- function(station, year, overwrite = FALSE, ...) {
  lcd_cache$mkdir()
  key <- lcd_key(station, year)
  file <- file.path(lcd_cache$cache_path_get(),
    sprintf("%s_%s.csv", year, station))
  if (!file.exists(file)) {
    suppressMessages(lcd_GET_write(key, file, overwrite, ...))
  } else {
    cache_mssg(file)
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
  "https://www.ncei.noaa.gov/data/local-climatological-data/access"
}

lcd_key <- function(station, year) {
  file.path(lcd_base(), year, paste0(station, ".csv"))
}

#' @title lcd_cache
#' @description Manage the `lcd()` cache
#' @export
#' @details The cache directory for `lcd()` is
#' `paste0(rappdirs::user_cache_dir(), "/R/noaa_lcd")`, but you can set
#' your own path using `cache_path_set()`
#'
#' `cache_delete` only accepts 1 file name, while
#' `cache_delete_all` doesn't accept any names, but deletes all files.
#' For deleting many specific files, use `cache_delete` in a [lapply()]
#' type call
#'
#' @section Useful user functions:
#'
#' - `lcd_cache$cache_path_get()` get cache path
#' - `lcd_cache$cache_path_set()` set cache path
#' - `lcd_cache$list()` returns a character vector of full path file names
#' - `lcd_cache$files()` returns file objects with metadata
#' - `lcd_cache$details()` returns files with details
#' - `lcd_cache$delete()` delete specific files
#' - `lcd_cache$delete_all()` delete all files, returns nothing
#'
#' @examples \dontrun{
#' lcd_cache
#'
#' # list files in cache
#' lcd_cache$list()
#'
#' # delete certain database files
#' # lcd_cache$delete("file path")
#' # lcd_cache$list()
#'
#' # delete all files in cache
#' # lcd_cache$delete_all()
#' # lcd_cache$list()
#'
#' # set a different cache path from the default
#' # lcd_cache$cache_path_set(full_path = file.path(tempdir(), "foo_bar"))
#' # lcd_cache
#' }
"lcd_cache"
