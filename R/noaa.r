#' Get NOAA data for any combination of dataset, datatype, station, location, 
#' and/or location type.
#' 
#' This is the main function to get NOAA data.
#' 
#' @template rnoaa 
#' @param station The station, within a dataset, see function 
#'    \code{\link{noaa_stations}}
#' @param datatype The data type, see function \code{\link{noaa_datatypes}}
#' @param location A single location code.
#' @param locationtype A single location type code.
#' @return A data.frame for all datasets, or a list of length two, each with a 
#'    data.frame.
#' @import httr
#' @examples \dontrun{
#' # January 2001 GHCN-Daily data
#' noaa(dataset='GHCND', year=2001, month=1)
#' 
#' # Normals Daily GHCND:USW00014895 dly-tmax-normal data
#' noaa(dataset='NORMAL_DLY', station='GHCND:USW00014895', year=2010, month=4)
#' 
#' # Dataset, and location in Australia
#' noaa(dataset='GHCND', location='FIPS:AS', year=2001, month=4)
#' 
#' # Dataset, location and datatype
#' noaa(dataset='PRECIP_HLY', location='ZIP:28801', datatype='HPCP', year=2001, month=4)
#' 
#' # Dataset, location, station and datatype
#' noaa(dataset='PRECIP_HLY', location='ZIP:28801', station='COOP:310301', datatype='HPCP', year=2001, month=4)
#' 
#' # Dataset, location, locationtype and datatype
#' noaa(dataset='GHCND', location='FIPS:AC', locationtype='CNTRY', datatype='HPCP')
#' 
#' # Dataset, location, locationtype and station
#' noaa(dataset='PRECIP_HLY', location='FIPS:ZIP:28801', locationtype='HYD_REG', station='COOP:310301')
#' 
#' # Normals Daily GHCND dly-tmax-normal data
#' noaa(dataset='NORMAL_DLY', datatype='dly-tmax-normal', year=2010, month=4)
#' 
#' # Normals Daily GHCND:USW00014895 dly-tmax-normal
#' noaa(dataset='NORMAL_DLY', station='GHCND:USW00014895', datatype='dly-tmax-normal', year=2010, month=4)
#' 
#' # Hourly Precipitation data for ZIP code 28801
#' noaa(dataset='PRECIP_HLY', location='ZIP:28801', datatype='HPCP', year=1980, 
#' month=7, day=17)
#' }
#' @export
noaa <- function(dataset=NULL, datatype=NULL, station=NULL, location=NULL, 
  locationtype=NULL, startdate=NULL, enddate=NULL, page=NULL, year=NULL, 
  month=NULL, day=NULL, 
  token=getOption("noaakey", stop("you need an API key NOAA data")),
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
  
  if(all(names(params) %in% 'dataset')){ # done
    url <- sprintf("%s/%s/data", base, dataset)
    tt <- content(GET(url, query=args, callopts))
    dat <- ldply(tt$dataCollection$data, parse_dat)
  } else
  if(all(names(params) %in% c('dataset','station'))){ # done
    url <- sprintf("%s/%s/stations/%s/data", base, dataset, station)
    tt <- content(GET(url, query=args, callopts))
    dat <- ldply(tt$dataCollection$data, parse_dat)
  } else
  if(all(names(params) %in% c('dataset','location'))){ # done
    url <- sprintf("%s/%s/locations/%s/data", base, dataset, location)
    tt <- content(GET(url, query=args, callopts))
    dat <- ldply(tt$dataCollection$data, parse_dat)
  } else
  if(all(names(params) %in% c('dataset','datatype','station'))){ # done
    url <- sprintf("%s/%s/stations/%s/datatypes/%s/data", base, dataset, 
                   station, datatype)
    tt <- content(GET(url, query=args, callopts))
    dat <- ldply(tt$dataCollection$data, parse_dat)
  } else
  if(all(names(params) %in% c('dataset','datatype','location'))){ # done
    url <- sprintf("%s/%s/locations/%s/datatypes/%s/data", base, dataset, 
                   location, datatype)
    tt <- content(GET(url, query=args, callopts))
    dat <- ldply(tt$dataCollection$data, parse_dat)
  } else
  if(all(names(params) %in% c('dataset','datatype'))){ # done
    url <- sprintf("%s/%s/datatypes/%s/data", base, dataset, datatype)
    tt <- content(GET(url, query=args, callopts))
    dat <- ldply(tt$dataCollection$data, parse_dat)
  } else
  if(all(names(params) %in% c('dataset','datatype','location'))){ # done
    url <- sprintf("%s/%s/locations/%s/datatypes/%s/data", base, dataset, 
                   location, datatype)
    tt <- content(GET(url, query=args, callopts))
    dat <- ldply(tt$dataCollection$data, parse_dat)
  } else
  if(all(names(params) %in% c('dataset','station','location'))){ # done
    url <- sprintf("%s/%s/locations/%s/stations/%s/data", base, dataset, 
                   location, station)
    tt <- content(GET(url, query=args, callopts))
    dat <- ldply(tt$dataCollection$data, parse_dat)
  } else
  if(all(names(params) %in% c('dataset','datatype','station','location'))){#done
    url <- sprintf("%s/%s/locations/%s/stations/%s/datatypes/%s/data", base, 
                   dataset, location, station, datatype)
    tt <- content(GET(url, query=args, callopts))
    dat <- ldply(tt$dataCollection$data, parse_dat)
  } else
  if(all(names(params) %in% c('dataset','locationtype'))){ # done
    url <- sprintf("%s/%s/locationtypes/%s/data", base, dataset, locationtype)
    tt <- content(GET(url, query=args, callopts))
    dat <- ldply(tt$dataCollection$data, parse_dat)
  } else
  if(all(names(params) %in% c('dataset','locationtype','datatype'))){ # done
    url <- sprintf("%s/%s/locationtypes/%s/datatypes/%s/data", base, dataset, 
                   locationtype, datatype)
    tt <- content(GET(url, query=args, callopts))
    dat <- ldply(tt$dataCollection$data, parse_dat)
  } else
  if(all(names(params) %in% c('dataset','locationtype','location'))){ # done
    url <- sprintf("%s/%s/locationtypes/%s/locations/%s/data", base, dataset, 
                   locationtype, location)
    tt <- content(GET(url, query=args, callopts))
    dat <- ldply(tt$dataCollection$data, parse_dat)
  } else
    #not working yet below here
  if(all(names(params) %in% c('dataset','locationtype','location','datatype'))){ # done
    url <- sprintf("%s/%s/locationtypes/%s/locations/%s/datatypes/%s/data", base, dataset, 
                   locationtype, location, datatype)
    tt <- content(GET(url, query=args, callopts))
    dat <- ldply(tt$dataCollection$data, parse_dat)
  } else
  if(all(names(params) %in% c('dataset','locationtype','location','station'))){ # done
    url <- sprintf("%s/%s/locationtypes/%s/locations/%s/stations/%s/data", base, dataset, 
                   locationtype, location, station)
    tt <- content(GET(url, query=args, callopts))
    dat <- ldply(tt$dataCollection$data, parse_dat)
  } else
  if(all(names(params) %in% c('dataset','locationtype','location','station','datatype'))){ # done
    url <- sprintf("%s/%s/locationtypes/%s/locations/%s/stations/%s/datatypes/%s/data", base, dataset, 
                   locationtype, location, station, datatype)
    tt <- content(GET(url, query=args, callopts))
    dat <- ldply(tt$dataCollection$data, parse_dat)
  } 

  atts <- list(totalCount=as.numeric(tt$dataCollection$`@totalCount`), 
               pageCount=as.numeric(tt$dataCollection$`@pageCount`)) 
  all <- list(atts=atts, data=dat)
  class(all) <- "noaa"
  return( all )
}