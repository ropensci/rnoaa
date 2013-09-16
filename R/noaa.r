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
#' @param results The number of results to return.  The larger the number of results requested, the longer the api call will take.
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
#' noaa(dataset='GHCND', location='FIPS:BR', locationtype='CNTRY', datatype='PRCP')
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
  locationtype=NULL, startdate=NULL, enddate=NULL, page=1, year=NULL,
  month=NULL, day=NULL, results = NULL,
  token=getOption("noaakey", stop("you need an API key NOAA data")),
  callopts=list())
{
  parse_dat <- function(x) {
    atts <- x[names(x) %in% 'attributes'][[1]]
    if(foo(sapply(atts[[1]], nchar) == 0))
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
  
  foo <- function(x) all(x %in% names(params)) && length(x)==length(names(params))

  if(foo('dataset')){
    url <- sprintf("%s/%s/data", base, dataset)
  } else if(foo(c('dataset','station'))){
    url <- sprintf("%s/%s/stations/%s/data", base, dataset, station)
  } else if(foo(c('dataset','location'))){
    url <- sprintf("%s/%s/locations/%s/data", base, dataset, location)
  } else if(foo(c('dataset','datatype','station'))){
    url <- sprintf("%s/%s/stations/%s/datatypes/%s/data", base, dataset, 
                   station, datatype)
  } else if(foo(c('dataset','datatype','location'))){
    url <- sprintf("%s/%s/locations/%s/datatypes/%s/data", base, dataset, 
                   location, datatype)
  } else if(foo(c('dataset','datatype'))){
    url <- sprintf("%s/%s/datatypes/%s/data", base, dataset, datatype)
  } else if(foo(c('dataset','datatype','location'))){
    url <- sprintf("%s/%s/locations/%s/datatypes/%s/data", base, dataset, 
                   location, datatype)
 } else if(foo(c('dataset','station','location'))){
    url <- sprintf("%s/%s/locations/%s/stations/%s/data", base, dataset, 
                   location, station)
  } else if(foo(c('dataset','datatype','station','location'))){#done
    url <- sprintf("%s/%s/locations/%s/stations/%s/datatypes/%s/data", base, 
                   dataset, location, station, datatype)
  } else if(foo(c('dataset','locationtype'))){
    url <- sprintf("%s/%s/locationtypes/%s/data", base, dataset, locationtype)

  } else if(foo(c('dataset','locationtype','datatype'))){
    url <- sprintf("%s/%s/locationtypes/%s/datatypes/%s/data", base, dataset, 
                   locationtype, datatype)
  } else if(foo(c('dataset','locationtype','location'))){
    url <- sprintf("%s/%s/locationtypes/%s/locations/%s/data", base, dataset, 
                   locationtype, location)
  } else if(foo(c('dataset','locationtype','location','datatype'))){
    url <- sprintf("%s/%s/locationtypes/%s/locations/%s/datatypes/%s/data", base, dataset, 
                   locationtype, location, datatype)
  } else if(foo(c('dataset','locationtype','location','station'))){
    url <- sprintf("%s/%s/locationtypes/%s/locations/%s/stations/%s/data", base, dataset, 
                   locationtype, location, station)
  } else if(foo(c('dataset','locationtype','location','station','datatype'))){ 
    url <- sprintf("%s/%s/locationtypes/%s/locations/%s/stations/%s/datatypes/%s/data", base, dataset, locationtype, location, station, datatype)
  } 
  ## Put together arguments
  args <- compact(list(startdate=startdate,enddate=enddate,page=page,
                       year=year,month=month,day=day,token=token))
  ## download data, get the number of potential results.
  temp <- GET(url, query=args, callopts)
  stop_for_status(temp)
  tt <- content(temp)
  if(class(try(tt$dataCollection$data, silent=TRUE))=="try-error")
    stop("Sorry, no data found")
  dat <- ldply(tt$dataCollection$data, parse_dat)
  page_ct <- tt$dataCollection$`@pageCount`
  
  # check the results and loop through
  
  if(results > 100 && !is.null(results)){
    
    # We get 100 results a page, so we need to figure out how many pages
    page_tot <- ceiling(results/100)
    for(i in 2:page_tot){
      args <- compact(list(startdate=startdate,enddate=enddate,page=i,
                           year=year,month=month,day=day,token=token))
      ## download data, get the number of potential results.
      temp <- GET(url, query=args, callopts)
      stop_for_status(temp)
      tt <- content(temp)
      dat <- rbind(dat,ldply(tt$dataCollection$data, parse_dat))
    }
    
  }
  
  if(results < dim(dat)[1] && !is.null(results)){
    dat <- dat[1:results,]
  } 
  
  atts <- list(totalCount=as.numeric(tt$dataCollection$`@totalCount`), 
               pageCount=as.numeric(tt$dataCollection$`@pageCount`)) 
  all <- list(atts=atts, data=dat)
  class(all) <- "noaa"
  return( all )
}