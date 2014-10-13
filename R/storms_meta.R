#' Get NOAA wind storm metadata.
#' 
#' @export
#'
#' @examples \donttest{
#' head( storm_meta() )
#' head( storm_meta("storm_columns") )
#' head( storm_meta("storm_names") )
#' }

storm_meta <- function(what="storm_columns")
{
  switch(what, storm_columns = storm_columns, storm_names = storm_names)
}
