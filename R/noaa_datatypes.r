#' Get possible data types for a particular dataset
#'   
#' @template rnoaa
#' @template datatypes
#' @return A \code{data.frame} for all datasets, or a list of length two, each with a data.frame.
#' @examples \dontrun{
#' noada_datatypes(datasetid="ANNUAL")
#'
#' ## With a filter
#' noaa_datatypes(datasetid="Annual",filter="precip")
#' 
#' ### with a two filters
#' noaa_datatypes(datasetid="Annual",filter = c("precip","sod"))
#' }
#' @export
noaa_datatypes <- function(datasetid=NULL, datatypeid=NULL, stationid=NULL, locationid=NULL, 
  startdate=NULL, enddate=NULL, sortfield=NULL, sortorder=NULL, limit=25, offset=NULL, 
  callopts=list(), token=getOption("noaakey", stop("you need an API key NOAA data")), 
  dataset=NULL, page=NULL, filter=NULL)
{
  calls <- deparse(sys.calls())
  calls_vec <- sapply(c("dataset", "page", "filter"), function(x) grepl(x, calls))
  if(any(calls_vec))
    stop("The parameters dataset, page, and filter \n  have been removed, and were only relavant in the old NOAA API v1. \n\nPlease see documentation for ?noaa_datatypes")
  
  if(!is.null(datasetid)){
    url <- sprintf("http://www.ncdc.noaa.gov/cdo-web/api/v2/datatypes/%s", datasetid)
  } else { url <- "http://www.ncdc.noaa.gov/cdo-web/api/v2/datatype" }
    
  args <- compact(list(datasetid=datasetid, datatypeid=datatypeid, 
                       locationid=locationid, stationid=stationid, startdate=startdate,
                       enddate=enddate, sortfield=sortfield, sortorder=sortorder, 
                       limit=limit, offset=offset))
  temp <- GET(url, query=args, config = add_headers("token" = token))
  stop_for_status(temp)
  raw_out <- content(temp)
  
  # custom parsing function to handle the weird lists that noaa returns
  s_parse <- function(x){
        if(length(x) == 2){
          x <- c(x,"NA")
        } else if(length(x) == 3){
          
        }
        return(c(x[1],x[2],x[3]))
  }
  parsed_out <- unlist(lapply(raw_out$dataTypeCollection$dataType,s_parse))
  parsed_out <- data.frame(matrix(parsed_out,ncol=3,nrow=(length(parsed_out)/3),byrow=T))
  colnames(parsed_out) <- c("ID","Description","Name")
  filt_id <- 1:dim(parsed_out)[1]
  #filtering
  
  if(!is.null(filter) ){
    filt_id <- vector()
    for(i in 1:length(filter)){
      ## Search both names and descriptions
      ids <- unique(c(grep(filter[i],parsed_out[,2],ignore.case=T),grep(filter[i],parsed_out[,3],ignore.case=T)))
      filt_id <- c(filt_id,ids)
      
    }
  }
  
  
  return(parsed_out[filt_id,])
  
}

# z <-noaa_datatypes(dataset="Annual",filter = c("precip","sod"))