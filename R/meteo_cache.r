#' Clear \emph{meteo} cached files
#'
#' The \emph{meteo} functions use an aplication
#'
#' @note This function will clear all cached \emph{meteo} files.
#' @family meteo
#' @export
meteo_clear_cache <- function() {
  files <- list.files(rnoaa_cache_dir, full.names = TRUE)
  unlink(files, recursive = TRUE, force = force)
}

#' Show the \emph{meteo} cache directory
#'
#' Displays the full path to the \code{meteo} cache directory
#'
#' @family meteo
#' @export
meteo_show_cache <- function() {
  cat(rnoaa_cache_dir, "\n")
}

