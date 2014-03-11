#' rnoaa is an R interface to NOAA climate data.
#' 
#' Specifically, most functions in this package interact
#' with the National Climatic Data Center application 
#' programming interface (API) at 
#' \url{http://www.ncdc.noaa.gov/cdo-web/webservices/v2}.
#' 
#' An access token, or API key, is required to use this 
#' R package. The key is required by NOAA, not the
#' creators of this R package. Go to the link given above 
#' to get an API key.
#' 
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