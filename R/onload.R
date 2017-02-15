cpc_cache <- NULL

.onLoad <- function(libname, pkgname){
  x <- hoardr::hoard()
  x$cache_path_set("noaa_cpc")
  cpc_cache <<- x
}
