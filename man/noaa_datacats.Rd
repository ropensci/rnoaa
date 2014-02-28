\name{noaa_datacats}
\alias{noaa_datacats}
\title{Get possible data categories for a particular datasetid, locationid, stationid, etc.}
\usage{
noaa_datacats(datasetid = NULL, datacategoryid = NULL, stationid = NULL,
  locationid = NULL, startdate = NULL, enddate = NULL, sortfield = NULL,
  sortorder = NULL, limit = 25, offset = NULL, callopts = list(),
  token = getOption("noaakey", stop("you need an API key NOAA data")))
}
\arguments{
  \item{datasetid}{Accepts a single valid dataset id. Data
  returned will be from the dataset specified, see
  datasets() (required)}

  \item{datacategoryid}{A valid data category id. Data
  types returned will be associated with the data
  category(ies) specified}

  \item{locationid}{Accepts a valid location id. Data
  returned will contain data for the location(s) specified
  (optional)}

  \item{stationid}{Accepts a valid station id. Data
  returned will contain data for the station(s) specified
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
}
\description{
From the NOAA API docs: Data Categories represent groupings
of data types.
}
\examples{
\dontrun{
noaa_datacats(limit=41)

## Single data category
noaa_datacats(datacategoryid="ANNAGR")

## Fetch data categories for a given set of locations
noaa_datacats(locationid='CITY:US390029')
noaa_datacats(locationid=c('CITY:US390029', 'FIPS:37'))
}
}
\references{
Vignette at
\url{http://ropensci.org/tutorials/rnoaa_tutorial.html}
}

