#' Get metadata about NOAA stations.
#' 
#' @import lubridate httr
#' @template rnoaa 
#' @param station The station, within a dataset.
#' @param datatype The data type, see function \code{\link{noaa_datatypes}}.
#' @param location Location
#' @param locationtype The location type
#' @return A list of metadata.
#' @examples \dontrun{
#' # Displays all stations within GHCN-Daily (100 Stations per page limit)
#' noaa_stations(dataset='GHCND')
#' 
#' # Station 
#' noaa_stations(dataset='NORMAL_DLY', station='GHCND:USW00014895')
#'
#' # Displays all stations within GHCN-Daily (Displaying page 10 of the results)
#' noaa_stations(dataset='GHCND', page=10)
#' 
#' # Specify dataset and location
#' noaa_stations(dataset='GHCND', location='FIPS:12017')
#' 
#' # Specify dataset, location, and station
#' noaa_stations(dataset='GHCND', location='FIPS:12017', station='GHCND:USC00084289')
#' 
#' # Specify dataset, locationtype, location, and station
#' noaa_stations(dataset='GHCND', locationtype='CNTY', location='FIPS:12017', station='GHCND:USC00084289')
#' 
#' # Displays list of stations within the specified county
#' noaa_stations(dataset='GHCND', locationtype='CNTY', location='FIPS:12017')
#'
#' # Displays list of Hourly Precipitation locations between 01/01/1990 and 12/31/1990
#' noaa_stations(dataset='PRECIP_HLY', startdate='19900101', enddate='19901231')
#' }
#' @export
noaa_stations <- function(dataset=NULL, station=NULL, location=NULL, 
  locationtype=NULL, startdate=NULL, enddate=NULL, page=NULL, 
  token=getOption("noaakey", stop("you need an API key NOAA data")), callopts=list())
{
  
  parse_dat <- function(x) {
    meta <- x[!names(x) %in% 'locationLabels']
    labels <- x$locationLabels
    if(class(labels[[1]]) == 'list'){
      df <- ldply(labels, function(x) data.frame(x[c('type','id','displayName')]))
    } else
    {
      df <- data.frame(labels)
    }
    list(meta=meta, lab=df)
  }
  
  base <- 'http://www.ncdc.noaa.gov/cdo-services/services/datasets'
  params <- compact(list(dataset=dataset, station=station, location=location, 
                         locationtype=locationtype))
  args <- compact(list(startdate=startdate,enddate=enddate,page=page,token=token))
  
  foo <- function(x) all(x %in% names(params)) && length(x)==length(names(params))
  
  if(foo('dataset')){
    url <- sprintf("%s/%s/stations", base, dataset)
    temp <- GET(url, query=args, callopts)
    stop_for_status(temp)
    tt <- content(temp)
    dat <- llply(tt$stationCollection$station, parse_dat)
  } else
    if(foo(c('dataset','station'))){
      url <- sprintf("%s/%s/stations/%s", base, dataset, station)
      temp <- GET(url, query=args, callopts)
      stop_for_status(temp)
      tt <- content(temp)
      dat <- parse_dat(tt$stationCollection$station[[1]])
    } else
      if(foo(c('dataset','location'))){
        url <- sprintf("%s/%s/locations/%s/stations", base, 
                       dataset, location)
        temp <- GET(url, query=args, callopts)
        stop_for_status(temp)
        tt <- content(temp)
        dat <- llply(tt$stationCollection$station, parse_dat)
      } else
        if(foo(c('dataset','location','station'))){
          url <- sprintf("%s/%s/locations/%s/stations/%s", base, dataset, 
                         location, station)
          temp <- GET(url, query=args, callopts)
          stop_for_status(temp)
          tt <- content(temp)
          dat <- parse_dat(tt$stationCollection$station[[1]])
        } else
          if(foo(c('dataset','locationtype','location'))){
            url <- sprintf("%s/%s/locationtypes/%s/locations/%s/stations", 
                           base, dataset, locationtype, location)
            temp <- GET(url, query=args, callopts)
            stop_for_status(temp)
            tt <- content(temp)
            dat <- llply(tt$stationCollection$station, parse_dat)
          } else
            if(foo(c('dataset','locationtype','location','station'))){
              url <- sprintf("%s/%s/locationtypes/%s/locations/%s/stations/%s", 
                             base, dataset, locationtype, location, station)
              temp <- GET(url, query=args, callopts)
              stop_for_status(temp)
              tt <- content(temp)
              dat <- parse_dat(tt$stationCollection$station[[1]]) 
            }
  
  atts <- list(totalCount=as.numeric(tt$stationCollection$`@totalCount`), 
               pageCount=as.numeric(tt$stationCollection$`@pageCount`)) 
  all <- list(atts=atts, data=dat)
  return( all )
}