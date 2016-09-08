#' @param datasetid Accepts a valid dataset id or a vector or list of dataset id's. Data returned
#' 		will be from the dataset specified, see datasets() (required)
#' @param datacategoryid A valid data category id. Data types returned will be associated
#' 	  with the data category(ies) specified
#' @param locationid Accepts a valid location id or a vector or list of location id's. (optional)
#' @param stationid Accepts a valid station id or a vector or list of station ids (optional)
#' @param startdate Accepts valid ISO formated date (yyyy-mm-dd). Data returned will have
#'    data after the specified date. Paramater can be use independently of enddate (optional)
#' @param enddate Accepts valid ISO formated date (yyyy-mm-dd). Data returned will have data
#'    before the specified date. Paramater can be use independently of startdate (optional)
#' @param sortfield The field to sort results by. Supports id, name, mindate, maxdate, and
#'    datacoverage fields (optional)
#' @param sortorder Which order to sort by, asc or desc. Defaults to asc (optional)
#' @param limit Defaults to 25, limits the number of results in the response. Maximum is
#'    1000 (optional)
#' @param offset Defaults to 0, used to offset the resultlist (optional)
#' @param ... Further named parameters, such as \code{query}, \code{path}, etc, passed on to
#' \code{\link[httr]{modify_url}}. Unnamed parameters will be combined with
#' \code{\link[httr]{config}}.
