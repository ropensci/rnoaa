rnoaa
========

[![Build Status](https://api.travis-ci.org/ropensci/rnoaa.png)](https://travis-ci.org/ropensci/rnoaa)


### IMPORTANT - BUOY DATA

NOAA buoy data requires an R pacakage `ncdf4` that is difficult to use on Windows. Therefore, we have moved functions for working with buoy data into a separate branch called `buoy`, and the `CRAN` version does not include buoy functions. Thus, if you're on a Linux machine or on OSX you should be able to use the `buoy` branch just fine after installing the `netcdf` as:

OSX

```
brew install netcdf
```

Linux (Ubuntu)

```
sudo apt-get install netcdf*
```

Then `rnoaa` with the buoy functions should install and load correctly. See [this stackoverflow post](http://stackoverflow.com/questions/22805123/netcdf-make-command-test/22806048#22806048) and [this blog post](http://mazamascience.com/WorkingWithData/?p=1429) for more Linux/OSX `netcdf` installation help.

### Help

There is a tutorial on the [rOpenSci website](http://ropensci.org/tutorials/rncdc_tutorial.html), and there are many tutorials in the package itself, available in your R session, or [on CRAN](http://cran.r-project.org/web/packages/rnoaa/index.html). The tutorials:

* NOAA Buoy vignette
* NOAA ERDDAP vignette
* NOAA NCDC vignette (examples)
* NOAA NCDC attributes vignette
* NOAA NCDC workflow vignette
* Sea ice vignette
* Severe Weather Data Inventory vignette

### Data sources used in rnoaa

The majority of functions in this package work with NOAA NCDC data.

* NOAA NCDC climate data:
    * We are using the NOAA API version 2. A previous version of this software was using their V1 API - older versions of this software use the old API - let us know if you want to use that.
    * The docs for the NCDC data API are [here](http://www.ncdc.noaa.gov/cdo-web/webservices/v2)
    * GCHN Daily data is available [here](http://www.ncdc.noaa.gov/oa/climate/ghcn-daily/) via FTP and HTTP
* Severe weather data docs are [here](http://www.ncdc.noaa.gov/swdiws/)
* Sea ice data [ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/shapefiles](ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/shapefiles)
* NOAA buoy data [http://www.ndbc.noaa.gov/](http://www.ndbc.noaa.gov/)
* ERDDAP data [http://coastwatch.pfeg.noaa.gov/erddap/index.html](http://coastwatch.pfeg.noaa.gov/erddap/index.html)

### NOAA NCDC Datasets

There are many NOAA NCDC datasets. Each is available throughout most functions in this package by using the `datasetid` parameter, except `NEXRAD2` and `NEXRAD3`, which don't work.

| Dataset | Description | Start date | End date |
|---------|-------------|------------|----------|
| ANNUAL | Annual Summaries | 1831-02-01 | 2013-11-01 |
| GHCND | Daily Summaries | 1763-01-01 | 2014-03-15 |
| GHCNDMS | Monthly Summaries | 1763-01-01 | 2014-01-01 |
| NORMAL_ANN | Normals Annual/Seasonal | 2010-01-01 | 2010-01-01 |
| NORMAL_DLY | Normals Daily | 2010-01-01 | 2010-12-31 |
| NORMAL_HLY | Normals Hourly | 2010-01-01 | 2010-12-31 |
| NORMAL_MLY | Normals Monthly | 2010-01-01 | 2010-12-01 |
| PRECIP_15 | Precipitation 15 Minute | 1970-05-12 | 2013-03-01 |
| PRECIP_HLY | Precipitation Hourly | 1900-01-01 | 2013-03-01 |
| NEXRAD2 | Nexrad Level II | 1991-06-05 | 2014-03-14 |
| NEXRAD3 | Nexrad Level III | 1994-05-20 | 2014-03-11 |

### NOAA NCDC Attributes

Each NOAA dataset has a different set of attributes that you can potentially get back in your search. See [the NOAA docs](http://www.ncdc.noaa.gov/cdo-web/datasets) for detailed info on each dataset. We provide some information on the attributes in this package; see the [vignette for attributes](inst/vign/rncdc_attributes.md) to find out more

### Authentication

You'll need an API key to use the NOAA NCDC functions (those starting with `noaa*`) in this package (essentially a password). Go [here](http://www.ncdc.noaa.gov/cdo-web/token) to get one. *You can't use this package without an API key.*

Once you obtain a key, there are two ways to use it.

a) Pass it inline with each function call (somewhat cumbersome)  

```coffee
ncdc(datasetid = 'PRECIP_HLY', locationid = 'ZIP:28801', datatypeid = 'HPCP', limit = 5, token =  "YOUR_TOKEN")
```

b) Alternatively, you might find it easier to set this as an option, either by adding this line to the top of a script or somewhere in your `.rprofile`

```coffee
options(noaakey = "KEY_EMAILED_TO_YOU")
```

c) You can always store in permamently in your `.Rprofile` file.


### Installation

__Stable version from CRAN__

```coffee
install.packages("rnoaa")
```

__or development version from GitHub__

```coffee
install.packages("devtools")
devtools::install_github("rnoaa", "ropensci")
library('rnoaa')
```

__or version with buoy functions on Github__

```coffee
install.packages("devtools")
devtools::install_github("rnoaa", "ropensci", ref="buoy")
library('rnoaa')
```

### Quick start

####  Fetch list of city locations in descending order

```coffee
ncdc_locs(locationcategoryid='CITY', sortfield='name', sortorder='desc')
```

```coffee
$atts
$atts$totalCount
[1] 1654

$atts$pageCount
[1] 25

$atts$offset
[1] 1


$data
              id                  name datacoverage    mindate    maxdate
1  CITY:NL000012            Zwolle, NL       1.0000 1892-08-01 2013-08-31
2  CITY:SZ000007            Zurich, SZ       1.0000 1901-01-01 2013-11-17
3  CITY:NG000004            Zinder, NG       0.8678 1906-01-01 1980-12-31
4  CITY:UP000025         Zhytomyra, UP       0.9725 1938-01-01 2013-11-17
5  CITY:KZ000017        Zhezkazgan, KZ       0.9275 1948-03-01 2013-11-17
6  CITY:CH000045         Zhengzhou, CH       1.0000 1951-01-01 2013-11-17
7  CITY:SP000021          Zaragoza, SP       1.0000 1941-01-01 2012-08-31
8  CITY:UP000024      Zaporiyhzhya, UP       0.9739 1936-01-01 2009-06-16
9  CITY:US390029     Zanesville, OH US       1.0000 1893-01-01 2013-11-19
10 CITY:LE000004             Zahle, LE       0.7811 1912-01-01 1971-12-31
11 CITY:IR000019           Zahedan, IR       0.9930 1951-01-01 2010-05-19
12 CITY:HR000002            Zagreb, HR       1.0000 1860-12-01 2008-12-31
13 CITY:RS000081 Yuzhno-Sakhalinsk, RS       1.0000 1947-01-01 2013-11-15
14 CITY:US040015           Yuma, AZ US       1.0000 1893-01-01 2013-11-19
15 CITY:US060048   Yucca Valley, CA US       1.0000 1942-02-01 2013-11-19
16 CITY:US060047      Yuba City, CA US       1.0000 1893-01-01 2013-11-19
17 CITY:US390028     Youngstown, OH US       1.0000 1893-01-01 2013-11-19
18 CITY:US420024           York, PA US       1.0000 1941-01-01 2013-11-19
19 CITY:US360031        Yonkers, NY US       1.0000 1876-01-01 2013-11-19
20 CITY:JA000017          Yokohama, JA       1.0000 1949-01-01 2013-11-17
21 CITY:CH000044          Yinchuan, CH       1.0000 1951-01-01 2013-11-17
22 CITY:AM000001           Yerevan, AM       0.9751 1885-06-01 2006-12-31
23 CITY:US280020     Yazoo City, MS US       1.0000 1948-01-01 2013-11-19
24 CITY:RS000080         Yaroslavl, RS       0.9850 1959-07-01 1987-05-20
25 CITY:US460009        Yankton, SD US       1.0000 1932-01-01 2013-11-19

attr(,"class")
[1] "ncdc_locs"
```

#### Get info on a station by specifcying a dataset, locationtype, location, and station

```coffee
ncdc_stations(datasetid='GHCND', locationid='FIPS:12017', stationid='GHCND:USC00084289')
```

```coffee
                 id                  name datacoverage    mindate    maxdate
1 GHCND:USC00084289 INVERNESS 3 SE, FL US            1 1899-02-01 2013-11-17
```

#### Search for data

```coffee
out <- ncdc(datasetid='NORMAL_DLY', stationid='GHCND:USW00014895', datatypeid='dly-tmax-normal', startdate = '2010-05-01', enddate = '2010-05-10')
```

##### See a data.frame

```coffee
head( out$data )
```

```coffee
             station value        datatype                date fl_c
1  GHCND:USW00014895   652 DLY-TMAX-NORMAL 2010-05-01T00:00:00    S
2  GHCND:USW00014895   655 DLY-TMAX-NORMAL 2010-05-02T00:00:00    S
3  GHCND:USW00014895   658 DLY-TMAX-NORMAL 2010-05-03T00:00:00    S
4  GHCND:USW00014895   661 DLY-TMAX-NORMAL 2010-05-04T00:00:00    S
5  GHCND:USW00014895   663 DLY-TMAX-NORMAL 2010-05-05T00:00:00    S
6  GHCND:USW00014895   666 DLY-TMAX-NORMAL 2010-05-06T00:00:00    S
```

#### Plot data, super simple, but it's a start

```coffee
out <- ncdc(datasetid='GHCND', stationid='GHCND:USW00014895', datatypeid='PRCP', startdate = '2010-05-01', enddate = '2010-10-31', limit=500)
ncdc_plot(out, breaks="1 month", dateformat="%d/%m")
```

![](inst/img/plot.png)

#### More plotting

You can pass many outputs from calls to the `noaa` function in to the `ncdc_plot` function.

```coffee
out1 <- ncdc(datasetid='GHCND', stationid='GHCND:USW00014895', datatypeid='PRCP', startdate = '2010-03-01', enddate = '2010-05-31', limit=500)
out2 <- ncdc(datasetid='GHCND', stationid='GHCND:USW00014895', datatypeid='PRCP', startdate = '2010-09-01', enddate = '2010-10-31', limit=500)
ncdc_plot(out1, out2, breaks="45 days")
```

![](inst/img/plot1.png)

### Get table of all datasets

```coffee
ncdc_datasets()
```

```coffee
$meta
$meta$limit
[1] 25

$meta$count
[1] 11

$meta$offset
[1] 1


$data
                    uid         id                    name datacoverage    mindate    maxdate
1  gov.noaa.ncdc:C00040     ANNUAL        Annual Summaries         1.00 1831-02-01 2013-12-01
2  gov.noaa.ncdc:C00861      GHCND         Daily Summaries         1.00 1763-01-01 2014-05-02
3  gov.noaa.ncdc:C00841    GHCNDMS       Monthly Summaries         1.00 1763-01-01 2014-03-01
4  gov.noaa.ncdc:C00345    NEXRAD2         Nexrad Level II         0.95 1991-06-05 2014-04-22
5  gov.noaa.ncdc:C00708    NEXRAD3        Nexrad Level III         0.95 1994-05-20 2014-04-19
6  gov.noaa.ncdc:C00821 NORMAL_ANN Normals Annual/Seasonal         1.00 2010-01-01 2010-01-01
7  gov.noaa.ncdc:C00823 NORMAL_DLY           Normals Daily         1.00 2010-01-01 2010-12-31
8  gov.noaa.ncdc:C00824 NORMAL_HLY          Normals Hourly         1.00 2010-01-01 2010-12-31
9  gov.noaa.ncdc:C00822 NORMAL_MLY         Normals Monthly         1.00 2010-01-01 2010-12-01
10 gov.noaa.ncdc:C00505  PRECIP_15 Precipitation 15 Minute         0.25 1970-05-12 2013-05-01
11 gov.noaa.ncdc:C00313 PRECIP_HLY    Precipitation Hourly         1.00 1900-01-01 2013-05-01

attr(,"class")
[1] "ncdc_datasets"
```

### Get data category data and metadata

```coffee
ncdc_datacats(locationid='CITY:US390029')
```

```coffee
$meta
$meta$totalCount
[1] 37

$meta$pageCount
[1] 25

$meta$offset
[1] 1


$data
              id                  name
1         ANNAGR   Annual Agricultural
2          ANNDD    Annual Degree Days
3        ANNPRCP  Annual Precipitation
4        ANNTEMP    Annual Temperature
5          AUAGR   Autumn Agricultural
6           AUDD    Autumn Degree Days
7         AUPRCP  Autumn Precipitation
8         AUTEMP    Autumn Temperature
9           COMP              Computed
10       COMPAGR Computed Agricultural
11            DD           Degree Days
12 DUALPOLMOMENT      Dual-Pol Moments
13       ECHOTOP             Echo Tops
14   HYDROMETEOR      Hydrometeor Type
15         OTHER                 Other
16       OVERLAY               Overlay
17          PRCP         Precipitation
18  REFLECTIVITY          Reflectivity
19           SKY    Sky cover & clouds
20         SPAGR   Spring Agricultural
21          SPDD    Spring Degree Days
22        SPPRCP  Spring Precipitation
23        SPTEMP    Spring Temperature
24         SUAGR   Summer Agricultural
25          SUDD    Summer Degree Days

attr(,"class")
[1] "ncdc_datacats"
```

[Please report any issues or bugs](https://github.com/ropensci/rnoaa/issues).

License: MIT

This package is part of the [rOpenSci](http://ropensci.org/packages) project.

To cite package `rnoaa` in publications use:

```coffee
  Hart Edmund, Scott Chamberlain and Karthik Ram (2014). rnoaa: NOAA climate data
  from R.. R package version 0.1.9.99. https://github.com/ropensci/rnoaa
```

A BibTeX entry for LaTeX users is

```coffee
  @Manual{,
    title = {rnoaa: NOAA climate data from R.},
    author = {Hart Edmund and Scott Chamberlain and Karthik Ram},
    year = {2014},
    note = {R package version 0.1.9.99},
    url = {https://github.com/ropensci/rnoaa},
  }
```

Get citation information for `rnoaa` in R doing `citation(package = 'rnoaa')`

[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
