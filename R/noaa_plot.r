#' Plot NOAA climate data.
#' 
#' This function accepts directly output from the \code{\link[rnoaa]{noaa}} function,
#' not other functions.
#'
#' @import ggplot2
#' @import lubridate
#' @importFrom scales date_breaks date_format
#' @param ... Input noaa object or objects.
#' @param breaks Regularly spaced date breaks for x-axis. See \code{\link{date_breaks}}
#' @param dateformat Date format using standard POSIX specification for labels on 
#' x-axis. See \code{\link{date_format}}
#' @return Plot of climate data.
#' @details
#' This is a simple wrapper function around some ggplot2 code. There is indeed a lot you
#' can modify in your plots, so this function just does some basic stuff. Here's the 
#' code within this function, where input is the output from a \code{\link[rnoaa]{noaa}} 
#' call - go crazy:
#' 
#' input <- input$data
#' input$date <- ymd(str_replace(as.character(input$date), "T00:00:00\\.000", ''))
#' ggplot(input, aes(date, value)) +
#'    theme_bw(base_size=18) + 
#'    geom_line(size=2) +
#'    scale_x_datetime(breaks = date_breaks("7 days"), labels = date_format('%d/%m/%y')) +
#'    labs(y=as.character(input[1,'dataType']), x="Date")
#'    
#' @examples \dontrun{
#' # Search for data first, then plot
#' out <- noaa(datasetid='GHCND', stationid='GHCND:USW00014895', datatypeid='PRCP', 
#' startdate = '2010-05-01', enddate = '2010-10-31', limit=500)
#' noaa_plot(out)
#' noaa_plot(out, breaks="14 days")
#' noaa_plot(out, breaks="1 month", dateformat="%d/%m")
#' noaa_plot(out, breaks="1 month", dateformat="%d/%m")
#' 
#' out2 <- noaa(datasetid='GHCND', stationid='GHCND:USW00014895', datatypeid='PRCP', 
#' startdate = '2010-05-01', enddate = '2010-05-03', limit=100)
#' noaa_plot(out2, breaks="6 hours", dateformat="%H")
#' 
#' # Combine many calls to noaa function
#' out1 <- noaa(datasetid='GHCND', stationid='GHCND:USW00014895', datatypeid='PRCP', 
#' startdate = '2010-03-01', enddate = '2010-05-31', limit=500)
#' out2 <- noaa(datasetid='GHCND', stationid='GHCND:USW00014895', datatypeid='PRCP', 
#' startdate = '2010-09-01', enddate = '2010-10-31', limit=500)
#' df <- noaa_combine(out1, out2)
#' noaa_plot(df)
#' ## or pass in each element separately
#' noaa_plot(out1, out2, breaks="45 days")
#' }
#' @export
noaa_plot <- function(..., breaks="7 days", dateformat='%d/%m/%y') UseMethod("noaa_plot")

#' @method noaa_plot noaa_data
#' @export
#' @rdname noaa_plot
noaa_plot.noaa_data <- function(..., breaks="7 days", dateformat='%d/%m/%y')
{
  input <- list(...)
  value = NULL
  if(!inherits(input[[1]], c('noaa_data','noaa_data_comb')))
    stop("Input is not of class noaa_data or noaa_data_comb")
  
  if(length(input) == 1){
    df <- input[[1]]$data
    df$date <- ymd(str_replace(as.character(df$date), 'T00:00:00\\.000|T00:00:00', ''))
    ggplot(df, aes(date, value)) +
      theme_bw(base_size=18) + 
      geom_line(size=2) +
      scale_x_datetime(breaks = date_breaks(breaks), labels = date_format(dateformat)) +
      labs(y=as.character(df[1,'dataType']), x="Date") +
      noaa_theme()
  } else {
    df <- do.call(rbind.fill, lapply(input, function(x) x$data))
    df$facet <- rep(paste("input", 1:length(input)), times=sapply(input, function(x) nrow(x$data)))
    df$date <- ymd(str_replace(as.character(df$date), "T00:00:00\\.000|T00:00:00", ''))
    ggplot(df, aes(date, value)) +
      theme_bw(base_size=18) + 
      geom_line(size=2) +
      scale_x_datetime(breaks = date_breaks(breaks), labels = date_format(dateformat)) +
      labs(y=as.character(df[1,'dataType']), x="Date") +
      noaa_theme() +
      facet_wrap(~ facet)
  } 
}