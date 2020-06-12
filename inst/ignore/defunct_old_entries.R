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
#' @rdname ghcnd_clear_cache-defunct
#' @keywords internal
ghcnd_clear_cache <- function(...) {
  .Defunct(msg = "`ghcnd_clear_cache` is defunct; see ?rnoaa_caching")
}
