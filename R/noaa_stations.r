#' Get metadata about NOAA stations.
#' 
#' @import httr
#' @template rnoaa 
#' @template stations
#' @value A list of metadata.
#' @examples \dontrun{
#' # Displays all stations within GHCN-Daily (100 Stations per page limit)
#' noaa_stations(datasetid='GHCND')
#' 
#' # Station 
#' noaa_stations(datasetid='NORMAL_DLY', stationid='GHCND:USW00014895')
#'
#' # Displays all stations within GHCN-Daily (Displaying page 10 of the results)
#' noaa_stations(datasetid='GHCND')
#' 
#' # Specify datasetid and locationid
#' noaa_stations(datasetid='GHCND', locationid='FIPS:12017')
#' 
#' # Specify datasetid, locationid, and station
#' noaa_stations(datasetid='GHCND', locationid='FIPS:12017', stationid='GHCND:USC00084289')
#' 
#' # Specify datasetid, locationidtype, locationid, and station
#' noaa_stations(datasetid='GHCND', locationid='FIPS:12017', stationid='GHCND:USC00084289')
#' 
#' # Displays list of stations within the specified county
#' noaa_stations(datasetid='GHCND', locationid='FIPS:12017')
#'
#' # Displays list of Hourly Precipitation locationids between 01/01/1990 and 12/31/1990
#' noaa_stations(datasetid='PRECIP_HLY', startdate='19900101', enddate='19901231')
#' }
#' @export
noaa_stations <- function(datasetid=NULL, datatypeid=NULL, stationid=NULL, locationid=NULL, 
  startdate=NULL, enddate=NULL, sortfield=NULL, sortorder=NULL, limit=25, offset=NULL,
  datacategoryid=NULL, extent=NULL,
  token=getOption("noaakey", stop("you need an API key NOAA data")), callopts=list(),
  dataset=NULL, station=NULL, location=NULL, locationtype=NULL, page=NULL)
{  
  url <- 'http://www.ncdc.noaa.gov/cdo-web/api/v2/stations'
  args <- compact(list(datasetid=datasetid, datatypeid=datatypeid, 
                       locationid=locationid, stationid=stationid, startdate=startdate,
                       enddate=enddate, sortfield=sortfield, sortorder=sortorder, 
                       limit=limit, offset=offset, datacategoryid=datacategoryid, 
                       extent=extent))
  
  atts <- list(totalCount=as.numeric(tt$stationCollection$`@totalCount`), 
               pageCount=as.numeric(tt$stationCollection$`@pageCount`)) 
  all <- list(atts=atts, data=dat)
  return( all )
}