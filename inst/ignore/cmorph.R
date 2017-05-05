#' Precipitation data from NOAA CPC Morphing Tecchnique (CMORPH)
#'
#' @export
#' @param date (date/character) date in YYYY-MM-DD format
#' @param us (logical) US data only? default: \code{FALSE}
#' @param ... curl options passed on to \code{\link[crul]{HttpClient}}
#' @return a data.frame, with columns:
#' \itemize{
#'  \item lon - longitude (0 to 360)
#'  \item lat - latitude (-90 to 90)
#'  \item precip - precipitation (in mm)
#' }
#'
#' @references
#' \url{http://www.cpc.ncep.noaa.gov/products/janowiak/cmorph_description.html}
#'
#' ftp://ftp.cpc.ncep.noaa.gov/precip/global_CMORPH/
#' ftp://ftp.cpc.ncep.noaa.gov/precip/global_CMORPH/30min_8km
#' ftp://ftp.cpc.ncep.noaa.gov/precip/global_CMORPH/3-hourly_025deg
#' ftp://ftp.cpc.ncep.noaa.gov/precip/global_CMORPH/daily_025deg
#' ftp://ftp.cpc.ncep.noaa.gov/precip/global_CMORPH/3-hourly_025deg
#'
#' ftp://ftp.cpc.ncep.noaa.gov/precip/qmorph/
#' ftp://ftp.cpc.ncep.noaa.gov/precip/qmorph/30min_8km
#' ftp://ftp.cpc.ncep.noaa.gov/precip/qmorph/30min_025deg
#'
#' @details
#' 8 KM - 30 MIN:
#' Filename: CMORPH_8KM-30MIN_YYYYMMDDHH.Z
#'
#'
#'
#' @details
#' xxx
#'
#' @examples \dontrun{
#' cmorph(date = "2017-01-15")
#' cmorph(date = "2017-02-15")
#' }
cmorph <- function(date, us = FALSE, ...) {
  assert(date, c("character", "Date"))
  assert(us, 'logical')

  dates <- str_extract_all_(date, "[0-9]+")[[1]]
  assert_range(dates[1], 1979:format(Sys.Date(), "%Y"))
  assert_range(as.numeric(dates[2]), 1:12)
  assert_range(as.numeric(dates[3]), 1:31)

  path <- cpc_get(year = dates[1], month = dates[2], day = dates[3],
                  us = us, ...)
  cpc_read(path, us)
}

cpc_get <- function(year, month, day, us, cache = TRUE, overwrite = FALSE, ...) {
  cmorph_cache$mkdir()
  key <- cpc_key(year, month, day, us)
  file <- file.path(cmorph_cache$cache_path_get(), basename(key))
  if (!file.exists(file)) {
    suppressMessages(cpc_GET_write(sub("/$", "", key), file, overwrite, ...))
  }
  return(file)
}

cpc_GET_write <- function(url, path, overwrite = TRUE, ...) {
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

cpc_base_ftp <- function(x) {
  base <- "ftp://ftp.cpc.ncep.noaa.gov/precip/CPC_UNI_PRCP"
  if (x) file.path(base, "GAUGE_CONUS") else file.path(base, "GAUGE_GLB")
}

cpc_base_file <- function(x) {
  base <- "PRCP_CU_GAUGE_V1.0%sdeg.lnx."
  if (x) sprintf(base, "CONUS_0.25") else sprintf(base, "GLB_0.50")
}

cpc_key <- function(year, month, day, us) {
  sprintf("%s/%s/%s/%s%s%s",
          cpc_base_ftp(us),
          if (year < 2006) "V1.0" else "RT",
          year,
          cpc_base_file(us),
          paste0(year, month, day),
          if (year < 2006) ".gz" else ".RT")
}

cpc_read <- function(x, us) {
  conn <- file(x, "rb")
  on.exit(close(conn))

  bites <- 1649 * 4948
  lats <- seq(from = -60.036385377, to = 59.963614, by = 0.072771377)
  longs <- seq(from = 0.036378335, to = 360, by = 0.072756669)

  # read data
  conn <- file(x, "rb")
  tmp <- readBin(conn, what = "double", n = bites, size = 4, endian = "little")
  tmp <- tmp * 0.2
  #tmp <- tmp[seq_len(bites/2)] * 0.1

  # make data.frame
  tibble::as_data_frame(
    stats::setNames(
      cbind(expand.grid(longs, lats), tmp),
      c('lon', 'lat', 'precip')
    )
  )
}
