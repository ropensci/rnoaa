#' meteo_distance
#'
#' @description
#'
#' @param data a dataframe. Expects col headers with names latName and longName
#' @param lat Latitude to centre search at
#' @param long Longitude to centre search at
#' @param latName Name of latitude header name in data, Default = 'latitude'
#' @param longName Name of longitude header name in data. Default = 'longitude'
#' @param units Units of the latitude and longitude values: degrees 'deg', radians 'rad', d/m/s 'dms'. Default = 'deg'
#' @param radius Radius to search (does nothing yet)
#' @param limit Upperbound on number of results. Deafult = 1
#'
#' @return a dataframe in a column with the distance of stations
#' @export
#'
#' @examples
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
#' @param data
#' @param lat
#' @param long
#' @param latName
#' @param longName
#' @param units
#'
#' @return
#' @export
#'
#' @examples
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
#' @param lat1
#' @param long1
#' @param lat2
#' @param long2
#' @param units
#'
#' @return
#' @export
#'
#' @examples
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
  a <- sin((lat2 - lat1) / 2) ^ 2 + cos(lat1) * cos(lat2) * sin((long2 - long1) / 2) ^ 2

  d <- 2 * atan2(sqrt(a), sqrt(1 - a)) * radius_earth

  return(d)

} # End calculate_spherical_distance

#' deg2rad
#'
#' @param deg
#'
#' @return
#' @export
#'
#' @examples
deg2rad <- function(deg) {
  return(deg*pi/180)
} # End deg2rad

