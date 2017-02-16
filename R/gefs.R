#' Get GEFS ensemble forecast data for a specific lat/lon.
#'
#' Fetches GEFS forecast data for every 6 hours out to 384 hours past selected date. GEFS
#' is an ensemble of 21 models that can be summarized to estimate likelihoods of forecasts.
#'
#' @export
#'
#' @param var the variable to get. Must be one of the variables listed in
#' \code{gefs_variables()}.
#' @param lat,lon the longitude. Will be converted to the nearest GEFS available
#'  longitude. If lon is a list of vlaues, it must be a sequential list, and
#'  data are returned for the number of longitudes in the list starting with
#'  the maximum value and incrementing through the indexed values for the
#'  length of the list.
#' @param date A date/string formatted as YYYYMMDD.
#' @param forecast_time a string indicating which time of day UTC the forecast is from.
#' Options are "0000", "0600", "1200", "1800".
#' @param ens_idx sequential list of ensembles to fetch. Default is all 21. Note that the
#' ensembles are labelled 0-20, so ens_idx=1:3 will return ensembles 0, 1, and 2.
#' @param time_idx sequential list of time increments to return. List is the index
#'   of times, which are in 6 hour increments. (e.g. c(1,2) fetches the 6 and 12 hour forecast.)
#' @param dims (not implemented) indices for additional dimensions to be included between
#' lat, lon, ens, and time.
#' @param raw logical to indicate whether to return raw data matrix or reshaped data frame.
#' @param ... additional parameters passed to \code{ncvar_get}.
#' @return a list containing metadata and accompanying data frame of forecast
#'   values. If lat/lon are not specified, the $data is an unprocessed matrix.
#'
#' @references \itemize{
#'  \item Data description - \url{http://bit.ly/noaagefs}.
#'  \item Adapted from Python code written by Von P. Walden, Washington State University.
#' }
#'
#' @author Nicholas Potter \email{potterzot@@gmail.com}
#' @examples \dontrun{
#'
#' #avialable latitudes and longitudes
#' gefs_latitudes()
#' gefs_longitudes()
#'
#' #get a list of all gefs variables
#' gefs_variables()
#'
#' #All GEFS dimensions
#' gefs_dimensions()
#'
#' #values for a specific dimension
#' gefs_dimension_values("height_above_ground")
#'
#' #example location.
#' lat <- 46.28125
#' lon <- -116.2188
#'
#' #Get forecast for a certain variable.
#' forecast <- gefs("Total_precipitation_surface_6_Hour_Accumulation_ens",
#'   lat, lon)
#'
#' #Fetch a different date (available up to 10 days prior to today)
#' forecast_yesterday_prec <- gefs(
#'    "Total_precipitation_surface_6_Hour_Accumulation_ens",
#'    lat, lon, date=format(as.Date(Sys.time()) - 1, "%Y%m%d"))
#'
#' #specific ensemble and times, for the 1800 forecast.
#' # here ensembles 1-3 (ensembles are numbered starting with 0)
#' # and time for 2 days from today at 1800
#' date <- format(as.Date(Sys.time()) - 1, "%Y%m%d")
#' var <- "Temperature_height_above_ground_ens"
#' gefs(var, lat, lon, date = date, forecast_time = "1800", ens_idx=2:4,
#'   time_idx=1:8)
#'
#' #One ensemble, all latitudes and longitudes (this is a big file) for the
#' # next 3 days.
#' # gefs(var, ens=1, time=1:12)
#' }
#'
gefs <- function(var, lat, lon, ...) {
  check4pkg("ncdf4")
  gefs_GET(var, lat, lon, ...)
}

#' @rdname gefs
gefs_CONNECT <- function(date = format(Sys.time(), "%Y%m%d"),
                         forecast_time = c("0000", "0600", "1200", "1800")) {


  # Until bug #127 is resolved
  if (is_windows()) stop("gefs not implemented on windows yet", .call = FALSE)

  #forecast time
  forecast_time <- match.arg(forecast_time)

  #url parts
  gefs_url_pre <- 'http://thredds.ucar.edu/thredds/dodsC/grib/NCEP/GEFS/Global_1p0deg_Ensemble/members/GEFS_Global_1p0deg_Ensemble_'
  gefs_url_suf <- ".grib2"

  #final url
  gefs_url <- paste0(gefs_url_pre, date, "_", forecast_time, gefs_url_suf)

  #open the connection
  #nc_open(gefs_url) #ncdf4 version
  ncdf4::nc_open(gefs_url)
}

