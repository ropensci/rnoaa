#' Arc2 - Africa Rainfall Climatology version 2
#'
#' @export
#' @param date (character/date) one or more dates of the form YYYY-MM-DD
#' @param ... curl options passed on to [crul::verb-GET]
#' @references docs:
#' <ftp://ftp.cpc.ncep.noaa.gov/fews/fewsdata/africa/arc2/ARC2_readme.txt>
#' @note See [arc2_cache] for managing cached files
#' @return a tibble/data.frame with columns:
#'
#' - date: date (YYYY-MM-DD)
#' - lon: longitude
#' - lat: latitude
#' - precip: precipitation (mm)
#'
#' @examples \dontrun{
#' x = arc2(date = "1983-01-01")
#' arc2(date = "2017-02-14")
#' 
#' # many dates
#' arc2(date = c("2019-05-27", "2019-05-28"))
#' arc2(seq(as.Date("2019-04-21"), by = "day", length.out = 5))
#' ## combine outputs 
#' x <- arc2(seq(as.Date("2019-05-20"), as.Date("2019-05-25"), "days"))
#' dplyr::bind_rows(x)
#' }
arc2 <- function(date, ...) {
  assert(date, c("character", "Date"))
  dates <- str_extract_all_(date, "[0-9]+")
  invisible(lapply(dates, arc2_lint_date))
  lapply(dates, function(w) {
    path <- arc2_get(year = w[1], month = w[2], day = w[3], ...)
    arc2_read(path, w)
  })
}

arc2_lint_date <- function(x) {
  assert_range(x[1], 1979:format(Sys.Date(), "%Y"))
  assert_range(as.numeric(x[2]), 1:12)
  assert_range(as.numeric(x[3]), 1:31)
}

todate <- function(year, month, day) paste(year, month, day, sep = "-")

arc2_get <- function(year, month, day, cache = TRUE, overwrite = FALSE, ...) {
  arc2_cache$mkdir()
  date <- paste(year, month, day, sep = "-")
  key <- file.path(arc2_base_ftp(arc2_base(), date))
  file <- file.path(arc2_cache$cache_path_get(), basename(key))
  date <- todate(year, month, day)
  if (!file.exists(file)) {
    res <- suppressMessages(
      arc2_GET_write(sub("/$", "", key), file, date, overwrite, ...))
    file <- res$content
  } else {
    cache_mssg(file)
  }
  return(file)
}

arc2_GET_write <- function(url, path, date, overwrite = TRUE, ...) {
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
    warning(res$message, ": ", date, call. = FALSE)
  }
  return(res)
}

arc2_base <- function() {
  "ftp://ftp.cpc.ncep.noaa.gov/fews/fewsdata/africa/arc2/bin"
}

arc2_base_ftp <- function(x, y) sprintf("%s/daily_clim.bin.%s.gz", x,
                                        gsub("-", "", y))

arc2_read <- function(x, w) {
  if (is.null(x)) return(tibble::tibble())
  date <- todate(w[1], w[2], w[3])
  conn <- gzcon(file(x, open = "rb"))
  on.exit(close(conn))

  # lats/longs
  lats <- seq(from = -40, to = 40, by = 0.1)
  longs <- seq(from = -20, to = 55, by = 0.1)

  # read data
  res <- readBin(conn, numeric(), n = 751*801, size = 4, endian = "big")

  # make data.frame
  df <- tibble::as_tibble(
    stats::setNames(
      cbind(expand.grid(longs, lats), res),
      c('lon', 'lat', 'precip')
    )
  )
  tibble::tibble(date = date, df)
}
