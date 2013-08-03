\name{noaa_loc_search}
\alias{noaa_loc_search}
\title{Get metadata about NOAA stations.}
\usage{
  noaa_loc_search(dataset = NULL, radius = NULL,
    latitude = NULL, longitude = NULL, startdate = NULL,
    enddate = NULL, sort = NULL, category = NULL,
    page = NULL, pagesize = NULL,
    token = getOption("noaakey", stop("you need an API key for NOAA data")),
    callopts = list())
}
\arguments{
  \item{dataset}{The data set name, see datasets()}

  \item{startdate}{The date format pattern to limit the
  start date of the web service query. This is a string
  date mask represented by "yyyyMMdd" where yyyy is a
  4-digit year, MM is the 2-digit month, and dd is the
  2-digit day.  Optional. (Note: not used for Normals)}

  \item{enddate}{The date format pattern to limit the end
  date of the web service query. This is a string date mask
  represented by "yyyyMMdd" where yyyy is a 4-digit year,
  MM is the 2-digit month, and dd is the 2-digit day.
  Optional. (Note: not used for Normals)}

  \item{page}{Results with over 10 items will be paginated.
  This controls which page of data is returned from the
  service. This variable only accepts an integer as input
  and is optional.}

  \item{year}{Used for Annual Normals to specify which
  yearly set of normals to use. Currently only available
  from 1981-2010, so specify 2010 as the value.  This is a
  string date mask represented by "yyyy" where yyyy is a
  4-digit year.}

  \item{month}{Used for Annual Normals to specify which
  month to display for Annual Normals. Values include
  01-12. This is a string date mask represented by "MM"
  where MM is the 2-digit month}

  \item{day}{Day of the month, between 01 and 31}

  \item{token}{This must be a valid token token supplied to
  you by NCDC's Climate Data Online access token generator.
  Required.}

  \item{callopts}{Further arguments passed on to the API
  GET call.}

  \item{datatype}{The data type, see function
  \code{\link{noaa_datatypes}}.}

  \item{radius}{Measured in kilometers, the default is
  100km but can be specified at any level. Requires
  latitude and longitude.}

  \item{latitude}{The latitude of a point in decimal
  format. Required.}

  \item{longitude}{The longitude of a point in decimal
  format. Required.}

  \item{sort}{This parameter accepts a string as input and
  is optional; the default value is best. Valid values for
  this parameter are: best, alpha, and reverseAlpha.}

  \item{category}{Parameter to choose stations, location,
  or both as results for the search service. Valid string
  values for this optional parameter are: all,
  stationsOnly, and locationsOnly.}

  \item{pagesize}{This controls the size of the page of
  data which is returned from the service. This variable
  only accepts an integer as input and is optional.}
}
\value{
  A list of metadata.
}
\description{
  Get metadata about NOAA stations.
}
\examples{
\dontrun{
# Search for GHCN-Daily stations within 100km of a lat/long point
noaa_loc_search(dataset='GHCND', latitude=35.59528, longitude=-82.55667)

# Search for hrly precip stations within 25km of a lat/long point in Kansas
noaa_loc_search(dataset='PRECIP_HLY', latitude=38.002511, longitude=-98.514404, radius=25)
}
}

