#' Get NOAA buoy data from the National Buoy Data Center
#'
#' @export
#'
#' @param dataset (character) Dataset name to query. See below for Details. Required
#' @param buoyid Buoy ID, can be numeric/integer/character. Required
#' @param datatype (character) Data type, one of 'c', 'cc', 'p', 'o'. Optional
#' @param year (integer) Year of data collection. Optional
#' @param ... Curl options passed on to \code{\link[httr]{GET}}. Optional
#'
#' @details Functions:
#' \itemize{
#'  \item buoys Get available buoys given a dataset name
#'  \item buoy Get data given some combination of dataset name, buoy ID, year, and datatype
#' }
#'
#' Options for the dataset parameter. One of:
#' \itemize{
#'  \item adcp - Acoustic Doppler Current Profiler data
#'  \item adcp2 - MMS Acoustic Doppler Current Profiler data
#'  \item cwind - Continuous Winds data
#'  \item dart - Deep-ocean Assessment and Reporting of Tsunamis data
#'  \item mmbcur - Marsh-McBirney Current Measurements data
#'  \item ocean - Oceanographic data
#'  \item pwind - Peak Winds data
#'  \item stdmet - Standard Meteorological data
#'  \item swden - Spectral Wave Density data with Spectral Wave Direction data
#'  \item wlevel - Water Level data
#' }
#' @references \url{http://www.ndbc.noaa.gov/} and \url{http://dods.ndbc.noaa.gov/}
#' @examples \dontrun{
#' # Get available buoys
#' buoys(dataset = 'cwind')
#'
#' # Get data for a buoy
#' ## if no year or datatype specified, we get the first file
#' buoy(dataset = 'cwind', buoyid = 46085)
#'
#' # Including specific year
#' buoy(dataset = 'cwind', buoyid = 41001, year = 1999)
#'
#' # Including specific year and datatype
#' buoy(dataset = 'cwind', buoyid = 41001, year = 2008, datatype = "cc")
#' buoy(dataset = 'cwind', buoyid = 41001, year = 2008, datatype = "cc")
#'
#' # Other datasets
#' buoy(dataset = 'ocean', buoyid = 41029)
#'
#' # curl debugging
#' library('httr')
#' buoy(dataset = 'cwind', buoyid = 46085, config=verbose())
#' 
#' # some buoy ids are character, case doesn't matter, we'll account for it
#' buoy(dataset = "stdmet", buoyid = "VCAF1")
#' buoy(dataset = "stdmet", buoyid = "wplf1")
#' buoy(dataset = "dart", buoyid = "dartu")
#' }
buoy <- function(dataset, buoyid, year=NULL, datatype=NULL, ...) {
  check4pkg("ncdf4")
  availbuoys <- buoys(dataset, ...)
  buoyid <- tolower(buoyid)
  page <- availbuoys[grep(buoyid, availbuoys$id, ignore.case = TRUE), "url"]
  files <- buoy_files(path = page, buoyid, ...)
  if (length(files) == 0) stop("No data files found, try a different search", call. = FALSE)
  fileuse <- pick_year_type(files, year, datatype)
  toget <- buoy_single_file_url(dataset, buoyid, fileuse)
  output <- tempdir()
  ncfile <- get_ncdf_file(path = toget, buoyid, file = files[[1]], output)
  buoy_collect_data(ncfile)
}

pick_year_type <- function(x, y, z) {
  if (is.null(y) && is.null(z)) {
    message("Using ", x[[1]])
    return(x[[1]])
  } else if (is.null(z) && !is.null(y)) {
    tt <- pickme(y, x)
    message("Using ", tt)
    return(tt)
  } else if (is.null(y) && !is.null(z)) {
    tt <- pickme(z, x)
    message("Using ", tt)
    return(tt)
  } else {
    pickme(paste0(z, y), x)
  }
}

pickme <- function(findme, against) {
  tmp <- grep(findme, against, value = TRUE)
  if (length(tmp) > 1) tmp[1] else tmp
}

