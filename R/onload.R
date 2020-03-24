cpc_cache <- NULL
arc2_cache <- NULL
lcd_cache <- NULL
bsw_cache <- NULL
isd_cache <- NULL
storms_cache <- NULL
stormevents_cache <- NULL
ersst_cache <- NULL
torn_cache <- NULL
ghcnd_cache <- NULL

.onLoad <- function(libname, pkgname){
  x <- hoardr::hoard()
  x$cache_path_set("noaa_cpc")
  cpc_cache <<- x

  y <- hoardr::hoard()
  y$cache_path_set("noaa_arc2")
  arc2_cache <<- y

  w <- hoardr::hoard()
  w$cache_path_set("noaa_lcd")
  lcd_cache <<- w

  m <- hoardr::hoard()
  m$cache_path_set("noaa_bsw")
  bsw_cache <<- m

  g <- hoardr::hoard()
  g$cache_path_set("noaa_isd")
  isd_cache <<- g

  s <- hoardr::hoard()
  s$cache_path_set("noaa_storms")
  storms_cache <<- s

  ss <- hoardr::hoard()
  ss$cache_path_set("noaa_stormevents")
  stormevents_cache <<- ss

  p <- hoardr::hoard()
  p$cache_path_set("noaa_ersst")
  ersst_cache <<- p

  torn <- hoardr::hoard()
  torn$cache_path_set("noaa_tornadoes")
  torn_cache <<- torn

  hh <- hoardr::hoard()
  hh$cache_path_set("noaa_ghcnd")
  ghcnd_cache <<- hh
}
