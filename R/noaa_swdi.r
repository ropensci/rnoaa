#' Get NOAA data for the sever weather data inventory (swdi).
#' 
#' @import httr XML
#' @importFrom plyr compact
#' @importFrom data.table rbindlist
#' @param dataset Dataset to query. See below for details.
#' @param format File format to download. One of xml, csv, shp, or kmz.
#' @param startdate Start date. See details.
#' @param enddate End date. See details.
#' @param limit Number of results to return. Defaults to 25. Any number from 1 to 10000000.
#' @param offset Any number from 1 to 10000000. Default is NULL, no offset, start from 1.
#' @param radius Search radius in miles (current limit is 15 miles)
#' @param center Center coordinate in lon,lat decimal degree format, e.g.: c(-95.45,36.88)
#' @param bbox Bounding box in format of minLon,minLat,maxLon,maxLat, e.g.: c(-91,30,-90,31)
#' @param tile Coordinate in lon,lat decimal degree format, e.g.: c(-95.45,36.88)
#'    The lat/lon values are rounded to the nearest tenth of degree. For the above example, 
#'    the matching tile would contain values from -95.4500 to -95.5499 and 36.8500 to 36.9499
#' @param stat One of count or tilesum:$longitude,$latitude. Setting stat='count' returns 
#'    number of results only (no actual data). stat='tilesum:$longitude,$latitude' returns 
#'    daily feature counts for a tenth of a degree grid centered at the nearest tenth of a 
#'    degree to the supplied values. 
#' @param id An identifier, e.g., 533623. Not sure how you find these ids?
#' @param callopts Further arguments passed on to the API GET call. (optional)
#' @details
#' Options for the dataset parameter. One of (and their data formats): 
#' \itemize{
#'  \item nx3tvs NEXRAD Level-3 Tornado Vortex Signatures (point)
#'  \item nx3meso NEXRAD Level-3 Mesocyclone Signatures (point)
#'  \item nx3hail NEXRAD Level-3 Hail Signatures (point)
#'  \item nx3structure NEXRAD Level-3 Storm Cell Structure Information (point)
#'  \item plsr Preliminary Local Storm Reports (point)
#'  \item warn Severe Thunderstorm, Tornado, Flash Flood and Special Marine warnings (polygon)
#'  \item nldn Lightning strikes from Vaisala (.gov and .mil ONLY) (point)
#' }
#' 
#' For startdate and enddate, the date range syntax is 'startDate:endDate' or special 
#' option of 'periodOfRecord'. Note that startDate is inclusive and endDate is exclusive.
#' All dates and times are in GMT. The current limit of the date range size is one year.
#' 
#' All latitude and longitude values for input parameters and output data are in the 
#' WGS84 datum.
#' 
#' @return A list of length three, a slot of metadata (meta), a slot for data (data), 
#' and a slot for shape file data with a single column 'shape'. The meta slot is a 
#' list of metadata elements, and the data slot is a data.frame, possibly of length zero 
#' if no data is found.
#' 
#' @export
#' @examples \dontrun{
#' # Search for nx3tvs data from 5 May 2006 to 6 May 2006
#' noaa_swdi(dataset='nx3tvs', startdate='20060505', enddate='20060506')
#' 
#' # Get all 'nx3tvs' within 15 miles of latitude = 32.7 and longitude = -102.0
#' noaa_swdi(dataset='nx3tvs', startdate='20060506', enddate='20060507', 
#' radius=15, center=c(-102.0,32.7))
#' 
#' # Get the warning text for the warning with id=533623
#' noaa_swdi(dataset='warn', id=533623)
#'
#' # Get all 'plsr' within the bounding box (-91,30,-90,31)
#' noaa_swdi(dataset='plsr', startdate='20060505', enddate='20060510', 
#' bbox=c(-91,30,-90,31))
#' 
#' # Get all 'nx3tvs' within the tile -102.1/32.6 (-102.15,32.55,-102.25,32.65)
#' noaa_swdi(dataset='nx3tvs', startdate='20060506', enddate='20060507', 
#' tile=c(-102.12,32.62))
#'
#' # Counts
#' ## Note: stat='count' will only return metadata, nothing in the data or shape slots
#' ## Note: stat='tilesum:...' returns counts in the data slot for each date for that tile,
#' ##   and shape data
#' ## Get number of 'nx3tvs' within 15 miles of latitude = 32.7 and longitude = -102.0
#' noaa_swdi(dataset='nx3tvs', startdate='20060505', enddate='20060516', radius=15, 
#' center=c(-102.0,32.7), stat='count')
#' 
#' ## Get daily count nx3tvs features on .1 degree grid centered at latitude = 32.7 
#' ## and longitude = -102.0
#' noaa_swdi(dataset='nx3tvs', startdate='20060505', enddate='20090516', 
#' stat='tilesum:-102.0,32.7')
#' }

noaa_swdi <- function(dataset=NULL, format='xml', startdate=NULL, enddate=NULL, limit=25, 
  offset=NULL, radius=NULL, center=NULL, bbox=NULL, tile=NULL, stat=NULL, id=NULL, 
  callopts=list())
{
  if(is.null(enddate)){
    daterange <- startdate
  } else {
    daterange <- paste0(startdate, ":", enddate)
  }
  center <- if(!is.null(center)) paste(center, collapse = ",")
  bbox <- if(!is.null(bbox)) paste(bbox, collapse = ",")
  tile <- if(!is.null(tile)) paste(tile, collapse = ",")
  if(is.null(offset)){
    url <- sprintf('http://www.ncdc.noaa.gov/swdiws/%s/%s/%s/%s', format, dataset, daterange, limit)
  } else if(!is.null(offset)){
    url <- sprintf('http://www.ncdc.noaa.gov/swdiws/%s/%s/%s/%s/%s', format, dataset, daterange, limit, offset)
  }
  args <- compact(list(radius=radius, center=center, bbox=bbox, tile=tile, stat=stat))
  
  temp <- GET(url, query=args, config = callopts)
  stop_for_status(temp)
  tt <- content(temp)
  
  res <- xpathSApply(tt, "//result")
  aslist <- lapply(res, xmlToList)
  dat <- data.frame(rbindlist(aslist), stringsAsFactors = FALSE)
  shp <- data.frame(shape=dat[, names(dat) %in% 'shape'], stringsAsFactors = FALSE)
  dat <- dat[, !names(dat) %in% c('shape','rownumber')]
  
  meta <- list(totalCount=as.numeric(xpathSApply(tt, "//summary/totalCount", xmlValue)),
               totalTimeInSeconds=as.numeric(xpathSApply(tt, "//summary/totalTimeInSeconds", xmlValue)))
  
  all <- list(meta=meta, data=dat, shape=shp)
  class(all) <- "noaa_swdi"
  return( all )
}