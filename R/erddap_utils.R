#' Options for saving ERDDAP datasets.
#' 
#' @export
#' @param path Path to store files in. Default: ~/.rnoaa/upwell
#' @param overwrite (logical) Overwrite an existing file of the same name? Default: TRUE
disk <- function(path = "~/.rnoaa/erddap", overwrite = TRUE){
  list(store="disk", path = path, overwrite = overwrite)
}

#' @export
#' @rdname disk
memory <- function() list(store="memory")
