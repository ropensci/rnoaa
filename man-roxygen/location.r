#' @param datasetid A single valid dataset id. Data returned will be from the 
#'    dataset specified, see datasets() (required)
#' @param locationcategoryid A valid location id or a chain of location category ids 
#' 	  seperated by ampersands. Locations returned will be in the location category(ies) specified
#' @param startdate A valid ISO formated date (yyyy-mm-dd). Data returned will have 
#'    data after the specified date. Paramater can be use independently of enddate (optional)
#' @param enddate Accepts valid ISO formated date (yyyy-mm-dd). Data returned will have data 
#'    before the specified date. Paramater can be use independently of startdate (optional)
#' @param sortfield The field to sort results by. Supports id, name, mindate, maxdate, and 
#'    datacoverage fields (optional)
#' @param sortorder Which order to sort by, asc or desc. Defaults to asc (optional)
#' @param limit Defaults to 25, limits the number of results in the response. Maximum is 
#'    1000 (optional)
#' @param offset Defaults to 0, used to offset the resultlist (optional)
#' @param token This must be a valid token token supplied to you by NCDC's Climate 
#'    Data Online access token generator. (required) Get an API key (=token) at 
#'    \url{http://www.ncdc.noaa.gov/cdo-web/token}. You can pass your token in as 
#'    an argument or store it in your .Rprofile file with an entry like
#'    \itemize{
#'      \item options("noaakey" = "your-noaa-token")
#'    }
#' @param callopts Further arguments passed on to the API GET call. (optional)