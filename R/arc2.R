#' Arc2 - Africa Rainfall Climatology version 2
#'
#' @export
#' @param date a date of form YYYY-MM-DD
#' @param ... curl options passed on to \code{\link[crul]{HttpClient}}
#' @references docs:
#' \url{ftp://ftp.cpc.ncep.noaa.gov/fews/fewsdata/africa/arc2/ARC2_readme.txt}
#' @return a tibble/data.frame with columns:
#' \itemize{
#'  \item lon - longitude
#'  \item lat - latitude
#'  \item precip - precipitation
#' }
#' @examples \dontrun{
#' arc2(date = "1983-01-01")
#' arc2(date = "2017-02-14")
#' }
arc2 <- function(date, ...) {
  assert(date, c("character", "Date"))

  dates <- str_extract_all_(date, "[0-9]+")[[1]]
  assert_range(dates[1], 1979:format(Sys.Date(), "%Y"))
  assert_range(as.numeric(dates[2]), 1:12)
  assert_range(as.numeric(dates[3]), 1:31)

  path <- arc2_get(year = dates[1], month = dates[2], day = dates[3], ...)
  arc2_read(path)
}

arc2_get <- function(year, month, day, cache = TRUE, overwrite = FALSE, ...) {
  arc2_cache$mkdir()
  date <- paste(year, month, day, sep = "-")
  key <- file.path(arc2_base_ftp(arc2_base(), date))
  file <- file.path(arc2_cache$cache_path_get(), basename(key))
  if (!file.exists(file)) {
    suppressMessages(arc2_GET_write(sub("/$", "", key), file, overwrite, ...))
  }
  return(file)
}

arc2_GET_write <- function(url, path, overwrite = TRUE, ...) {
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

arc2_base <- function() {
  "ftp://ftp.cpc.ncep.noaa.gov/fews/fewsdata/africa/arc2/bin"
}

arc2_base_ftp <- function(x, y) sprintf("%s/daily_clim.bin.%s.gz", x,
                                        gsub("-", "", y))

arc2_read <- function(x) {
  conn <- conn <- gzcon(file(x, open = "rb"))
  on.exit(close(conn))

  # lats/longs
  lats <- seq(from = -40, to = 40, by = 0.1)
  longs <- seq(from = -20, to = 55, by = 0.1)

  # read data
  res <- readBin(conn, numeric(), n = 751*801, size = 4, endian = "big")

  # make data.frame
  tibble::as_data_frame(
    stats::setNames(
      cbind(expand.grid(longs, lats), res),
      c('lon', 'lat', 'precip')
    )
  )
}
