\name{noaa_loc_types}
\alias{noaa_loc_types}
\title{Get metadata about NOAA location types.}
\usage{
  noaa_loc_types(dataset = NULL, locationtype = NULL,
    startdate = NULL, enddate = NULL, page = NULL,
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

  \item{locationtype}{A single location type code.}
}
\value{
  A data.frame of metadata.
}
\description{
  Get metadata about NOAA location types.
}
\examples{
\dontrun{
# Displays location types within GHCN-Daily data
noaa_loc_types(dataset='GHCND')

# Show details of Hydrologic Cataloging Unit data
noaa_loc_types(dataset='GHCND', locationtype='HYD_CAT')
}
}

