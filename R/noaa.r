#' Get NOAA data.
#' 
#' This is the main function to get NOAA data.
#' 
#' @import lubridate
#' @template rnoaa 
#' @param station The station, within a dataset, see function 
#'    \code{\link{noaa_stations}}
#' @param datatype The data type, see function \code{\link{noaa_datatypes}}
#' @return A data.frame for all datasets, or a list of length two, each with a 
#'    data.frame.
#' @import httr
#' @examples \dontrun{
#' # January 2001 GHCN-Daily data from stations in Australia
#' noaa(dataset='GHCND', location='FIPS:AS', year=2001, month=1)
#' 
#' # Normals Daily GHCND:USW00014895 dly-tmax-normal data for April (the year is required, but the normals period is 1981-2010)
#' noaa(dataset='NORMAL_DLY', station='GHCND:USW00014895', datatype='dly-tmax-normal', year=2010, month=4)
#' 
#' # Hourly Precipitation data for ZIP code 28801
#' noaa(dataset='PRECIP_HLY', location='ZIP:28801', datatype='HPCP', year=1980, month=7, day=17)
#' }
#' @export
noaa <- function(dataset=NULL, datatype=NULL, station=NULL, location=NULL, 
  locationtype=NULL, startdate=NULL, enddate=NULL, page=NULL, year=NULL, 
  month=NULL, day=NULL, token=getOption("noaakey", stop("you need an API key NOAA data")),
  callopts=list())
{
  parse_dat <- function(x) {
    atts <- x[names(x) %in% 'attributes'][[1]]
    if(all(sapply(atts[[1]], nchar) == 0))
      atts <- "none"
    else
      atts <- atts[[1]][!sapply(atts[[1]], nchar) == 0]
      atts <- paste0(atts, collapse='')
    data <- data.frame(x[!names(x) %in% 'attributes'])
    data.frame(data,atts)
  }
  
  base <- 'http://www.ncdc.noaa.gov/cdo-services/services/datasets'
  params <- compact(list(dataset=dataset, datatype=datatype, station=station, 
                         location=location, locationtype=locationtype))
  args <- compact(list(startdate=startdate,enddate=enddate,page=page,
                       year=year,month=month,day=day,token=token))
  
  if(all(names(params) %in% 'dataset')){
    url <- sprintf("%s/%s/stations", base, dataset)
    tt <- content(GET(url, query=args, callopts))
    dat <- llply(tt$stationCollection$station, parse_dat)
  } else
    if(all(names(params) %in% c('dataset','station'))){
      url <- sprintf("%s/%s/stations/%s", base, dataset, station)
      tt <- content(GET(url, query=args, callopts))
      dat <- parse_dat(tt$stationCollection$station[[1]])
    } else
      if(all(names(params) %in% c('dataset','location'))){ # done
        url <- sprintf("%s/%s/locations/%s/data", base, dataset, location)
        tt <- content(GET(url, query=args, callopts))
        dat <- ldply(tt$dataCollection$data, parse_dat)
      } else
        if(all(names(params) %in% c('dataset','datatype','station'))){ # done
          url <- sprintf("%s/%s/stations/%s/datatypes/%s/data", base, dataset, station, datatype)
          tt <- content(GET(url, query=args, callopts))
          dat <- ldply(tt$dataCollection$data, parse_dat)
        } else
          if(all(names(params) %in% c('dataset','datatype','location'))){ # done
            url <- sprintf("%s/%s/locations/%s/datatypes/%s/data", base, dataset, location, datatype)
            tt <- content(GET(url, query=args, callopts))
            dat <- ldply(tt$dataCollection$data, parse_dat)
          } else
            if(all(names(params) %in% c('dataset','locationtype','location','station'))){
              url <- sprintf("%s/%s/locationtypes/%s/locations/%s/stations/%s", 
                             base, dataset, locationtype, location, station)
              tt <- content(GET(url, query=args, callopts))
              dat <- parse_dat(tt$stationCollection$station[[1]]) 
            }
  
  atts <- list(totalCount=as.numeric(tt$dataCollection$`@totalCount`), 
               pageCount=as.numeric(tt$dataCollection$`@pageCount`)) 
  all <- list(atts=atts, data=dat)
  class(all) <- "noaa"
  return( all )
}

# /datasets/{dataSet}/data
# /datasets/{dataSet}/datatypes/{dataType}/data
# /datasets/{dataSet}/locationtypes/{locationType}/data
# /datasets/{dataSet}/locationtypes/{locationType}/datatypes/{dataType}/data
# /datasets/{dataSet}/locationtypes/{locationType}/locations/{location}/data
# /datasets/{dataSet}/locationtypes/{locationType}/locations/{location}/datatypes/{dataType}/data
# /datasets/{dataSet}/locationtypes/{locationType}/locations/{location}/stations/{station}/data
# /datasets/{dataSet}/locationtypes/{locationType}/locations/{location}/stations/{station}/datatypes/{dataType}/data
# /datasets/{dataSet}/locations/{location}/data
# /datasets/{dataSet}/locations/{location}/datatypes/{dataType}/data
# /datasets/{dataSet}/locations/{location}/stations/{station}/data
# /datasets/{dataSet}/locations/{location}/stations/{station}/datatypes/{dataType}/data
# /datasets/{dataSet}/stations/{station}/data
# /datasets/{dataSet}/stations/{station}/datatypes/{dataType}/data