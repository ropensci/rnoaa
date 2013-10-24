\name{noaa_stations}
\alias{noaa_stations}
\title{Get metadata about NOAA stations.}
\usage{
  noaa_stations(dataset = NULL, station = NULL,
    location = NULL, locationtype = NULL, startdate = NULL,
    enddate = NULL, page = NULL,
    token = getOption("noaakey", stop("you need an API key NOAA data")),
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

  \item{station}{The station, within a dataset.}

  \item{datatype}{The data type, see function
  \code{\link{noaa_datatypes}}.}

  \item{location}{Location}

  \item{locationtype}{The location type}
}
\value{
  A list of metadata.
}
\description{
  Get metadata about NOAA stations.
}
\examples{
\dontrun{
# Displays all stations within GHCN-Daily (100 Stations per page limit)
noaa_stations(dataset='GHCND')

# Station
noaa_stations(dataset='NORMAL_DLY', station='GHCND:USW00014895')

# Displays all stations within GHCN-Daily (Displaying page 10 of the results)
noaa_stations(dataset='GHCND', page=10)

# Specify dataset and location
noaa_stations(dataset='GHCND', location='FIPS:12017')

# Specify dataset, location, and station
noaa_stations(dataset='GHCND', location='FIPS:12017', station='GHCND:USC00084289')

# Specify dataset, locationtype, location, and station
noaa_stations(dataset='GHCND', locationtype='CNTY', location='FIPS:12017', station='GHCND:USC00084289')

# Displays list of stations within the specified county
noaa_stations(dataset='GHCND', locationtype='CNTY', location='FIPS:12017')

# Displays list of Hourly Precipitation locations between 01/01/1990 and 12/31/1990
noaa_stations(dataset='PRECIP_HLY', startdate='19900101', enddate='19901231')
}
}

