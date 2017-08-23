#' NOAA Extended Reconstructed Sea Surface Temperature (ERSST) data
#'
#' @export
#' @param year (numeric) A year. Must be > 1853. The max value is whatever
#' the current year is. Required
#' @param month A month, character or numeric. If single digit (e.g. 8), we
#' add a zero in front (e.g., 08). Required
#' @param overwrite (logical) To overwrite the path to store files in or not,
#' Default: \code{TRUE}
#' @param ... Curl options passed on to \code{\link[httr]{GET}}. Optional
#'
#' @return An \code{ncdf4} object for now, may change output later to
#' perhaps a data.frame. See \pkg{ncdf4} for parsing the output.
#' @references
#' \url{https://www.ncdc.noaa.gov/data-access/marineocean-data/extended-reconstructed-sea-surface-temperature-ersst-v4}
#'
#' @section File storage:
#' We use \pkg{rappdirs} to store files, see
#' \code{\link[rappdirs]{user_cache_dir}} for how we determine the directory on
#' your machine to save files to, and run
#' \code{rappdirs::user_cache_dir("rnoaa/ersst")}
#' to get that directory.
#'
#' Files are quite small, so we don't worry about reading in cached data to
#' save time, as we do in some of the other functions in this package.
#' @examples \dontrun{
#' # October, 2015
#' ersst(year = 2015, month = 10)
#'
#' # May, 2015
#' ersst(year = 2015, month = 5)
#' ersst(year = 2015, month = "05")
#'
#' # February, 1890
#' ersst(year = 1890, month = 2)
#'
#' # Process data
#' library("ncdf4")
#' res <- ersst(year = 1890, month = 2)
#' ## varibles
#' names(res$var)
#' ## get a variable
#' ncdf4::ncvar_get(res, "ssta")
#' }
ersst <- function(year, month, overwrite = TRUE, ...) {
  calls <- names(sapply(match.call(), deparse))[-1]
  calls_vec <- "path" %in% calls
  if (any(calls_vec)) {
    stop("The parameter path has been removed, see docs for ?ersst",
         call. = FALSE)
  }
  check4pkg("ncdf4")
  path <- file.path(rnoaa_cache_dir(), "ersst")
  ff <- ersst_local(path, year, month)
  dpath <- ersst_GET(make_ersst(year, month), path = ff, overwrite, ...)
  ncdf4::nc_open(dpath)
}

make_ersst <- function(year, month) {
  check_year(year)
  month <- check_month(month)
  paste0(".", year, month, ".nc")
}

ersst_base <- function(ver = "v4") {
  sprintf("https://www1.ncdc.noaa.gov/pub/data/cmb/ersst/%s/netcdf/ersst.%s",
          ver, ver)
}

check_year <- function(x) {
  if (nchar(x) != 4) stop("year must be a length 4 numeric", call. = FALSE)
  if (as.numeric(x) < 1854) stop("year must be > 1853", call. = FALSE)
}

check_month <- function(x) {
  if (!nchar(x) %in% c(1, 2))
    stop("month must be a length 1 or 2 month value", call. = FALSE)
  if (as.numeric(x) < 1 || as.numeric(x) > 12)
    stop("month must be a number between 1 and 12", call. = FALSE)
  if (nchar(x) == 1) paste0("0", x) else x
}

ersst_GET <- function(dat, path, overwrite, ...) {
  dir.create(dirname(path), showWarnings = FALSE, recursive = TRUE)
  res <- GET(paste0(ersst_base(), dat),
             write_disk(path, overwrite = overwrite), ...)
  stop_for_status(res)
  res$request$output$path
}

ersst_local <- function(path, year, month) {
  file.path(path, sprintf("%s%s.nc", year, month))
}
