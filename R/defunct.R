#' This function is defunct.
#' @export
#' @rdname noaa-defunct
#' @keywords internal
noaa <- function(...){
  .Defunct(new = "ncdc", package = "rnoaa", msg = "the noaa() function name has been changed to ncdc()")
}

#' This function is defunct.
#' @export
#' @rdname noaa_datacats-defunct
#' @keywords internal
noaa_datacats <- function(...){
  .Defunct(new = "ncdc_datacats", package = "rnoaa", msg = "the noaa_datacats() function name has been changed to ncdc_datacats()")
}

#' This function is defunct.
#' @export
#' @rdname noaa_datasets-defunct
#' @keywords internal
noaa_datasets <- function(...){
  .Defunct(new = "ncdc_datasets", package = "rnoaa", msg = "the noaa_datasets() function name has been changed to ncdc_datasets()")
}

#' This function is defunct.
#' @export
#' @rdname noaa_datatypes-defunct
#' @keywords internal
noaa_datatypes <- function(...){
  .Defunct(new = "ncdc_datatypes", package = "rnoaa", msg = "the noaa_datatypes() function name has been changed to ncdc_datatypes()")
}

#' This function is defunct.
#' @export
#' @rdname noaa_locs-defunct
#' @keywords internal
noaa_locs <- function(...){
  .Defunct(new = "ncdc_locs", package = "rnoaa", msg = "the noaa_locs() function name has been changed to ncdc_locs()")
}

#' This function is defunct.
#' @export
#' @rdname noaa_locs_cats-defunct
#' @keywords internal
noaa_locs_cats <- function(...){
  .Defunct(new = "ncdc_locs_cats", package = "rnoaa", msg = "the noaa_locs_cats() function name has been changed to ncdc_locs_cats()")
}

#' This function is defunct.
#' @export
#' @rdname noaa_stations-defunct
#' @keywords internal
noaa_stations <- function(...){
  .Defunct(new = "ncdc_stations", package = "rnoaa", msg = "the noaa_stations() function name has been changed to ncdc_stations()")
}

#' This function is defunct.
#' @export
#' @rdname noaa_plot-defunct
#' @keywords internal
noaa_plot <- function(...){
  .Defunct(new = "ncdc_plot", package = "rnoaa", msg = "the noaa_plot() function name has been changed to ncdc_plot()")
}

#' This function is defunct.
#' @export
#' @rdname noaa_combine-defunct
#' @keywords internal
noaa_combine <- function(...){
  .Defunct(new = "ncdc_combine", package = "rnoaa", msg = "the noaa_combine() function name has been changed to ncdc_combine()")
}

#' This function is defunct.
#' @export
#' @rdname noaa_seaice-defunct
#' @keywords internal
noaa_seaice <- function(...){
  .Defunct(new = "seaice", package = "rnoaa", msg = "the noaa_seaice() function name has been changed to seaice()")
}

#' This function is defunct.
#' @export
#' @rdname erddap_data-defunct
#' @keywords internal
erddap_data <- function(){
  .Defunct(msg = "See functions erddap_grid and erddap_table for griddap and tabledap data, respectively")
}

#' This function is defunct.
#' @export
#' @rdname erddap_clear_cache-defunct
#' @keywords internal
erddap_clear_cache <- function(){
  .Defunct(msg = "See package rerddap")
}

#' This function is defunct.
#' @export
#' @rdname erddap_datasets-defunct
#' @keywords internal
erddap_datasets <- function(){
  .Defunct(new = "ed_datasets", msg = "See ed_datasets() in package rerddap")
}

#' This function is defunct.
#' @export
#' @rdname erddap_grid-defunct
#' @keywords internal
erddap_grid <- function(){
  .Defunct(new = "griddap", msg = "See griddap() in package rerddap")
}

#' This function is defunct.
#' @export
#' @rdname erddap_info-defunct
#' @keywords internal
erddap_info <- function(){
  .Defunct(new = "info", msg = "See info() in package rerddap")
}

#' This function is defunct.
#' @export
#' @rdname erddap_search-defunct
#' @keywords internal
erddap_search <- function(){
  .Defunct(new = "ed_search", msg = "See ed_search() in package rerddap")
}

#' This function is defunct.
#' @export
#' @rdname erddap_table-defunct
#' @keywords internal
erddap_table <- function(){
  .Defunct(new = "tabledap", msg = "See tabledap() in package rerddap")
}


#' This function is defunct.
#' @export
#' @rdname ncdc_leg_variables-defunct
#' @keywords internal
ncdc_leg_variables <- function(){
  .Defunct(msg = "This function is defunct, see ncdc_*() functions")
}

