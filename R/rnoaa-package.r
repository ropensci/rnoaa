#' rnoaa is an R interface to NOAA climate data.
#' 
#' Many functions in this package interact with the National Climatic Data Center application 
#' programming interface (API) at \url{http://www.ncdc.noaa.gov/cdo-web/webservices/v2}, all of 
#' which functions start with \code{ncdc_}. An access token, or API key, is required to use all
#' the \code{ncdc_} functions. The key is required by NOAA, not the creators of this R package. 
#' Go to the link given above to get an API key.
#' 
#' More NOAA data sources are being added through time. Data sources and their function prefixes
#' are:
#' 
#' \itemize{
#'  \item \code{buoy_*} - NOAA Buoy data, only on buoy branch in Github repo
#'  \item \code{erddap_*} - NOAA ERDDAP vignette
#'  \item \code{ncdc_*} - NOAA National Climatic Data Center (NCDC) vignette (examples)
#'  \item \code{seaice} - Sea ice vignette
#'  \item \code{swdi} - Severe Weather Data Inventory (SWDI) vignette
#'  \item \code{homr_*} - Historical Observing Metadata Repository (HOMR) vignette
#'  \item \code{storm_} - Storms (IBTrACS) vignette
#'  \item \code{tornadoes} - From the NOAA Storm Prediction Center
#' } 
#' 
#' @name rnoaa-package
#' @aliases rnoaa
#' @docType package
#' @title General purpose R interface to noaa.
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
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
#' This dataset includes description of the columns of each dataset acquired using 
#' \code{\link[rnoaa]{storm_data}}
#' 
#' @docType data
#' @keywords datasets
#' @format A data frame with 195 rows and 8 variables
#' @name storm_columns
NULL

#' NOAA storm names from IBTrACS
#' 
#' This dataset includes a crosswalk from storm serial numbers to their names. Storm serial numbers
#' are used to search for storms in the \code{\link[rnoaa]{storm_data}} function.
#' 
#' @docType data
#' @keywords datasets
#' @format A data frame with 12,209 rows and 2 variables
#' @name storm_names
NULL
