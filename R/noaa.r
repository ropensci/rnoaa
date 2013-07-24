#' Get NOAA data
#' 
#' @import lubridate
#' @template rnoaa 
#' @param station The station, within a dataset, see function \code{\link{noaa_stations}}
#' @param datatype The data type, see function \code{\link{noaa_datatypes}}
#' @return A data.frame for all datasets, or a list of length two, each with a data.frame.
#' @import httr
#' @examples \dontrun{
#' # Get data from a particular dataset, station, and data type
#' noaa(dataset='NORMAL_DLY', station='GHCND:USW00014895', datatype='dly-tmax-normal', year=2010, month=4)
#' }
#' @export
noaa <- function(dataset=NULL, station=NULL, datatype=NULL, startdate=NULL, enddate=NULL, page=NULL, year=NULL, month=NULL, token=getOption("noaakey", stop("you need an API key NOAA data")), ...)
{
  url <- sprintf("http://www.ncdc.noaa.gov/cdo-services/services/datasets/%s/stations/%s/datatypes/%s/data", dataset, station, datatype)
  args <- compact(list(startdate=startdate,enddate=enddate,page=page,year=year,month=month,token=token))
  tt <- content(GET(url, query=args))
  atts <- c(totalCount=as.numeric(tt$dataCollection$`@totalCount`), pageCount=as.numeric(tt$dataCollection$`@pageCount`))
#   out <- ldply(tt$dataCollection$data, function(x) data.frame(x[c('date','dataType','station','value')]))
  out <- llply(tt$dataCollection$data, function(x) x[c('date','dataType','station','value')])
#   out$date <- as.POSIXct.Date(out$date, format="%d/%m/%y")
#   ymd(as.POSIXct.Date(out$date, format="%d/%m/%y"))
  class(out) <- "noaa"
  return( out )
}