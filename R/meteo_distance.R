#' meteo_distance
#'
#' @param station_data a dataframe. Expects col headers with names latName and longName
#' @param lat Latitude to centre search at
#' @param long Longitude to centre search at
#' @param latName Name of latitude header name in the station data, Default = 'latitude'
#' @param longName Name of longitude header name in station data. Default = 'longitude'
#' @param units Units of the latitude and longitude values: degrees 'deg',
#'    radians 'rad', d/m/s 'dms'. Default = 'deg'
#' @param radius Radius to search (does nothing yet)
#' @param limit Upperbound on number of results. Deafult = 1
#'
#' @return a dataframe in a column with the distance of stations
#' @export
meteo_distance <- function(station_data, lat, long,
                           latName = 'latitude',
                           longName = 'longitude',
                           units = 'deg', radius = NULL, limit = NULL) {

  data <- meteo_process_geographic_data(
    data = station_data,
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
#' @inheritParams meteo_distance
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
    stop(paste('Error, missing header label. Expected columns in the station',
               'dataset with column names as specified by the latName and',
               'longName arguments.'))
  } # End check for header ontology

  # Add new column to store distance from given location ([lat, lon] point)
  data["distance"] <- NA

  # Caluclate distance between points
  data$distance <- meteo_spherical_distance(lat1 = lat, long1 = long,
                                            lat2 = data[ , latName],
                                            long2 = data[ , longName],
                                            units = "deg")

  # Sort data into ascending order by distance column
  data <- arrange(data, distance)

  return(data)
} # End meteo_process_geographic_data

#' Calculate the distance between two locations
#'
#' This functions uses the haversine formula to calculate the great circle
#' distance between two locations, identified by their latitudes and longitudes.
#'
#' @param lat1 data
#' @param long1 data
#' @param lat2 data
#' @param long2 data
#' @inheritParams meteo_distance
#'
#' @return A numeric vector giving the distance (in kilometers) between the
#'    pair of locations input.
#'
#' @note This function assumes an earth radius of 6,371 km.
#'
#' @export
meteo_spherical_distance <- function(lat1, long1, lat2, long2, units = 'deg') {

  radius_earth <- 6371

  # Convert angle values into radians
  if (units == 'deg') {
    lat1 <- deg2rad(lat1)
    long1 <- deg2rad(long1)
    lat2 <- deg2rad(lat2)
    long2 <- deg2rad(long2)
  } else if (units == 'dms') {
    stop("dms to rad function currently under dev")
  } else if(units != 'rad'){
    stop("The `units` argument must be one of: `deg`, `rad`, or `dms`.")
  }

  # Determine distance using the haversine formula, assuming a spherical earth
  a <- sin((lat2 - lat1) / 2) ^ 2 + cos(lat1) * cos(lat2) *
    sin((long2 - long1) / 2) ^ 2

  # d <- 2 * atan2(sqrt(a), sqrt(1 - a)) * radius_earth
  d <- 2 * asin(sqrt(a)) * radius_earth
  return(d)

} # End calculate_spherical_distance

#' Convert from degrees to radians
#'
#' @param deg A numeric vector in units of degrees.
#'
#' @return The input numeric vector, converted to units of radians.
#'
#' @export
deg2rad <- function(deg) {
  return(deg*pi/180)
} # End deg2rad

#' Find weather monitors near locations
#'
#' This function inputs a dataframe with latitudes and longitudes of locations
#' and creates a dataframe with monitors with a certain radius of those
#' locations. The site ids from this dataframe can then be used with other
#' \code{rnoaa} functions to pull data from all available weather stations near
#' a location.
#'
#' @param lat_lon_df A dataframe that contains the site latitude and longitude
#'    values used to search for nearby weather stations
#' @param lat_colname A character string giving the name of the latitude column
#'    in the \code{lat_lon_df} dataframe.
#' @param lon_colname A character string giving the name of the longitude column
#'    in the \code{lat_lon_df} dataframe.
#' @param station_data The output of \code{\link{ghcnd_stations()[[1]]}}:
#'    a current list of weather stations available through NOAA for the GHCND
#'    dataset. The format of this is a list with a single element, a dataframe
#'    with one row per available weather station.
#' @param radius A numeric vector giving the radius (in kilometers) within which
#'    to search for monitors near a location
#'
#' @return a dataframe containing a unique set of the weather stations within
#'    the search radius. Site IDs for the weather stations given in this
#'    dataframe can be used in conjunction with other functions in the
#'    \code{rnoaa} package to pull weather data for the station.
#'
#' @note By default, this function will pull the full station list from NOAA
#'    to use to identify nearby locations. If you will be creating lists of
#'    monitors nearby several stations, you can save some time by using the
#'    \code{\link{ghcnd_stations}} function separately to create an object
#'    with all stations and then use the argument \code{ghcnd_station_list} in
#'    this function to reference that object, rather than using this function's
#'    defaults.
#'
#' @examples
#' \dontrun{
#' lat <- c(37.779199, 37.531635)
#' lon <- c(-122.404294, -122.419282)
#' lat_lon_df <- data.frame(latitude = lat, longitude = lon)
#'
#' station_data <- ghncd_stations()[[1]]
#' nearby_stations <-
#' meteo_nearby_stations(lat_lon_df, lat_colname = 'latitude',
#'    lon_colname = 'longitude', ghcnd_station_list = stations, radius = 20)
#' }
#'
#' @importFrom dplyr %>%
#'
#' @export
meteo_nearby_stations <- function(lat_lon_df, lat_colname = "latitude",
                                  lon_colname = "longitude",
                                  station_data = ghcnd_stations()[[1]],
                                  var = "all",
                                  year_min = NULL,
                                  year_max = NULL,
                                  radius = 25, ...)

  # Handle generic values for `var`, `year_min`, and `year_max` arguments
  if(is.null(year_min)) year_min <- min(station_data$first_year, na.rm = TRUE)
  if(is.null(year_max)) year_max <- max(station_data$first_year, na.rm = TRUE)
  if(var == "all") var <- unique(station_data$element)

  station_data2 <- dplyr::filter(station_data,
                                 last_year >= year_min &
                                   first_year <= year_max &
                                   element %in% var &
                                   !is.na(element)) %>%
    dplyr::select(id, name, latitude, longitude) %>%
    dplyr::distinct()

  lat_lon_df %>%
  dplyr::distinct_(lat_colname, lon_colname) %>%
  split(.[, lat_colname], .[, lon_colname]) %>%
  purrr::map(function(x) {
    station_ids <-
      meteo_distance(station_data = station_data, lat = x[ , lat_colname],
                     long = x[ , lon_colname], radius = radius) %>%
      distinct(id)
    station_ids <- dplyr::rbind_all(station_ids)
    return(station_ids)
    })
