#' Get NOAA co-ops data
#'
#' @name coops
#' @param station_name (numeric)
#' @param begin_date (numeric) Date in yyyymmdd format. Required
#' @param end_date (numeric) Date in yyyymmdd format. Required
#' @param product (character) Specify the data type. See below for Details. Required
#' @param datum (character) See below for Details. Required for all water level products.
#' @param units (character) Specify metric or english (imperial) units, one of 'metric', 'english'. 
#' @param time_zone (character) Time zone, one of 'gmt', 'lst', 'lst_ldt'.
#' @param application (character) If called within an external package, set to the name of your organization. Optional
#' @param ... Curl options passed on to \code{\link[httr]{GET}}. Optional
#' 
#' @details 
#' Options for the product paramter. One of:
#' \itemize{
#'  \item water_level - Preliminary or verified water levels, depending on availability
#'  \item air_temperature - Air temperature as measured at the station
#'  \item water_temperature - Water temperature as measured at the station
#'  \item wind - Wind speed, direction, and gusts as measured at the station
#'  \item air_pressure - Barometric pressure as measured at the station
#'  \item air_gap - Air Gap (distance between a bridge and the water's surface) at the station
#'  \item conductivity - The water's conductivity as measured at the station
#'  \item visibility - Visibility from the station's visibility sensor. A measure of atmospheric clarity
#'  \item humidity - Relative humidity as measured at the station
#'  \item salinity - Salinity and specific gravity data for the station
#'  \item hourly_height - Verified hourly height water level data for the station
#'  \item high_low - Verified high/low water level data for the station
#'  \item daily_mean - Verified daily mean water level data for the station
#'  \item monthly_mean - Verified monthly mean water level data for the station
#'  \item one_minute_water_level - One minute water level data for the station
#'  \item predictions - 6 minute predictions water level data for the station
#'  \item datums - datums data for the stations
#'  \item currents - Currents data for currents stations
#' }
#' 
#' Options for the datum paramter. One of:
#' \itemize{
#'  \item MHHW - Mean higher high water
#'  \item MHW - Mean high water
#'  \item MTL - Mean tide level
#'  \item MSL - Mean sea level
#'  \item MLW - Mean low water
#'  \item MLLW - Mean lower low water
#'  \item NAVD - North American Vertical Datum
#'  \item STND - Station datum
#' }
#'
#' @export
#' @references \url{http://co-ops.nos.noaa.gov/api/}
#' @examples \dontrun{
#' # Get monthly mean sea level data at Vaca Key (8723970)
#' coops_search(station_name = 8723970, begin_date = 19820301, end_date = 20141001,
#'  datum = "stnd", product = "monthly_mean")
#'  
#' # Get verified water level data at Vaca Key (2723970)
#' coops_search(station_name = 8723970, begin_date = 20140927, end_date = 20140928,
#'  datum = "stnd", product = "water_level")
#'  
#' # Get air temperature at Vaca Key (2723970)
#' coops_search(station_name = 8723970, begin_date = 20140927, end_date = 20140928,
#'  product = "air_temperature")
#' 
#' # Get water temperature at Vaca Key (2723970)
#' coops_search(station_name = 8723970, begin_date = 20140927, end_date = 20140928,
#'  product = "water_temperature")
#' }
coops_search <- function(begin_date = NULL, end_date = NULL, station_name = NULL, product, datum = NULL, units = "metric", time_zone = "gmt", application = "rnoaa", ...){

  args <- noaa_compact(list(begin_date = begin_date, end_date = end_date, station = station_name, product = product, datum = datum, units = units, time_zone = time_zone, application = application, format = "json"))

  res <- coops_GET(coops_base(), args, ...)

  if(is.null(nrow(res$data))){
    stop("No data was found")
  }
  
  res
}

coops_base <- function() "http://tidesandcurrents.noaa.gov/api/datagetter"
  
coops_GET <- function(url, args, ...) {
  res <- httr::GET(url, query = args, ...)
  httr::stop_for_status(res)
  jsonlite::fromJSON(httr::content(res, "text"))
}
        