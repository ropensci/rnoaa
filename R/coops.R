#' Get NOAA co-ops data
#'
#' @name coops
#' @param station_name numeric
#' @param begin_date numeric date in yyyymmdd format
#' @param end_date numeric date in yyyymmdd format
#' @param datum character choice of MHHW, MHW, MTL, MSL, MLW, MLLW, NAVD, STND
#' @param product character choice of water_level, air_temperature, water_temperature, wind, air_pressure, air_gap, conductivity, visibility, humidity, salinity, hourly_height, high_low, daily_mean, monthly_mean, one_minute_water_level, predictions, datums, currents.
#' @export
#' @references \url{http://co-ops.nos.noaa.gov/api/}
#' @examples \dontrun{
#' coops_search(station_name = 8723970, begin_date = 19820301, end_date = 20141001, datum = "stnd", product = "monthly_mean")
#' }
coops_search <- function(begin_date = NULL, end_date = NULL, station_name = NULL, product = NULL, datum = NULL, units = "metric", time_zone = "gmt", application = "web_services", format = "json"){

  args <- noaa_compact(list(begin_date = begin_date, end_date = end_date, station = station_name, product = product, datum = datum, units = units, time_zone = time_zone, application = application, format = format))

  coops_GET(coops_base(), args)
}

coops_base <- function() "http://tidesandcurrents.noaa.gov/api/datagetter"

coops_GET <- function(url, args, ...) {
  res <- httr::GET(url, query = args, ...)
  httr::stop_for_status(res)
  jsonlite::fromJSON(httr::content(res, "text"))
}
        