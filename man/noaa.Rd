\name{noaa}
\alias{noaa}
\title{Get NOAA data for any combination of dataset, datatype, station, location,
and/or location type.}
\usage{
  noaa(dataset = NULL, datatype = NULL, station = NULL,
    location = NULL, locationtype = NULL, startdate = NULL,
    enddate = NULL, page = 1, year = NULL, month = NULL,
    day = NULL, results = NULL,
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
  where MM is the 2-digit month}

  \item{day}{Day of the month, between 01 and 31}

  \item{token}{This must be a valid token token supplied to
  you by NCDC's Climate Data Online access token generator.
  Required.}

  \item{callopts}{Further arguments passed on to the API
  GET call.}

  \item{station}{The station, within a dataset, see
  function \code{\link{noaa_stations}}}

  \item{datatype}{The data type, see function
  \code{\link{noaa_datatypes}}}

  \item{location}{A single location code.}

  \item{results}{The number of results to return.  The
  larger the number of results requested, the longer the
  api call will take.}

  \item{locationtype}{A single location type code.}
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
# January 2001 GHCN-Daily data
noaa(dataset='GHCND', year=2001, month=1)

# Normals Daily GHCND:USW00014895 dly-tmax-normal data
noaa(dataset='NORMAL_DLY', station='GHCND:USW00014895', year=2010, month=4)

# Dataset, and location in Australia
noaa(dataset='GHCND', location='FIPS:AS', year=2001, month=4)

# Dataset, location and datatype
noaa(dataset='PRECIP_HLY', location='ZIP:28801', datatype='HPCP', year=2001, month=4)

# Dataset, location, station and datatype
noaa(dataset='PRECIP_HLY', location='ZIP:28801', station='COOP:310301', datatype='HPCP', year=2001, month=4)

# Dataset, location, locationtype and datatype
noaa(dataset='GHCND', location='FIPS:BR', locationtype='CNTRY', datatype='PRCP')

# Normals Daily GHCND dly-tmax-normal data
noaa(dataset='NORMAL_DLY', datatype='dly-tmax-normal', year=2010, month=4)

# Normals Daily GHCND:USW00014895 dly-tmax-normal
noaa(dataset='NORMAL_DLY', station='GHCND:USW00014895', datatype='dly-tmax-normal', year=2010, month=4)

# Hourly Precipitation data for ZIP code 28801
noaa(dataset='PRECIP_HLY', location='ZIP:28801', datatype='HPCP', year=1980,
month=7, day=17)
}
}

