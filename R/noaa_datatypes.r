#' Get possible data types for a particular dataset
#' 
#' @param dataset foo
#' @param  startdate foo
#' @param  enddate foo
#' @param  page foo
#' @param  filter a string or vector of strings used to filter results.  Useful for scenarios where many possible options are returned.
#' @param  token API key
#' @template rnoaa
#' @return A \code{data.frame} for all datasets, or a list of length two, each with a data.frame.
#' @examples \dontrun{
#' noaa_datatypes(dataset="ANNUAL")
#'
#' ## With a filter
#' noaa_datatypes(dataset="Annual",filter="precip")
#' 
#' ### with a two filters
#' noaa_datatypes(dataset="Annual",filter = c("precip","sod"))
#' }
#' @export
noaa_datatypes <- function(dataset=NULL, startdate=NULL, enddate=NULL, page=NULL, 
  filter=NULL, token=getOption("noaakey", stop("you need an API key NOAA data")))
{
  url <- sprintf("http://www.ncdc.noaa.gov/cdo-services/services/datasets/%s/datatypes", dataset)
  args <- compact(list(startdate=startdate,enddate=enddate,page=page,token=token))
  temp <- GET(url, query=args)
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