#' @export
#' @rdname buoy
buoys <- function(dataset, ...) {
  url <- sprintf('http://dods.ndbc.noaa.gov/thredds/catalog/data/%s/catalog.html', dataset)
  res <- GET(url, ...)
  tt <- utcf8(res)
  html <- htmlParse(tt)
  folders <- xpathSApply(html, "//a//tt", xmlValue)
  folders <- grep("/", folders, value = TRUE)
  tmp <- paste0(sprintf('http://dods.ndbc.noaa.gov/thredds/catalog/data/%s/', dataset), folders, "catalog.html")
  data.frame(id = gsub("/", "", folders), url = tmp, stringsAsFactors = FALSE)
}

# Get NOAA buoy data from the National Buoy Data Center
buoy_files <- function(path, buoyid, ...){
  singlebuoy_files <- GET(path, ...)
  tt_sbf <- utcf8(singlebuoy_files)
  html_sbf <- htmlParse(tt_sbf)
  files_sbf <- grep(".nc$", xpathSApply(html_sbf, "//a//tt", xmlValue), value = TRUE)
  gsub(tolower(buoyid), "", files_sbf)
}

# Make url for a single NOAA buoy data file
buoy_single_file_url <- function(dataset, buoyid, file){
  sprintf('http://dods.ndbc.noaa.gov/thredds/fileServer/data/%s/%s/%s%s',
          dataset, buoyid, buoyid, file)
}

# Download a single ncdf file
get_ncdf_file <- function(path, buoyid, file, output){
  res <- GET(path)
  outpath <- sprintf("%s/%s%s", output, buoyid, file)
  writeBin(content(res, "raw"), outpath) ### FIXME, do new content parsing
  return(outpath)
}

# Download a single ncdf file
buoy_collect_data <- function(path) {
  nc <- ncdf4::nc_open(path)
  
  out <- list()
  dims <- names(nc$dim)
  for (i in seq_along(dims)) {
    out[[dims[i]]] <- ncdf4::ncvar_get(nc, nc$dim[[dims[i]]])
  }
  out$time <- sapply(out$time, convert_time)
  
  vars <- names(nc$var)
  outvars <- list()
  for (i in seq_along(vars)) {
    outvars[[ vars[i] ]] <- as.vector(ncdf4::ncvar_get(nc, vars[i]))
  }
  df <- do.call("cbind.data.frame", outvars)
  
  rows <- length(outvars[[1]])
  time <- rep(out$time, each = rows/length(out$time))
  lat <- rep(rep(out$latitude, each = length(out$longitude)), length(out$time))
  lon <- rep(rep(out$longitude, times = length(out$latitude)), times = length(out$time))
  meta <- data.frame(time, lat, lon, stringsAsFactors = FALSE)
  alldf <- cbind(meta, df)
  
  nms <- c('name','prec','units','longname','missval','hasAddOffset','hasScaleFact')
  meta <- lapply(vars, function(x) nc$var[[x]][names(nc$var[[x]]) %in% nms])
  names(meta) <- vars
  
  on.exit(ncdf4::nc_close(nc))
  structure(list(meta = meta, data = alldf), class = "buoy")
}

#' @export
print.buoy <- function(x, ..., n = 10) {
  vars <- names(x$meta)
  dims <- dim(x$data)
  cat(sprintf('Dimensions (rows/cols): [%s X %s]', dims[1], dims[2]), "\n")
  cat(sprintf('%s variables: [%s]', length(vars), paste0(vars, collapse = ", ")), "\n\n")
  trunc_mat_(x$data, n = n)
}

convert_time <- function(n = NULL, isoTime = NULL) {
#   if (!is.null(n)) stopifnot(is.numeric(n))
#   if (!is.null(isoTime)) stopifnot(is.character(isoTime))
#   check1notboth(n, isoTime)
  format(as.POSIXct(noaa_compact(list(n, isoTime))[[1]], origin = "1970-01-01T00:00:00Z", tz = "UTC"),
         format = "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
}
