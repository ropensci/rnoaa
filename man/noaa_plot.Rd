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
  Make map to visualize NOAA climate data.
}
\examples{
\dontrun{
# Search for data first, then plot
out <- noaa(dataset='NORMAL_DLY', station='GHCND:USW00014895', datatype='dly-tmax-normal', year=2010, month=4)
noaa_plot(out)
}
}

