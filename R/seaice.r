#' Get sea ice data.
#'
#' @export
#' @param url A url for a NOAA sea ice ftp file
#' @param ... Further arguments passed on to readshpfile function, see
#'    \code{readshpfile}
#' @return A data.frame
#' @details If you want to reproject the shape files, use
#' \code{\link{readshpfile}} to read in shape file, then reproject, and so on.
#' @examples \dontrun{
#' # Look at data.frame's for a series of years for Feb, South pole
#' urls <- sapply(seq(1979,1990,1), function(x) seaiceeurls(yr=x, mo='Feb', pole='S'))
#' out <- lapply(urls, seaice)
#' lapply(out, head)
#'
#' # Map a single year/month/pole combo
#' urls <- seaiceeurls(mo='Apr', pole='N', yr=1990)
#' out <- seaice(urls)
#' library('ggplot2')
#' ggplot(out, aes(long, lat, group=group)) +
#'    geom_polygon(fill="steelblue") +
#'    theme_ice()
#' }
seaice <- function(url, ...) {
  check4pkg("rgdal")
  tt <- readshpfile(url, ...)
  suppressMessages(fortify(tt))
}

#' Make all urls for sea ice data
#'
#' @param yr Year (numeric)
#' @param mo Month, as character abbrevation of a month  (character)
#' @param Pole One of S (south) or N (north) (character)
#' @return A list of urls
#' @examples \dontrun{
#' # Get all urls
#' seaiceeurls()
#'
#' # Get urls for Feb of all years, both S and N poles
#' seaiceeurls(mo='Feb')
#'
#' # Get urls for Feb of all years, just S pole
#' seaiceeurls(mo='Feb', pole='S')
#'
#' # Get urls for Feb of 1980, just S pole
#' seaiceeurls(yr=1980, mo='Feb', pole='S')
#' }
#' @export
#' @keywords internal
seaiceeurls <- function(yr=NULL, mo=NULL, pole=NULL) {
  eachmonth <- sprintf(seaiceftp(), month.abb)
  yrs_prev <- seq(1979, year(today()) - 1, 1)
  months_prevyr <- c(paste0(0, seq(1, 9)), c(10, 11, 12))
  yrs_months <- do.call(c, lapply(yrs_prev, function(x) paste(x, months_prevyr, sep = '')))
  urls <- do.call(c, lapply(c('S', 'N'), function(x) {
    paste(eachmonth, 'extent_', x, '_', yrs_months, '_polygon.zip', sep = '')
  }))

  months_thisyr <- paste0(0, seq(1,month(today())))
  yrs_months_thisyr <- paste0(2013, months_thisyr)
  eachmonth_thiyr <- eachmonth[1:grep(month(today() - months(1), label = TRUE, abbr = TRUE), eachmonth)]
  urls_thisyr <- do.call(c, lapply(c('S', 'N'), function(x) {
    paste(eachmonth_thiyr, 'extent_', x, '_', yrs_months_thisyr, '_polygon.zip', sep = '')
  }))

  allurls <- c(urls, urls_thisyr)

  if (!is.null(pole)) pole <- sprintf("_%s_", pole)
  if (!is.null(yr)) yr <- sprintf("_%s", yr)

  ss <- allurls
  if (!is.null(yr) & is.null(mo) & is.null(pole))
    ss <- grep(yr, allurls, value = TRUE)
  if (is.null(yr) & !is.null(mo) & is.null(pole))
    ss <- grep(mo, allurls, value = TRUE)
  if (is.null(yr) & is.null(mo) & !is.null(pole))
    ss <- grep(pole, allurls, value = TRUE)
  if (!is.null(yr) & !is.null(mo) & is.null(pole))
    ss <- grep(yr, grep(mo, allurls, value = TRUE), value = TRUE)
  if (!is.null(yr) & is.null(mo) & !is.null(pole))
    ss <- grep(yr, grep(pole, allurls, value = TRUE), value = TRUE)
  if (is.null(yr) & !is.null(mo) & !is.null(pole))
    ss <- grep(pole, grep(mo, allurls, value = TRUE), value = TRUE)
  if (!is.null(yr) & !is.null(mo) & !is.null(pole))
    ss <- grep(yr, grep(pole, grep(mo, allurls, value = TRUE), value = TRUE), value = TRUE)

  return( ss )
}

seaiceftp <- function() 'ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/shapefiles/%s/shp_extent/'

#' Function to read shapefiles
#' @param x A url
#' @param storepath Path to store data in
#' @return An object of class sp
#' @export
#' @keywords internal
readshpfile <- function(x, storepath = NULL) {
  filename <- strsplit(x, '/')[[1]][length(strsplit(x, '/')[[1]])]
  filename_noending <- strsplit(filename, "\\.")[[1]][[1]]
  if (is.null(storepath)) {
    storepath <- tempdir()
  }
  path_write <- paste0(storepath, '/', filename_noending)
  path <- paste0(storepath, '/', filename)
  bb <- try(download.file(x, path, quiet = TRUE), silent = TRUE)
  if (class(bb) == "try-error") {
    stop('Data not available, ftp server may be down')
  }
  dir.create(path_write, showWarnings = FALSE)
  unzip(path, exdir = path_write)
  my_layer <- rgdal::ogrListLayers(path.expand(path_write))
  rgdal::readOGR(path.expand(path_write), layer = my_layer, verbose = FALSE)
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
