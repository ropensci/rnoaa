#' Clear cached files
#'
#' @name caching
#' @param path Path to location of cached files. Defaults to \code{disk()$path}
#' @param force (logical) Should we force removal of files if permissions say otherwise?
#' @details BEWARE: this will clear all cached files.

#' @export
#' @rdname caching
ghcnd_clear_cache <- function(path = "~/.rnoaa/ghcnd", force = FALSE) {
  files <- list.files(path, full.names = TRUE)
  unlink(files, recursive = TRUE, force = force)
}
