#' Wavewatch data
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
#' \url{http://polar.ncep.noaa.gov/waves/products.shtml}
#' hindcast archive: ftp://polar.ncep.noaa.gov/pub/history/waves/nww3
#' not sure where grib files are in this ftp though ftp://polar.ncep.noaa.gov/pub/waves/
#'
#' @details
#' xxx
#'
#' @examples \dontrun{
#' waves()
#' }
waves <- function(date, us = FALSE, ...) {
  assert(date, c("character", "Date"))
  assert(us, 'logical')
  dates <- str_extract_all_(date, "[0-9]+")[[1]]
  assert_range(dates[1], 1979:format(Sys.Date(), "%Y"))
  assert_range(as.numeric(dates[2]), 1:12)
  assert_range(as.numeric(dates[3]), 1:31)

  path <- bsw_get(year = dates[1], month = dates[2], day = dates[3],
                  us = us, ...)
  bsw_read(path, us)
}

bsw_get <- function(year, month, day, us, cache = TRUE, overwrite = FALSE, ...) {
  bsw_cache$mkdir()
  key <- bsw_key(year, month, day, us)
  file <- file.path(bsw_cache$cache_path_get(), basename(key))
  if (!file.exists(file)) {
    suppressMessages(bsw_GET_write(sub("/$", "", key), file, overwrite, ...))
  }
  return(file)
}

bsw_GET_write <- function(url, path, overwrite = TRUE, ...) {
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

bsw_base_ftp <- function(x) {
  base <- "ftp://ftp.cpc.ncep.noaa.gov/precip/bsw_UNI_PRCP"
  if (x) file.path(base, "GAUGE_CONUS") else file.path(base, "GAUGE_GLB")
}

bsw_base_file <- function(x) {
  base <- "PRCP_CU_GAUGE_V1.0%sdeg.lnx."
  if (x) sprintf(base, "CONUS_0.25") else sprintf(base, "GLB_0.50")
}

bsw_key <- function(year, month, day, us) {
  sprintf("%s/%s/%s/%s%s%s",
    bsw_base_ftp(us),
    if (year < 2006) "V1.0" else "RT",
    year,
    bsw_base_file(us),
    paste0(year, month, day),
    if (year < 2006) {
      ".gz"
    } else if (year > 2005 && year < 2009) {
      if (us && year == 2006) {
        ".gz"
      } else {
        ".RT.gz"
      }
    } else {
      ".RT"
    }
  )
}

bsw_read <- function(x, us) {
  conn <- file(x, "rb")
  on.exit(close(conn))

  if (us) {
    bites <- 120 * 300 * 2
    lats <- seq(from = 20.125, to = 49.875, by = 0.25)
    longs <- seq(from = 230.125, to = 304.875, by = 0.25)
  } else {
    bites <- 360 * 720 * 2
    lats <- seq(from = 0.25, to = 89.75, by = 0.5)
    lats <- c(rev(lats * -1), lats)
    longs <- seq(from = 0.25, to = 359.75, by = 0.5)
  }

  # read data
  tmp <- readBin(conn, numeric(), n = bites, size = 4, endian = "little")
  tmp <- tmp[seq_len(bites/2)] * 0.1

  # make data.frame
  tibble::as_data_frame(
    stats::setNames(
      cbind(expand.grid(longs, lats), tmp),
      c('lon', 'lat', 'precip')
    )
  )
}
