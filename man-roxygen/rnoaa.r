#' @import httr
#' @param dataset The data set name, see datasets()
#' @param startdate The date format pattern to limit the start date of the web 
#'    service query. This is a string date mask represented by "yyyyMMdd" where 
#'    yyyy is a 4-digit year, MM is the 2-digit month, and dd is the 2-digit day. 
#'    Optional. (Note: not used for Normals)
#' @param enddate The date format pattern to limit the end date of the web service 
#'    query. This is a string date mask represented by "yyyyMMdd" where yyyy is a 
#'    4-digit year, MM is the 2-digit month, and dd is the 2-digit day. 
#'    Optional. (Note: not used for Normals)
#' @param page Results with over 10 items will be paginated. This controls which 
#'    page of data is returned from the service. This variable only accepts an 
#'    integer as input and is optional.
#' @param year Used for Annual Normals to specify which yearly set of normals to 
#'    use. Currently only available from 1981-2010, so specify 2010 as the value. 
#'    This is a string date mask represented by "yyyy" where yyyy is a 4-digit year.
#' @param month Used for Annual Normals to specify which month to display for Annual 
#'    Normals. Values include 01-12. This is a string date mask represented by "MM" 
#'    where MM is the 2-digit month
#' @param day Day of the month, between 01 and 31
#' @param token This must be a valid token token supplied to you by NCDC's Climate 
#'    Data Online access token generator. Required.
#' @param callopts Further arguments passed on to the API GET call.