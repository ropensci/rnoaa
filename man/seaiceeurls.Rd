\name{seaiceeurls}
\alias{seaiceeurls}
\title{Make all urls for sea ice data}
\usage{
  seaiceeurls(yr = NULL, mo = NULL, pole = NULL)
}
\arguments{
  \item{yr}{Year (numeric)}

  \item{mo}{Month, as character abbrevation of a month
  (character)}

  \item{Pole}{One of S (south) or N (north) (character)}
}
\value{
  A list of urls
}
\description{
  Make all urls for sea ice data
}
\examples{
# Get all urls
seaiceeurls()

# Get urls for Feb of all years, both S and N poles
seaiceeurls(mo='Feb')

# Get urls for Feb of all years, just S pole
seaiceeurls(mo='Feb', pole='S')

# Get urls for Feb of 1980, just S pole
seaiceeurls(yr=1980, mo='Feb', pole='S')
}
\keyword{internal}

