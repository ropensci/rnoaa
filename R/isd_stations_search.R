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
#' @references ftp://ftp.ncdc.noaa.gov/pub/data/noaa/
#'
#' @return a data.frame with the columns:
#' \itemize{
#'  \item usaf - USAF number, character
#'  \item wban - WBAN number, character
#'  \item station_name - station name, character
#'  \item ctry - Country, if given, character
#'  \item state - State, if given, character
#'  \item icao - ICAO number, if given, character
#'  \item lat - Latitude, if given, numeric
#'  \item lon - Longitude, if given, numeric
#'  \item elev_m - Elevation, if given, numeric
#'  \item begin - Begin date of data coverage, of form YYYYMMDD, numeric
#'  \item end - End date of data coverage, of form YYYYMMDD, numeric
#'  \item distance - distance (km) (only present if using lat/lon/radius
#'  parameter combination)
#' }
#'
#' @details We internally call \code{\link{isd_stations}} to get the data.frame
#' of ISD stations, which is quite fast as long as it's not the first time
#' called since we cache the table. Before searching, we clean up the
#' data.frame, removing stations with no lat/long coordinates, those with
#' impossible lat/long coordinates, and those at 0,0.
#'
#' When lat/lon/radius input we use \code{\link{meteo_distance}} to search
#' for stations, while when bbox is input, we simply use
#' \code{\link[dplyr]{filter}}
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
#'     addCircles(lng = x$longitude,
#'                lat = x$latitude,
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

  stations <- dplyr::filter_(
    isd_stations(),
    "!(is.na(lat) | is.na(lon) | (lat == 0 & lon == 0) | abs(lon) > 180 | abs(lat) > 90)"
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
