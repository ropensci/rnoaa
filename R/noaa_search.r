#' Search metadata about NOAA locations.
#' 
#' @import lubridate httr
#' @template rnoaa 
#' @param datatype The data type, see function \code{\link{noaa_datatypes}}.
#' @param resulttype The type id indicating the type of result to return. One of
#'    station, city, country, country.
#' @param location A single location code.
#' @param locationtype A single location type code.
#' @return A data.frame of metadata.
#' @examples \dontrun{
#' # Search GHCN-Daily stations which contain the label "Boulder"
#' noaa_search(dataset='GHCND', resulttype='station', text='Boulder')
#' 
#' # Search 15 Minute Precipitation countries labeled with "United States"
#' noaa_search(dataset='GHCND', resulttype='station', text='United States')
#' }
#' @export
noaa_search <- function(dataset=NULL,resulttype=NULL,text=NULL,datatypecategory=NULL,
  startdate=NULL,enddate=NULL,sort=NULL,page=NULL,pagesize=NULL,
  token=getOption("noaakey", stop("you need an API key for NOAA data")),
  callopts=list())
{
  url <- sprintf(
    'http://www.ncdc.noaa.gov/cdo-services/services/datasets/%s/search', 
    dataset)
  args <- compact(list(resulttype=resulttype,text=text,datatypecategory=datatypecategory,
                       startdate=startdate,enddate=enddate,sort=sort,page=page,
                       pagesize=pagesize,token=token))
  temp <- GET(url, query=args, callopts)
  stop_for_status(temp)
  tt <- content(temp)
  dat <- ldply(tt$searchResultCollection$searchResult, function(x) as.data.frame(x))
  
  atts <- list(totalCount=as.numeric(tt$searchResultCollection$`@totalCount`), 
               pageCount=as.numeric(tt$searchResultCollection$`@pageCount`)) 
  all <- list(atts=atts, data=dat)
  return( all )
}