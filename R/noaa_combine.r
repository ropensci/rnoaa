#' Coerce multiple outputs to a single data.frame object.
#' 
#' @param x Object from another noaa_* function.
#' @param ... Other arguments passed on, not used right now.
#' 
#' @return A data.frame
#' @export
#' @examples \dontrun{
#' out1 <- noaa(datasetid='GHCND', locationid = 'FIPS:02', startdate = '2010-05-01', enddate = '2010-05-31', limit=10)
#' out2 <- noaa(datasetid='GHCND', locationid = 'FIPS:02', startdate = '2010-07-01', enddate = '2010-07-31', limit=10)
#' noaa_combine(out1, out2)
#' }

noaa_combine <- function(...){
  UseMethod("noaa_combine")
}

#' @method noaa_combine default
#' @export
#' @rdname noaa_combine
noaa_combine.default <- function(...){
  input <- list(...)
  class <- class(input[[1]])
  if (db == 'noaa_data') {
    out <- noaa_combine(input)
  }
#   if (db == 'ncbi') {
#     id <- get_uid(x, ...)
#     out <- classification(id, ...)
#     names(out) <- x
#   }
#   if (db == 'eol') {
#     id <- get_eolid(x, ...)
#     out <- classification(id, ...)
#     names(out) <- x
#   }
#   if (db == 'col') {
#     id <- get_colid(x, ...)
#     out <- classification(id, ...)
#     names(out) <- x
#   }
#   if (db == 'tropicos') {
#     id <- get_tpsid(x, ...)
#     out <- classification(id, ...)
#     names(out) <- x
#   }
  return(out)
}

#' @method noaa_combine noaa_data
#' @export
#' @rdname noaa_combine
noaa_combine.noaa_data <- function(x) 
{
  rbindlist(lapply(x, "[[", "data"))
  out <- lapply(id, fun)
  #   names(out) <- id
  return(out)
}
