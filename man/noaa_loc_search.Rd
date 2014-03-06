\name{noaa_loc_search}
\alias{noaa_loc_search}
\title{Search station list by extent}
\usage{
noaa_loc_search(extent = NULL, foptions = list(),
  token = getOption("noaakey", stop("you need an API key for NOAA data")))
}
\arguments{
  \item{extent}{The extent to search.  Order is min
  Longitude , min Latitude , max Longitude , max Latitude}

  \item{foptions}{(optional) additional arguments to httr
  for diagnostic purposes.}

  \item{token}{This must be a valid token token supplied to
  you by NCDC's Climate}
}
\description{
Search station list by extent
}
\examples{
\dontrun{
noaa_loc_search(extent = "47.5204,-122.2047,47.6139,-122.1065")
}
}
\author{
Karthik Ram karthik.ram@gmail.com
}

