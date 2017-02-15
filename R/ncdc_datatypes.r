#' Get possible data types for a particular dataset
#'
#' From the NOAA API docs: Describes the type of data, acts as a label.
#' For example: If it's 64 degrees out right now, then the data type is
#' Air Temperature and the data is 64.
#'
#' @export
#' @template rnoaa
#' @template rnoaa2
#' @template datatypes
#' @template token
#' @param datasetid (optional) Accepts a valid dataset id or a vector or list
#' of them. Data returned will be from the dataset specified.
#' @param stationid Accepts a valid station id or a vector or list of
#' station ids
#' @param datacategoryid Optional. Accepts a valid data category id or a vector
#' or list of data category ids (although it is rare to have a data type with
#' more than one data category)
#' @return A \code{data.frame} for all datasets, or a list of length two,
#' each with a data.frame
#' @family ncdc
#' @references \url{https://www.ncdc.noaa.gov/cdo-web/webservices/v2}
#' @examples \dontrun{
#' # Fetch available data types
#' ncdc_datatypes()
#'
#' # Fetch more information about the ACMH data type id, or the ACSC
#' ncdc_datatypes(datatypeid="ACMH")
#' ncdc_datatypes(datatypeid="ACSC")
#'
#' # datasetid, one or many
#' ## ANNUAL should be replaced by GSOY, but both exist and give
#' ## different answers
#' ncdc_datatypes(datasetid="ANNUAL")
#' ncdc_datatypes(datasetid="GSOY")
#' ncdc_datatypes(datasetid=c("ANNUAL", "PRECIP_HLY"))
#'
#' # Fetch data types with the air temperature data category
#' ncdc_datatypes(datacategoryid="TEMP", limit=56)
#' ncdc_datatypes(datacategoryid=c("TEMP", "AUPRCP"))
#'
#' # Fetch data types that support a given set of stations
#' ncdc_datatypes(stationid='COOP:310090')
#' ncdc_datatypes(stationid=c('COOP:310090','COOP:310184','COOP:310212'))
#'
#' # Fetch data types that support a given set of loncationids
#' ncdc_datatypes(locationid='CITY:AG000001')
#' ncdc_datatypes(locationid=c('CITY:AG000001','CITY:AG000004'))
#' }

ncdc_datatypes <- function(datasetid=NULL, datatypeid=NULL, datacategoryid=NULL,
  stationid=NULL, locationid=NULL, startdate=NULL, enddate=NULL, sortfield=NULL,
  sortorder=NULL, limit=25, offset=NULL, token=NULL,
  dataset=NULL, page=NULL, filter=NULL, ...)
{
  calls <- names(sapply(match.call(), deparse))[-1]
  calls_vec <- c("dataset", "page", "filter") %in% calls
  if (any(calls_vec))
    stop("The parameters dataset, page, and filter \n  have been removed, and were only relavant in the old NOAA API v1. \n\nPlease see documentation for ?ncdc_datatypes", call. = FALSE)

  token <- check_key(token)

  if (!is.null(datatypeid)) {
    url <- sprintf("%sdatatypes/%s", ncdc_base(), datatypeid)
  } else {
    url <- paste0(ncdc_base(), "datatypes")
  }

  args <- noaa_compact(list(startdate=startdate, enddate=enddate,
                            sortfield=sortfield, sortorder=sortorder,
                            limit=limit, offset=offset))
  if (!is.null(datasetid)) {
    datasetid <- lapply(datasetid, function(x) list(datasetid = x))
  }
  if (!is.null(stationid)) {
    stationid <- lapply(stationid, function(x) list(stationid = x))
  }
  if (!is.null(datacategoryid)) {
    datacategoryid <- lapply(datacategoryid, function(x) list(datacategoryid = x))
  }
  if (!is.null(locationid)) {
    locationid <- lapply(locationid, function(x) list(locationid = x))
  }
  args <- c(args, datasetid, stationid, datacategoryid, locationid)
  args <- as.list(unlist(args))
  names(args) <- gsub("[0-9]+", "", names(args))
  if (length(args) == 0) args <- NULL
  temp <- GET(url, query = args, add_headers("token" = token), ...)
  out <- check_response(temp)
  if (inherits(out, "character")) {
    all <- list(meta = NULL, data = NULL)
  } else {
    if (!is.null(datatypeid)) {
      dat <- data.frame(out, stringsAsFactors = FALSE)
      metadat <- NULL
      all <- list(data = dat, meta = metadat)
    } else {
      dat <- dplyr::bind_rows(lapply(out$results, function(x) data.frame(x, stringsAsFactors = FALSE)))
      metadat <- data.frame(out$metadata$resultset, stringsAsFactors = FALSE)
      all <- list(meta = metadat, data = dat)
    }
  }
  class(all) <- "ncdc_datatypes"
  return( all )
}
