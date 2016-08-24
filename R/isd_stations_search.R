#' Search for NOAA ISD/ISH station data from NOAA FTP server.
#'
#' @export
#' @param lat (numeric) Latitude, in decimal degree
#' @param lon (numeric) Latitude, in decimal degree
#' @param radius (numeric) Radius (in km) to search from the lat,lon coordinates
#' @param bbox (numeric) Bounding box, of the form: min-longitude, min-latitude,
#' max-longitude, max-latitude
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
#'  \item dist - distance (km) (only present if using lat/lon/radius
#'  parameter combination)
#' }
#'
#' @details We internally call \code{\link{isd_stations}} to get the data.frame
#' of ISD stations, which is quite fast as long as it's not the first time called
#' since we cache the table. Before searching, we clean up the data.frame, removing
#' stations with no lat/long coordinates, those with impossible lat/long coordinates,
#' and those at 0,0.
#'
#' @seealso \code{\link{isd}}, \code{\link{isd_stations}}
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
isd_stations_search <- function(lat = NULL, lon = NULL, radius = NULL, bbox = NULL) {
  search_lat <- lat; search_lon <- lon
  rm(lat, lon)
  stations <- dplyr::filter_(
    isd_stations(),
    "!(is.na(lat) | is.na(lon) | (lat == 0 & lon == 0) | abs(lon) > 180 | abs(lat) > 90)"
  )

  if (!is.null(bbox)) {
    filter(stations, lat >= bbox[2] & lat <= bbox[4], lon >= bbox[1] & lon <= bbox[3])
  } else {
    search_lat_rad <- search_lat*pi/180
    grid_size_search_lat <-
      111132.954 - 559.822*cos(2*search_lat_rad) +  1.175*cos(4*search_lat_rad)
    grid_size_search_lon <- grid_size_search_lat*cos(search_lat_rad)
    stations <-
      mutate(
        stations,
        lat_rad = lat*pi/180,
        grid_size_lat = 111132.954 - 559.822*cos(2*lat_rad) + 1.175*cos(4*lat_rad),
        grid_size_lon = grid_size_lat*cos(lat_rad),
        grid_size_lat = (grid_size_lat + grid_size_search_lat)/2,
        grid_size_lon = (grid_size_lon + grid_size_search_lon)/2,
        dist = 0.001*sqrt(((search_lon - lon)*grid_size_lon)^2 + ((search_lat - lat)*grid_size_lat)^2)
      )
    stations <- select(stations, -lat_rad, -grid_size_lat, -grid_size_lon)
    filter(stations, dist <= radius)
  }
}


# isd_stations_search <- function(lat = NULL, lon = NULL, radius = NULL,
#                                 bbox = NULL, ...) {
#
#   check4pkg("lawn")
#   check4pkg("geojsonio")
#
#   # prep user selected polygon
#   latlonrad <- noaa_compact(list(lat, lon, radius))
#   allargs <- noaa_compact(list(llr = latlonrad, bb = bbox))
#   allargs <- allargs[sapply(allargs, length) != 0]
#   if (length(allargs) > 1) {
#     stop("Only one of lat/lon/radius together, or bbox alone",
#          call. = FALSE)
#   }
#
#   if (!is.null(bbox)) {
#     poly <- lawn::lawn_featurecollection(lawn::lawn_bbox_polygon(bbox))
#   } else {
#     poly <- lawn::lawn_buffer(lawn::lawn_point(c(lon, lat)), dist = radius)
#   }
#
#   # prep station data
#   x <- isd_stations(...)
#   x$lat <- as.numeric(x$lat)
#   x$lon <- as.numeric(x$lon)
#   df <- x[stats::complete.cases(x$lat, x$lon), ]
#   df <- df[abs(df$lat) <= 90, ]
#   df <- df[abs(df$lon) <= 180, ]
#   df <- df[df$lat != 0, ]
#   row.names(df) <- NULL
#
#   # clip stations to polygon
#   xx <- geojsonio::geojson_json(df)
#   pts <- lawn::lawn_featurecollection(xx)
#   outout <- lawn::lawn_within(pts, poly)
#   tmp <- outout$features
#   cbind(
#     tmp$properties,
#     stats::setNames(do.call("rbind.data.frame", tmp$geometry$coordinates), c("lon", "lat"))
#   )
# }
