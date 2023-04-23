#' Get sea ice data.
#'
#' @export
#' @param year (numeric) a year
#' @param month (character) a month, as character abbrevation of a month
#' @param pole (character) one of S (south) or N (north)
#' @param format (character) one of shp (default), geotiff-extent (for geotiff
#' extent data), or geotiff-conc (for geotiff concentration data)
#' @param ... Further arguments passed on to `rgdal::readshpfile()` if
#' `format="shp"` or `raster::raster()` if not
#' @return data.frame if `format="shp"` (a fortified sp object);
#' `raster::raster()` if not
#' @seealso [sea_ice_tabular()]
#' @references See the "User Guide" pdf at https://nsidc.org/data/g02135
#' @examples \dontrun{
#' if (requireNamespace("raster")) {
#'
#' ## one year, one moth, one pole
#' sea_ice(year = 1990, month = "Apr", pole = "N")
#' sea_ice(year = 1990, month = "Apr", pole = "N", format = "geotiff-extent")
#' sea_ice(year = 1990, month = "Apr", pole = "N", format = "geotiff-conc")
#'
#' ## one year, one month, many poles
#' sea_ice(year = 1990, month = "Apr")
#'
#' ## one year, many months, many poles
#' sea_ice(year = 1990, month = c("Apr", "Jun", "Oct"))
#'
#' ## many years, one month, one pole
#' sea_ice(year = 1990:1992, month = "Sep", pole = "N")
#'
#' # get geotiff instead of shp data.
#' x <- sea_ice(year = 1990, month = "Apr", format = "geotiff-extent")
#' y <- sea_ice(year = 1990, month = "Apr", format = "geotiff-conc")
#' }
#'
#' }
sea_ice <- function(year = NULL, month = NULL, pole = NULL, format = "shp",
  ...) {

  assert(year, c('integer', 'numeric'))
  assert(month, 'character')
  assert(pole, 'character')
  assert(format, 'character')
  if (!format %in% c("shp", "geotiff-extent", "geotiff-conc"))
    stop("'format' must be one of: 'shp', 'geotiff-extent', 'geotiff-conc'")
  urls <- seaiceeurls(yr=year, mo=month, pole, format)
  if (format == "shp") {
    check4pkg("rgdal")
    lapply(urls, readshpfile, ...)
  } else {
    check4pkg("raster")
    lapply(urls, function(w) suppressWarnings(raster::raster(w, ...)))
  }
}

#' Make all urls for sea ice data
#'
#' @export
#' @keywords internal
#' @param yr (numeric) a year
#' @param mo (character) a month, as character abbrevation of a month
#' @param pole (character) one of S (south) or N (north)
#' @return A vector of urls (character)
#' @examples \dontrun{
#' # Get all urls
#' seaiceeurls()
#'
#' # for some range of years
#' seaiceeurls(yr = 1980:1983)
#' seaiceeurls(yr = 1980, mo = c("Jan", "Feb", "Mar"))
#' seaiceeurls(yr = 1980:1983, mo = c("Jan", "Apr", "Oct"))
#'
#' # Get urls for Feb of all years, both S and N poles
#' seaiceeurls(mo='Feb')
#'
#' # Get urls for Feb of all years, just S pole
#' seaiceeurls(mo='Feb', pole='S')
#'
#' # Get urls for Feb of 1980, just S pole
#' seaiceeurls(yr=1980, mo='Feb', pole='S')
#'
#' # GeoTIFF
#' seaiceeurls(yr=1980, mo='Feb', pole='S', format = "geotiff")
#' }
seaiceeurls <- function(yr = NULL, mo = NULL, pole = NULL, format = "shp") {
  type <- if (!grepl("geotiff", format)) NULL else strsplit(format, "-")[[1]][2]
  urls <- generate_urls(format, type)
  if (!is.null(pole)) {
    pole <- switch(format, shp=sprintf("_%s_", pole), sprintf("%s_", pole))
  }
  if (!is.null(yr)) yr <- sprintf("_%s", yr)

  ss <- urls
  if (!is.null(yr) & is.null(mo) & is.null(pole))
    ss <- grep2(yr, urls)
  if (is.null(yr) & !is.null(mo) & is.null(pole))
    ss <- grep2(mo, urls)
  if (is.null(yr) & is.null(mo) & !is.null(pole))
    ss <- grep2(pole, urls)
  if (!is.null(yr) & !is.null(mo) & is.null(pole))
    ss <- grep2(yr, grep2(mo, urls))
  if (!is.null(yr) & is.null(mo) & !is.null(pole))
    ss <- grep2(yr, grep2(pole, urls))
  if (is.null(yr) & !is.null(mo) & !is.null(pole))
    ss <- grep2(pole, grep2(mo, urls))
  if (!is.null(yr) & !is.null(mo) & !is.null(pole))
    ss <- grep2(yr, grep2(pole, grep2(mo, urls)))

  return( ss )
}

