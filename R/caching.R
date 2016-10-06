#' Clear cached files
#'
#' @name caching
#' @param force (logical) Should we force removal of files if permissions
#' say otherwise?. Default: \code{FALSE}
#'
#' @details BEWARE: this will clear all cached files.
#'
#' @section File storage:
#' We use \pkg{rappdirs} to store files, see
#' \code{\link[rappdirs]{user_cache_dir}} for how
#' we determine the directory on your machine to save files to, and run
#' \code{user_cache_dir("rnoaa")} to get that directory.

#' @export
#' @rdname caching
ghcnd_clear_cache <- function(force = FALSE) {
  calls <- names(sapply(match.call(), deparse))[-1]
  calls_vec <- "path" %in% calls
  if (any(calls_vec)) {
    stop("The parameter path has been removed, see ?ghcnd_clear_cache",
         call. = FALSE)
  }

  path <- file.path(rnoaa_cache_dir, "ghcnd")
  files <- list.files(path, full.names = TRUE)
  unlink(files, recursive = TRUE, force = force)
}
