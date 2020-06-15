#' Get Argo buoy data
#'
#' @export
#' @name argo
#' @template argo_params
#' @template argo_egs
argo_search <- function(func = NULL, of = NULL, qwmo = NULL, wmo = NULL,
  box=NULL, area = NULL, around = NULL, year = NULL, yearmin = NULL,
  yearmax = NULL, month = NULL, monthmin = NULL, monthmax = NULL, lr = NULL,
  from =NULL, to = NULL, dmode = NULL, pres_qc = NULL, temp_qc = NULL,
  psal_qc = NULL, doxy_qc = NULL, ticket = NULL, limit = 10, ...) {

  if (!is.null(box)) box <- paste0(box, collapse = ",")
  args <- noaa_compact(list(get = func, of = of, qwmo = qwmo, wmo = wmo,
      box = box, area = area, around = around, year = year, yearmin = yearmin,
      yearmax = yearmax, month = month, monthmin = monthmin,
      monthmax = monthmax, lr = lr, from = from, to = to, dmode = dmode,
      pres_qc = pres_qc, temp_qc = temp_qc,
      psal_qc = psal_qc, doxy_qc = doxy_qc, ticket = ticket, limit = limit))
  res <- argo_GET(argo_base, argo_api, args, ...)
  jsonlite::fromJSON(parse_argo(res))
}

#' @export
#' @rdname argo
argo_files <- function(wmo = NULL, cyc = NULL, ...) {
  args <- noaa_compact(list(wmo = wmo, cyc = cyc, file = ""))
  res <- argo_GET(argo_base, argo_api, args, ...)
  jsonlite::fromJSON(parse_argo(res))
}

#' @export
#' @rdname argo
argo_qwmo <- function(qwmo, limit = 10, ...) {
  args <- noaa_compact(list(qwmo = qwmo, limit = limit))
  res <- argo_GET(argo_base, argo_api, args, ...)
  jsonlite::fromJSON(parse_argo(res))
}

#' @export
#' @rdname argo
argo_plan <- function(...) {
  args <- noaa_compact(list(plan = ""))
  res <- argo_GET(argo_base, argo_api, args, ...)
  jsonlite::fromJSON(parse_argo(res))
}

#' @export
#' @rdname argo
argo_buoy_files <- function(dac, id, ...) {
  tfile <- tempfile(fileext = ".txt")
  url <- paste0(argo_ftp(), sprintf('dac/%s/%s/profiles/', dac, id))
  download.file(url, destfile = tfile, quiet = TRUE)
  res <- readLines(tfile, warn = FALSE)
  tab <- read.table(text = res, stringsAsFactors = FALSE,
    allowEscapes = TRUE, fill = TRUE)
  tab[, NCOL(tab)]
}

#' @export
#' @rdname argo
argo <- function(dac, id, cycle, dtype, ...) {
  path <- file.path(rnoaa_cache_dir(), "argo")
  path <- file.path(path, dac)
  apath <- a_local(dac, id, cycle, dtype, path)
  if (!is_isd(apath)) {
    dir.create(path, showWarnings = FALSE, recursive = TRUE)
    url <- a_remote(dac, id, cycle, dtype)
    f <- tryCatch(
      suppressWarnings(argo_GET_disk(url, apath, ...)),
      error = function(e) e
    )
    if (inherits(f, "error")) {
      unlink(apath)
      stop("download failed for\n   ", url, call. = FALSE)
    }
  }
  message(sprintf("<path> %s", apath), "\n")
  ncdf4::nc_open(apath)
}

# helpers -----------------------------------
argo_GET <- function(url, path, args = list(), ...) {
  cli <- crul::HttpClient$new(url = url, opts = list(...))
  res <- cli$get(path, query = args)
  res$raise_for_status()
  res
}

argo_GET_disk <- function(url, file, ...) {
  cli <- crul::HttpClient$new(url = url, opts = list(...))
  cli$get(disk = file)
}

parse_argo <- function(x) x$parse("UTF-8")

argo_base <- "https://www.umr-lops.fr"
argo_api <- "naarc/api/v1/"
argo_ftp <- function() "ftp://ftp.ifremer.fr/ifremer/argo/"

a_local <- function(dac, id, cycle, dtype, path) {
  file.path(path, sprintf("%s%s_%s.nc", dtype, id, cycle))
}

a_remote <- function(dac, id, cycle, dtype) {
  file.path(argo_ftp(), "dac", dac, id, "profiles",
            sprintf("%s%s_%s.nc", dtype, id, cycle))
}