grep2 <- function(pattern, x) {
  grep(paste0(pattern, collapse = "|"), x, value = TRUE)
}

generate_urls <- function(format, type) {
  fun <- if (format == "shp") make_urls_shp else make_urls_geotiff
  if (!is.null(type)) type <- switch(type, extent = "extent", "concentration")

  yrs_prev <- seq(1979, year(today()) - 1, 1)
  months_prevyr <- c(paste0(0, seq(1, 9)), c(10, 11, 12))
  yrs_months <- do.call(c, lapply(yrs_prev, function(x)
    paste(x, months_prevyr, sep = '')))
  urls <- fun(yrs_months, month.abb, type = type)

  # this year
  months_thisyr <- seq(1, as.numeric(format(Sys.Date(), "%m")))
  months_thisyr <- months_thisyr[-length(months_thisyr)]
  if (!length(months_thisyr) == 0) {
    months_thisyr <- vapply(months_thisyr, function(z) {
      if (nchar(z) == 1) paste0(0, z) else as.character(z)
    }, "")
    yrs_months_thisyr <- paste0(format(Sys.Date(), "%Y"), months_thisyr)
    eachmonth_thiyr <- month.abb[1:grep(format(Sys.Date() - months(1), "%b"),
                                        month.abb)]
    urls_thisyr <- fun(yrs_months_thisyr, eachmonth_thiyr, type = type)
  } else {
    urls_thisyr <- c()
  }

  # all urls
  c(urls, urls_thisyr)
}

make_urls_shp <- function(yrs_months, mos, type = NULL) {
  do.call(
    "c",
    lapply(c('south', 'north'), function(x) {
      mm <- paste(
        vapply(seq_along(mos), function(z) {
          if (nchar(z) == 1) paste0(0, z) else as.character(z)
        }, ""),
        mos,
        sep = "_"
      )
      tmp <- sprintf(ftp_url_shp, x, mm)
      route <- paste('extent_', switch(x, south = "S", north = "N"),
                     '_', yrs_months, '_polygon_v3.0.zip',
                     sep = '')
      file.path(tmp, route)
    })
  )
}
make_urls_geotiff <- function(yrs_months, mos, type = "extent") {
  do.call(
    "c",
    lapply(c('south', 'north'), function(x) {
      mm <- paste(
        vapply(seq_along(mos), function(z) {
          if (nchar(z) == 1) paste0(0, z) else as.character(z)
        }, ""),
        mos,
        sep = "_"
      )
      tmp <- sprintf(ftp_url_geotiff, x, mm)
      route <- paste(switch(x, south = "S", north = "N"),
                     '_', yrs_months, sprintf('_%s_v3.0.tif', type),
                     sep = '')
      file.path(tmp, route)
    })
  )
}

ftp_url_shp <-
  'ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/%s/monthly/shapefiles/shp_extent/%s'
ftp_url_geotiff <-
  'ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/%s/monthly/geotiff/%s'

#' Function to read shapefiles
#'
#' @export
#' @keywords internal
#' @param x A url
#' @param storepath Path to store data in
#' @return An object of class sp
readshpfile <- function(x, storepath = NULL) {
  filename <- strsplit(x, '/')[[1]][length(strsplit(x, '/')[[1]])]
  filename_noending <- strsplit(filename, "\\.")[[1]][[1]]
  if (is.null(storepath)) {
    storepath <- tempdir()
  }
  path_write <- paste0(storepath, '/', filename_noending)
  path <- paste0(storepath, '/', filename)
  bb <- try(download.file(x, path, quiet = TRUE), silent = TRUE)
  if (inherits(bb, "try-error")) {
    stop('Data not available, ftp server may be down')
  }
  dir.create(path_write, showWarnings = FALSE)
  unzip(path, exdir = path_write)
  my_layer <- rgdal::ogrListLayers(path.expand(path_write))
  ggplot2::fortify(
    suppressWarnings(rgdal::readOGR(path.expand(path_write), layer = my_layer,
      verbose = FALSE, stringsAsFactors = FALSE)))
}

#' ggplot2 map theme
#' @export
#' @keywords internal
theme_ice <- function() {
  list(theme_bw(base_size = 18),
       theme(panel.border = element_blank(),
             panel.grid.major = element_blank(),
             panel.grid.minor = element_blank(),
             axis.text = element_blank(),
             axis.ticks = element_blank()),
       labs(x = '', y = ''))
}
