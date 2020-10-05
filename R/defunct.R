#' This function is defunct.
#' @export
#' @rdname gefs-defunct
#' @keywords internal
gefs <- function(...) {
  .Defunct(msg = "`gefs` is defunct; it may return later")
}
#' This function is defunct.
#' @export
#' @rdname gefs_dimension_values-defunct
#' @keywords internal
gefs_dimension_values <- function(...) {
  .Defunct(msg = "`gefs_dimension_values` is defunct; it may return later")
}
#' This function is defunct.
#' @export
#' @rdname gefs_dimensions-defunct
#' @keywords internal
gefs_dimensions <- function(...) {
  .Defunct(msg = "`gefs_dimensions` is defunct; it may return later")
}
#' This function is defunct.
#' @export
#' @rdname gefs_ensembles-defunct
#' @keywords internal
gefs_ensembles <- function(...) {
  .Defunct(msg = "`gefs_ensembles` is defunct; it may return later")
}
#' This function is defunct.
#' @export
#' @rdname gefs_latitudes-defunct
#' @keywords internal
gefs_latitudes <- function(...) {
  .Defunct(msg = "`gefs_latitudes` is defunct; it may return later")
}
#' This function is defunct.
#' @export
#' @rdname gefs_longitudes-defunct
#' @keywords internal
gefs_longitudes <- function(...) {
  .Defunct(msg = "`gefs_longitudes` is defunct; it may return later")
}
#' This function is defunct.
#' @export
#' @rdname gefs_times-defunct
#' @keywords internal
gefs_times <- function(...) {
  .Defunct(msg = "`gefs_times` is defunct; it may return later")
}
#' This function is defunct.
#' @export
#' @rdname gefs_variables-defunct
#' @keywords internal
gefs_variables <- function(...) {
  .Defunct(msg = "`gefs_variables` is defunct; it may return later")
}

#' Defunct functions in rnoaa
#'
#' - `noaa`: Function name changed, prefixed with ncdc now
#' - `noaa_datacats`: Function name changed, prefixed with ncdc now
#' - `noaa_datasets`: Function name changed, prefixed with ncdc now
#' - `noaa_datatypes`: Function name changed, prefixed with ncdc now
#' - `noaa_locs`: Function name changed, prefixed with ncdc now
#' - `noaa_locs_cats`: Function name changed, prefixed with ncdc now
#' - `noaa_stations`: Function name changed, prefixed with ncdc now
#' - `noaa_plot`: Function name changed, prefixed with ncdc now
#' - `noaa_combine`: Function name changed, prefixed with ncdc now
#' - `noaa_seaice`: Function name changed to seaice
#' - `erddap_data`: See package rerddap
#' - `erddap_clear_cache`: See package rerddap
#' - `erddap_datasets`: Moved to package rerddap
#' - `erddap_grid`: Moved to package rerddap
#' - `erddap_info`: Moved to `rerddap::info()`
#' - `erddap_search`: Moved to `rerddap::ed_search`
#' - `erddap_table`: Moved to `rerddap::tabledap`
#' - `ncdc_leg_variables`: Removed. See `NCDC Legacy` below
#' - `ncdc_leg_sites`: Removed. See `NCDC Legacy` below
#' - `ncdc_leg_site_info`: Removed. See `NCDC Legacy` below
#' - `ncdc_leg_data`: Removed. See `NCDC Legacy` below
#' - `seaice`: Replaced with [sea_ice()]
#' - `lcd_cleanup`: No longer available. See `lcd` docs
#' - `ghcnd_clear_cache`: No longer available. See [rnoaa_caching]
#' - `storm_shp`: Function defunct.
#' - `storm_shp_read`: Function defunct.
#' - `storm_data`: Function defunct.
#' - `storm_meta`: Function defunct.
#'
#' The functions for working with GEFS ensemble forecast data (prefixed with
#' "gefs") are defunct, but may come back to rnoaa later:
#'
#' - [gefs()]
#' - [gefs_dimension_values()]
#' - [gefs_dimensions()]
#' - [gefs_ensembles()]
#' - [gefs_latitudes()]
#' - [gefs_longitudes()]
#' - [gefs_times()]
#' - [gefs_variables()]
#'
#' @section NCDC Legacy:
#' The NCDC legacy API is too unreliable and slow. Use the newer NCDC API via
#' the functions [ncdc()], [ncdc_datacats()], [ncdc_datasets()],
#' [ncdc_datatypes()], [ncdc_locs()], [ncdc_locs_cats()], [ncdc_stations()],
#' [ncdc_plot()], and [ncdc_combine()]
#'
#' @name rnoaa-defunct
NULL
