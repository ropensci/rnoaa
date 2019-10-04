#' Get NOAA tornado data.
#'
#' This function gets spatial paths of tornadoes from NOAA's National Weather
#' Service Storm Prediction Center Severe Weather GIS web page.
#'
#' @export
#' @param overwrite (logical) To overwrite the path to store files in or not,
#' Default: `TRUE`
#' @param ... Curl options passed on to [crul::verb-GET] (optional)
#'
#' @return A Spatial object is returned of class SpatialLinesDataFrame.
#' @references https://www.spc.noaa.gov/gis/svrgis/
#'
#' @section File storage:
#' We use \pkg{rappdirs} to store files, see
#' [rappdirs::user_cache_dir()] for how
#' we determine the directory on your machine to save files to, and run
#' `rappdirs::user_cache_dir("rnoaa/tornadoes")` to get that directory.
#'
#' @examples \dontrun{
#' shp <- tornadoes()
#' library('sp')
#' if (interactive()) {
#'   # may take 10 sec or so to render
#'   plot(shp)
#' }
#' }
tornadoes <- function(overwrite = TRUE, ...) {
  calls <- names(sapply(match.call(), deparse))[-1]
  calls_vec <- "path" %in% calls
  if (any(calls_vec)) {
    stop("The parameter path has been removed, see docs for ?tornadoes")
  }

  check4pkg('rgdal')
  path <- file.path(rnoaa_cache_dir(), "tornadoes")
  if (!is_tornadoes(path)) {
    url <- 'https://www.spc.noaa.gov/gis/svrgis/zipped/1950-2018-torn-aspath.zip'
    tornadoes_GET(path, url, overwrite, ...)
  }
  readshp(file.path(path, tornadoes_basename))
}

tornadoes_GET <- function(bp, url, overwrite, ...){
  dir.create(bp, showWarnings = FALSE, recursive = TRUE)
  fp <- file.path(bp, "tornadoes.zip")
  if (!overwrite && file.exists(fp)) {
    stop("file exists and overwrite=FALSE")
  }
  cli <- crul::HttpClient$new(url, opts = list(...))
  res <- cli$get(disk = fp)
  res$raise_for_status()
  unzip(fp, exdir = bp)
}

is_tornadoes <- function(x){
  if (identical(list.files(x), character(0))) {
    FALSE
  } else {
    all(list.files(x) %in% tornadoes_files)
  }
}

tornadoes_basename <- "1950-2018-torn-aspath"

readshp <- function(x) rgdal::readOGR(dsn = path.expand(x),
                                      layer = tornadoes_basename,
                                      stringsAsFactors = FALSE)

tornadoes_files <- paste0(tornadoes_basename, c(".dbf", ".prj", ".shp", ".shx"))
