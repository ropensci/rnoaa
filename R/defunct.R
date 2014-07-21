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
#' }
#'
#' @name rnoaa-defunct
NULL
