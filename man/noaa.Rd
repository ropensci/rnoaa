\name{noaa}
\alias{noaa}
\title{Get NOAA data for any combination of dataset, datatype, station, location,
and/or location type.}
\usage{
  noaa(datasetid = NULL, datatypeid = NULL,
    stationid = NULL, locationid = NULL, startdate = NULL,
    enddate = NULL, sortfield = NULL, sortorder = NULL,
    limit = 25, offset = NULL, callopts = list(),
    token = getOption("noaakey", stop("you need an API key NOAA data")),
    dataset = NULL, datatype = NULL, station = NULL,
    location = NULL, locationtype = NULL, page = NULL,
    year = NULL, month = NULL, day = NULL, results = NULL)
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

  \item{dataset}{THIS IS A DEPRECATED ARGUMENT. See
  datasetid.}

  \item{datatype}{THIS IS A DEPRECATED ARGUMENT. See
  datatypeid.}

  \item{station}{THIS IS A DEPRECATED ARGUMENT. See
  stationid.}

  \item{location}{THIS IS A DEPRECATED ARGUMENT. See
  locationid.}

  \item{locationtype}{THIS IS A DEPRECATED ARGUMENT. There
  is no equivalent argument in v2 of the NOAA API.}

  \item{page}{THIS IS A DEPRECATED ARGUMENT. There is no
  equivalent argument in v2 of the NOAA API.}

  \item{year}{THIS IS A DEPRECATED ARGUMENT. Use
  combination of startdate and enddate arguments.}

  \item{month}{THIS IS A DEPRECATED ARGUMENT. Use
  combination of startdate and enddate arguments.}

  \item{day}{THIS IS A DEPRECATED ARGUMENT. Use combination
  of startdate and enddate arguments.}

  \item{results}{THIS IS A DEPRECATED ARGUMENT. See limit.}
}
\value{
  A data.frame for all datasets, or a list of length two,
  each with a data.frame.
}
\description{
  This is the main function to get NOAA data.
}
\examples{
\dontrun{
noaa(datasetid='GHCND', locationid = 'FIPS:02', startdate = '2010-05-01', enddate = '2010-05-31', limit=5)

# GHCN-Daily data since Septemer 1 2013
noaa(datasetid='GHCND', startdate = '2013-09-01')

# Normals Daily GHCND:USW00014895 dly-tmax-normal data
noaa(datasetid='NORMAL_DLY', stationid='GHCND:USW00014895', startdate = '2010-05-01', enddate = '2010-05-10')

# Dataset, and location in Australia
noaa(datasetid='GHCND', locationid='FIPS:AS', limit=5)

# Dataset, location and datatype
noaa(datasetid='PRECIP_HLY', locationid='ZIP:28801', datatypeid='HPCP', limit=5)

# Dataset, location, station and datatype
noaa(datasetid='PRECIP_HLY', locationid='ZIP:28801', stationid='COOP:310301', datatypeid='HPCP', limit=5)

# Dataset, location, and datatype
noaa(datasetid='GHCND', locationid='FIPS:BR', datatypeid='PRCP', limit=5)

# Normals Daily GHCND dly-tmax-normal data
noaa(datasetid='NORMAL_DLY', datatypeid='dly-tmax-normal', limit=5)

# Normals Daily GHCND:USW00014895 dly-tmax-normal
noaa(datasetid='NORMAL_DLY', stationid='GHCND:USW00014895', datatypeid='dly-tmax-normal', limit=5)

# Hourly Precipitation data for ZIP code 28801
noaa(datasetid='PRECIP_HLY', locationid='ZIP:28801', datatypeid='HPCP', limit=5)
}
}

