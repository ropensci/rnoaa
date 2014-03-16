#' Get NOAA data. 
#' 
#' @import httr
#' @importFrom plyr compact round_any rbind.fill
#' @export
#' @template rnoaa
#' @template noaa
#' 
#' @details 
#' Note that NOAA API calls can take a long time depending on the call. If you get a 
#' error try setting startdate and enddate explicitly. The NOAA API doesn't perform 
#' well with very long timespans, and will time out and make you angry - beware.
#' 
#' Keep in mind that three parameters, datasetid, startdate, and enddate are required. 
#' 
#' @return An S3 list of length two, a slot of metadata (meta), and a slot for data (data). 
#' The meta slot is a list of metadata elements, and the data slot is a data.frame, 
#' possibly of length zero if no data is found.
#' 
#' @examples \dontrun{
#' noaa(datasetid='GHCND', locationid = 'FIPS:02', startdate = '2010-05-01', 
#'    enddate = '2010-05-31', limit=15)
#' 
#' # GHCN-Daily data from October 1 2013 to December 1 2013
#' noaa(datasetid='GHCND', startdate = '2013-10-01', enddate = '2013-12-01')
#' 
#' # Normals Daily GHCND:USW00014895 dly-tmax-normal data
#' noaa(datasetid='NORMAL_DLY', stationid='GHCND:USW00014895', startdate = '2010-05-01', 
#'    enddate = '2010-05-10')
#' 
#' # Dataset, and location in Australia
#' noaa(datasetid='GHCND', locationid='FIPS:AS', startdate = '2010-05-01', enddate = '2010-05-31')
#' 
#' # Dataset, location and datatype for PRECIP_HLY
#' noaa(datasetid='PRECIP_HLY', locationid='ZIP:28801', datatypeid='HPCP', startdate = '2010-05-01',
#'    enddate = '2010-05-10')
#' 
#' # Dataset, location, station and datatype
#' noaa(datasetid='PRECIP_HLY', locationid='ZIP:28801', stationid='COOP:310301', datatypeid='HPCP',
#'    startdate = '2010-05-01', enddate = '2010-05-10')
#' 
#' # Dataset, location, and datatype for GHCND
#' noaa(datasetid='GHCND', locationid='FIPS:BR', datatypeid='PRCP', startdate = '2010-05-01', 
#'    enddate = '2010-05-10')
#' 
#' # Normals Daily GHCND dly-tmax-normal data
#' noaa(datasetid='NORMAL_DLY', datatypeid='dly-tmax-normal', startdate = '2010-05-01', 
#'    enddate = '2010-05-10')
#' 
#' # Normals Daily GHCND:USW00014895 dly-tmax-normal
#' noaa(datasetid='NORMAL_DLY', stationid='GHCND:USW00014895', datatypeid='dly-tmax-normal', 
#'    startdate = '2010-05-01', enddate = '2010-05-10')
#' 
#' # Hourly Precipitation data for ZIP code 28801
#' noaa(datasetid='PRECIP_HLY', locationid='ZIP:28801', datatypeid='HPCP', startdate = '2010-05-01',
#'    enddate = '2010-05-10')
#' }

noaa <- function(datasetid=NULL, datatypeid=NULL, stationid=NULL, locationid=NULL, 
  startdate=NULL, enddate=NULL, sortfield=NULL, sortorder=NULL, limit=25, offset=NULL, 
  callopts=list(), token=NULL, dataset=NULL, datatype=NULL, station=NULL, location=NULL, 
  locationtype=NULL, page=NULL, year=NULL, month=NULL, day=NULL, results=NULL)
{
  calls <- names(sapply(match.call(), deparse))[-1]
  calls_vec <- c("dataset","datatype","station","location","locationtype","page","year","month","day","results") %in% calls
  if(any(calls_vec))
    stop("The parameters name, code, modifiedsince, startindex, and maxresults \n  have been removed, and were only relavant in the old NOAA API v1. \n\nPlease see documentation for ?noaa")
  
  if(is.null(token))
    token <- getOption("noaakey", stop("you need an API key NOAA data"))
  
  base = 'http://www.ncdc.noaa.gov/cdo-web/api/v2/data'
  args <- compact(list(datasetid=datasetid, datatypeid=datatypeid, 
                         locationid=locationid, stationid=stationid, startdate=startdate,
                         enddate=enddate, sortfield=sortfield, sortorder=sortorder, 
                         limit=limit, offset=offset))
  args <- as.list(unlist(args))
  names(args) <- gsub("[0-9]+", "", names(args))
  
  if(limit > 1000){
    startat <- seq(1, limit, 1000)-1
    repto <- rep(1000, length(startat))
    repto[length(repto)] <- limit-round_any(limit, 1000, floor)
    
    out <- list()
    for(i in seq_along(startat)){
      args$limit <- repto[i]
      args$offset <- startat[i]
      callopts <- c(add_headers("token" = token), callopts)
      temp <- GET(base, query=args, config = callopts)
      stop_for_status(temp)
      tt <- content(temp)
      out[[i]] <- do.call(rbind.fill, lapply(tt$results, function(x) data.frame(x,stringsAsFactors=FALSE)))
    }
    dat <- do.call(rbind.data.frame, out)
    meta <- tt$metadata$resultset
    atts <- list(totalCount=meta$count, pageCount="none", offset="none")
  } else
  {   
    callopts <- c(add_headers("token" = token), callopts)
    temp <- GET(base, query=args, config = callopts)
    if(!temp$status_code == 200){
      stnames <- names(content(temp))
      if(!is.null(stnames)){
        if('developerMessage' %in% stnames){
          stop(sprintf("Error: (%s) - %s", temp$status_code, content(temp)$developerMessage))
        } else { stop(sprintf("Error: (%s) - %s", temp$status_code)) }
      } else { stop_for_status(temp) }
    }
    tt <- content(temp)
    if( class(try(tt$results, silent=TRUE))=="try-error"|is.null(try(tt$results, silent=TRUE)) )
      stop("Sorry, no data found")
    dat <- do.call(rbind.fill, lapply(tt$results, function(x) data.frame(x,stringsAsFactors=FALSE)))
    meta <- tt$metadata$resultset
    atts <- list(totalCount=meta$count, pageCount=meta$limit, offset=meta$offset)
  }
  
  all <- list(meta=atts, data=dat)
  class(all) <- "noaa_data"
  return( all )
}