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
#' urls <- sapply(seq(1979,1990,1), function(x) seaiceeurls(yr=x,
#'   mo='Feb', pole='S'))
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
#' # Get urls for Feb of all years, both S and N poles
#' seaiceeurls(mo='Feb')
#'
#' # Get urls for Feb of all years, just S pole
#' seaiceeurls(mo='Feb', pole='S')
#'
#' # Get urls for Feb of 1980, just S pole
#' seaiceeurls(yr=1980, mo='Feb', pole='S')
#' }
seaiceeurls <- function(yr = NULL, mo = NULL, pole = NULL) {
  # previous years
  yrs_prev <- seq(1979, year(today()) - 1, 1)
  months_prevyr <- c(paste0(0, seq(1, 9)), c(10, 11, 12))
  yrs_months <- do.call(c, lapply(yrs_prev, function(x)
    paste(x, months_prevyr, sep = '')))
  urls <- make_seaice_urls(yrs_months, month.abb)

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
    urls_thisyr <- make_seaice_urls(yrs_months_thisyr, eachmonth_thiyr)
  } else {
    urls_thisyr <- c()
  }

  # all urls
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
    ss <- grep(yr, grep(pole, grep(mo, allurls, value = TRUE),
                        value = TRUE), value = TRUE)

  return( ss )
}

make_seaice_urls <- function(yrs_months, mos) {
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
      tmp <- sprintf(seaiceftp, x, mm)
      route <- paste('extent_', switch(x, south = "S", north = "N"),
                     '_', yrs_months, '_polygon_v2.1.zip',
                     sep = '')
      file.path(tmp, route)
    })
  )
}

seaiceftp <-
  'ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/%s/monthly/shapefiles/shp_extent/%s'

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
