

#' Search station list by extent
#'
#' @param extent The extent to search
#' @param foptions (optional) additional arguments to httr for diagnostic purposes.
#' @param token This must be a valid token token supplied to you by NCDC's Climate 
#' @export
#' @importFrom assertthat assert_that
#' @importFrom plyr compact
#' @author Karthik Ram karthik.ram@@gmail.com
#' @examples \dontrun{
#' noaa_loc_search(extent = "47.5204,-122.2047,47.6139,-122.1065")
#'}
noaa_loc_search <- function(extent = NULL, foptions = list(), 
	token = getOption("noaakey", stop("you need an API key for NOAA data"))) {
	assert_that(!is.null(extent))
	base_url <- "http://www.ncdc.noaa.gov/cdo-web/api/v2/stations"
	foptions <- c(add_headers("token" = token), foptions)
	args <- as.list(compact(c(extent = extent, token = token)))
	data_sources <- GET(base_url, query = args, foptions)
	stop_for_status(data_sources)
	obs_data <- content(data_sources)		
	data.frame(do.call(rbind, obs_data[[1]]))
}