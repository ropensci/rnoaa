#' Get NOAA buoy data from the National Buoy Data Center
#' 
#' @importFrom XML htmlParse
#' @export
#'
#' @param dataset (character) Dataset name to query. See below for Details. Required
#' @param buoyid (integer) Buoy ID. Required
#' @param datatype (character) Data type, one of 'c', 'cc', 'p', 'o'
#' @param year (integer) Year of data collection
#' @param ... Curl options passed on to \code{\link[httr]{GET}} (optional)
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
#'  \item stdmet- Standard Meteorological data
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
#' buoy(dataset = 'ocean', buoyid = 42856)
#'
#' # curl debugging
#' library('httr')
#' buoy(dataset = 'cwind', buoyid = 46085, config=verbose())
#' }
buoy <- function(dataset, buoyid, year=NULL, datatype=NULL, ...) {
  check4ncdf()
  availbuoys <- buoys(dataset, ...)
  page <- availbuoys[grep(buoyid, availbuoys$id), "url"]
  files <- buoy_files(page, buoyid, ...)
  if (length(files) == 0) stop("No data files found, try a different search", call. = FALSE)
  fileuse <- pick_year_type(files, year, datatype)
  toget <- buoy_single_file_url(dataset, buoyid, fileuse)
  output <- tempdir()
  ncfile <- get_ncdf_file(toget, buoyid, files[[1]], output)
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
  tt <- content(res, as = "text")
  html <- htmlParse(tt)
  folders <- xpathSApply(html, "//a//tt", xmlValue)
  folders <- grep("/", folders, value = TRUE)
  tmp <- paste0(sprintf('http://dods.ndbc.noaa.gov/thredds/catalog/data/%s/', dataset), folders, "catalog.html")
  data.frame(id = gsub("/", "", folders), url = tmp, stringsAsFactors = FALSE)
}

# Get NOAA buoy data from the National Buoy Data Center
buoy_files <- function(path, buoyid, ...){
  singlebuoy_files <- GET(path, ...)
  tt_sbf <- content(singlebuoy_files, as = "text")
  html_sbf <- htmlParse(tt_sbf)
  files_sbf <- grep(".nc$", xpathSApply(html_sbf, "//a//tt", xmlValue), value = TRUE)
  gsub(buoyid, "", files_sbf)
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
  writeBin(content(res), outpath)
  return(outpath)
}

# Download a single ncdf file
buoy_collect_data <- function(path){
  nc <- ncdf::open.ncdf(path)
  
  out <- list()
  dims <- names(nc$dim)
  for (i in seq_along(dims)) {
    out[[dims[i]]] <- ncdf::get.var.ncdf(nc, nc$dim[[dims[i]]])
  }
  out$time <- sapply(out$time, convert_time)
  
  vars <- names(nc$var)
  outvars <- list()
  for (i in seq_along(vars)) {
    outvars[[ vars[i] ]] <- as.vector(ncdf::get.var.ncdf(nc, vars[i]))
  }
  df <- do.call("cbind.data.frame", outvars)
  
  rows <- length(outvars[[1]])
  out <- lapply(out, function(z) rep(z, each = rows/length(z)))
  
  meta <- data.frame(out, stringsAsFactors = FALSE)
  alldf <- cbind(meta, df)
  
  nms <- c('name','prec','units','longname','missval','hasAddOffset','hasScaleFact')
  meta <- lapply(vars, function(x) nc$var[[x]][names(nc$var[[x]]) %in% nms])
  names(meta) <- vars
  
  invisible(ncdf::close.ncdf(nc))
  all <- list(meta = meta, data = alldf)
  class(all) <- "buoy"
  return( all )
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

# check1notboth <- function(x, y) {
#   if (is.null(x) && is.null(y)) {
#     stop(sprintf("One of %s or %s must be non-NULL", deparse(substitute(x)), deparse(substitute(y))), call. = FALSE)
#   }
#   if (!is.null(x) && !is.null(y)) {
#     stop(sprintf("Supply only one of %s or %s", deparse(substitute(x)), deparse(substitute(y))), call. = FALSE)
#   }
# }

# check for ncdf
check4ncdf <- function() {
  if (!requireNamespace("ncdf", quietly = TRUE)) {
    stop("Please install ncdf", call. = FALSE)
  } else {
    invisible(TRUE)
  }
}
