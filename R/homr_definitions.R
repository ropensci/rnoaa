#' Historical Observing Metadata Repository (HOMR) station metadata - definitions
#'
#' @export
#'
#' @param ... Named parameters, such as \code{query}, \code{path}, etc, passed on to
#' \code{\link[httr]{modify_url}}. Unnamed parameters will be combined with
#' \code{\link[httr]{config}}.
#'
#' @examples \dontrun{
#' head( homr_definitions() )
#' }

homr_definitions <- function(...){
  res <- GET(paste0(homr_base(), "search"), query=list(qid='COOP:046742'), ...)
  out <- content(res, "text")
  json <- jsonlite::fromJSON(out, FALSE)
  parse_defs(json$stationCollection$definitions)
}

parse_defs <- function(x){
  if(is.null(x)) NULL else do.call(rbind.fill, lapply(x, data.frame, stringsAsFactors = FALSE))
}
