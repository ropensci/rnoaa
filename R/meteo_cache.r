#' Clear *meteo* cached files
#'
#' The *meteo* functions use an aplication
#'
#' @note This function will clear all cached *meteo* files.
#' @param force (logical) force delete. default: `FALSE`
#' @family meteo
#' @export
meteo_clear_cache <- function(force = FALSE) {
  files <- list.files(ghcnd_cache$cache_path_get(), full.names = TRUE)
  unlink(files, recursive = TRUE, force = force)
}

#' Show the *meteo* cache directory
#'
#' Displays the full path to the `meteo` cache directory
#'
#' @family meteo
#' @export
meteo_show_cache <- function() {
  cat(ghcnd_cache$cache_path_get(), "\n")
}
