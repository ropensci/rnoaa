#' @param datasetid A valid dataset id or a vector or list of dataset id's. Data returned will be from the
#'    dataset specified, see datasets() (required)
#' @param locationcategoryid A valid location id or a vector or list of location category ids
#' @param startdate A valid ISO formatted date (yyyy-mm-dd). Data returned will have
#'    data after the specified date. Paramater can be use independently of enddate (optional)
#' @param enddate Accepts valid ISO formatted date (yyyy-mm-dd). Data returned will have data
#'    before the specified date. Paramater can be use independently of startdate (optional)
#' @param sortfield The field to sort results by. Supports id, name, mindate, maxdate, and
#'    datacoverage fields (optional)
#' @param sortorder Which order to sort by, asc or desc. Defaults to asc (optional)
#' @param limit Defaults to 25, limits the number of results in the response. Maximum is
#'    1000 (optional)
#' @param offset Defaults to 0, used to offset the resultlist (optional)
#' @param ... Curl options passed on to \code{\link[crul]{HttpClient}}
