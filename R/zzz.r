#' Check if object is of class noaa
#' @param x input
#' @export
is.noaa <- function(x) inherits(x, "noaa")

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