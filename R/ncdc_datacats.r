#' Get possible data categories for a particular datasetid, locationid, stationid, etc.
#'
#' Data Categories represent groupings of data types.
#'
#' @export
#' @template datacats
#' @template all
#' @return A \code{data.frame} for all datasets, or a list of length two, each
#'    with a data.frame.
#' @details Note that calls with both startdate and enddate don't seem to work, though specifying
#'    one or the other mostly works.
#' @examples \dontrun{
#' ## Limit to 10 results
#' ncdc_datacats(limit=10)
#'
#' ## Single data category
#' ncdc_datacats(datacategoryid="ANNAGR")
#'
#' ## Fetch data categories for a given set of locations
#' ncdc_datacats(locationid='CITY:US390029')
#' ncdc_datacats(locationid=c('CITY:US390029', 'FIPS:37'))
#'
#' ## Data categories for a given date
#' ncdc_datacats(startdate = '2013-10-01')
#' 
#' ## Curl debugging
#' ncdc_datacats(limit=10, config=verbose())
#' out <- ncdc_datacats(limit=10, config=progress())
#' }

ncdc_datacats <- function(datasetid=NULL, datacategoryid=NULL, stationid=NULL,
  locationid=NULL, startdate=NULL, enddate=NULL, sortfield=NULL, sortorder=NULL,
  limit=25, offset=NULL, token=NULL, ...)
{
  token <- check_key(token)
  url <- "http://www.ncdc.noaa.gov/cdo-web/api/v2/datacategories"
  if(!is.null(datacategoryid))
    url <- paste(url, "/", datacategoryid, sep="")
  args <- c(datasetid=datasetid, locationid=locationid, stationid=stationid,
            startdate=startdate, enddate=enddate, sortfield=sortfield,
            sortorder=sortorder, limit=limit, offset=offset)
  names(args) <- sapply(names(args), function(y) gsub("[0-9+]", "", y), USE.NAMES=FALSE)

  temp <- GET(url, query=as.list(args), add_headers("token" = token), ...)
  tt <- check_response(temp)
  if(is(tt, "character")){
    all <- list(meta=NULL, data=NULL)
  } else {
    if(!is.null(datacategoryid)){
      dat <- data.frame(tt,stringsAsFactors=FALSE)
      all <- list(meta=NULL, data=dat)
    } else
    {
      if(class(try(tt$results, silent=TRUE))=="try-error"){
        all <- list(meta=NULL, data=NULL)
        warning("Sorry, no data found")
      } else {
        dat <- do.call(rbind.fill, lapply(tt$results, function(x) data.frame(x,stringsAsFactors=FALSE)))
        meta <- tt$metadata$resultset
        atts <- list(totalCount=meta$count, pageCount=meta$limit, offset=meta$offset)
        all <- list(meta=atts, data=dat)
      }
    }
  }
  class(all) <- "ncdc_datacats"
  return( all )
}
