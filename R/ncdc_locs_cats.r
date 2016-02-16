#' Get metadata about NOAA location categories.
#'
#' Location categories are groupings of similar locations.
#'
#' Locations can be a specific latitude/longitude point such as a station, or a
#' label representing a bounding area such as a city.
#'
#' @export
#'
#' @template location
#' @return A list containing metadata and the data, or a single data.frame.
#' @examples \dontrun{
#' # All location categories, first 25 results
#' ncdc_locs_cats()
#'
#' # Find locations with category id of CLIM_REG
#' ncdc_locs_cats(locationcategoryid='CLIM_REG')
#'
#' # Displays available location categories within GHCN-Daily dataset
#' ncdc_locs_cats(datasetid='GHCND')
#' 
#' # multiple datasetid's
#' ncdc_locs_cats(datasetid=c('GHCND', 'GHCNDMS'))
#'
#' # Displays available location categories from start date 1970-01-01
#' ncdc_locs_cats(startdate='1970-01-01')
#' }

ncdc_locs_cats <- function(datasetid=NULL, locationcategoryid=NULL,
  startdate=NULL, enddate=NULL, sortfield=NULL, sortorder=NULL,
  limit=25, offset=NULL, token=NULL, ...)
{
  token <- check_key(token)
  url <- 'http://www.ncdc.noaa.gov/cdo-web/api/v2/locationcategories'
  if(!is.null(locationcategoryid))
    url <- paste(url, "/", locationcategoryid, sep="")
  args <- noaa_compact(list(locationcategoryid=locationcategoryid,
    startdate=startdate, enddate=enddate,token=token,sortfield=sortfield,
    sortorder=sortorder,limit=limit,offset=offset))
  if (!is.null(datasetid)) {
    datasetid <- lapply(datasetid, function(x) list(datasetid = x))
  }
  args <- c(args, datasetid)
  args <- as.list(unlist(args))
  if (length(args) == 0) args <- NULL
  temp <- GET(url, query=args, add_headers("token" = token), ...)
  tt <- check_response(temp)
  if(is(tt, "character")){
    all <- list(meta=NULL, data=NULL)
  } else {
    if(!is.null(locationcategoryid)){
      dat <- data.frame(tt,stringsAsFactors=FALSE)
      all <- list(meta=NULL, data=dat)
    } else
    {
      dat <- dplyr::bind_rows(lapply(tt$results, function(x) data.frame(x,stringsAsFactors=FALSE)))
      meta <- tt$metadata$resultset
      atts <- list(totalCount=meta$count, pageCount=meta$limit, offset=meta$offset)
      all <- list(meta=atts, data=dat)
    }
  }
  class(all) <- "ncdc_locs_cats"
  return( all )
}
