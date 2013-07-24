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
  where MM is the 2-digit month,}

  \item{token}{This must be a valid token token supplied to
  you by NCDC's Climate Data Online access token generator.
  Required.}

  \item{callopts}{Further arguments passed on to the API
  GET call.}

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

