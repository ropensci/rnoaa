\name{noaa_seaice}
\alias{noaa_seaice}
\title{Get sea ice data.}
\usage{
  noaa_seaice(url, ...)
}
\arguments{
  \item{url}{A url for a NOAA sea ice ftp file}

  \item{...}{Further arguments passed on to readshpfile
  function, see \code{readshpfile}}
}
\value{
  A data.frame
}
\description{
  Get sea ice data.
}
\examples{
\dontrun{
# Look at data.frame's for a series of years for Feb, South pole
urls <- sapply(seq(1979,1990,1), function(x) seaiceeurls(yr=x, mo='Feb', pole='S'))
out <- llply(urls, noaa_seaice)
lapply(out, head)

# Map a single year/month/pole combo
urls <- seaiceeurls(mo='Apr', pole='N', yr=1990)
out <- noaa_seaice(urls)
ggplot(out, aes(long, lat, group=group)) +
   geom_polygon(fill="steelblue") +
   theme_ice()

# Map all years for April only for North pole
urls <- seaiceeurls(mo='Apr', pole='N')
registerDoMC(cores=4)
out <- llply(urls, noaa_seaice, .parallel=TRUE)
names(out) <- seq(1979,2013,1)
df <- ldply(out)
ggplot(df, aes(long, lat, group=group)) +
  geom_polygon(fill="steelblue") +
  theme_ice() +
  facet_wrap(~ .id)

ggplot(df, aes()) + geom_point()
}
}

