#' Get metadata about NOAA NCDC locations.
#'
#' From the NOAA NCDC API docs: Locations can be a specific latitude/longitude point
#' such as a station, or a label representing a bounding area such as a city.
#'
#' @import httr
#' @importFrom plyr compact rbind.fill
#' @export
#' @template location
#' @param locationid A valid location id or a chain of location ids seperated by
#'    ampersands. Data returned will contain data for the location(s) specified (optional)
#' @return A list containing metadata and the data, or a single data.frame.
#' @examples \dontrun{
#' # All locations, first 25 results
#' ncdc_locs()
#'
#' # Fetch more information about location id FIPS:37
#' ncdc_locs(locationid='FIPS:37')
#'
#' # Fetch available locations for the GHCND (Daily Summaries) dataset
#' ncdc_locs(datasetid='GHCND')
#'
#' # Fetch all U.S. States
#' ncdc_locs(locationcategoryid='ST', limit=52)
#'
#' # Fetch list of city locations in descending order
#' ncdc_locs(locationcategoryid='CITY', sortfield='name', sortorder='desc')
#' }

ncdc_locs <- function(datasetid=NULL, locationid=NULL, locationcategoryid=NULL,
  startdate=NULL, enddate=NULL, sortfield=NULL, sortorder=NULL,
  limit=25, offset=NULL, callopts=list(), token=NULL)
{
  if(is.null(token))
    token <- getOption("noaakey", stop("you need an API key NOAA data"))
  url <- 'http://www.ncdc.noaa.gov/cdo-web/api/v2/locations'
  if(!is.null(locationid))
    url <- paste(url, "/", locationid, sep="")
  args <- compact(list(datasetid=datasetid,locationid=locationid,
                       locationcategoryid=locationcategoryid,startdate=startdate,
                       enddate=enddate,token=token,sortfield=sortfield,
                       sortorder=sortorder,limit=limit,offset=offset))

  callopts <- c(add_headers("token" = token), callopts)
  temp <- GET(url, query=as.list(args), config=callopts)
  tt <- check_response(temp)
  if(is(tt, "character")){
    all <- list(meta=NULL, data=NULL)
  } else {
    if(!is.null(locationid)){
      dat <- data.frame(tt, stringsAsFactors=FALSE)
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
  class(all) <- "ncdc_locs"
  return( all )
}
