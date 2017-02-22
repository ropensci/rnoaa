cpc_cache <- NULL
cmorph_cache <- NULL
arc2_cache <- NULL

.onLoad <- function(libname, pkgname){
  x <- hoardr::hoard()
  x$cache_path_set("noaa_cpc")
  cpc_cache <<- x

  y <- hoardr::hoard()
  y$cache_path_set("noaa_arc2")
  arc2_cache <<- y

  z <- hoardr::hoard()
  z$cache_path_set("noaa_cmorph")
  cmorph_cache <<- z
}
