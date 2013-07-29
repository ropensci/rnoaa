#' Get sea ice data.
#' 
#' @import rgdal stringr
#' @param 
noaa_seaice <- function()
{
  tt <- readshpfile(urls[[2]])
  fortify(tt)
}

#' Make all urls for sea ice data
#' @examples
#' seaiceeurls()
#' @export
#' @keywords internal
seaiceeurls <- function()
{ 
  eachmonth <- sprintf('ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/shapefiles/%s/shp_extent/', month.abb)
  yrs_prev <- seq(1979, year(today())-1, 1)
  months_prevyr <- c(paste0(0, seq(1,9)), c(10,11,12))
  yrs_months <- do.call(c, lapply(yrs_prev, function(x) paste(x, months_prevyr, sep='')))
  urls <- do.call(c, lapply(c('S','N'), function(x) paste(eachmonth, 'extent_', x, '_', yrs_months, '_polygon.zip', sep='')))
  
  months_thisyr <- paste0(0, seq(1,month(today())))
  yrs_months_thisyr <- paste0(2013, months_thisyr)
  eachmonth_thiyr <- eachmonth[1:grep(month(today() - months(1), label=TRUE, abbr=TRUE), eachmonth)]
  urls_thisyr <- do.call(c, lapply(c('S','N'), function(x) paste(eachmonth_thiyr, 'extent_', x, '_', yrs_months_thisyr, '_polygon.zip', sep='')))
  
  c(urls, urls_thisyr)
}

library(rgdal); library(stringr); library(ggplot2)

#' Function to read shapefile and 
#' @export
#' @keywords internal
readshpfile <- function(x, storepath="~/seaicedata", ...) {
  filename <- str_split(x, '/')[[1]][length(str_split(x, '/')[[1]])]
  path <- paste0(storepath, '/', filename)
  path_shp <- str_replace(path, ".zip", ".shp")
  download.file(x, path)
  unzip(path, exdir=storepath)
  temp <- readShapePoly(path_shp, proj4string=CRS("+proj=utm +datum=WGS84"))
  spTransform(temp, CRS("+proj=longlat"))
}

#' ggplot2 map theme
#' @export
#' @keywords internal
theme_ice <- function(){
  list(theme_bw(base_size=18),
       theme(panel.border = element_blank(),
             panel.grid.major = element_blank(),
             panel.grid.minor = element_blank()))
}

#' Make a map of sea ice using ggplot2
#' 
#' @import ggplot2
#' @param data Input object
#' @examples \dontrun{
#' 
#' }
#' @export 
map_seaice <- function(data)
{
  ggplot(data, aes(long, lat, group=group)) + 
    geom_polygon(fill="steelblue") +
    theme_ice()
}