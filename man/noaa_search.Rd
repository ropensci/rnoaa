\name{noaa_search}
\alias{noaa_search}
\title{Search metadata about NOAA locations.}
\usage{
  noaa_search(dataset = NULL, resulttype = NULL,
    text = NULL, datatypecategory = NULL, startdate = NULL,
    enddate = NULL, sort = NULL, page = NULL,
    pagesize = NULL,
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

  \item{resulttype}{The type id indicating the type of
  result to return. One of station, city, country,
  country.}

  \item{location}{A single location code.}

  \item{locationtype}{A single location type code.}
}
\value{
  A data.frame of metadata.
}
\description{
  Search metadata about NOAA locations.
}
\examples{
\dontrun{
# Search GHCN-Daily stations which contain the label "Boulder"
noaa_search(dataset='GHCND', resulttype='station', text='Boulder')

# Search 15 Minute Precipitation countries labeled with "United States"
noaa_search(dataset='GHCND', resulttype='station', text='United States')
}
}

