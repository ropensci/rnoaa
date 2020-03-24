#' NOAA Extended Reconstructed Sea Surface Temperature (ERSST) data
#'
#' @export
#' @param year (numeric) A year. Must be > 1853. The max value is whatever
#' the current year is. Required
#' @param month A month, character or numeric. If single digit (e.g. 8), we
#' add a zero in front (e.g., 08). Required
#' @param overwrite (logical) To overwrite the path to store files in or not,
#' Default: `TRUE`
#' @param ... Curl options passed on to [crul::verb-GET]
#' Optional
#'
#' @return An `ncdf4` object for now, may change output later to
#' perhaps a data.frame. See \pkg{ncdf4} for parsing the output.
#' @references
#' <https://www.ncdc.noaa.gov/data-access/marineocean-data/extended-reconstructed-sea-surface-temperature-ersst-v4>
#' @note See [ersst_cache] for managing cached files
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
  check4pkg("ncdf4")
  ff <- ersst_local(year, month)
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
  ersst_cache$mkdir()
  if (!file.exists(path)) {
    cli <- crul::HttpClient$new(paste0(ersst_base(), dat), opts = list(...))
    res <- cli$get(disk = path)
    res$raise_for_status()
    res$content
  } else {
    cache_mssg(path)
    return(path)
  }
}

ersst_local <- function(year, month) {
  file.path(ersst_cache$cache_path_get(), sprintf("%s%s.nc", year, month))
}
