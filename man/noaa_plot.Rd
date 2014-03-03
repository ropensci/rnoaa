\name{noaa_plot}
\alias{noaa_plot}
\alias{noaa_plot.noaa_data}
\title{Plot NOAA climate data.}
\usage{
noaa_plot(..., breaks = "7 days", dateformat = "\%d/\%m/\%y")

\method{noaa_plot}{noaa_data}(..., breaks = "7 days",
  dateformat = "\%d/\%m/\%y")
}
\arguments{
  \item{...}{Input noaa object or objects.}

  \item{breaks}{Regularly spaced date breaks for x-axis.
  See \code{\link{date_breaks}}}

  \item{dateformat}{Date format using standard POSIX
  specification for labels on x-axis. See
  \code{\link{date_format}}}
}
\value{
Plot of climate data.
}
\description{
This function accepts directly output from the
\code{\link[rnoaa]{noaa}} function, not other functions.
}
\details{
This is a simple wrapper function around some ggplot2 code.
There is indeed a lot you can modify in your plots, so this
function just does some basic stuff. Here's the code within
this function, where input is the output from a
\code{\link[rnoaa]{noaa}} call - go crazy:

input <- input$data input$date <-
ymd(str_replace(as.character(input$date),
"T00:00:00\\.000", '')) ggplot(input, aes(date, value)) +
theme_bw(base_size=18) + geom_line(size=2) +
scale_x_datetime(breaks = date_breaks("7 days"), labels =
date_format('%d/%m/%y')) +
labs(y=as.character(input[1,'dataType']), x="Date")
}
\examples{
\dontrun{
# Search for data first, then plot
out <- noaa(datasetid='GHCND', stationid='GHCND:USW00014895', datatypeid='PRCP',
startdate = '2010-05-01', enddate = '2010-10-31', limit=500)
noaa_plot(out)
noaa_plot(out, breaks="14 days")
noaa_plot(out, breaks="1 month", dateformat="\%d/\%m")
noaa_plot(out, breaks="1 month", dateformat="\%d/\%m")

out2 <- noaa(datasetid='GHCND', stationid='GHCND:USW00014895', datatypeid='PRCP',
startdate = '2010-05-01', enddate = '2010-05-03', limit=100)
noaa_plot(out2, breaks="6 hours", dateformat="\%H")

# Combine many calls to noaa function
out1 <- noaa(datasetid='GHCND', stationid='GHCND:USW00014895', datatypeid='PRCP',
startdate = '2010-03-01', enddate = '2010-05-31', limit=500)
out2 <- noaa(datasetid='GHCND', stationid='GHCND:USW00014895', datatypeid='PRCP',
startdate = '2010-09-01', enddate = '2010-10-31', limit=500)
df <- noaa_combine(out1, out2)
noaa_plot(df)
## or pass in each element separately
noaa_plot(out1, out2, breaks="45 days")
}
}

