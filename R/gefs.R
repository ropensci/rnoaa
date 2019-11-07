#' Get GEFS ensemble forecast data for a specific lat/lon.
#'
#' Fetches GEFS forecast data for every 6 hours out to 384 hours past
#' selected date. GEFS is an ensemble of 21 models that can be
#' summarized to estimate likelihoods of forecasts.
#'
#' @export
#'
#' @param var the variable to get. Must be one of the variables listed in
#' `gefs_variables()`.
#' @param lat the latitude. Values must be sequential and are rounded to the
#' nearest GEFS available latitude.
#' @param lon the longitude. Values must be sequential and are rounded to the
#' nearest GEFS available longitude.
#' @param date A date/string formatted as YYYYMMDD.
#' @param forecast_time a string indicating which time of day UTC the
#' forecast is from. Options are "0000", "0600", "1200", "1800".
#' @param ens,ens_idx sequential list of ensembles to fetch. Default is all 21.
#' Note that the ensembles are labelled 0-20, so ens_idx=1:3 will return
#' ensembles 0, 1, and 2.
#' @param time,time_idx sequential list of time increments to return. List is the
#' index of times, which are in 6 hour increments. (e.g. c(1,2) fetches the
#' 6 and 12 hour forecast.)
#' @param dims (not implemented) indices for additional dimensions to be
#' included between lat, lon, ens, and time.
#' @param raw logical to indicate whether to return raw data matrix or
#' reshaped data frame.
#' @param ... for \code{gefs()}, additional parameters passed to the
#' connection, for other functions, passed on to
#' \code{gefs_dimension_values()}
#' @return a list containing metadata and accompanying data frame of
#' forecast values. If lat/lon are not specified, the $data is an
#' unprocessed matrix.
#'
#' @references
#'
#' - Data description - \url{http://bit.ly/noaagefs}.
#' - Adapted from Python code written by Von P. Walden, Washington State
#' University
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
#' lon <- -118.2188
#'
#' #Get forecast for a certain variable.
#' forecast <- gefs("Total_precipitation_surface_6_Hour_Accumulation_ens",
#'   lat, lon, ens = 0, time = 12)
#'
#' #Fetch a different date (available up to 10 days prior to today)
#' forecast_yesterday_prec <- gefs(
#'    "Total_precipitation_surface_6_Hour_Accumulation_ens",
#'    lat, lon, ens = 1, time = 6, date=format(as.Date(Sys.time()) - 1, "%Y%m%d"))
#'
#' #specific ensemble and times, for the 1800 forecast.
#' # here ensembles 1-3 (ensembles are numbered starting with 0)
#' # and two time periods: c(1800, 2400)
#' date <- format(as.Date(Sys.time()) - 1, "%Y%m%d")
#' var <- "Temperature_height_above_ground_ens"
#' gefs(var, lat, lon, date = date, forecast_time = "1800", ens=1:3,
#'   time=6*(3:4))
#'
#' #One ensemble, all latitudes and longitudes (this is a big file) for the
#' # next 3 days.
#' # gefs(var, ens=1, time=6*(1:12))
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
  if (is_windows()) warning("gefs not implemented on windows yet", .call = FALSE)

  #forecast time
  forecast_time <- match.arg(forecast_time)

  #url parts
  gefs_url_pre <- 'http://thredds.ucar.edu/thredds/dodsC/grib/NCEP/GEFS/Global_1p0deg_Ensemble/members/GEFS_Global_1p0deg_Ensemble_'
  gefs_url_suf <- ".grib2"

  #final url
  gefs_url <- paste0(gefs_url_pre, date, "_", forecast_time, gefs_url_suf)

  #open the connection
  ncdf4::nc_open(gefs_url)
}

