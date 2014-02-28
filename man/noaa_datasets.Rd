\name{noaa_datasets}
\alias{noaa_datasets}
\title{Search NOAA datasets}
\usage{
noaa_datasets(datasetid = NULL, datatypeid = NULL, stationid = NULL,
  locationid = NULL, startdate = NULL, enddate = NULL, sortfield = NULL,
  sortorder = NULL, limit = 25, offset = NULL, callopts = list(),
  token = NULL, dataset = NULL, page = NULL, year = NULL,
  month = NULL)
}
\arguments{
  \item{datasetid}{Accepts a single valid dataset id. Data
  returned will be from the dataset specified, see
  datasets() (required)}

  \item{datatypeid}{Accepts a valid data type id or a chain
  of data type ids in a comma-separated vector. Data
  returned will contain all of the data type(s) specified
  (optional)}

  \item{locationid}{Accepts a valid location id or a chain
  of location ids in a comma-separated vector. Data
  returned will contain data for the location(s) specified
  (optional)}

  \item{stationid}{Accepts a valid station id or a chain of
  of station ids in a comma-separated vector. Data returned
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

  \item{page}{THIS IS A DEPRECATED ARGUMENT. There is no
  equivalent argument in v2 of the NOAA API.}

  \item{year}{THIS IS A DEPRECATED ARGUMENT. Use
  combination of startdate and enddate arguments.}

  \item{month}{THIS IS A DEPRECATED ARGUMENT. Use
  combination of startdate and enddate arguments.}
}
\description{
From the NOAA API docs: All of our data are in datasets. To
retrieve any data from us, you must know what dataset it is
in.
}
\examples{
\dontrun{
# Get a table of all datasets
noaa_datasets()

# Get details from a particular dataset
noaa_datasets(datasetid='ANNUAL')

# Get datasets with Temperature at the time of observation (TOBS) data type
noaa_datasets(datatypeid='TOBS')

# Get datasets with data for a series of the same parameter arg, in this case
# stationid's
noaa_datasets(stationid=c('COOP:310090','COOP:310184','COOP:310212'))

# Multiple datatypeid's
noaa_datasets(datatypeid=c('ACMC','ACMH','ACSC'))
noaa_datasets(datasetid='ANNUAL', datatypeid=c('ACMC','ACMH','ACSC'))
}
}

