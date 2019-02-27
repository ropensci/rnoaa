#' Historical Observing Metadata Repository (HOMR) station metadata -
#' definitions
#'
#' @export
#' @param ... Curl options passed on to [crul::verb-GET]
#' optional
#' @examples \dontrun{
#' head( homr_definitions() )
#' }
homr_definitions <- function(...) {
  cli <- crul::HttpClient$new(paste0(homr_base(), "search"), opts = list(...))
  res <- cli$get(query = list(qid = 'COOP:046742'))
  res$raise_for_status()
  json <- jsonlite::fromJSON(res$parse("UTF-8"), FALSE)
  parse_defs(json$stationCollection$definitions)
}

parse_defs <- function(x){
  if (is.null(x)) NULL else
    dplyr::bind_rows(lapply(x, data.frame, stringsAsFactors = FALSE))
}
