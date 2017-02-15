#' @param datatypeid Accepts a valid data type id or a vector or list of data
#' type ids. (optional)
#' @param locationid Accepts a valid location id or a vector or list of
#' location ids (optional)
#' @param sortfield The field to sort results by. Supports id, name, mindate,
#' maxdate, and datacoverage fields (optional)
#' @param sortorder Which order to sort by, asc or desc. Defaults to
#' asc (optional)
#' @param limit Defaults to 25, limits the number of results in the response.
#' Maximum is 1000 (optional)
#' @param offset Defaults to 0, used to offset the resultlist (optional)
#' @param ... Curl options passed on to \code{\link[httr]{GET}} (optional)
