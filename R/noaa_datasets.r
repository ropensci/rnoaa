#' Search NOAA datasets
#' 
#' @template rnoaa
#' @template datasets
#' @value A data.frame for all datasets, or a list of length two, each with a data.frame.
#' @examples \dontrun{
#' # Get a table of all datasets
#' noaa_datasets()
#' 
#' # Get details from a particular dataset
#' noaa_datasets(datasetid='ANNUAL')
#' }
#' @export
noaa_datasets <- function(datasetid=NULL, datatypeid=NULL, stationid=NULL, locationid=NULL, 
  startdate=NULL, enddate=NULL, sortfield=NULL, sortorder=NULL, limit=25, offset=NULL, 
  callopts=list(), token=getOption("noaakey", stop("you need an API key NOAA data")),
  dataset=NULL, page=NULL, year=NULL, month=NULL)
{
  calls <- deparse(sys.calls())
  calls_vec <- sapply(c("dataset", "page", "year", "month"), function(x) grepl(x, calls))
  if(any(calls_vec))
    stop("The parameters dataset, page, year, and month \n  have been removed, and were only relavant in the old NOAA API v1. \n\nPlease see documentation for ?noaa_datasets")
  
  url <- "http://www.ncdc.noaa.gov/cdo-web/api/v2/datasets"
  if(!is.null(datasetid))
    url <- paste(url, "/", datasetid, sep="")
  args <- compact(list(datasetid=datasetid, datatypeid=datatypeid, 
                       locationid=locationid, stationid=stationid, startdate=startdate,
                       enddate=enddate, sortfield=sortfield, sortorder=sortorder, 
                       limit=limit, offset=offset))
  
  temp <- GET(url, query=args, config = add_headers("token" = token))
  stop_for_status(temp)
  tt <- content(temp)
  
  if(!is.null(dataset)){
    one <- data.frame(tt$dataSetCollection$dataSet[[1]][c('id','name','description','minDate','maxDate')])
    two <- ldply(tt$dataSetCollection$dataSet[[1]]$attributes$attribute, function(x) data.frame(x[c('name','defaultValue','indexNumber')]))
    list(one, two)
  } else
  {
    ldply(tt$dataSetCollection$dataSet, function(x) data.frame(x[c('id','name','description','minDate','maxDate')]))
  }
}