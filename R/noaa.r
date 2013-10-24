#' Get NOAA data for any combination of dataset, datatype, station, location, 
#' and/or location type.
#' 
#' This is the main function to get NOAA data.
#' 
#' @import httr
#' @importFrom plyr compact round_any
#' @template rnoaa 
#' @template noaa
#' @return A data.frame for all datasets, or a list of length two, each with a 
#'    data.frame.
#' @examples \dontrun{
#' noaa(datasetid='GHCND', locationid = 'FIPS:02', startdate = '2010-05-01', enddate = '2010-05-31', limit=5)
#' 
#' # GHCN-Daily data since Septemer 1 2013
#' noaa(datasetid='GHCND', startdate = '2013-09-01')
#' 
#' # Normals Daily GHCND:USW00014895 dly-tmax-normal data
#' noaa(datasetid='NORMAL_DLY', stationid='GHCND:USW00014895', startdate = '2010-05-01', enddate = '2010-05-10')
#' 
#' # Dataset, and location in Australia
#' noaa(datasetid='GHCND', locationid='FIPS:AS', limit=5)
#' 
#' # Dataset, location and datatype
#' noaa(datasetid='PRECIP_HLY', locationid='ZIP:28801', datatypeid='HPCP', limit=5)
#' 
#' # Dataset, location, station and datatype
#' noaa(datasetid='PRECIP_HLY', locationid='ZIP:28801', stationid='COOP:310301', datatypeid='HPCP', limit=5)
#' 
#' # Dataset, location, and datatype
#' noaa(datasetid='GHCND', locationid='FIPS:BR', datatypeid='PRCP', limit=5)
#' 
#' # Normals Daily GHCND dly-tmax-normal data
#' noaa(datasetid='NORMAL_DLY', datatypeid='dly-tmax-normal', limit=5)
#' 
#' # Normals Daily GHCND:USW00014895 dly-tmax-normal
#' noaa(datasetid='NORMAL_DLY', stationid='GHCND:USW00014895', datatypeid='dly-tmax-normal', limit=5)
#' 
#' # Hourly Precipitation data for ZIP code 28801
#' noaa(datasetid='PRECIP_HLY', locationid='ZIP:28801', datatypeid='HPCP', limit=5)
#' }
#' @export
noaa <- function(datasetid=NULL, datatypeid=NULL, stationid=NULL, locationid=NULL, 
  startdate=NULL, enddate=NULL, sortfield=NULL, sortorder=NULL, limit=25, offset=NULL, 
  callopts=list(), token=getOption("noaakey", stop("you need an API key NOAA data")),
  dataset=NULL, datatype=NULL, station=NULL, location=NULL, locationtype=NULL, 
  page=NULL, year=NULL, month=NULL, day=NULL, results=NULL)
{
  calls <- deparse(sys.calls())
  calls_vec <- sapply(c("dataset", "datatype", "station", "location", "locationtype", 
                        "page", "year", "month", "day", "results"), 
                      function(x) grepl(x, calls))
  if(any(calls_vec))
    stop("The parameters name, code, modifiedsince, startindex, and maxresults \n  have been removed, and were only relavant in the old NOAA API v1. \n\nPlease see documentation for ?noaa")
  
  base = 'http://www.ncdc.noaa.gov/cdo-web/api/v2/data'
  args <- compact(list(datasetid=datasetid, datatypeid=datatypeid, 
                         locationid=locationid, stationid=stationid, startdate=startdate,
                         enddate=enddate, sortfield=sortfield, sortorder=sortorder, 
                         limit=limit, offset=offset))
  if(limit > 1000){
    startat <- seq(1, limit, 1000)-1
    repto <- rep(1000, length(startat))
    repto[length(repto)] <- limit-round_any(limit, 1000, floor)
    
    out <- list()
    for(i in seq_along(startat)){
      args$limit <- repto[i]
      args$offset <- startat[i]
      temp <- GET(base, query=args, config = add_headers("token" = token))
      stop_for_status(temp)
      tt <- content(temp)
      out[[i]] <- do.call(rbind.data.frame, tt$results)
    }
    dat <- do.call(rbind.data.frame, out)
    meta <- tt$metadata$resultset
    atts <- list(totalCount=meta$count, pageCount="none", offset="none")
  } else
  {   
    temp <- GET(base, query=args, config = add_headers("token" = token))
    stop_for_status(temp)
    tt <- content(temp)
    if(class(try(tt$results, silent=TRUE))=="try-error")
      stop("Sorry, no data found")
    dat <- do.call(rbind.data.frame, tt$results)
    meta <- tt$metadata$resultset
    atts <- list(totalCount=meta$count, pageCount=meta$limit, offset=meta$offset)
  }
  
  all <- list(atts=atts, data=dat)
  class(all) <- "noaa"
  return( all )
}