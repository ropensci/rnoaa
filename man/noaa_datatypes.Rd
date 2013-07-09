\name{noaa_datatypes}
\alias{noaa_datatypes}
\title{Get possible data types for a particular dataset}
\usage{
  noaa_datatypes(dataset = NULL, startdate = NULL,
    enddate = NULL, page = NULL,
    token = getOption("noaakey", stop("you need an API key NOAA data")))
}
\arguments{
  \item{dataset}{foo}

  \item{startdate}{foo}

  \item{enddate}{foo}

  \item{page}{foo}

  \item{token}{API key}

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
}
\value{
  A \code{data.frame} for all datasets, or a list of length
  two, each with a data.frame.
}
\description{
  Get possible data types for a particular dataset
}
\examples{
\dontrun{
noaa_datatypes(dataset="ANNUAL")
}
}

