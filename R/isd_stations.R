#' Get NOAA ISD/ISH station data from NOAA FTP server.
#'
#' @export
#' @name isd_stations
#' @param refresh (logical) Download station data from NOAA ftp server again. 
#' Default: \code{FALSE}
#' @param path (character) If \code{refresh=TRUE}, this is the path where file is saved.
#' If \code{refresh=FALSE}, this argument is ignored.
#' @param lat (numeric) Latitude, in decimal degree
#' @param lon (numeric) Latitude, in decimal degree
#' @param radius (numeric) Radius (in km) to search from the lat,lon coordinates
#' @param bbox (numeric) Bounding box, of the form: min-longitude, min-latitude, 
#' max-longitude, max-latitude
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @references ftp://ftp.ncdc.noaa.gov/pub/data/noaa/
#' @seealso \code{\link{isd}}
#' @return \code{isd_stations} returns a data.frame with the columns:
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
#' }
#' 
#' \code{isd_stations_search} returns a data.frame, if any matches, with the same columns
#' as listed above
#' @details \code{\link{isd_stations_search}} requires \pkg{geojsonio} and \pkg{lawn}, 
#' but are not imported in this package, so they aren't required for the rest of the 
#' package to operate - only this function. Install those from CRAN if you don't 
#' already have them.
#' 
#' When using \code{isd_station_search} we clean up the data.frame, removing
#' stations with no lat/long coordinates, those with impossible lat/long coordinates, 
#' and those at 0,0.
#' @examples \dontrun{
#' # Get station table
#' stations <- isd_stations()
#' head(stations)
#' 
#' ## plot stations
#' ### remove incomplete cases, those at 0,0
#' df <- stations[complete.cases(stations$lat, stations$lon), ]
#' df <- df[df$lat != 0, ]
#' ### make plot
#' library("leaflet")
#' leaflet(data = df) %>%
#'   addTiles() %>%
#'   addCircles()
#' 
#' # Search for stations by various inputs
#' ## bounding box
#' bbox <- c(-125.0, 38.4, -121.8, 40.9)
#' (out <- isd_stations_search(bbox = bbox))
#' 
#' ## lat, long, radius
#' isd_stations_search(lat = 38.4, lon = -123, radius = 250)
#' 
#' ### then plot...
#' }
isd_stations <- function(refresh = FALSE, path = NULL, ...) {
  if (refresh) {
    res <- suppressWarnings(GET(paste0(isdbase(), "/isd-history.csv"), ...))
    df <- read.csv(text = utcf8(res), header = TRUE, colClasses = 'character')
    df$LAT <- as.numeric(df$LAT)
    df$LON <- as.numeric(df$LON)
    df$ELEV.M. <- as.numeric(df$ELEV.M.)
    df$BEGIN <- as.numeric(df$BEGIN)
    df$END <- as.numeric(df$END)
    dat <- setNames(df, gsub("_$", "", gsub("\\.", "_", tolower(names(df)))))
    if (is.null(path)) path <- file.path(".", "isd_stations.rds")
    rnoaa_env$isd_stations_path <- path
    saveRDS(dat, file = path)
    return(dat)
  } else {
    res <- suppressWarnings(tryCatch(readRDS(rnoaa_env$isd_stations_path), error = function(e) e))
    if (is(res, "error")) path <- system.file("isd_stations.rds", package = "rnoaa")
    readRDS(path)
  }
}

rnoaa_env <- new.env()

#' @export
#' @rdname isd_stations
isd_stations_search <- function(lat = NULL, lon = NULL, radius = NULL, 
                               bbox = NULL, ...) {
  
  check4pkg("lawn")
  check4pkg("geojsonio")
  
  # prep user selected polygon
  latlonrad <- noaa_compact(list(lat, lon, radius))
  allargs <- noaa_compact(list(llr = latlonrad, bb = bbox))
  allargs <- allargs[sapply(allargs, length) != 0]
  if (length(allargs) > 1) {
    stop("Only one of lat/lon/radius together, or bbox alone", 
         call. = FALSE)
  }
  
  if (!is.null(bbox)) {
    poly <- lawn::lawn_featurecollection(lawn::lawn_bbox_polygon(bbox))
  } else {
    poly <- lawn::lawn_buffer(lawn::lawn_point(c(lon, lat)), dist = radius)
  }
  
  # prep station data
  x <- isd_stations(...)
  x$lat <- as.numeric(x$lat)
  x$lon <- as.numeric(x$lon)
  df <- x[complete.cases(x$lat, x$lon), ]
  df <- df[abs(df$lat) <= 90, ]
  df <- df[abs(df$lon) <= 180, ]
  df <- df[df$lat != 0, ]
  row.names(df) <- NULL
  
  # clip stations to polygon
  xx <- geojsonio::geojson_json(df)
  pts <- lawn::lawn_featurecollection(xx)
  outout <- lawn::lawn_within(pts, poly)
  tmp <- outout$features
  cbind(
    tmp$properties, 
    setNames(do.call("rbind.data.frame", tmp$geometry$coordinates), c("lon", "lat"))
  )
}
