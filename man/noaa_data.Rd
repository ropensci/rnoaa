\name{noaa_data}
\alias{noaa_data}
\title{Get NOAA data.}
\usage{
  noaa_data(input = NULL, datatype = "df")
}
\arguments{
  \item{input}{Output from noaa function.}

  \item{datatype}{One of df or list.}
}
\value{
  A data.frame or list.
}
\description{
  datatype = data_df returns all data in a data.frame,
  while data_list returns data in a list.
}
\examples{
\dontrun{
out <- noaa(dataset='NORMAL_DLY', station='GHCND:USW00014895', datatype='dly-tmax-normal', year=2010, month=4)
noaa_data(input=out) # data.frame output by default
noaa_data(input=out, datatype="list") # list if you want it
}
}

