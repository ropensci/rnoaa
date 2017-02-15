#' Get metadata about NOAA NCDC stations.
#'
#' From the NOAA NCDC API docs: Stations are where the data comes from
#' (for most datasets) and can be considered the smallest granual of location
#' data. If you know what station you want, you can quickly get all manner of
#' data from it
#'
#' @export
#'
#' @template rnoaa
#' @template rnoaa2
#' @template stations
#' @template token
#' @param datasetid (optional) Accepts a valid dataset id or a vector or
#' list of them. Data returned will be from the dataset specified.
#' @param stationid A single valid station id, with datasetid namespace,
#' e.g., GHCND:USW00014895
#' @return A list of metadata.
#' @family ncdc
#' @references \url{https://www.ncdc.noaa.gov/cdo-web/webservices/v2}
#' @examples \dontrun{
#' # Get metadata on all stations
#' ncdc_stations()
#' ncdc_stations(limit=5)
#'
#' # Get metadata on a single station
#' ncdc_stations(stationid='COOP:010008')
#'
#' # For many stations use lapply or similar
#' lapply(c("COOP:010008", "COOP:010063", "COOP:010116"), function(z) {
#'   ncdc_stations(
#'    startdate = "2013-01-01",
#'    enddate = "2014-11-01",
#'    stationid = z)
#' }$data)
#'
#' # Displays all stations within GHCN-Daily (100 Stations per page limit)
#' ncdc_stations(datasetid = 'GHCND')
#' ncdc_stations(datasetid = 'ANNUAL')
#' ncdc_stations(datasetid = 'GSOY')
#'
#' # Station
#' ncdc_stations(datasetid='NORMAL_DLY', stationid='GHCND:USW00014895')
#'
#' # datatypeid
#' ncdc_stations(datatypeid="ANN-HTDD-NORMAL")
#' ncdc_stations(datatypeid=c("ANN-HTDD-NORMAL", "ACSC"))
#'
#' # locationid
#' ncdc_stations(locationid="CITY:AG000001")
#' ncdc_stations(locationid="FIPS:30091")
#' ncdc_stations(locationid=c("FIPS:30103", "FIPS:30091"))
#'
#' # datacategoryid
#' ncdc_stations(datacategoryid="ANNPRCP")
#' ncdc_stations(datacategoryid="AUAGR")
#' ncdc_stations(datacategoryid=c("ANNPRCP", "AUAGR"))
#'
#' # Displays all stations within GHCN-Daily (Displaying page 10 of the results)
#' ncdc_stations(datasetid='GHCND')
#'
#' # Specify datasetid and locationid
#' ncdc_stations(datasetid='GHCND', locationid='FIPS:12017')
#'
#' # Specify datasetid, locationid, and station
#' ncdc_stations(datasetid='GHCND', locationid='FIPS:12017', stationid='GHCND:USC00084289')
#'
#' # Specify datasetid, locationidtype, locationid, and station
#' ncdc_stations(datasetid='GHCND', locationid='FIPS:12017', stationid='GHCND:USC00084289')
#'
#' # Displays list of stations within the specified county
#' ncdc_stations(datasetid='GHCND', locationid='FIPS:12017')
#'
#' # Displays list of Hourly Precipitation locationids between 01/01/1990 and 12/31/1990
#' ncdc_stations(datasetid='PRECIP_HLY', startdate='19900101', enddate='19901231')
#'
#' # Search for stations by spatial extent
#' ## Search using a bounding box, w/ lat/long of the SW corner, then of NE corner
#' ncdc_stations(extent=c(47.5204,-122.2047,47.6139,-122.1065))
#' }

ncdc_stations <- function(stationid=NULL, datasetid=NULL, datatypeid=NULL, locationid=NULL,
  startdate=NULL, enddate=NULL, sortfield=NULL, sortorder=NULL, limit=25, offset=NULL,
  datacategoryid=NULL, extent=NULL, token=NULL, dataset=NULL,
  station=NULL, location=NULL, locationtype=NULL, page=NULL, ...) {

  token <- check_key(token)

  if (!is.null(stationid)) {
    if (length(stationid) > 1) stop("stationid must be of length 1", call. = FALSE)
    url <- sprintf('%sstations/%s', ncdc_base(), stationid)
    args <- list()
  } else {
    url <- paste0(ncdc_base(), "stations")
    if (!is.null(extent)) {
      stopifnot(length(extent) == 4)
      stopifnot(inherits(extent, "numeric"))
      extent <- paste0(extent, collapse = ",")
    }
    args <- noaa_compact(list(startdate = startdate, enddate = enddate,
          sortfield = sortfield, sortorder = sortorder, limit = limit,
          offset = offset, extent = extent))
  }

  if (!is.null(datasetid)) {
    datasetid <- lapply(datasetid, function(x) list(datasetid = x))
  }
  if (!is.null(datatypeid)) {
    datatypeid <- lapply(datatypeid, function(x) list(datatypeid = x))
  }
  if (!is.null(locationid)) {
    locationid <- lapply(locationid, function(x) list(locationid = x))
  }
  if (!is.null(datacategoryid)) {
    datacategoryid <- lapply(datacategoryid, function(x) list(datacategoryid = x))
  }
  args <- c(args, datasetid, datatypeid, locationid, datacategoryid)
  args <- as.list(unlist(args))

  if (length(args) == 0) args <- NULL
  temp <- GET(url, query = args, add_headers("token" = token), ...)
  tt <- check_response(temp)
  if (inherits(temp, "character")) {
    all <- list(meta = NULL, data = NULL)
  } else {
    if (!is.null(stationid)) {
      dat <- data.frame(tt, stringsAsFactors = FALSE)
      all <- list(meta = NULL, data = dat)
    } else {
      dat <- dplyr::bind_rows(lapply(tt$results, function(x) data.frame(x, stringsAsFactors = FALSE)))
      meta <- tt$metadata$resultset
      atts <- list(totalCount = meta$count, pageCount = meta$limit, offset = meta$offset)
      all <- list(meta = atts, data = dat)
    }
  }
  class(all) <- "ncdc_stations"
  return( all )
}
