rnoaa
========

Still early days, so not much here yet, but look quick start below...

### Info

[NOAA web services documentation](http://www.ncdc.noaa.gov/cdo-web/webservices)

### API key

You'll need an API key to use this package (essentially a password). Go [here](http://www.ncdc.noaa.gov/cdo-web/token) to get one. 


### Install from Github (not on CRAN yet)

```coffee
install.packages("devtools")
library(devtools)
install_github("rnoaa", "ropensci")
library(rnoaa)
```

### Quick start

####  Search for hrly precip stations within 25km of a lat/long point in Kansas

```coffee
noaa_loc_search(dataset='PRECIP_HLY', latitude=38.002511, longitude=-98.514404, radius=25)$data

$data
           id    minDate    maxDate             name score    type number inCart inDateRange
1 COOP:146469 1948-08-01 1978-03-01    PLEVNA, KS US    19 station      1  FALSE       FALSE
2 COOP:140326 1978-10-01 2012-08-01 ARLINGTON, KS US    23 station      2  FALSE       FALSE
```

#### Get info on a station by specifcying a dataset, locationtype, location, and station

```coffee
noaa_stations(dataset='GHCND', locationtype='CNTY', location='FIPS:12017', station='GHCND:USC00084289')$data

$meta
$meta$id
[1] "GHCND:USC00084289"

$meta$displayName
[1] "INVERNESS 3 SE, FL US"

$meta$minDate
[1] "1948-07-01"

$meta$maxDate
[1] "2013-07-22"

$meta$latitude
[1] 28.8029

$meta$longitude
[1] -82.3126

$meta$elevation
[1] 12.2

$meta$coverage
[1] 0.7945


$lab
       type            id                            displayName
1       ZIP     ZIP:34450                    Inverness, FL 34450
2   HYD_CAT  HUC:03100208          Withlacoochee Hydrologic Unit
3   HYD_ACC    HUC:031002              Tampa Bay Hydrologic Unit
4   HYD_SUB      HUC:0310        Peace-Tampa Bay Hydrologic Unit
5   HYD_REG        HUC:03    South Atlantic-Gulf Hydrologic Unit
6      CITY CITY:US120016               Homosassa Springs, FL US
7      CNTY    FIPS:12017                      Citrus County, FL
8        ST       FIPS:12                                Florida
9  CLIM_DIV     CLIM:1203 North Central Florida Climate Division
10 CLIM_REG      CLIM:104               Southeast Climate Region
11    CNTRY       FIPS:US                          United States
```

#### Search for data and get a data.frame or list

```coffee
out <- noaa(dataset='NORMAL_DLY', station='GHCND:USW00014895', datatype='dly-tmax-normal', year=2010, month=4)
```

##### See a data.frame

```coffee
head( noaa_data(out) )

                     date        dataType           station value
1 2010-04-01T00:00:00.000 DLY-TMAX-NORMAL GHCND:USW00014895   536
2 2010-04-02T00:00:00.000 DLY-TMAX-NORMAL GHCND:USW00014895   540
3 2010-04-03T00:00:00.000 DLY-TMAX-NORMAL GHCND:USW00014895   545
4 2010-04-04T00:00:00.000 DLY-TMAX-NORMAL GHCND:USW00014895   549
5 2010-04-05T00:00:00.000 DLY-TMAX-NORMAL GHCND:USW00014895   554
6 2010-04-06T00:00:00.000 DLY-TMAX-NORMAL GHCND:USW00014895   558
```

##### See a list (just first two elements)

```coffee
noaa_data(out, "list")[1:2]

[[1]]
[[1]]$date
[1] "2010-04-01T00:00:00.000"

[[1]]$dataType
[1] "DLY-TMAX-NORMAL"

[[1]]$station
[1] "GHCND:USW00014895"

[[1]]$value
[1] 536


[[2]]
[[2]]$date
[1] "2010-04-02T00:00:00.000"

[[2]]$dataType
[1] "DLY-TMAX-NORMAL"

[[2]]$station
[1] "GHCND:USW00014895"

[[2]]$value
[1] 540
````

#### Plot data, super simple, but it's a start

```coffee
out <- noaa(dataset='NORMAL_DLY', station='GHCND:USW00014895', datatype='dly-tmax-normal', year=2010, month=4)
noaa_plot(out)
```

![](/inst/img/plot.png)