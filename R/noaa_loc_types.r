#' Get metadata about NOAA location types.
#' 
#' @import lubridate httr
#' @template rnoaa 
#' @param datatype The data type, see function \code{\link{noaa_datatypes}}.
#' @param locationtype  A single location type code.
#' @return A data.frame of metadata.
#' @examples \dontrun{
#' # Displays location types within GHCN-Daily data
#' noaa_loc_types(dataset='GHCND')
#' 
#' # Show details of Hydrologic Cataloging Unit data
#' noaa_loc_types(dataset='GHCND', locationtype='HYD_CAT')
#' }
#' @export
noaa_loc_types <- function(dataset=NULL,locationtype=NULL,startdate=NULL,
  enddate=NULL,page=NULL,
  token=getOption("noaakey", stop("you need an API key for NOAA data")), 
  callopts=list())
{
  base <- 'http://www.ncdc.noaa.gov/cdo-services/services/datasets'
  if(is.null(locationtype)){
    url <- sprintf("%s/%s/locationtypes", base, dataset)
  } else
  {
    url <- sprintf("%s/%s/locationtypes/%s", base, dataset, locationtype)
  }
  args <- compact(list(startdate=startdate,enddate=enddate,page=page,token=token))
  temp <- GET(url, query=args, callopts)
  stop_for_status(temp)
  tt <- content(temp)
  if(is.null(locationtype))
    dat <- ldply(tt$locationTypeCollection$locationType, function(x) as.data.frame(x))
  else
    dat <- data.frame(tt$locationTypeCollection$locationType)
  return( dat )
}