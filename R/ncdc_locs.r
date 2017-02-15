#' Get metadata about NOAA NCDC locations.
#'
#' From the NOAA NCDC API docs: Locations can be a specific latitude/longitude
#' point such as a station, or a label representing a bounding area such as
#' a city.
#'
#' @export
#'
#' @template location
#' @template token
#' @param locationid A valid location id or a vector or list of location ids.
#' @return A list containing metadata and the data, or a single data.frame.
#' @family ncdc
#' @references \url{https://www.ncdc.noaa.gov/cdo-web/webservices/v2}
#' @examples \dontrun{
#' # All locations, first 25 results
#' ncdc_locs()
#'
#' # Fetch more information about location id FIPS:37
#' ncdc_locs(locationid='FIPS:37')
#'
#' # Fetch available locations for the GHCND (Daily Summaries) dataset
#' ncdc_locs(datasetid='GHCND')
#' ncdc_locs(datasetid=c('GHCND', 'ANNUAL'))
#' ncdc_locs(datasetid=c('GSOY', 'ANNUAL'))
#' ncdc_locs(datasetid=c('GHCND', 'GSOM'))
#'
#' # Fetch all U.S. States
#' ncdc_locs(locationcategoryid='ST', limit=52)
#'
#' # Many locationcategoryid's
#' ## this apparently works, but returns nothing often with multiple
#' ## locationcategoryid's
#' ncdc_locs(locationcategoryid=c('ST', 'ZIP'))
#'
#' # Fetch list of city locations in descending order
#' ncdc_locs(locationcategoryid='CITY', sortfield='name', sortorder='desc')
#' }

ncdc_locs <- function(datasetid=NULL, locationid=NULL, locationcategoryid=NULL,
  startdate=NULL, enddate=NULL, sortfield=NULL, sortorder=NULL,
  limit=25, offset=NULL, token=NULL, ...)
{
  token <- check_key(token)
  url <- paste0(ncdc_base(), "locations")
  if (!is.null(locationid)) {
    url <- paste(url, "/", locationid, sep = "")
  }
  args <- noaa_compact(list(locationid=locationid, startdate=startdate,
                       enddate=enddate, token=token, sortfield=sortfield,
                       sortorder=sortorder, limit=limit, offset=offset))
  if (!is.null(datasetid)) {
    datasetid <- lapply(datasetid, function(x) list(datasetid = x))
  }
  if (!is.null(locationcategoryid)) {
    locationcategoryid <- lapply(locationcategoryid, function(x) list(locationcategoryid = x))
  }
  args <- c(args, datasetid, locationcategoryid)
  args <- as.list(unlist(args))
  if (length(args) == 0) args <- NULL
  temp <- GET(url, query=args, add_headers("token" = token), ...)
  tt <- check_response(temp)
  if (inherits(tt, "character")){
    all <- list(meta=NULL, data=NULL)
  } else {
    if (!is.null(locationid)){
      dat <- data.frame(tt, stringsAsFactors=FALSE)
      all <- list(meta=NULL, data=dat)
    } else {
      if (class(try(tt$results, silent = TRUE)) == "try-error"){
        all <- list(meta = NULL, data = NULL)
        warning("Sorry, no data found")
      } else {
        dat <- dplyr::bind_rows(lapply(tt$results, function(x) data.frame(x,stringsAsFactors=FALSE)))
        meta <- tt$metadata$resultset
        atts <- list(totalCount=meta$count, pageCount=meta$limit, offset=meta$offset)
        all <- list(meta=atts, data=dat)
      }
    }
  }
  class(all) <- "ncdc_locs"
  return( all )
}