#' This function is defunct.
#' @export
#' @rdname ncdc_leg_sites-defunct
#' @keywords internal
ncdc_leg_sites <- function() {
  .Defunct(msg = "This function is defunct, see ncdc_*() functions")
}

#' This function is defunct.
#' @export
#' @rdname ncdc_leg_site_info-defunct
#' @keywords internal
ncdc_leg_site_info <- function() {
  .Defunct(msg = "This function is defunct, see ncdc_*() functions")
}

#' This function is defunct.
#' @export
#' @rdname ncdc_leg_data-defunct
#' @keywords internal
ncdc_leg_data <- function() {
  .Defunct(msg = "This function is defunct, see ncdc_*() functions")
}

#' This function is defunct.
#' @export
#' @rdname seaice-defunct
#' @keywords internal
seaice <- function() {
  .Defunct(msg = "This function is defunct, see sea_ice()")
}

#' This function is defunct.
#' @export
#' @rdname lcd_cleanup-defunct
#' @keywords internal
lcd_cleanup <- function(...) {
  .Defunct(msg = "`lcd_cleanup` no longer available, see ?lcd")
}

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
#' \itemize{
#'  \item \code{\link{noaa}}: Function name changed, prefixed with ncdc now
#'  \item \code{\link{noaa_datacats}}: Function name changed, prefixed with ncdc now
#'  \item \code{\link{noaa_datasets}}: Function name changed, prefixed with ncdc now
#'  \item \code{\link{noaa_datatypes}}: Function name changed, prefixed with ncdc now
#'  \item \code{\link{noaa_locs}}: Function name changed, prefixed with ncdc now
#'  \item \code{\link{noaa_locs_cats}}: Function name changed, prefixed with ncdc now
#'  \item \code{\link{noaa_stations}}: Function name changed, prefixed with ncdc now
#'  \item \code{\link{noaa_plot}}: Function name changed, prefixed with ncdc now
#'  \item \code{\link{noaa_combine}}: Function name changed, prefixed with ncdc now
#'  \item \code{\link{noaa_seaice}}: Function name changed to seaice
#'  \item \code{\link{erddap_data}}: See package rerddap
#'  \item \code{\link{erddap_clear_cache}}: See package rerddap
#'  \item \code{\link{erddap_datasets}}: Moved to \code{ed_datasets} in
#'  package rerddap
#'  \item \code{\link{erddap_grid}}: Moved to \code{griddap} in package
#'  rerddap
#'  \item \code{\link{erddap_info}}: Moved to \code{info} in package
#'  rerddap
#'  \item \code{\link{erddap_search}}: Moved to \code{ed_search} in
#'  package rerddap
#'  \item \code{\link{erddap_table}}: Moved to \code{tabledap} in
#'  package rerddap
#'  \item \code{\link{ncdc_leg_variables}}: Removed. See \code{NCDC Legacy} below
#'  \item \code{\link{ncdc_leg_sites}}: Removed. See \code{NCDC Legacy} below
#'  \item \code{\link{ncdc_leg_site_info}}: Removed. See \code{NCDC Legacy} below
#'  \item \code{\link{ncdc_leg_data}}: Removed. See \code{NCDC Legacy} below
#'  \item \code{\link{seaice}}: Replaced with \code{\link{sea_ice}}
#'  \item \code{\link{lcd_cleanup}}: No longer available. See \code{\link{lcd}}
#'  docs
#' }
#' 
#' The functions for working with GEFS ensemble forecast data (prefixed with
#' "gefs") are defunct, but may come back to rnoaa later. They are:
#' 
#' \itemize{
#'  \item \code{\link{gefs}}
#'  \item \code{\link{gefs_dimension_values}}
#'  \item \code{\link{gefs_dimensions}}
#'  \item \code{\link{gefs_ensembles}}
#'  \item \code{\link{gefs_latitudes}}
#'  \item \code{\link{gefs_longitudes}}
#'  \item \code{\link{gefs_times}}
#'  \item \code{\link{gefs_variables}}
#' }
#' 
#' 
#' @section NCDC Legacy:
#' The NCDC legacy API is too unreliable and slow. Use the newer NCDC API via the 
#' functions \code{\link{ncdc}}, \code{\link{ncdc_datacats}}, \code{\link{ncdc_datasets}},
#' \code{\link{ncdc_datatypes}}, \code{\link{ncdc_locs}}, \code{\link{ncdc_locs_cats}},
#' \code{\link{ncdc_stations}}, \code{\link{ncdc_plot}}, and \code{\link{ncdc_combine}}
#'
#' @name rnoaa-defunct
NULL
