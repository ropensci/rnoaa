#' Clear *meteo* cached files
#'
#' The *meteo* functions use an aplication
#'
#' @note This function will clear all cached *meteo* files.
#' @param force (logical) force delete. default: `FALSE`
#' @family meteo
#' @export
meteo_clear_cache <- function(force = FALSE) {
  files <- list.files(file.path(rnoaa_cache_dir(), "ghcnd"), full.names = TRUE)
  unlink(files, recursive = TRUE, force = force)
}

#' Show the *meteo* cache directory
#'
#' Displays the full path to the `meteo` cache directory
#'
#' @family meteo
#' @export
meteo_show_cache <- function() {
  cat(file.path(rnoaa_cache_dir(), "ghcnd"), "\n")
}
