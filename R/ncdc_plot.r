#' Plot NOAA climate data.
#'
#' This function accepts directly output from the \code{\link[rnoaa]{ncdc}} function,
#' not other functions.
#'
#' @export
#' @import ggplot2
#' @importFrom lubridate ymd
#' @importFrom scales date_breaks date_format
#'
#' @param ... Input noaa object or objects.
#' @param breaks Regularly spaced date breaks for x-axis. See \code{\link{date_breaks}}
#' @param dateformat Date format using standard POSIX specification for labels on
#' x-axis. See \code{\link{date_format}}
#' @return Plot of climate data.
#' @details
#' This is a simple wrapper function around some ggplot2 code. There is indeed a lot you
#' can modify in your plots, so this function just does some basic stuff. Here's the
#' code within this function, where input is the output from a \code{\link[rnoaa]{ncdc}}
#' call - go crazy:
#'
#' input <- input$data
#' input$date <- ymd(sub("T00:00:00\\.000", '', as.character(input$date)))
#' ggplot(input, aes(date, value)) +
#'    theme_bw(base_size=18) +
#'    geom_line(size=2) +
#'    scale_x_datetime(breaks = date_breaks("7 days"), labels = date_format('%d/%m/%y')) +
#'    labs(y=as.character(input[1,'dataType']), x="Date")
#'
#' @examples \dontrun{
#' # Search for data first, then plot
#' out <- ncdc(datasetid='GHCND', stationid='GHCND:USW00014895', datatypeid='PRCP',
#'    startdate = '2010-05-01', enddate = '2010-10-31', limit=500)
#' ncdc_plot(out)
#' ncdc_plot(out, breaks="14 days")
#' ncdc_plot(out, breaks="1 month", dateformat="%d/%m")
#' ncdc_plot(out, breaks="1 month", dateformat="%d/%m")
#'
#' out2 <- ncdc(datasetid='GHCND', stationid='GHCND:USW00014895', datatypeid='PRCP',
#' startdate = '2010-05-01', enddate = '2010-05-03', limit=100)
#' ncdc_plot(out2, breaks="6 hours", dateformat="%H")
#'
#' # Combine many calls to ncdc function
#' out1 <- ncdc(datasetid='GHCND', stationid='GHCND:USW00014895', datatypeid='PRCP',
#' startdate = '2010-03-01', enddate = '2010-05-31', limit=500)
#' out2 <- ncdc(datasetid='GHCND', stationid='GHCND:USW00014895', datatypeid='PRCP',
#' startdate = '2010-09-01', enddate = '2010-10-31', limit=500)
#' df <- ncdc_combine(out1, out2)
#' ncdc_plot(df)
#' ## or pass in each element separately
#' ncdc_plot(out1, out2, breaks="45 days")
#' }
ncdc_plot <- function(..., breaks="7 days", dateformat='%d/%m/%y') UseMethod("ncdc_plot")

#' @method ncdc_plot ncdc_data
#' @export
#' @rdname ncdc_plot
ncdc_plot.ncdc_data <- function(..., breaks="7 days", dateformat='%d/%m/%y')
{
  input <- list(...)
  value = NULL
  if(!inherits(input[[1]], c('ncdc_data','ncdc_data_comb')))
    stop("Input is not of class ncdc_data or ncdc_data_comb")

  if(length(input) == 1){
    df <- input[[1]]$data
    df$date <- ymd(sub('T00:00:00\\.000|T00:00:00', '', as.character(df$date)))
    ggplot(df, aes(date, value)) +
      theme_bw(base_size=18) +
      geom_line(size=2) +
      scale_x_datetime(breaks = date_breaks(breaks), labels = date_format(dateformat)) +
      labs(y=as.character(df[1,'dataType']), x="Date") +
      ncdc_theme()
  } else {
    df <- dplyr::bind_rows(lapply(input, function(x) x$data))
    df$facet <- rep(paste("input", 1:length(input)), times=sapply(input, function(x) nrow(x$data)))
    df$date <- ymd(sub("T00:00:00\\.000|T00:00:00", '', as.character(df$date)))
    ggplot(df, aes(date, value)) +
      theme_bw(base_size=18) +
      geom_line(size=2) +
      scale_x_datetime(breaks = date_breaks(breaks), labels = date_format(dateformat)) +
      labs(y=as.character(df[1,'dataType']), x="Date") +
      ncdc_theme() +
      facet_wrap(~ facet, scales="free")
  }
}
