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
  res <- argo_GET(url = argo_api(), args, ...)
  jsonlite::fromJSON(utcf8(res))
}

#' @export
#' @rdname argo
argo_files <- function(wmo = NULL, cyc = NULL, ...) {
  args <- noaa_compact(list(wmo = wmo, cyc = cyc, file = ""))
  res <- argo_GET(argo_api(), args, ...)
  jsonlite::fromJSON(utcf8(res))
}

#' @export
#' @rdname argo
argo_qwmo <- function(qwmo, limit = 10, ...) {
  args <- noaa_compact(list(qwmo = qwmo, limit = limit))
  res <- argo_GET(argo_api(), args, ...)
  jsonlite::fromJSON(utcf8(res))
}

#' @export
#' @rdname argo
argo_plan <- function(...) {
  args <- noaa_compact(list(plan = ""))
  res <- argo_GET(argo_api(), args, ...)
  jsonlite::fromJSON(utcf8(res))
}

#' @export
#' @rdname argo
argo_buoy_files <- function(dac, id, ...) {
  tfile <- tempfile(fileext = ".txt")
  url <- paste0(argo_ftp(), sprintf('dac/%s/%s/profiles/', dac, id))
  download.file(url, destfile = tfile, quiet = TRUE)
  res <- readLines(tfile, warn = FALSE)
  tab <- read.table(text = res, stringsAsFactors = FALSE)
  tab[,NCOL(tab)]
}

#' @export
#' @rdname argo
argo <- function(dac, id, cycle, dtype, overwrite = TRUE, ...) {
  calls <- names(sapply(match.call(), deparse))[-1]
  calls_vec <- "path" %in% calls
  if (any(calls_vec)) {
    stop("The parameter path has been removed, see docs for ?argo",
         call. = FALSE)
  }

  path <- file.path(rnoaa_cache_dir(), "argo")
  path <- file.path(path, dac)
  apath <- a_local(dac, id, cycle, dtype, path)
  if (!is_isd(apath)) {
    dir.create(path, showWarnings = FALSE, recursive = TRUE)
    suppressWarnings(argo_GET(a_remote(dac, id, cycle, dtype), list(),
                              write_disk(apath, overwrite), ...))
  }
  message(sprintf("<path> %s", apath), "\n")
  ncdf4::nc_open(apath)
}

# helpers -----------------------------------
argo_GET <- function(url, args = list(), ...) {
  res <- GET(url, query = args, ...)
  stop_for_status(res)
  res
}

argo_base <- function() "http://www.ifremer.fr/"
argo_api <- function() paste0(argo_base(), "lpo/naarc/api/v1/")
argo_ftp <- function() "ftp://ftp.ifremer.fr/ifremer/argo/"

a_local <- function(dac, id, cycle, dtype, path) {
  file.path(path, sprintf("%s%s_%s.nc", dtype, id, cycle))
}

a_remote <- function(dac, id, cycle, dtype) {
  file.path(argo_ftp(), "dac", dac, id, "profiles",
            sprintf("%s%s_%s.nc", dtype, id, cycle))
}
