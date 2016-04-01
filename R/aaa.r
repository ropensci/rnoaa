# base app folder for rappdirs
rnoaa_app_name <- "rnoaa"
rnoaa_cache_dir <- rappdirs::user_cache_dir(rnoaa_app_name)

# for the caches for the meteo verbs
rnoaa_meteo_dir <- file.path(rnoaa_cache_dir, "meteo")

# Create cache dir on load if it doesn't exit
.onLoad <- function(libname, pkgname) {
  dir.create(rnoaa_meteo_dir, showWarnings = FALSE, recursive = TRUE)
  invisible()
}
