#' Search NOAA datasets
#'
#' From the NOAA API docs: All of our data are in datasets. To retrieve any data
#' from us, you must know what dataset it is in.
#'
#' @export
#'
#' @template rnoaa
#' @template rnoaa2
#' @template datasets
#' @template token
#' @param datasetid (optional) Accepts a single valid dataset id. Data returned
#' will be from the dataset specified.
#' @param stationid Accepts a valid station id or a vector or list of station
#' ids
#' @return A data.frame for all datasets, or a list of length two, each with
#' a data.frame.
#' @family ncdc
#' @references \url{https://www.ncdc.noaa.gov/cdo-web/webservices/v2}
#' @examples \dontrun{
#' # Get a table of all datasets
#' ncdc_datasets()
#'
#' # Get details from a particular dataset
#' ncdc_datasets(datasetid='ANNUAL')
#'
#' # Get datasets with Temperature at the time of observation (TOBS) data type
#' ncdc_datasets(datatypeid='TOBS')
#' ## two datatypeid's
#' ncdc_datasets(datatypeid=c('TOBS', "ACMH"))
#'
#' # Get datasets with data for a series of the same parameter arg, in this case
#' # stationid's
#' ncdc_datasets(stationid='COOP:310090')
#' ncdc_datasets(stationid=c('COOP:310090','COOP:310184','COOP:310212'))
#'
#' # Multiple datatypeid's
#' ncdc_datasets(datatypeid=c('ACMC','ACMH','ACSC'))
#' ncdc_datasets(datasetid='ANNUAL', datatypeid=c('ACMC','ACMH','ACSC'))
#' ncdc_datasets(datasetid='GSOY', datatypeid=c('ACMC','ACMH','ACSC'))
#'
#' # Multiple locationid's
#' ncdc_datasets(locationid="FIPS:30091")
#' ncdc_datasets(locationid=c("FIPS:30103", "FIPS:30091"))
#' }

ncdc_datasets <- function(datasetid=NULL, datatypeid=NULL, stationid=NULL, locationid=NULL,
  startdate=NULL, enddate=NULL, sortfield=NULL, sortorder=NULL, limit=25, offset=NULL,
  token=NULL, dataset=NULL, page=NULL, year=NULL, month=NULL, ...)
{
  calls <- names(sapply(match.call(), deparse))[-1]
  calls_vec <- c("dataset", "page", "year", "month") %in% calls
  if (any(calls_vec))
    stop("The parameters dataset, page, year, and month \n  have been removed, and were only relavant in the old NOAA API v1. \n\nPlease see documentation for ?ncdc_datasets")

  token <- check_key(token)

  url <- paste0(ncdc_base(), "datasets")
  if (!is.null(datasetid)) url <- paste(url, "/", datasetid, sep = "")
  args <- noaa_compact(list(startdate=startdate,
                       enddate=enddate, sortfield=sortfield, sortorder=sortorder,
                       limit=limit, offset=offset))
  if (!is.null(stationid)) {
    stationid <- lapply(stationid, function(x) list(stationid = x))
  }
  if (!is.null(datatypeid)) {
    datatypeid <- lapply(datatypeid, function(x) list(datatypeid = x))
  }
  if (!is.null(locationid)) {
    locationid <- lapply(locationid, function(x) list(locationid = x))
  }
  args <- c(args, stationid, datatypeid, locationid)
  args <- as.list(unlist(args))
  names(args) <- gsub("[0-9]+", "", names(args))
  if (length(args) == 0) args <- NULL
  temp <- GET(url, query = args, add_headers("token" = token), ...)
  tt <- check_response(temp)
  if (inherits(tt, "character")) {
    all <- list(meta = NULL, data = NULL)
  } else {
    if (!is.null(datasetid)) {
      dat <- data.frame(tt, stringsAsFactors = FALSE)
      all <- list(meta = NULL, data = dat)
    } else {
      dat <- dplyr::bind_rows(lapply(tt$results, function(x) data.frame(x, stringsAsFactors = FALSE)))
      all <- list(meta = tt$metadata$resultset, data = dat)
    }
  }
  structure(all, class = "ncdc_datasets")
}
