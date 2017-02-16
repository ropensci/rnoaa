#' Get NOAA tornado data.
#'
#' @export
#' @param overwrite (logical) To overwrite the path to store files in or not,
#' Default: \code{TRUE}
#' @param ... Curl options passed on to \code{\link[httr]{GET}} (optional)
#'
#' @return A Spatial object is returned of class SpatialLinesDataFrame.
#' @references \url{http://www.spc.noaa.gov/gis/svrgis/}
#'
#' @section File storage:
#' We use \pkg{rappdirs} to store files, see
#' \code{\link[rappdirs]{user_cache_dir}} for how
#' we determine the directory on your machine to save files to, and run
#' \code{rappdirs::user_cache_dir("rnoaa/tornadoes")} to get that directory.
#'
#' @examples \dontrun{
#' shp <- tornadoes()
#' library('sp')
#' plot(shp) # may take 10 sec or so to render
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
    url <- 'http://www.spc.noaa.gov/gis/svrgis/zipped/tornado.zip'
    tornadoes_GET(path, url, overwrite, ...)
  }
  readshp(file.path(path, "torn"))
}

tornadoes_GET <- function(bp, url, overwrite, ...){
  dir.create(bp, showWarnings = FALSE, recursive = TRUE)
  fp <- file.path(bp, "tornadoes.zip")
  res <- GET(url, write_disk(fp, overwrite), ...)
  stop_for_status(res)
  untar(fp, exdir = bp)
}

is_tornadoes <- function(x){
  if (identical(list.files(x), character(0))) {
    FALSE
  } else {
    all(list.files(x) %in% tornadoes_files)
  }
}

readshp <- function(x) rgdal::readOGR(dsn = path.expand(x), layer = "torn",
                                      stringsAsFactors = FALSE)

tornadoes_files <-
  c("torn.dbf","torn.prj","torn.cpg","torn.shp","torn.shx")
