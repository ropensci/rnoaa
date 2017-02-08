#' Precipitation data from NOAA Climate Prediction Center
#'
#' @export
#' @param date (date/character) date in YYYY-MM-DD format
#' @param us (logical) us data only? default: \code{FALSE}
#' @param ... curl options passed on to \code{\link[crul]{HttpClient}}
#' @return a data.frame, with columns:
#' \itemize{
#'  \item lon - longitude
#'  \item lat - latitude
#'  \item precip - precipitation (in mm)
#' }
#' note that longitude is in 0 to 360 range
#' @references \url{http://www.cpc.ncep.noaa.gov/}
#' ftp://ftp.cpc.ncep.noaa.gov/precip/CPC_UNI_PRCP
#' @details
#' Rainfall data for the world (1979-present), at resolution 50 km, and
#' the US (1948-present, resolution 25 km).
#' @examples
#' cpc_prcp(date = "2017-01-15")
#' cpc_prcp(date = "2015-06-05")
#' cpc_prcp(date = "2017-01-15")
#'
#' cpc_prcp(date = "2005-07-09")
#'
#' cpc_prcp(date = "2005-07-09", us = TRUE)
cpc_prcp <- function(date, ...) {
  assert(date, c("character", "Date"))
  dates <- str_extract_all_(date, "[0-9]+")[[1]]
  assert_range(dates[1], 1979:format(Sys.Date(), "%Y"))
  assert_range(as.numeric(dates[2]), 1:12)
  assert_range(as.numeric(dates[3]), 1:31)

  path <- cpc_get(year = dates[1], month = dates[2], day = dates[3], ...)
  cpc_read(path)
}

cpc_get <- function(year, month, day, cache = TRUE, overwrite = FALSE, ...) {
  cpc_cache$mkdir()
  key <- cpc_key(year, month, day)
  file <- file.path(cpc_cache$cache_path_get(), basename(key))
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

cpc_base_ftp <- function() "ftp://ftp.cpc.ncep.noaa.gov/precip/CPC_UNI_PRCP/GAUGE_GLB"

cpc_key <- function(year, month, day) {
  sprintf("%s/%s/%s/%s%s%s",
          cpc_base_ftp(),
          if (year < 2006) "V1.0" else "RT",
          year,
          "PRCP_CU_GAUGE_V1.0GLB_0.50deg.lnx.",
          paste0(year, month, day),
          if (year < 2006) ".gz" else ".RT")
}

cpc_read <- function(x) {
  conn <- file(x, "rb")
  on.exit(close(conn))
  bites <- 360 * 720 * 2
  tmp <- readBin(conn, numeric(), n = bites, size = 4, endian = "little")
  tmp <- tmp[seq_len(bites/2)] * 0.1
  lats <- seq(from = 0.25, to = 89.75, by = 0.5)
  lats <- c(rev(lats * -1), lats)
  longs <- seq(from = 359.75, to = 0.25, by = -0.5)
  tibble::as_data_frame(
    stats::setNames(
      cbind(expand.grid(longs, lats), tmp),
      c('lon', 'lat', 'precip')
    )
  )
}

# ftp://ftp.cpc.ncep.noaa.gov/precip/CPC_UNI_PRCP/GAUGE_GLB/RT/2017/
# ftp://ftp.cpc.ncep.noaa.gov/precip/CPC_UNI_PRCP/GAUGE_GLB/DOCU/PRCP_CU_GAUGE_V1.0GLB_0.50deg_README.txt

# >= 2006
# ftp://ftp.cpc.ncep.noaa.gov/precip/CPC_UNI_PRCP/GAUGE_GLB/RT/
# eg.,: ftp://ftp.cpc.ncep.noaa.gov/precip/CPC_UNI_PRCP/GAUGE_GLB/RT/2017/PRCP_CU_GAUGE_V1.0GLB_0.50deg.lnx.20170121.RT

# 1979 - 2005
# ftp://ftp.cpc.ncep.noaa.gov/precip/CPC_UNI_PRCP/GAUGE_GLB/V1.0/
# eg.,: ftp://ftp.cpc.ncep.noaa.gov/precip/CPC_UNI_PRCP/GAUGE_GLB/V1.0/2000/PRCP_CU_GAUGE_V1.0GLB_0.50deg.lnx.20000512.gz
