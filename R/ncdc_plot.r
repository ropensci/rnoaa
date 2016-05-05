#' Plot NOAA climate data.
#'
#' @export
#' @param ... Input noaa object or objects.
#' @param breaks Regularly spaced date breaks for x-axis. See examples for usage.
#' See \code{\link{date_breaks}}. Default: \code{NULL} (uses ggplot2 default break
#' sformatting)
#' @param dateformat Date format using standard POSIX specification for labels on
#' x-axis. See \code{\link{date_format}}
#' @return ggplot2 plot
#' @details
#' This function accepts directly output from the \code{\link[rnoaa]{ncdc}} function,
#' not other functions.
#'
#' This is a simple wrapper function around some ggplot2 code. There is indeed a lot you
#' can modify in your plots, so this function just does some basic stuff. Look at the internals
#' for what the function does.
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
#' # Combine many calls to ncdc function
#' out1 <- ncdc(datasetid='GHCND', stationid='GHCND:USW00014895', datatypeid='PRCP',
#'    startdate = '2010-03-01', enddate = '2010-05-31', limit=500)
#' out2 <- ncdc(datasetid='GHCND', stationid='GHCND:USW00014895', datatypeid='PRCP',
#'    startdate = '2010-09-01', enddate = '2010-10-31', limit=500)
#' df <- ncdc_combine(out1, out2)
#' ncdc_plot(df)
#' ## or pass in each element separately
#' ncdc_plot(out1, out2, breaks="45 days")
#' }
ncdc_plot <- function(...,  breaks = NULL, dateformat='%d/%m/%y') {
  UseMethod("ncdc_plot")
}

#' @export
ncdc_plot.ncdc_data <- function(..., breaks = NULL, dateformat='%d/%m/%y') {
  input <- list(...)
  value = NULL
  if (!inherits(input[[1]], c('ncdc_data','ncdc_data_comb'))) {
    stop("Input is not of class ncdc_data or ncdc_data_comb", call. = FALSE)
  }

  if (length(input) == 1) {
    df <- input[[1]]$data
    df$date <- ymd(sub('T00:00:00\\.000|T00:00:00', '', as.character(df$date)))
    ggplot(df, aes(date, value)) +
      plot_template(df, breaks, dateformat) +
      ncdc_theme()
  } else {
    df <- dplyr::bind_rows(lapply(input, function(x) x$data))
    df$facet <- rep(paste("input", 1:length(input)), times = sapply(input, function(x) nrow(x$data)))
    df$date <- ymd(sub("T00:00:00\\.000|T00:00:00", '', as.character(df$date)))
    ggplot(df, aes(date, value)) +
      plot_template(df, breaks, dateformat) +
      ncdc_theme() +
      facet_wrap(~facet, scales = "free")
  }
}

#' @export
ncdc_plot.default <- function(...,  breaks = NULL, dateformat='%d/%m/%y') {
  stop("No method for ", class(list(...)[[1]]), call. = FALSE)
}

plot_template <- function(df, breaks, dateformat) {
  tt <- list(
    theme_bw(base_size = 18),
    geom_line(size = 2),
    labs(y = as.character(df[1, 'datatype']), x = "Date")
  )
  if (!is.null(breaks)) {
    c(tt, scale_x_date(date_breaks = breaks, date_labels = dateformat))

  } else {
    tt
  }
}
