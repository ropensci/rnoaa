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
  \item{datasetid}{Accepts a single valid dataset id. Data
  returned will be from the dataset specified, see
  datasets() (required)}

  \item{datatypeid}{Accepts a valid data type id or a chain
  of data type ids seperated by ampersands. Data returned
  will contain all of the data type(s) specified
  (optional)}

  \item{locationid}{Accepts a valid location id or a chain
  of location ids seperated by ampersands. Data returned
  will contain data for the location(s) specified
  (optional)}

  \item{stationid}{Accepts a valid station id or a chain of
  of station ids seperated by ampersands. Data returned
  will contain data for the station(s) specified
  (optional)}

  \item{startdate}{Accepts valid ISO formated date
  (yyyy-mm-dd). Data returned will have data after the
  specified date. Paramater can be use independently of
  enddate (optional)}

  \item{enddate}{Accepts valid ISO formated date
  (yyyy-mm-dd). Data returned will have data before the
  specified date. Paramater can be use independently of
  startdate (optional)}

  \item{sortfield}{The field to sort results by. Supports
  id, name, mindate, maxdate, and datacoverage fields
  (optional)}

  \item{sortorder}{Which order to sort by, asc or desc.
  Defaults to asc (optional)}

  \item{limit}{Defaults to 25, limits the number of results
  in the response. Maximum is 1000 (optional)}

  \item{offset}{Defaults to 0, used to offset the
  resultlist (optional)}

  \item{token}{This must be a valid token token supplied to
  you by NCDC's Climate Data Online access token generator.
  (required) Get an API key (=token) at
  \url{http://www.ncdc.noaa.gov/cdo-web/token}. You can
  pass your token in as an argument or store it in your
  .Rprofile file with an entry like \itemize{ \item
  options("noaakey" = "your-noaa-token") }}

  \item{callopts}{Further arguments passed on to the API
  GET call. (optional)}

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

