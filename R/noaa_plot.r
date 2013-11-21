#' Make map to visualize NOAA climate data.
#' 
#' This function accepts directly output from the \code{\link{noaa}} function, but
#' not other functions.
#'
#' @import ggplot2
#' @importFrom scales date_breaks date_format
#' @param input Input noaa object.
#' @return Plot of climate data.
#' @examples \dontrun{
#' # Search for data first, then plot
#' out <- noaa(datasetid='NORMAL_DLY', stationid='GHCND:USW00014895', datatypeid='dly-tmax-normal', startdate = '2010-05-01', enddate = '2010-05-31')
#' noaa_plot(out)
#' }
#' @export
noaa_plot <- function(input = NULL) UseMethod("noaa_plot")

#' @method noaa_plot noaa_data
#' @export
#' @rdname noaa_plot
noaa_plot.noaa_data <- function(input = NULL)
{
  value = NULL
  if(!is.noaa_data(input))
    stop("Input is not of class noaa_data")
  
  input <- input$data
  input$date <- ymd(str_replace(as.character(input$date), "T00:00:00\\.000", ''))
    
  ggplot(input, aes(date, value)) +
    theme_bw(base_size=18) + 
    geom_line(size=2) +
    scale_x_datetime(breaks = date_breaks("7 days"), labels = date_format('%d/%m/%y')) +
    labs(y=as.character(input[1,'dataType']), x="Date") +
    noaa_theme()
}