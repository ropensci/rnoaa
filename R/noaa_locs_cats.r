#' Get metadata about NOAA location categories.
#' 
#' Location categories are groupings of similar locations.
#' 
#' From the NOAA API docs: Locations can be a specific latitude/longitude point 
#' such as a station, or a label representing a bounding area such as a city.
#' 
#' @import httr
#' @template location
#' @return A list containing metadata and the data, or a single data.frame.
#' @examples \dontrun{
#' # All location categories, first 25 results
#' noaa_locs_cats()
#' 
#' # Find locations with category id of CLIM_REG
#' noaa_locs_cats(locationcategoryid='CLIM_REG')
#' 
#' # Displays available location categories within GHCN-Daily dataset
#' noaa_locs_cats(datasetid='GHCND')
#' 
#' # Displays available location categories from start date 1970-01-01
#' noaa_locs_cats(startdate='1970-01-01')
#' }
#' @export
noaa_locs_cats <- function(datasetid=NULL, locationcategoryid=NULL,
  startdate=NULL, enddate=NULL, sortfield=NULL, sortorder=NULL, 
  limit=25, offset=NULL, callopts=list(), 
  token=getOption("noaakey", stop("you need an API key for NOAA data")))
{
  url <- 'http://www.ncdc.noaa.gov/cdo-web/api/v2/locationcategories'
  if(!is.null(locationcategoryid))
    url <- paste(url, "/", locationcategoryid, sep="")
  args <- compact(list(datasetid=datasetid,locationcategoryid=locationcategoryid,
    startdate=startdate, enddate=enddate,token=token,sortfield=sortfield,
    sortorder=sortorder,limit=limit,offset=offset))
  
  callopts <- c(add_headers("token" = token), callopts)
  temp <- GET(url, query=as.list(args), config=callopts)
  stop_for_status(temp)
  tt <- content(temp)
  if(!is.null(locationcategoryid)){
    dat <- data.frame(tt,stringsAsFactors=FALSE)
    all <- list(meta=NULL, data=dat)
    class(all) <- "noaa_locs_cats"
    return( all )
  } else
  {    
    if(class(try(tt$results, silent=TRUE))=="try-error")
      stop("Sorry, no data found")
    dat <- do.call(rbind.fill, lapply(tt$results, function(x) data.frame(x,stringsAsFactors=FALSE)))
    meta <- tt$metadata$resultset
    atts <- list(totalCount=meta$count, pageCount=meta$limit, offset=meta$offset)
    all <- list(atts=atts, data=dat)
    class(all) <- "noaa_locs_cats"
    return( all )
  }
}