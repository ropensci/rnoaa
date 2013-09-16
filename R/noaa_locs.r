#' Get metadata about NOAA locations.
#' 
#' @import lubridate httr
#' @template rnoaa 
#' @param datatype The data type, see function \code{\link{noaa_datatypes}}.
#' @param location A single location code.
#' @param locationtype A single location type code.
#' @return A data.frame of metadata.
#' @examples \dontrun{
#' # Find locations within the Daily Normals dataset
#' noaa_locs(dataset='NORMAL_DLY', startdate='20100101')
#' 
#' # Displays the location CITY:CA000012 within the PRECIP_HLY dataset
#' noaa_locs(dataset='PRECIP_HLY', location='CITY:CA000012')
#' 
#' # Displays available countries within GHCN-Daily
#' noaa_locs(dataset='GHCND', locationtype='CNTRY')
#' }
#' @export
noaa_locs <- function(dataset=NULL,location=NULL,locationtype=NULL,
  startdate=NULL,enddate=NULL,page=NULL,
  token=getOption("noaakey", stop("you need an API key for NOAA data")),
  callopts=list())
{
  base <- 'http://www.ncdc.noaa.gov/cdo-services/services/datasets'
  args <- compact(list(startdate=startdate,enddate=enddate,page=page,token=token))
  params <- compact(list(dataset=dataset,location=location,locationtype=locationtype))
  
  if(all(names(params) %in% 'dataset')){
    url <- sprintf("%s/%s/locations", base, dataset)
  } else
    if(all(names(params) %in% c('dataset','location'))){
      url <- sprintf("%s/%s/locations/%s", base, dataset, location)
    } else
    { url <- sprintf("%s/%s/locationtypes/%s/locations", base, dataset, locationtype) }
  
  temp <- GET(url, query=args, callopts)
  stop_for_status(temp)
  tt <- content(temp)
  temp <- ldply(tt$locationCollection$location, 
                function(x) data.frame(x[!names(x) %in% 'locationType'], data.frame(x$locationType)))
  atts <- list(totalCount=as.numeric(tt$locationCollection$`@totalCount`), 
               pageCount=as.numeric(tt$locationCollection$`@pageCount`)) 
  all <- list(atts=atts, data=temp)
  return( all )
}