#' @rdname gefs
gefs_GET <- function(var, lat = NULL, lon = NULL, ens = NULL, time = NULL,
                     date = format(Sys.time(), "%Y%m%d"),
                     forecast_time = c("0000", "0600", "1200", "1800"),
                     ens_idx = NULL, # will be removed in future version
                     time_idx = NULL, # will be removed in future version
                     dims = NULL,
                     raw = FALSE,
                     ...) {

  ###Sanity Checks
  if (missing(var)) stop("Need to specify the variable to get. A list of variables is available from gefs_variables().")

  # lats and lons must be sequential and within ranges
  lats <- sort(round(lat, 0))
  if (!all(lats == seq(lats[1], length.out = length(lats)))) stop("Latitudes must be sequential.")
  if (any(lats < -90 | lats > 90)) stop("Latitudes must be in c(-90,90).")

  lons <- sort(round(lon, 0))
  if (!all(lons == seq(lons[1], length.out = length(lons)))) stop("Longitudes must be sequential.")
  if (any(lons < -180 | lons > 360)) stop("Longitudes must be in c(-180,180) or c(0,360).")


  #get a connection
  con <- gefs_CONNECT(date, forecast_time)

  # Rename extra dimensions, to be changed later
  if (!is.null(dims)) {
    warning("Can't select additional dimensions yet.",
                                .call = FALSE)
  } else {
    additional_dims <- dims
  }


  #Get a subset of data to speed up access
  v <- con$var[[var]] # lon, lat, height_above_ground, ens (ensemble), time1
  varsize <- v$varsize
  ndims <- v$ndims
  n_time <- varsize[ndims] #time is always the last dimension

  # Set the indices for each dimension
  dim_names <- sapply(v$dim, function(d) { d$name })
  dim_idxs <- list()
  for (i in 1:length(v$dim)) {
    dn <- v$dim[[i]]$name
    if(dn == "lon") {
      dim_idxs[[i]] <- if(!is.null(lon)) which(v$dim[[i]]$vals %in% (round(lon,0) %% 360)) else 1:v$dim[[i]]$len
    } else if (dn == "lat") {
      dim_idxs[[i]] <- if(!is.null(lat)) which(v$dim[[i]]$vals %in% round(lat, 0)) else 1:v$dim[[i]]$len
    } else if (dn == "ens") {
      dim_idxs[[i]] <- if(!is.null(ens)) which(v$dim[[i]]$vals %in% ens) else 1:v$dim[[i]]$len
    } else if (dn %in% c("time", "time1", "time2")) {
      dim_idxs[[i]] <- if(!is.null(ens)) which(v$dim[[i]]$vals %in% time) else 1:v$dim[[i]]$len
    } else if (dn %in% names(additional_dims)) {
      dim_idxs[[i]] <- which(v$dim[[i]]$vals %in% additional_dims[[dn]])
    } else {
      dim_idxs[[i]] <- 1:v$dim[[i]]$len
    }
  }
  names(dim_idxs) <- dim_names

  # Assign ens_idx and time_idx if used
  if(!is.null(ens_idx)) {
    d_idx <- which(dim_names == "ens")
    if(!is.null(ens_idx)) message("'ens_idx' is deprecated and will be removed in future versions, please specify values (not indices) in 'ens' instead.")
    if(!any(ens_idx %in% 1:v$dim[[d_idx]]$len)) {
      ncdf4::nc_close(con)
      stop("'ens_idx' is out of bounds, check the dimension values with 'gefs_dimension_values(dim = 'ens').")
    }
    dim_idxs[['ens']] <- ens_idx
  }
  if(!is.null(time_idx)) {
    time_name <- grep("time", dim_names, value = TRUE)
    d_idx <- which(dim_names %in% time_name)
    if(!is.null(time_idx)) message("'time_idx' is deprecated and will be removed in future versions, please specify values (not indices) in 'time' instead.")
    if(!any(time_idx %in% 1:v$dim[[d_idx]]$len)) {
      ncdf4::nc_close(con)
      stop("'time_idx' is out of bounds, check the dimension values with 'gefs_dimension_values(dim = 'time').")
    }
    dim_idxs[[time_name]] <- time_idx
  }



  #start indices of dimensions to read from data
  start <- sapply(dim_idxs, function(d) { min(d) })
  count_n <- sapply(dim_idxs, function(d) { length(d) })

  ##ncdf4 version
  d_raw <- ncdf4::ncvar_get(con, v, start = start, count = count_n, ...)
  ncdf4::nc_close(con)

  #create the data frame
  #For now, if lat/lon are not specified, just return a matrix.
  if (!raw) {
    dim_vals <- lapply(1:length(dim_idxs), function(i) { v$dim[[i]]$vals[dim_idxs[[i]]] })
    names(dim_vals) <- names(dim_idxs)
    d = cbind(as.data.frame(as.vector(d_raw)), expand.grid(dim_vals))
    names(d)[[1]] <- var
  } else {
    d <- d_raw
  }

  fname <- strsplit(con$filename, "_")[[1]]
  date <- fname[7]
  forecast_time <- strsplit(fname, ".grib2")[[8]]
  list(forecast_date = date,
       forecast_time = forecast_time,
       dimensions    = names(dim_idxs),
       data          = d)
}

########################
# helper functions

#' @export
#'
#' @rdname gefs
gefs_latitudes <- function(...) {
  gefs_dimension_values(dim = "lat", ...)  
}

#' @export
#' 
#' @rdname gefs
gefs_longitudes <- function(...) {
  gefs_dimension_values(dim = "lon", ...)
}

#' @export
#'
#' @rdname gefs
gefs_ensembles <- function(...) {
  gefs_dimension_values(dim = "ens", ...)  
}

#' @export
#'
#' @rdname gefs
gefs_times <- function(...) {
  gefs_dimension_values(dim = "time", ...)  
}

#' @export
#' 
#' @rdname gefs
gefs_variables <- function(...) {
  con = gefs_CONNECT(...)
  vars <- names(con$var)
  ncdf4::nc_close(con)
  vars
}

#' @export
#'
#' @rdname gefs
gefs_dimensions <- function(var = NULL, ...) {

  con = gefs_CONNECT(...)
  if(is.null(var)) {
    dims <- names(con$dim)
  } else {
    v <- con$var[[var]]
    dims <- sapply(v$dim, function(d) { d$name })
  }  
  ncdf4::nc_close(con)
  dims
  
}

#' @export
#'
#' @param dim (character) the dimension to fetch values for.
#' @rdname gefs
gefs_dimension_values <- function(dim, var = NULL, ...) {
  if (missing(dim)) stop("dim cannot be NULL or missing.")

  con = gefs_CONNECT(...)
  
  if (!(dim %in% names(con$dim))) {
    ncdf4::nc_close(con)
    stop(paste0(dim, " is not a valid GEFS dimension. Get valid dimensions with 'gefs_dimensions()'."))
  }

  if (!is.null(var)) {
    v <- con$var[[var]]
    dim_names <- sapply(v$dim, function(d) { d$name })

    # there are multiple "time" dimensions, so get the one for this variable
    if(grepl("time", dim)) dim <- grep("time", dim_names, value = TRUE)
    if(!(dim %in% dim_names)) {
      ncdf4::nc_close(con)
      stop(paste0(dim,
                  " is not in variable dimensions: ",
                  paste0(dim_names, collapse = ", "),
                  "."))
    }
    
    dim_idx <- which(dim_names == dim)
    res = con$var[[var]]$dim[[dim_idx]]$vals
  } else {
    res <- con$dim[[dim]]$vals
  }
  ncdf4::nc_close(con)
  res
}

