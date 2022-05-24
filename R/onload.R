cpc_cache <- NULL
arc2_cache <- NULL
lcd_cache <- NULL
bsw_cache <- NULL
isd_cache <- NULL
stormevents_cache <- NULL
ersst_cache <- NULL
torn_cache <- NULL
ghcnd_cache <- NULL

.onLoad <- function(libname, pkgname){
  x <- hoardr::hoard()
  x$cache_path_set(full_path = tools::R_user_dir("rnoaa/noaa_cpc", which = "cache"))
  cpc_cache <<- x

  y <- hoardr::hoard()
  y$cache_path_set(full_path = tools::R_user_dir("rnoaa/noaa_arc2", which = "cache"))
  arc2_cache <<- y

  w <- hoardr::hoard()
  w$cache_path_set(full_path = tools::R_user_dir("rnoaa/noaa_lcd", which = "cache"))
  lcd_cache <<- w

  m <- hoardr::hoard()
  m$cache_path_set(full_path = tools::R_user_dir("rnoaa/noaa_bsw", which = "cache"))
  bsw_cache <<- m

  g <- hoardr::hoard()
  g$cache_path_set(full_path = tools::R_user_dir("rnoaa/noaa_isd", which = "cache"))
  isd_cache <<- g

  ss <- hoardr::hoard()
  ss$cache_path_set(full_path = tools::R_user_dir("rnoaa/noaa_stormevents", which = "cache"))
  stormevents_cache <<- ss

  p <- hoardr::hoard()
  p$cache_path_set(full_path = tools::R_user_dir("rnoaa/noaa_ersst", which = "cache"))
  ersst_cache <<- p

  torn <- hoardr::hoard()
  torn$cache_path_set(full_path = tools::R_user_dir("rnoaa/noaa_tornadoes", which = "cache"))
  torn_cache <<- torn

  hh <- hoardr::hoard()
  hh$cache_path_set(full_path = tools::R_user_dir("rnoaa/noaa_ghcnd", which = "cache"))
  ghcnd_cache <<- hh
}
