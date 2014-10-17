#' Get NOAA buoy data from the National Buoy Data Center
#'
#' @import httr XML ncdf4
#' @export
#'
#' @param dataset Dataset to query. See below for details. (required)
#' @param buoyid Buoy id. (optional)
#' @param datatype Data type, one of 'c', 'cc', 'p'. (optional)
#' @param year Year of data collection. (optional)
#' @param ... Further arguments passed on to the API GET call. (optional)
#' @param x Input to print, output from buoy function.
#'
#' @details
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
#' @return A data.frame
#' @seealso \link{buoy_buoys}, \link{buoy_files}, \link{buoy_single_file_url},
#' \link{get_ncdf_file}, \link{buoy_collect_data}
#'
#' @examples \dontrun{
#' buoy(dataset = 'cwind', buoyid = 46085)
#' buoy(dataset = 'pwind', buoyid = 41021)
#'
#' #curl debugging
#' library('httr')
#' buoy(dataset = 'cwind', buoyid = 46085, config=verbose())
#' }

buoy <- function(dataset=NULL, buoyid=NULL, datatype=NULL, year=NULL, ...)
{
  if(is.null(dataset)) stop("You must supply a dataset")

  availbuoys <- buoy_buoys(dataset, ...)
  page <- availbuoys[grep(buoyid, names(availbuoys))][[1]]
  files <- buoy_files(page, buoyid, ...)
  toget <- buoy_single_file_url(dataset, buoyid, files[[1]])
  output <- tempdir()
  ncfile <- get_ncdf_file(toget, buoyid, files[[1]], output)
  buoy_collect_data(path=ncfile)
}

#' Get NOAA buoy data from the National Buoy Data Center
#'
#' @export
#' @keywords internal
#' @param dataset Dataset to query. See below for details. (required)
#' @param ... Further arguments passed on to the API GET call. (optional)
buoy_buoys <- function(dataset=NULL, ...)
{
  if(is.null(dataset)) stop("You must supply a dataset")
  url <- sprintf('http://dods.ndbc.noaa.gov/thredds/catalog/data/%s/catalog.html', dataset)
  res <- GET(url, ...)
  tt <- content(res, as="text")
  html <- htmlParse(tt)
  folders <- xpathSApply(html, "//a//tt", xmlValue)
  folders <- grep("/", folders, value = TRUE)
  tmp <- paste0(sprintf('http://dods.ndbc.noaa.gov/thredds/catalog/data/%s/', dataset), folders, "catalog.html")
  names2 <- gsub("/", "", folders)
  names(tmp) <- names2
  message(sprintf("Available buoys in %s:", dataset))
  cat(names2)
  return( tmp )
}

#' Get NOAA buoy data from the National Buoy Data Center
#'
#' @export
#' @keywords internal
#' @param path Path to a single buoy data file
#' @param buoyid Buoy id. (optional)
#' @param ... Further arguments passed on to the API GET call. (optional)
buoy_files <- function(path, buoyid, ...){
  singlebuoy_files <- GET(path, ...)
  tt_sbf <- content(singlebuoy_files, as="text")
  html_sbf <- htmlParse(tt_sbf)
  files_sbf <- grep(".nc$", xpathSApply(html_sbf, "//a//tt", xmlValue), value = TRUE)
  availfiles <- gsub(buoyid, "", files_sbf)
  message(sprintf("Available files for buoy %s:", buoyid))
  cat(availfiles)
  return( availfiles )
}

#' Make url for a single NOAA buoy data file
#'
#' @export
#' @keywords internal
#' @param dataset Dataset to query. See below for details. (required)
#' @param buoyid Buoy id. (optional)
#' @param file Output file name
buoy_single_file_url <- function(dataset, buoyid, file){
  sprintf('http://dods.ndbc.noaa.gov/thredds/fileServer/data/%s/%s/%s%s',
          dataset, buoyid, buoyid, file)
}

#' Download a single ncdf file
#'
#' @export
#' @keywords internal
#' @param path Path to a single buoy data file
#' @param buoyid Buoy id. (optional)
#' @param file XX
#' @param output XX
get_ncdf_file <- function(path, buoyid, file, output){
  res <- GET(path)
  outpath <- sprintf("%s/%s%s", output, buoyid, file)
  writeBin(content(res), outpath)
  return(outpath)
}

#' Download a single ncdf file
#'
#' @export
#' @keywords internal
#' @param path Path to a single buoy data file on local system
buoy_collect_data <- function(path){
  dat <- nc_open(path)
  variables <- names(dat$var)
  data <- lapply(variables, function(x) ncvar_get(nc = dat, varid = x))
  df <- data.frame(do.call(cbind, data), stringsAsFactors = FALSE)
  names(df) <- variables
  head(df)

  meta <- lapply(variables, function(x) dat$var[[x]][names(dat$var[[x]]) %in% c('name','prec','units','longname','missval','hasAddOffset','hasScaleFact')])
  names(meta) <- variables
  nc_close( dat )

  all <- list(metadata=meta, data=df)
  class(all) <- "buoy"
  return( all )
}

#' @method print buoy
#' @export
#' @rdname buoy
print.buoy <- function(x, ...)
{
  cat("\n")
  vars <- names(x$metadata)
  dims <- dim(x$data)
  cat(sprintf('Dimensions: [rows %s, cols %s]', dims[1], dims[2]), "\n")
  cat(sprintf('%s variables: [%s]', length(vars), paste0(vars, collapse = ", ")), "\n\n")
  print(head(x$data, n = 10))
}
