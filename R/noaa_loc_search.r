#' Get metadata about NOAA stations.
#' 
#' @import lubridate httr
#' @template rnoaa 
#' @param datatype The data type, see function \code{\link{noaa_datatypes}}.
#' @param radius  Measured in kilometers, the default is 100km but can be 
#'    specified at any level. Requires latitude and longitude.
#' @param latitude The latitude of a point in decimal format. Required.
#' @param longitude The longitude of a point in decimal format. Required.
#' @param sort This parameter accepts a string as input and is optional; the 
#'    default value is best. Valid values for this parameter are: best, alpha, 
#'    and reverseAlpha.
#' @param category Parameter to choose stations, location, or both as results 
#'    for the search service. Valid string values for this optional parameter 
#'    are: all, stationsOnly, and locationsOnly.
#' @param pagesize This controls the size of the page of data which is returned 
#'    from the service. This variable only accepts an integer as input and is 
#'    optional.
#' @return A list of metadata.
#' @examples \dontrun{
#' # Search for GHCN-Daily stations within 100km of a lat/long point
#' noaa_loc_search(dataset='GHCND', latitude=35.59528, longitude=-82.55667)
#' 
#' # Search for hrly precip stations within 25km of a lat/long point in Kansas
#' noaa_loc_search(dataset='PRECIP_HLY', latitude=38.002511, longitude=-98.514404, radius=25)
#' }
#' @export
noaa_loc_search <- function(dataset=NULL,radius=NULL,latitude=NULL,longitude=NULL, 
  startdate=NULL,enddate=NULL,sort=NULL,category=NULL,page=NULL,pagesize=NULL,
  token=getOption("noaakey", stop("you need an API key for NOAA data")), 
  callopts=list())
{
  url <- sprintf(
    'http://www.ncdc.noaa.gov/cdo-services/services/datasets/%s/locationsearch', 
    dataset)
  args <- compact(list(dataset=dataset,radius=radius,latitude=latitude, 
                       longitude=longitude,startdate=startdate,enddate=enddate,
                       sort=sort,category=category,page=page,pagesize=pagesize,
                       token=token))
  temp <- GET(url, query=args, callopts)
  stop_for_status(temp)
  tt <- content(temp)
  dat <- ldply(tt$searchResultCollection$searchResult, function(x) as.data.frame(x))
  
  atts <- list(totalCount=as.numeric(tt$searchResultCollection$`@totalCount`), 
               pageCount=as.numeric(tt$searchResultCollection$`@pageCount`)) 
  all <- list(atts=atts, data=dat)
  return( all )
}