#' Historical Observing Metadata Repository (HOMR) station metadata - definitions
#'
#' @export
#' @param ... Curl options passed on to \code{\link[httr]{GET}} (optional)
#' @examples \dontrun{
#' head( homr_definitions() )
#' }

homr_definitions <- function(...){
  res <- GET(paste0(homr_base(), "search"), query=list(qid='COOP:046742'), ...)
  out <- utcf8(res)
  json <- jsonlite::fromJSON(out, FALSE)
  parse_defs(json$stationCollection$definitions)
}

parse_defs <- function(x){
  if(is.null(x)) NULL else dplyr::bind_rows(lapply(x, data.frame, stringsAsFactors = FALSE))
}
