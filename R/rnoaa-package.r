#' @title rnoaa
#'
#' @description rnoaa is an R interface to NOAA climate data.
#'
#' @section Data Sources:
#' Many functions in this package interact with the National Climatic Data
#' Center application programming interface (API) at
#' https://www.ncdc.noaa.gov/cdo-web/webservices/v2, all of
#' which functions start with `ncdc_`. An access token, or API key, is
#' required to use all the `ncdc_` functions. The key is required by NOAA,
#' not us. Go to the link given above to get an API key.
#'
#' More NOAA data sources are being added through time. Data sources and their
#' function prefixes are:
#'
#' - `buoy_*` - NOAA Buoy data from the National Buoy Data Center
#' - `ghcnd_*`/`meteo_*` - GHCND daily data from NOAA
#' - `isd_*` - ISD/ISH data from NOAA
#' - `homr_*` - Historical Observing Metadata Repository (HOMR)
#'  vignette
#' - `ncdc_*` - NOAA National Climatic Data Center (NCDC) vignette
#'  (examples)
#' - `sea_ice` - Sea ice vignette
#' - `storm_` - Storms (IBTrACS) vignette
#' - `swdi` - Severe Weather Data Inventory (SWDI) vignette
#' - `tornadoes` - From the NOAA Storm Prediction Center
#' - `coops_search` - NOAA CO-OPS - tides and currents data
#' - `cpc_prcp` - rainfall data from the NOAA Climate
#'  Prediction Center (CPC)
#' - `arc2` - rainfall data from Africa Rainfall Climatology
#'  version 2
#' - `bsw` - Blended sea winds (BSW)
#' - `ersst` - NOAA Extended Reconstructed Sea Surface
#'   Temperature (ERSST) data
#' - `lcd` - Local Climitalogical Data from NOAA
#'
#' @section Where data comes from and government shutdowns:
#'
#' Government shutdowns can greatly affect data sources in this package.
#' The following is a breakdown of the functions that fetch data by
#' HTTP vs. FTP - done this way as we've noticed that during the ealry 2019
#' border wall shutdown most FTP services were up, while those that were down
#' were HTTP; though not all HTTP services were down.
#'
#' - HTTP info: https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol
#' - FTP info: https://en.wikipedia.org/wiki/File_Transfer_Protocol
#'
#' HTTP services (whether service is/was up or down during early 2019 shutdown)
#'
#' - `buoy_*` - Up
#' - `homr_*` - Up
#' - `ncdc_*` - Down
#' - `swdi` - Down
#' - `tornadoes` - Down
#' - `coops_search` - Up
#' - `ersst` - Down
#' - `lcd` - Down
#' - `se_*` - Down
#'
#' FTP services (whether service is/was up or down during early 2019 shutdown)
#'
#' - `ghcnd_*` - Up
#' - `isd_*` - Up
#' - `sea_ice` - Up
#' - `storm_` - Up
#' - `cpc_prcp` - Up
#' - `arc2` - Up
#' - `bsw` - Up
#'
#' We've tried to whenever possible detect whether a service is error
#' due to a government shutdown and give a message saying so. If you know
#' a service is down that rnoaa interacts with but we don't fail well
#' during a shutdown let us know.
#'
#' @section A note about NCDF data:
#'
#' Some functions use netcdf files, including:
#'
#' - `ersst`
#' - `buoy`
#' - `bsw`
#'
#' You'll need the `ncdf4` package for those functions, and those only.
#' `ncdf4` is in Suggests in this package, meaning you only need
#' `ncdf4` if you are using any of the functions listed above. You'll get
#' an informative error telling you to install `ncdf4` if you don't have
#' it and you try to use the those functions. Installation of `ncdf4`
#' should be straightforward on any system.
#'
#' @section The `meteo` family of functions:
#'
#' The `meteo` family of functions are prefixed with `meteo_` and
#' provide a set of helper functions to:
#'
#' - Identify candidate stations from a latitude/longitude pair
#' - Retrieve complete data for one or more stations (`meteo_coverage()`)
#'
#' @importFrom utils head download.file read.csv read.delim read.fwf read.table
#' write.csv unzip
#' @importFrom lubridate ymd year today month
#' @importFrom scales date_breaks date_format
#' @importFrom ggplot2 autoplot ggplot aes facet_wrap theme theme_bw geom_line
#' labs guides guide_legend fortify scale_x_date scale_x_datetime element_blank
#' @importFrom crul HttpClient url_build url_parse
#' @importFrom XML xpathSApply xpathApply xmlValue xmlParse xmlToList htmlParse
#' @importFrom xml2 read_html read_xml xml_find_all xml_attr as_list
#' xml_text xml_find_first
#' @importFrom jsonlite fromJSON
#' @importFrom tidyr gather separate
#' @importFrom gridExtra grid.arrange
#' @importFrom dplyr %>% select mutate rename filter bind_rows
#' as_tibble contains rowwise do bind_cols ungroup
#' @importFrom tibble as_tibble data_frame
#' @importFrom scales comma
#' @importFrom tidyselect vars_select
#' @name rnoaa-package
#' @aliases rnoaa
#' @docType package
#' @keywords package
NULL

#' FIPS codes for US states.
#'
#' A dataset containing the FIPS codes for 51 US states
#' 		and territories. The variables are as follows:
#'
#' - state. US state name.
#' - county. County name.
#' - fips_state. Numeric value, from 1 to 51.
#' - fips_county. Numeric value, from 1 to 840.
#' - fips. Numeric value, from 1001 to 56045.
#'
#' @docType data
#' @keywords datasets
#' @format A data frame with 3142 rows and 5 variables
#' @name fipscodes
NULL

