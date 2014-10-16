#' @export
#' @rdname storms
storm_meta <- function(what="storm_columns")
{
  switch(what, storm_columns = storm_columns, storm_names = storm_names)
}
