#' NOAA Extended Reconstructed Sea Surface Temperature (ERSST) data
#'
#' @export
#' @param year (numeric) A year. Must be > 1853. The max value is whatever
#' the current year is. Required
#' @param month A month, character or numeric. If single digit (e.g. 8), we
#' add a zero in front (e.g., 08). Required
#' @param overwrite (logical) To overwrite the path to store files in or not,
#' Default: `TRUE`
#' @param version (character) ERSST version. one of "v5" (default) or "v4"
#' @param ... Curl options passed on to [crul::verb-GET]
#' @return An `ncdf4` object. See \pkg{ncdf4} for parsing the output
#' @references
#' https://www.ncdc.noaa.gov/data-access/marineocean-data/extended-reconstructed-sea-surface-temperature-ersst-v5
#' @details See [ersst_cache] for managing cached files
#' 
#' `ersst()` currently defaults to use ERSST v5 - you can set v4 or v5
#' using the `version` parameter
#' 
#' If a request is unsuccesful, the file written to disk is deleted before
#' the function exits.
#' 
#' If you use this data in your research please cite rnoaa
#' (`citation("rnoaa")`), and cite NOAA ERSST (see citations at link above)
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
ersst <- function(year, month, overwrite = TRUE, version = 'v5', ...) {
  check4pkg("ncdf4")
  assert(version, "character")
  stopifnot("version must be one of: v4, v5" = version %in% c("v4", "v5"))
  ff <- ersst_local(year, month)
  dpath <- ersst_GET(make_ersst(year, month), ff, overwrite, version, ...)
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

ersst_GET <- function(dat, path, overwrite, version, ...) {
  ersst_cache$mkdir()
  if (!file.exists(path)) {
    cli <- crul::HttpClient$new(paste0(ersst_base(version), dat),
      opts = list(...))
    res <- cli$get(disk = path)
    if (!res$success()) on.exit(unlink(path))
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
