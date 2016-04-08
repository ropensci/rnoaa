#' meteo_distance
#'
#' @param data a dataframe. Expects col headers with names latName and longName
#' @param lat Latitude to centre search at
#' @param long Longitude to centre search at
#' @param latName Name of latitude header name in data, Default = 'latitude'
#' @param longName Name of longitude header name in data. Default = 'longitude'
#' @param units Units of the latitude and longitude values: degrees 'deg',
#'    radians 'rad', d/m/s 'dms'. Default = 'deg'
#' @param radius Radius to search (does nothing yet)
#' @param limit Upperbound on number of results. Deafult = 1
#'
#' @return a dataframe in a column with the distance of stations
#' @export
meteo_distance <- function(data,
                           lat,
                           long,
                           latName = 'latitude',
                           longName = 'longitude',
                           units = 'deg',
                           radius=NULL,
                           limit = NULL) {

  data <- meteo_process_geographic_data(
    data = data,
    lat = lat,
    long = long,
    latName = latName,
    longName = longName
  )

  if(!is.null(radius)) {
    print('test')
    data <- data[data$distance < radius,]
  }

  if(!is.null(limit)) {
    data <- data[1:min(limit,nrow(data)),]
  }
  return(data)
}

#' meteo_process_geographic_data
#'
#' @param data data
#' @param lat data
#' @param long data
#' @param latName data
#' @param longName data
#' @param units data
#'
#' @export
meteo_process_geographic_data <- function(data,
                                          lat,
                                          long,
                                          latName,
                                          longName,
                                          units = 'deg') {

  # Convert headers to lowercase for consistency across code
  names(data) <- tolower(names(data))

  # Check if lat, long exists as headers in the data frame
  if (!all(c(latName, longName) %in% colnames(data))) {
    stop('Error, missing header label. Expected latName and longName')
  } # End check for header ontology

  # Add new column to store distance from given location ([lat, lon] point)
  data["distance"] <- NA

  # Caluclate distance between points
  data$distance <-
    meteo_spherical_distance(
      lat1 = lat,
      long1 = long,
      lat2 = data[latName][1:nrow(data),],
      long2 = data[longName][1:nrow(data),],
      units = 'deg'
    )

  # Sort data into ascending order by distance column
  data <- arrange(data, distance)

  return(data)
} # End meteo_process_geographic_data

#' meteo_spherical_distance
#'
#' @param lat1 data
#' @param long1 data
#' @param lat2 data
#' @param long2 data
#' @param units data
#'
#' @export
meteo_spherical_distance <- function(lat1,
                                     long1,
                                     lat2,
                                     long2,
                                     units = 'deg') {

  radius_earth <- 6371

  # Convert angle values into radians
  if (units == 'deg') {
    lat1 <- deg2rad(lat1)
    long1 <- deg2rad(long1)
    lat2 <- deg2rad(lat2)
    long2 <- deg2rad(long2)
  } else if (units == 'dms') {
    stop("dms to rad function currently under dev")
  }

  # Determine distance using the haversine formula, assuming a spherical earth
  a <- sin((lat2 - lat1) / 2) ^ 2 + cos(lat1) * cos(lat2) *
    sin((long2 - long1) / 2) ^ 2

  d <- 2 * atan2(sqrt(a), sqrt(1 - a)) * radius_earth

  return(d)

} # End calculate_spherical_distance

#' deg2rad
#'
#' @param deg
#'
#' @export
deg2rad <- function(deg) {
  return(deg*pi/180)
} # End deg2rad

#' get_nearby_stations
#'
#' @description
#'
#' @param lat_lon_df A dataframe that contains the site latitude and longitude
#'    values used to search for nearby weather stations
#' @param lat_colname Name of the latitude column in the lat_lon_df
#' @param lon_colname Name of the longitude column in the lat_lon_df
#' @param ghcnd_station_list List of weather stations obtained using
#'    `ghcnd_stations()`
#' @param radius Radius to search (in km)
#'
#' @return a dataframe containing a unique set of the weather stations within
#'    the search radius
#'
#' @examples
#' lat <- c(37.779199, 37.531635)
#' lon <- c(-122.404294, -122.419282)
#' lat_lon_df <- data.frame(latitude = lat, longitude = lon)
#'
#' nearby_stations <-
#' get_nearby_stations(lat_lon_df = test_df, lat_colname = 'latitude',
#' lon_colname = 'longitude', ghcnd_station_list = stations, radius = 20)
#'
#' @export
meteo_nearby_stations <- function(lat_lon_df, lat_colname, lon_colname,
                                  ghcnd_station_list, radius, ...)
  lat_lon_df %>%
  dplyr::distinct_(lat_colname, lon_colname) %>%
  split(.[, lat_colname], .[, lon_colname]) %>%
  purrr::map(function(x) {
    station_ids <-
      meteo_distance(data = ghcnd_station_list, lat = x$latitude,
                     long = x$longitude, radius = radius) %>%
      distinct(id)
    station_ids <- dplyr::rbind_all(station_ids)
    return(station_ids)
    })
