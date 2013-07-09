#' Make map to visualize NOAA climate data.
#'
#' @import ggplot2
#' @param input Input noaa object.
#' @return Plot of climate data.
#' @examples \dontrun{
#' # Search for data first, then plot
#' out <- noaa_data(dataset='NORMAL_DLY', station='GHCND:USW00014895', datatype='dly-tmax-normal', year=2010, month=4)
#' noaa_plot(out)
#' }
#' @export
noaa_plot <- function(input = NULL) UseMethod("noaa_plot")

#' @S3method noaa_plot noaa
#' @export
#' @keywords internal
noaa_plot.noaa <- function(input = NULL)
{
  if(!is.noaa(input))
    stop("Input is not of class noaa")
  input <- data.frame(date=input$date, dataType=input$dataType, station=input$station, value=input$value)
  
  ggplot(input, aes(date, value)) +
    theme_bw(base_size=18) + 
    geom_line(size=2) +
    scale_x_datetime(breaks = date_breaks("5 days"), labels = date_format('%d')) +
    labs(y=as.character(input[1,'dataType']), x="") +
    noaa_theme()
}