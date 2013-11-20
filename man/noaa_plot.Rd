\name{noaa_plot}
\alias{noaa_plot}
\title{Make map to visualize NOAA climate data.}
\usage{
  noaa_plot(input = NULL)
}
\arguments{
  \item{input}{Input noaa object.}
}
\value{
  Plot of climate data.
}
\description{
  This function accepts directly output from the
  \code{\link{noaa}} function, but not other functions.
}
\examples{
\dontrun{
# Search for data first, then plot
out <- noaa(datasetid='NORMAL_DLY', stationid='GHCND:USW00014895', datatypeid='dly-tmax-normal', startdate = '2010-05-01', enddate = '2010-05-31')
noaa_plot(out)
}
}