#' @rdname gefs
gefs_GET <- function(var, lat, lon,
                     date = format(Sys.time(), "%Y%m%d"),
                     forecast_time = c("0000", "0600", "1200", "1800"),
                     ens_idx = 1:21,
                     time_idx = 1:65,
                     dims = NULL,
                     raw = FALSE,
                     ...) {

  #Sanity Checks
  if (missing(var)) stop("Need to specify the variable to get. A list of variables is available from gefs_variables().")

  #get a connection
  con <- gefs_CONNECT(date, forecast_time)

  #Get a subset of data to speed up access
  v <- con$var[[var]] # lon, lat, height_above_ground, ens (ensemble), time1
  varsize <- v$varsize
  ndims <- v$ndims
  n_time <- varsize[ndims] #time is always the last dimension
  dims <- c()
  for (i in 1:length(v$dim)) { dims[i] <- v$dim[[i]]$name }

  #get lat/lon indices
  lon_start_idx <- if(!missing(lon)) which(v$dim[[1]]$vals==round(max(lon) %% 360, 0)) else 1
  lat_start_idx <- if(!missing(lat)) which(v$dim[[2]]$vals==round(max(lat), 0)) else 1

  #indices of dimensions to read from data
  start <- rep(1,ndims) #number of dims
  start[1] <- lon_start_idx #first is always longitude
  start[2] <- lat_start_idx #first is always latitude
  start[ndims - 1] <- ens_idx[1] #first ensemble
  start[ndims] <- time_idx[1] #first time

  count_n <- rep(1,ndims)

  #if not specified, get all locations.
  count_n[1] <- if(missing(lon)) -1 else length(lon)
  count_n[2] <- if(missing(lat)) -1 else length(lat)

  #ensemble is always the 2nd to last dimension. Take either the variable
  #max or the last value indicated by the parameter ens
  count_n[ndims-1] <- min(varsize[ndims-1], length(ens_idx))

  #time is always the last dimension
  #take the minimum of the variable max or the value indicated by the parameter time
  count_n[ndims] <- min(varsize[ndims], length(time_idx))

  # actual data
  # Do not modify the data, so don't convert (- 273.15) * 1.8 + 32. #convert from K to F
  #d <- ncvar_get(con, v, start = start, count = count_n, ...) #ncdf4 version
  d <- ncdf4::ncvar_get(con, v, start = start, count = count_n, ...)

  #create the data frame
  #For now, if lat/lon are not specified, just return a matrix.
  if (raw==FALSE) {
    d = as.data.frame(as.vector(d))

    for (i in 1:length(count_n)) {
      dim_vals <- v$dim[[i]]$vals
      if(count_n[i]==1) {
        d[dims[i]] <- dim_vals[start[i]]
      }
      else {
        d[dims[i]] <- dim_vals[0:(count_n[i]-1) + start[i]]
      }
    }
    names(d) <- c(var, dims)
  }

  fname <- strsplit(con$filename, "_")[[1]]
  date <- fname[7]
  forecast_time <- strsplit(fname, ".grib2")[[8]]
  list(forecast_date = date,
       forecast_time = forecast_time,
       dimensions    = dims,
       data          = d)
}

########################
# helper functions

#' @export
#'
#' @param con an ncdf4 connection.
#' @rdname gefs
gefs_latitudes <- function(con = NULL, ...) {
  gefs_dimension_values("lat", con)
}

#' @export
#' @rdname gefs
gefs_longitudes <- function(con = NULL, ...) {
  gefs_dimension_values("lon", con)
}

#' @export
#' @rdname gefs
gefs_variables <- function(con = NULL, ...) {
  if (is.null(con)) con = gefs_CONNECT(...)
  names(con$var)
}

#' @export
#' @rdname gefs
gefs_dimensions <- function(con = NULL, ...) {
  if (is.null(con)) con = gefs_CONNECT(...)
  names(con$dim)
}

#' @export
#'
#' @param dim (character) the dimension.
#' @rdname gefs
gefs_dimension_values <- function(dim, con = NULL, ...) {
  if (is.null(dim) || missing(dim)) stop("dim cannot be NULL or missing.")
  if (is.null(con)) con = gefs_CONNECT(...)
  con$dim[[dim]]$vals
}

