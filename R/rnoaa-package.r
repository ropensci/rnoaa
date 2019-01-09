#' @title rnoaa
#'
#' @description rnoaa is an R interface to NOAA climate data.
#'
#' @section Data Sources:
#' Many functions in this package interact with the National Climatic Data
#' Center application programming interface (API) at
#' https://www.ncdc.noaa.gov/cdo-web/webservices/v2, all of
#' which functions start with \code{ncdc_}. An access token, or API key, is
#' required to use all the \code{ncdc_} functions. The key is required by NOAA,
#' not us. Go to the link given above to get an API key.
#'
#' More NOAA data sources are being added through time. Data sources and their
#' function prefixes are:
#'
#' \itemize{
#'  \item \code{buoy_*} - NOAA Buoy data from the National Buoy Data Center
#'  \item \code{gefs_*} - GEFS forecast ensemble data
#'  \item \code{ghcnd_*}/\code{meteo_*} - GHCND daily data from NOAA
#'  \item \code{isd_*} - ISD/ISH data from NOAA
#'  \item \code{homr_*} - Historical Observing Metadata Repository (HOMR)
#'  vignette
#'  \item \code{ncdc_*} - NOAA National Climatic Data Center (NCDC) vignette
#'  (examples)
#'  \item \code{seaice} - Sea ice vignette
#'  \item \code{storm_} - Storms (IBTrACS) vignette
#'  \item \code{swdi} - Severe Weather Data Inventory (SWDI) vignette
#'  \item \code{tornadoes} - From the NOAA Storm Prediction Center
#'  \item \code{argo_*} - Argo buoys
#'  \item \code{coops_search} - NOAA CO-OPS - tides and currents data
#'  \item \code{cpc_prcp} - rainfall data from the NOAA Climate
#'  Prediction Center (CPC)
#'  \item \code{arc2} - rainfall data from Africa Rainfall Climatology
#'  version 2
#'  \item \code{bsw} - Blended sea winds (BSW)
#'  \item \code{ersst} - NOAA Extended Reconstructed Sea Surface 
#'   Temperature (ERSST) data
#'  \item \code{lcd} - Local Climitalogical Data from NOAA
#' }
#' 
#' @section Where data comes from and government shutdowns:
#' 
#' Government shutdowns can greatly affect data sources in this package.
#' The following is a breakdown of the functions that fetch data by 
#' HTTP vs. FTP - done this way as we've noticed that during the ealry 2019
#' border wall shutdown most FTP services were up, while those that were down
#' were HTTP; though not all HTTP services were down.
#' 
#' \itemize{
#'  \item HTTP info: https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol
#'  \item FTP info: https://en.wikipedia.org/wiki/File_Transfer_Protocol
#' }
#' 
#' HTTP services (whether service is/was up or down during early 2019 shutdown)
#' 
#' \itemize{
#'  \item \code{buoy_*} - Up
#'  \item \code{gefs_*} - Up
#'  \item \code{homr_*} - Up
#'  \item \code{ncdc_*} - Down
#'  \item \code{swdi} - Down
#'  \item \code{tornadoes} - Down
#'  \item \code{argo_*} - Up (all HTTP except two fxns, see also FTP below)
#'  \item \code{coops_search} - Up
#'  \item \code{ersst} - Down
#'  \item \code{lcd} - Down
#'  \item \code{se_*} - Down
#' }
#' 
#' FTP services (whether service is/was up or down during early 2019 shutdown)
#' 
#' \itemize{
#'  \item \code{ghcnd_*} - Up
#'  \item \code{isd_*} - Up
#'  \item \code{seaice} - Up
#'  \item \code{storm_} - Up
#'  \item \code{argo_*} - Up (only two fxns: \code{argo()} and 
#'   \code{argo_buoy_files()})
#'  \item \code{cpc_prcp} - Up
#'  \item \code{arc2} - Up
#'  \item \code{bsw} - Up
#' }
#' 
#' We've tried to whenever possible detect whether a service is error 
#' due to a government shutdown and give a message saying so. If you know 
#' a service is down that rnoaa interacts with but we don't fail well
#' during a shutdown let us know.
#'
#' @section A note about NCDF data:
#'
#' Functions to work with buoy data use netcdf files. You'll need the
#' \code{ncdf4} package for those functions, and those only. \code{ncdf4} is
#' in Suggests in this package, meaning you only need \code{ncdf4} if you are
#' using the buoy functions. You'll get an informative error telling you to
#' install \code{ncdf4} if you don't have it and you try to use the
#' buoy functions.

#' @section The \code{meteo} family of functions:
#'
#' The \code{meteo} family of functions are prefixed with \code{meteo_} and
#' provide a set of helper functions to:
#'
#' \itemize{
#'   \item Identify candidate stations from a latitude/longitude pair
#'   \item Retrieve complete data for one or more stations
#'   (\code{meteo_coverage()})
#' }
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
#' @importFrom tidyr gather
#' @importFrom rappdirs user_cache_dir
#' @importFrom gridExtra grid.arrange
#' @importFrom dplyr %>% select mutate rename tbl_df filter bind_rows
#' as_data_frame contains rowwise do bind_cols ungroup
#' @importFrom tibble as_data_frame data_frame
#' @importFrom scales comma
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
#' \itemize{
#'   \item state. US state name.
#'   \item county. County name.
#'   \item fips_state. Numeric value, from 1 to 51.
#'   \item fips_county. Numeric value, from 1 to 840.
#'   \item fips. Numeric value, from 1001 to 56045.
#' }
#'
#' @docType data
#' @keywords datasets
#' @format A data frame with 3142 rows and 5 variables
#' @name fipscodes
NULL

#' NOAA storm column descriptions for data from IBTrACS
#'
#' This dataset includes description of the columns of each dataset acquired
#' using \code{\link[rnoaa]{storm_data}}
#'
#' @docType data
#' @keywords datasets
#' @format A data frame with 195 rows and 8 variables
#' @name storm_columns
NULL

#' NOAA storm names from IBTrACS
#'
#' This dataset includes a crosswalk from storm serial numbers to their names.
#' Storm serial numbers are used to search for storms in the
#' \code{\link[rnoaa]{storm_data}} function.
#'
#' @docType data
#' @keywords datasets
#' @format A data frame with 12,209 rows and 2 variables
#' @name storm_names
NULL
