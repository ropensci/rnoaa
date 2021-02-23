#' Get NOAA tornado data.
#'
#' This function gets spatial paths of tornadoes from NOAA's National Weather
#' Service Storm Prediction Center Severe Weather GIS web page.
#'
#' @export
#' @param ... Curl options passed on to [crul::verb-GET] (optional)
#' @return A Spatial object is returned of class SpatialLinesDataFrame.
#' @references https://www.spc.noaa.gov/gis/svrgis/
#' @note See [torn_cache] for managing cached files
#' @examples \dontrun{
#' shp <- tornadoes()
#' library('sp')
#' if (interactive()) {
#'   # may take 10 sec or so to render
#'   plot(shp)
#' }
#' }
tornadoes <- function(...) {
  check4pkg('rgdal')
  url <- 'https://www.spc.noaa.gov/gis/svrgis/zipped/1950-2019-torn-aspath.zip'
  tornadoes_GET(url, ...)
  readshp(file.path(torn_cache$cache_path_get(), tornadoes_basename))
}

tornadoes_GET <- function(url, ...) {
  bp <- torn_cache$cache_path_get()
  torn_cache$mkdir()
  if (!is_tornadoes(file.path(bp, tornadoes_basename))) {
    fp <- file.path(bp, "tornadoes.zip")
    cli <- crul::HttpClient$new(url, opts = list(...))
    res <- cli$get(disk = fp)
    res$raise_for_status()
    unzip(fp, exdir = bp)
  } else {
    cache_mssg(bp)
  }
}

is_tornadoes <- function(x){
  if (identical(list.files(x), character(0))) {
    FALSE
  } else {
    all(list.files(x) %in% tornadoes_files)
  }
}

tornadoes_basename <- "1950-2019-torn-aspath"

readshp <- function(x) {
  rgdal::readOGR(dsn = path.expand(x),
    layer = tornadoes_basename, stringsAsFactors = FALSE)
}

tornadoes_files <- paste0(tornadoes_basename,
  c(".dbf", ".prj", ".shp", ".shx", ".cpg"))
