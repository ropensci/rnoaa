#' Check object class
#' 
#' Check if an object is of class noaa_data, noaa_datasets, 
#' noaa_datatypes, noaa_datacats, noaa_locs, noaa_locs_cats, 
#' or noaa_stations
#' 
#' @param x input
#' @export
is.noaa_data <- function(x) inherits(x, "noaa_data")

#' @rdname is.noaa_data
#' @export
is.noaa_datasets <- function(x) inherits(x, "noaa_datasets")

#' @rdname is.noaa_data
#' @export
is.noaa_datatypes <- function(x) inherits(x, "noaa_datatypes")

#' @rdname is.noaa_data
#' @export
is.noaa_datacats <- function(x) inherits(x, "noaa_datacats")

#' @rdname is.noaa_data
#' @export
is.noaa_locs <- function(x) inherits(x, "noaa_locs")

#' @rdname is.noaa_data
#' @export
is.noaa_locs_cats <- function(x) inherits(x, "noaa_locs_cats")

#' @rdname is.noaa_data
#' @export
is.noaa_stations <- function(x) inherits(x, "noaa_stations")

#' Theme for plotting NOAA data
#' @export
#' @keywords internal
noaa_theme <- function(){
  list(theme(panel.grid.major = element_blank(),
             panel.grid.minor = element_blank(),
             legend.position = c(0.7,0.6),
             legend.key = element_blank()),
       guides(col = guide_legend(nrow=1)))
}