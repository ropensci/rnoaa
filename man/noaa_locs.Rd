\name{noaa_locs}
\alias{noaa_locs}
\title{Get metadata about NOAA locations.}
\usage{
  noaa_locs(dataset = NULL, location = NULL,
    locationtype = NULL, startdate = NULL, enddate = NULL,
    page = NULL,
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
  where MM is the 2-digit month,}

  \item{token}{This must be a valid token token supplied to
  you by NCDC's Climate Data Online access token generator.
  Required.}

  \item{callopts}{Further arguments passed on to the API
  GET call.}

  \item{datatype}{The data type, see function
  \code{\link{noaa_datatypes}}.}

  \item{location}{A single location code.}

  \item{locationtype}{A single location type code.}
}
\value{
  A data.frame of metadata.
}
\description{
  Get metadata about NOAA locations.
}
\examples{
\dontrun{
# Find locations within the Daily Normals dataset
noaa_locs(dataset='NORMAL_DLY', startdate='20100101')

# Displays the location CITY:CA000012 within the PRECIP_HLY dataset
noaa_locs(dataset='PRECIP_HLY', location='CITY:CA000012')

# Displays available countries within GHCN-Daily
noaa_locs(dataset='GHCND', locationtype='CNTRY')
}
}

