#' Search for NOAA ISD/ISH station data from NOAA FTP server.
#'
#' @export
#' @param lat (numeric) Latitude, in decimal degree
#' @param lon (numeric) Latitude, in decimal degree
#' @param radius (numeric) Radius (in km) to search from the lat,lon 
#' coordinates
#' @param bbox (numeric) Bounding box, of the form: min-longitude, 
#' min-latitude, max-longitude, max-latitude
#'
#' @references https://ftp.ncdc.noaa.gov/pub/data/noaa/
#'
#' @return a data.frame with the columns:
#' 
#' - usaf - USAF number, character
#' - wban - WBAN number, character
#' - station_name - station name, character
#' - ctry - Country, if given, character
#' - state - State, if given, character
#' - icao - ICAO number, if given, character
#' - lat - Latitude, if given, numeric
#' - lon - Longitude, if given, numeric
#' - elev_m - Elevation, if given, numeric
#' - begin - Begin date of data coverage, of form YYYYMMDD, numeric
#' - end - End date of data coverage, of form YYYYMMDD, numeric
#' - distance - distance (km) (only present if using lat/lon/radius
#'  parameter combination)
#'
#'
#' @details We internally call [isd_stations()] to get the data.frame
#' of ISD stations, which is quite fast as long as it's not the first time
#' called since we cache the table. Before searching, we clean up the
#' data.frame, removing stations with no lat/long coordinates, those with
#' impossible lat/long coordinates, and those at 0,0.
#'
#' When lat/lon/radius input we use [meteo_distance()] to search
#' for stations, while when bbox is input, we simply use
#' [dplyr::filter()]
#'
#' @family isd
#'
#' @examples \dontrun{
#' ## lat, long, radius
#' isd_stations_search(lat = 38.4, lon = -123, radius = 250)
#'
#' x <- isd_stations_search(lat = 60, lon = 18, radius = 200)
#'
#' if (requireNamespace("leaflet")) {
#'   library("leaflet")
#'   leaflet() %>%
#'     addTiles() %>%
#'     addCircles(lng = x$lon,
#'                lat = x$lat,
#'                popup = x$station_name) %>%
#'     clearBounds()
#' }
#'
#' ## bounding box
#' bbox <- c(-125.0, 38.4, -121.8, 40.9)
#' isd_stations_search(bbox = bbox)
#' }
isd_stations_search <- function(lat = NULL, lon = NULL, radius = NULL, 
  bbox = NULL) {

  stations <- dplyr::filter(
    isd_stations(),
    !(is.na(lat) | is.na(lon) | (lat == 0 & lon == 0) | abs(lon) > 180 | abs(lat) > 90)
  )

  if (!is.null(bbox)) {
    filter(stations, 
      lat >= bbox[2] & lat <= bbox[4], 
      lon >= bbox[1] & lon <= bbox[3])
  } else {
    stations <- rename(stations, latitude = lat, longitude = lon)
    tmp <- meteo_distance(stations, lat = lat, long = lon, radius = radius)
    rename(tmp, lat = latitude, lon = longitude)
  }
}
