# u <- "ftp://polar.ncep.noaa.gov/pub/history/waves/nww3/akw.dp.200409.grb"
# library(raster)
# res <- raster::brick(u)


#' Wavewatch data
#'
#' @export
#' @param date (date/character) date in YYYY-MM format
#' @param grid (logical) single grid or multi, only used when date is in the overlap
#' years of 2005-2007 for single- and multi-grid data
#' @param ... Curl options passed on to [crul::verb-GET]
#' @return an object of class `RasterBrick`, with xx:
#' 
#' - xx
#'
#' @references 
#' ftp://polar.ncep.noaa.gov/pub/history/waves/nww3,
#' ftp://polar.ncep.noaa.gov/pub/history/waves/multi_1/
#'
#' @details
#' The data is split into two groups: 
#' 
#' - nww3/ -- Early WW3 version, single grid from Jul 1999 - Nov 2007
#' with gaps
#' - multi_1/ -- Multi-grid WW3, from Feb 2005 to present
#'
#' @examples \dontrun{
#' waves(date = "2003-02")
#' waves(date = "2009-02")
#' }
waves <- function(date, grid = FALSE, ...) {
  assert(date, c("character", "Date"))
  assert(grid, 'character')
  dates <- str_extract_all_(date, "[0-9]+")[[1]]
  assert_range(dates[1], 1999:format(Sys.Date(), "%Y"))
  assert_range(as.numeric(dates[2]), 1:12)

  path <- waves_get(year = dates[1], month = dates[2], grid = grid, ...)
  waves_read(path, grid)
}
# ftp://polar.ncep.noaa.gov/pub/history/waves/nww3/enp.hs.200304.grb
# ftp://polar.ncep.noaa.gov/pub/history/waves/nww3/akw.dp.200610.grb
# ftp://polar.ncep.noaa.gov/pub/history/waves/nww3/nah.tp.200109.grb
# ftp://polar.ncep.noaa.gov/pub/history/waves/multi_1/200502/gribs/multi_1.ak_10m.dp.200502.grb2
# ftp://polar.ncep.noaa.gov/pub/history/waves/multi_1/201903/gribs/multi_1.wc_4m.wind.201903.grb2

# ftp://polar.ncep.noaa.gov/pub/history/waves/nww3/enp.wind.200602.grb
# ftp://polar.ncep.noaa.gov/pub/history/waves/multi_1/200602/gribs/multi_1.ep_10m.wind.200602.grb2

waves_get <- function(year, month, grid, cache = TRUE, overwrite = FALSE, ...) {
  waves_cache$mkdir()
  key <- waves_key(year, month, grid)
  file <- file.path(waves_cache$cache_path_get(), basename(key))
  if (!file.exists(file)) {
    suppressMessages(waves_GET_write(sub("/$", "", key), file, overwrite, ...))
  }
  return(file)
}

waves_GET_write <- function(url, path, overwrite = TRUE, ...) {
  cli <- crul::HttpClient$new(
    url = url,
    headers = list(Authorization = "Basic anonymous:myrmecocystus@gmail.com")
  )
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

waves_base_ftp <- function(x) {
  base <- "ftp://polar.ncep.noaa.gov/pub/history/waves"
  if (x) file.path(base, "multi_1") else file.path(base, "nww3")
}

waves_base_file <- function(x) {
  base <- "PRCP_CU_GAUGE_V1.0%sdeg.lnx."
  if (x) sprintf(base, "CONUS_0.25") else sprintf(base, "GLB_0.50")
}

waves_key <- function(year, month, grid) {
  sprintf("%s/%s/%s/%s%s%s",
    waves_base_ftp(grid),
    if (year < 2006) "V1.0" else "RT",
    year,
    waves_base_file(grid),
    paste0(year, month),
    if (year < 2006) {
      ".gz"
    } else if (year > 2005 && year < 2009) {
      if (grid && year == 2006) {
        ".gz"
      } else {
        ".RT.gz"
      }
    } else {
      ".RT"
    }
  )
}

# waves_read <- function(x, us) {
#   conn <- file(x, "rb")
#   on.exit(close(conn))

#   if (us) {
#     bites <- 120 * 300 * 2
#     lats <- seq(from = 20.125, to = 49.875, by = 0.25)
#     longs <- seq(from = 230.125, to = 304.875, by = 0.25)
#   } else {
#     bites <- 360 * 720 * 2
#     lats <- seq(from = 0.25, to = 89.75, by = 0.5)
#     lats <- c(rev(lats * -1), lats)
#     longs <- seq(from = 0.25, to = 359.75, by = 0.5)
#   }

#   # read data
#   tmp <- readBin(conn, numeric(), n = bites, size = 4, endian = "little")
#   tmp <- tmp[seq_len(bites/2)] * 0.1

#   # make data.frame
#   tibble::as_tibble(
#     stats::setNames(
#       cbind(expand.grid(longs, lats), tmp),
#       c('lon', 'lat', 'precip')
#     )
#   )
# }
