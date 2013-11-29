#' Get possible data categories for a particular datasetid, locationid, stationid, etc.
#' 
#' From the NOAA API docs: Data Categories represent groupings of data types.
#'  
#' @template datacats
#' @template all
#' @value A \code{data.frame} for all datasets, or a list of length two, each 
#'    with a data.frame.
#' @examples \dontrun{
#' noaa_datacats(limit=41)
#'
#' ## Single data category
#' noaa_datacats(datacategoryid="ANNAGR")
#' 
#' ## Fetch data categories for a given set of locations
#' noaa_datacats(locationid='CITY:US390029')
#' noaa_datacats(locationid=c('CITY:US390029', 'FIPS:37'))
#' }
#' @export
noaa_datacats <- function(datasetid=NULL, datacategoryid=NULL, stationid=NULL,
  locationid=NULL, startdate=NULL, enddate=NULL, sortfield=NULL, sortorder=NULL, 
  limit=25, offset=NULL, callopts=list(), 
  token=getOption("noaakey", stop("you need an API key NOAA data")))
{  
  url <- "http://www.ncdc.noaa.gov/cdo-web/api/v2/datacategories"
  if(!is.null(datacategoryid))
    url <- paste(url, "/", datacategoryid, sep="")
  args <- c(datasetid=datasetid, locationid=locationid, stationid=stationid,
            startdate=startdate, enddate=enddate, sortfield=sortfield, 
            sortorder=sortorder, limit=limit, offset=offset)
  names(args) <- sapply(names(args), function(y) gsub("[0-9+]", "", y), USE.NAMES=FALSE)
  
  callopts <- c(add_headers("token" = token), callopts)
  temp <- GET(url, query=as.list(args), config=callopts)
  stop_for_status(temp)
  tt <- content(temp)
  if(!is.null(datacategoryid)){
    dat <- data.frame(tt,stringsAsFactors=FALSE)
    all <- list(meta=NULL, data=dat)
    class(all) <- "noaa_datacats"
    return( all )
  } else
  {    
    if(class(try(tt$results, silent=TRUE))=="try-error")
      stop("Sorry, no data found")
    dat <- do.call(rbind.fill, lapply(tt$results, function(x) data.frame(x,stringsAsFactors=FALSE)))
    meta <- tt$metadata$resultset
    atts <- list(totalCount=meta$count, pageCount=meta$limit, offset=meta$offset)
    all <- list(meta=atts, data=dat)
    class(all) <- "noaa_datacats"
    return( all )
  }
}