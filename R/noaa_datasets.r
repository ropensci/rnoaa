#' Search NOAA datasets
#' 
#' From the NOAA API docs: All of our data are in datasets. To retrieve any data 
#' from us, you must know what dataset it is in.
#' 
#' @importFrom plyr compact rbind.fill
#' @template rnoaa
#' @template datasets
#' @value A data.frame for all datasets, or a list of length two, each with a data.frame.
#' @examples \dontrun{
#' # Get a table of all datasets
#' noaa_datasets()
#' 
#' # Get details from a particular dataset
#' noaa_datasets(datasetid='ANNUAL')
#' 
#' # Get datasets with Temperature at the time of observation (TOBS) data type
#' noaa_datasets(datatypeid='TOBS')
#' 
#' # Get datasets with data for a series of the same parameter arg, in this case
#' # stationid's
#' noaa_datasets(stationid=c('COOP:310090','COOP:310184','COOP:310212'))
#' 
#' # Multiple datatypeid's
#' noaa_datasets(datatypeid=c('ACMC','ACMH','ACSC'))
#' noaa_datasets(datasetid='ANNUAL', datatypeid=c('ACMC','ACMH','ACSC'))
#' }
#' @export

noaa_datasets <- function(datasetid=NULL, datatypeid=NULL, stationid=NULL, locationid=NULL, 
  startdate=NULL, enddate=NULL, sortfield=NULL, sortorder=NULL, limit=25, offset=NULL, 
  callopts=list(), token=NULL, dataset=NULL, page=NULL, year=NULL, month=NULL)
{
  calls <- names(sapply(match.call(), deparse))[-1]
  calls_vec <- c("dataset", "page", "year", "month") %in% calls
  if(any(calls_vec))
    stop("The parameters dataset, page, year, and month \n  have been removed, and were only relavant in the old NOAA API v1. \n\nPlease see documentation for ?noaa_datasets")
  
  if(is.null(token))
    token <- getOption("noaakey", stop("you need an API key NOAA data"))
  
  url <- "http://www.ncdc.noaa.gov/cdo-web/api/v2/datasets"
  if(!is.null(datasetid))
    url <- paste(url, "/", datasetid, sep="")
  args <- compact(list(datasetid=datasetid, datatypeid=datatypeid, 
                       locationid=locationid, stationid=stationid, startdate=startdate,
                       enddate=enddate, sortfield=sortfield, sortorder=sortorder, 
                       limit=limit, offset=offset))
  args <- as.list(unlist(args))
  names(args) <- gsub("[0-9]+", "", names(args))
    
  callopts <- c(add_headers("token" = token), callopts)
  temp <- GET(url, query=args, config=callopts)
  stop_for_status(temp)
  tt <- content(temp)
  
  if(!is.null(datasetid)){
    dat <- data.frame(tt, stringsAsFactors=FALSE)
    all <- list(meta = NULL, data = dat)
  } else
  {
    dat <- do.call(rbind.fill, lapply(tt$results, function(x) data.frame(x, stringsAsFactors=FALSE)))
    all <- list(meta = tt$metadata$resultset, data = dat)
  }
  class(all) <- "noaa_datasets"
  return( all )    
}