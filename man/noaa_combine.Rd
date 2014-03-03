\name{noaa_combine}
\alias{noaa_combine}
\title{Coerce multiple outputs to a single data.frame object.}
\usage{
noaa_combine(...)
}
\arguments{
  \item{...}{Objects from another noaa_* function.}
}
\value{
A data.frame
}
\description{
Coerce multiple outputs to a single data.frame object.
}
\examples{
\dontrun{
# data
out1 <- noaa(datasetid='GHCND', locationid = 'FIPS:02', startdate = '2010-05-01',
enddate = '2010-05-31', limit=10)
out2 <- noaa(datasetid='GHCND', locationid = 'FIPS:02', startdate = '2010-07-01',
enddate = '2010-07-31', limit=10)
noaa_combine(out1, out2)

# data sets
out1 <- noaa_datasets(datatypeid='TOBS')
out2 <- noaa_datasets(datatypeid='PRCP')
noaa_combine(out1, out2)

# data types
out1 <- noaa_datatypes(datatypeid="ACMH")
out2 <- noaa_datatypes(datatypeid='PRCP')
noaa_combine(out1, out2)

# data categories
out1 <- noaa_datacats(datacategoryid="ANNAGR")
out2 <- noaa_datacats(datacategoryid='PRCP')
noaa_combine(out1, out2)

# data locations
out1 <- noaa_locs(locationcategoryid='ST', limit=52)
out2 <- noaa_locs(locationcategoryid='CITY', sortfield='name', sortorder='desc')
noaa_combine(out1, out2)

# data locations
out1 <- noaa_locs_cats(startdate='1970-01-01')
out2 <- noaa_locs_cats(locationcategoryid='CLIM_REG')
noaa_combine(out1, out2)

# stations
out1 <- noaa_stations(datasetid='GHCND', locationid='FIPS:12017',
stationid='GHCND:USC00084289')
out2 <- noaa_stations(stationid='COOP:010008')
out3 <- noaa_stations(datasetid='PRECIP_HLY', startdate='19900101',
enddate='19901231')
out4 <- noaa_stations(datasetid='GHCND', locationid='FIPS:12017')
noaa_combine(out1, out2, out3, out4)

# try to combine two different classes
out1 <- noaa_locs_cats(startdate='1970-01-01')
out2 <- noaa_stations(stationid='COOP:010008')
out3 <- noaa_locs_cats(locationcategoryid='CLIM_REG')
noaa_combine(out1, out2)
}
}

