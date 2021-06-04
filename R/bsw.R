#' Blended sea winds (BSW)
#' 
#' The Blended Sea Winds dataset contains globally gridded, high-resolution 
#' ocean surface vector winds and wind stresses on a global 0.25° grid, and 
#' multiple time resolutions of six-hourly, daily, monthly, and 11-year 
#' (1995–2005) climatological monthlies. 
#'
#' @export
#' @param date (date/character) date, in the form YYYY-MM-DD if resolution 
#' is 6hrly or daily, or in the form YYYY-MM if resolution is monthly. 
#' For resolution=clm can be left NULL. If given, must be in the 
#' range 1987-07-09 to today-1 (yesterday)
#' @param uv_stress (character) one of uv or stresss, not sure what these
#' mean exactly yet. Default: uv
#' @param resolution (character) temporal resolution. one of 6hrly, 
#' clm, daily, or monthly. See Details.
#' @param ... curl options passed on to [crul::verb-GET]
#' @return an object of class `ncdf4`
#' 
#' @details 
#' Products are available from July 9th, 1987 - present.
#' 
#' Uses `ncdf4` under the hood to read NetCDF files
#' 
#' @note See [bsw_cache] for managing cached files
#' 
#' @section Citing NOAA and BSW data:
#' Message from NOAA: "We also ask you to acknowledge us in your use of the 
#' data to help us justify continued service. This may be done by  including 
#' text such as: The wind data are acquired from NOAA's National Climatic 
#' Data Center, via their website We would also  appreciate receiving a 
#' copy of the relevant publication."
#' 
#' @section Temporal resolution:
#'
#' - 6hrly: 6-hourly, 4 global snapshots (u,v) at UTC 00, 06, 12 and 18Z
#' - clm: climatological monthlies; also provided is the scalar 
#'   mean (u,v,w)
#' - daily: averages of the 6hrly time points, thus with a center time 
#'   09Z; also provided is the scalar mean, (u,v,w)
#' - monthly: averages of daily data; also provided is the scalar 
#'   mean (u,v,w)
#' 
#' @note We only handle the netcdf files for now, we're avoiding the ieee 
#' files, see https://www.cpc.ncep.noaa.gov/products/wesley/wgrib2/ieee.html
#' 
#' @references 
#' https://www.ncdc.noaa.gov/data-access/marineocean-data/blended-global/blended-sea-winds
#'
#' @examples \dontrun{
#' # 6hrly data
#' ## uv
#' x <- bsw(date = "2017-10-01")
#' ## stress
#' y <- bsw(date = "2011-08-01", uv_stress = "stress")
#' 
#' # daily
#' z <- bsw(date = "2017-10-01", resolution = "daily")
#' 
#' # monthly
#' w <- bsw(date = "2011-08", resolution = "monthly")
#' 
#' # clm
#' # x <- bsw(resolution = "clm")
#' }
bsw <- function(date = NULL, uv_stress = "uv", resolution = "6hrly", ...) {
  assert(uv_stress, 'character')
  assert(resolution, 'character')
  if (!is.null(date)) {
    if (resolution == "monthly") date <- paste0(date, "-01")
    assert(date, c("character", "Date"))
    dates <- str_extract_all_(date, "[0-9]+")[[1]]
    assert_range(dates[1], 1987:format(Sys.Date(), "%Y"))
    assert_range(as.numeric(dates[2]), 1:12)
    assert_range(as.numeric(dates[3]), 1:31)
    # monthly resolution specific date range check
    if (resolution == "monthly") {
      assert_range(dates[1], 1987:2011)
      if (dates[1] == 1987) assert_range(as.numeric(dates[2]), 7:12)
      if (dates[1] == 2011) assert_range(as.numeric(dates[2]), 1:9)
    }
    # stress specific date range check
    if (uv_stress == "stress") {
      if (resolution %in% c("6hrly", "daily"))
      assert_range(dates[1], 1987:2011)
      if (dates[1] == 1987) assert_range(as.numeric(dates[2]), 7:12)
      if (dates[1] == 2011) assert_range(as.numeric(dates[2]), 1:9)
    }
    stopifnot(as.Date(date) < Sys.Date())
  } else {
    dates <- rep(NA, 3)
  }

  path <- bsw_get(year = dates[1], month = dates[2], day = dates[3],
                  uv_stress = uv_stress, resolution = resolution, ...)
  bsw_read(path)
}

bsw_get <- function(year, month, day, uv_stress, resolution,
  cache = TRUE, overwrite = FALSE, ...) {

  # create main dir
  bsw_cache$mkdir()
  # create sub dirs
  invisible(lapply(c("uv", "stress"), function(z) {
    dir.create(file.path(bsw_cache$cache_path_get(), z), 
      recursive = TRUE, showWarnings = FALSE)
  }))
  invisible(lapply(c("6hrly", "daily", "monthly", "clm"), function(z) {
    dir.create(file.path(bsw_cache$cache_path_get(), "uv", z), 
      recursive = TRUE, showWarnings = FALSE)
  }))
  invisible(lapply(c("6hrly", "daily", "monthly", "clm"), function(z) {
    dir.create(file.path(bsw_cache$cache_path_get(), "stress", z), 
      recursive = TRUE, showWarnings = FALSE)
  }))

  # create key (aka: url)
  if (resolution == "clm") {
    key <- "https://www.ncei.noaa.gov/data/blended-global-sea-surface-wind-products/access/winds/climatology/uvclm95to05.nc"
  } else {
    key <- bsw_key(year, month, day, uv_stress, resolution)
  }
  
  file <- file.path(
    bsw_cache$cache_path_get(), 
    uv_stress,
    resolution, 
    basename(key)
  )
  if (!file.exists(file)) {
    suppressMessages(bsw_GET_write(key, file, overwrite, ...))
  } else {
    cache_mssg(file)
  }
  return(file)
}

bsw_GET_write <- function(url, path, overwrite = TRUE, ...) {
  cli <- crul::HttpClient$new(url = url, opts = list(...))
  if (!overwrite) {
    if (file.exists(path)) {
      stop("file exists and ovewrite != TRUE", call. = FALSE)
    }
  }
  res <- tryCatch(cli$get(disk = path, ...), error = function(e) e)
  if (inherits(res, "error")) {
    unlink(path)
    stop(res$message, call. = FALSE)
  }
  return(res)
}

bsw_base_ftp <- function(x) {
  base <- "https://www.ncei.noaa.gov/data/blended-global-sea-surface-wind-products/access"
  if (x == "uv") file.path(base, "winds") else file.path(base, "stress")
}

bsw_key <- function(year, month, day, uv_stress, resolution) {
  sprintf("%s/%s/%s%s%s%s.nc",
    bsw_base_ftp(uv_stress),
    if (resolution == "6hrly") "6-hourly" else resolution,
    if (resolution %in% c('6hrly', 'daily', "monthly")) {
      paste0(year, "/")
    } else {
      ""
    },
    switch(uv_stress, uv = "uv", stress = "tauxy"),
    if (resolution == "monthly") paste0(year, month) else paste0(year, month, day),
    if (
      as.Date(sprintf("%s-%s-%s", year, month, day)) >= as.Date("2011-10-01") &&
      resolution %in% c('6hrly', 'daily')
    ) {
      "rt"
    } else {
      ""
    }
  )
}

bsw_read <- function(x) {
  check4pkg("ncdf4")
  ncdf4::nc_open(x)
}
