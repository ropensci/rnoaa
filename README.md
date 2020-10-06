rnoaa
=====



[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![cran checks](https://cranchecks.info/badges/worst/rnoaa)](https://cranchecks.info/pkgs/rnoaa)
[![R-check](https://github.com/ropensci/rnoaa/workflows/R-check/badge.svg)](https://github.com/ropensci/rnoaa/actions)
[![codecov.io](https://codecov.io/github/ropensci/rnoaa/coverage.svg?branch=master)](https://codecov.io/github/ropensci/rnoaa?branch=master)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/rnoaa?color=C9A115)](https://github.com/r-hub/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/rnoaa)](https://cran.r-project.org/package=rnoaa)


`rnoaa` is an R interface to many NOAA data sources. We don't cover all of them, but we include many commonly used sources, and add we are always adding new sources. We focus on easy to use interfaces for getting NOAA data, and giving back data in easy to use formats downstream. We currently don't do much in the way of plots or analysis. To get started see: https://docs.ropensci.org/rnoaa/articles/rnoaa.html

## Data sources in rnoaa

* NOAA NCDC climate data:
    * We are using the NOAA API version 2
    * Docs for the NCDC API are at https://www.ncdc.noaa.gov/cdo-web/webservices/v2
    * GHCN Daily data is available at http://www.ncdc.noaa.gov/ghcn-daily-description via FTP and HTTP
* Severe weather data docs are at https://www.ncdc.noaa.gov/swdiws/
* Sea ice data (ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/shapefiles)
* NOAA buoy data (https://www.ndbc.noaa.gov/)
* ERDDAP data (https://upwell.pfeg.noaa.gov/erddap/index.html)
  * Now in package rerddap (https://github.com/ropensci/rerddap)
* Tornadoes! Data from the NOAA Storm Prediction Center (https://www.spc.noaa.gov/gis/svrgis/)
* HOMR - Historical Observing Metadata Repository (http://www.ncdc.noaa.gov/homr/api)
* GHCND FTP data (ftp://ftp.ncdc.noaa.gov/pub/data/noaa) - NOAA NCDC API has some/all (not sure really) of this data, but FTP allows to get more data more quickly
* Extended Reconstructed Sea Surface Temperature (ERSST) data (https://www.ncdc.noaa.gov/data-access/marineocean-data/extended-reconstructed-sea-surface-temperature-ersst-v4)
* Argo buoys (http://www.argo.ucsd.edu/) - a global array of more than 3,000 free-drifting profiling floats that measures thetemperature and salinity of the upper 2000 m of the ocean
* NOAA CO-OPS - tides and currents data (https://tidesandcurrents.noaa.gov/)
* NOAA Climate Prediction Center (CPC) (http://www.cpc.ncep.noaa.gov/)
* Africa Rainfall Climatology version 2 (ftp://ftp.cpc.ncep.noaa.gov/fews/fewsdata/africa/arc2/ARC2_readme.txt)
* Blended Sea Winds (https://www.ncdc.noaa.gov/data-access/marineocean-data/blended-global/blended-sea-winds)
* Local Climatological Data (https://www.ncdc.noaa.gov/cdo-web/datatools/lcd)
* Storm Events Database (https://www.ncdc.noaa.gov/stormevents/)

## Help/Getting Started

Documentation is at https://docs.ropensci.org/rnoaa/, and there are many vignettes in the package itself, available in your R session, or on CRAN (https://cran.r-project.org/package=rnoaa). The tutorials:

* **Getting started - start here**
* NOAA Buoy vignette
* NOAA National Climatic Data Center (NCDC) vignette (examples)
* NOAA NCDC attributes vignette
* NOAA NCDC workflow vignette
* Sea ice vignette
* Severe Weather Data Inventory (SWDI) vignette
* Historical Observing Metadata Repository (HOMR) vignette
* Complementing air quality data (ropenaq (https://github.com/ropensci/ropenaq)) with weather data using rnoaa

## netcdf data

Some functions use netcdf files, including:

* `ersst`
* `buoy`
* `bsw`
* `argo`
 
You'll need the `ncdf4` package for those functions, and those only. `ncdf4` is in Suggests in this package, meaning you only need `ncdf4` if you are using any of the functions listed above. You'll get an informative error telling you to install `ncdf4` if you don't have it and you try to use the those functions. Installation of `ncdf4` should be straightforward on any system. See https://cran.r-project.org/package=ncdf4

## NOAA NCDC Datasets

There are many NOAA NCDC datasets. All data sources work, except `NEXRAD2` and `NEXRAD3`, for an unknown reason. This relates to `ncdc_*()` functions only.


|Dataset    |Description                 |Start Date |End Date   | Data Coverage|
|:----------|:---------------------------|:----------|:----------|-------------:|
|GHCND      |Daily Summaries             |1763-01-01 |2020-10-03 |          1.00|
|GSOM       |Global Summary of the Month |1763-01-01 |2020-09-01 |          1.00|
|GSOY       |Global Summary of the Year  |1763-01-01 |2020-01-01 |          1.00|
|NEXRAD2    |Weather Radar (Level II)    |1991-06-05 |2020-10-02 |          0.95|
|NEXRAD3    |Weather Radar (Level III)   |1994-05-20 |2020-10-03 |          0.95|
|NORMAL_ANN |Normals Annual/Seasonal     |2010-01-01 |2010-01-01 |          1.00|
|NORMAL_DLY |Normals Daily               |2010-01-01 |2010-12-31 |          1.00|
|NORMAL_HLY |Normals Hourly              |2010-01-01 |2010-12-31 |          1.00|
|NORMAL_MLY |Normals Monthly             |2010-01-01 |2010-12-01 |          1.00|
|PRECIP_15  |Precipitation 15 Minute     |1970-05-12 |2014-01-01 |          0.25|
|PRECIP_HLY |Precipitation Hourly        |1900-01-01 |2014-01-01 |          1.00|


```
#> table updated on 2020-10-05
```

**NOAA NCDC Attributes**

Each NOAA dataset has a different set of attributes that you can potentially get back in your search. See https://www.ncdc.noaa.gov/cdo-web/datasets for detailed info on each dataset. We provide some information on the attributes in this package; see the vignette for attributes (https://docs.ropensci.org/rnoaa/articles/ncdc_attributes.html) to find out more


## Contributors

* Scott Chamberlain (https://github.com/sckott)
* Brooke Anderson (https://github.com/geanders)
* Maëlle Salmon (https://github.com/maelle)
* Adam Erickson (https://github.com/adam-erickson)
* Nicholas Potter (https://github.com/potterzot)
* Joseph Stachelek (https://github.com/jsta)

## Meta

* Please report any issues or bugs: https://github.com/ropensci/rnoaa/issues
* License: MIT
* Get citation information for `rnoaa` in R doing `citation(package = 'rnoaa')`
* Please note that this package is released with a Contributor Code of Conduct (https://ropensci.org/code-of-conduct/). By contributing to this project, you agree to abide by its terms.

[![rofooter](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
