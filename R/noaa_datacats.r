#' Get possible data types for a particular dataset. 
#' 
#' Data Categories represent groupings of data types.
#'   
#' @template rnoaa
#' @template datacats
#' @value A \code{data.frame} for all datasets, or a list of length two, each with a data.frame.
#' @examples \dontrun{
#' noaa_datacats(limit=41)
#'
#' ## With a filter
#' noaa_datacats(datasetid="ANNAGR")
#' 
#' ## With a filter
#' noaa_datacats(locationid='CITY:US390029', locationid='FIPS:37')
#' }
#' @export
noaa_datacats <- function(datasetid=NULL, stationid=NULL, locationid=NULL, 
  startdate=NULL, enddate=NULL, sortfield=NULL, sortorder=NULL, limit=25, offset=NULL, 
  callopts=list(), token=getOption("noaakey", stop("you need an API key NOAA data")))
{  
  url <- sprintf("http://www.ncdc.noaa.gov/cdo-web/api/v2/datacategories", dataset)
  args <- compact(list(datasetid=datasetid, datatypeid=datatypeid, 
                       locationid=locationid, stationid=stationid, startdate=startdate,
                       enddate=enddate, sortfield=sortfield, sortorder=sortorder, 
                       limit=limit, offset=offset))
  temp <- GET(url, query=args, config = add_headers("token" = token))
  stop_for_status(temp)
  raw_out <- content(temp)
  
}