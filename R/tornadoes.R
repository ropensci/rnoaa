#' Get NOAA tornado data.
#'
#' @export
#' @param path A path to store the files, Default: \code{~/.ots/kelp}
#' @param overwrite (logical) To overwrite the path to store files in or not, Default: TRUE.
#' @param ... Curl options passed on to \code{\link[httr]{GET}} (optional)
#'
#' @return A Spatial object is returned of class SpatialLinesDataFrame.
#' @references \url{http://www.spc.noaa.gov/gis/svrgis/}
#'
#' @examples \dontrun{
#' shp <- tornadoes()
#' library('sp')
#' plot(shp) # may take 10 sec or so to render
#' }

tornadoes <- function(path="~/.rnoaa/tornadoes", overwrite = TRUE, ...) {
  check4pkg('rgdal')
  if(!is_tornadoes(path.expand(file.path(path, "tornadoes")))){
    url <- 'http://spc.noaa.gov/gis/svrgis/zipped/tornado.zip'
    tornadoes_GET(path, url, overwrite, ...)
  }
  readshp(file.path(path, "tornadoes"))
}

tornadoes_GET <- function(bp, url, overwrite, ...){
  dir.create(bp, showWarnings = FALSE, recursive = TRUE)
  fp <- file.path(bp, "tornadoes.zip")
  res <- GET(url, write_disk(fp, overwrite), ...)
  stop_for_status(res)
  untar(fp, exdir = path.expand(file.path(bp, 'tornadoes')))
}

is_tornadoes <- function(x){
  if(identical(list.files(x), character(0))){ FALSE } else {
    if(all(list.files(x) %in% tornadoes_files)) TRUE else FALSE
  }
}

readshp <- function(x) rgdal::readOGR(dsn = path.expand(x), layer = "tornado", stringsAsFactors = FALSE)

tornadoes_files <-
  c("tornado.dbf","tornado.prj","tornado.sbn","tornado.sbx","tornado.shp","tornado.shx")
