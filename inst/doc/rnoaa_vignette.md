<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{rnoaa vignette}
-->

rnoaa vignette
======

### About the package

`rnoaa` is an R wrapper for the NOAA API.

********************

### Install `rnoaa`

Install and load `rnoaa` into the R session.


```r
install.packages("devtools")
library(devtools)
install_github("rnoaa", "ropensci", ref = "newapi")
```



```r
library(rnoaa)
library(plyr)
```


#### Get info on a station by specifcying a datasetid, locationid, and stationid


```r
noaa_stations(datasetid = "GHCND", locationid = "FIPS:12017", stationid = "GHCND:USC00084289")
```

```
##                  id                  name datacoverage    mindate
## 1 GHCND:USC00084289 INVERNESS 3 SE, FL US            1 1899-02-01
##      maxdate
## 1 2013-11-17
```


#### Search for data and get a data.frame or list


```r
out <- noaa(datasetid = "NORMAL_DLY", stationid = "GHCND:USW00014895", datatypeid = "dly-tmax-normal")
```


##### See a data.frame


```r
out$data
```

```
##              station value attributes        datatype       date
## 1  GHCND:USW00014895   334          S DLY-TMAX-NORMAL 2010-01-01
## 2  GHCND:USW00014895   333          S DLY-TMAX-NORMAL 2010-01-02
## 3  GHCND:USW00014895   332          S DLY-TMAX-NORMAL 2010-01-03
## 4  GHCND:USW00014895   331          S DLY-TMAX-NORMAL 2010-01-04
## 5  GHCND:USW00014895   331          S DLY-TMAX-NORMAL 2010-01-05
## 6  GHCND:USW00014895   330          S DLY-TMAX-NORMAL 2010-01-06
## 7  GHCND:USW00014895   329          S DLY-TMAX-NORMAL 2010-01-07
## 8  GHCND:USW00014895   329          S DLY-TMAX-NORMAL 2010-01-08
## 9  GHCND:USW00014895   329          S DLY-TMAX-NORMAL 2010-01-09
## 10 GHCND:USW00014895   328          S DLY-TMAX-NORMAL 2010-01-10
## 11 GHCND:USW00014895   328          S DLY-TMAX-NORMAL 2010-01-11
## 12 GHCND:USW00014895   328          S DLY-TMAX-NORMAL 2010-01-12
## 13 GHCND:USW00014895   328          S DLY-TMAX-NORMAL 2010-01-13
## 14 GHCND:USW00014895   328          S DLY-TMAX-NORMAL 2010-01-14
## 15 GHCND:USW00014895   328          S DLY-TMAX-NORMAL 2010-01-15
## 16 GHCND:USW00014895   328          S DLY-TMAX-NORMAL 2010-01-16
## 17 GHCND:USW00014895   328          S DLY-TMAX-NORMAL 2010-01-17
## 18 GHCND:USW00014895   329          S DLY-TMAX-NORMAL 2010-01-18
## 19 GHCND:USW00014895   329          S DLY-TMAX-NORMAL 2010-01-19
## 20 GHCND:USW00014895   329          S DLY-TMAX-NORMAL 2010-01-20
## 21 GHCND:USW00014895   330          S DLY-TMAX-NORMAL 2010-01-21
## 22 GHCND:USW00014895   330          S DLY-TMAX-NORMAL 2010-01-22
## 23 GHCND:USW00014895   331          S DLY-TMAX-NORMAL 2010-01-23
## 24 GHCND:USW00014895   332          S DLY-TMAX-NORMAL 2010-01-24
## 25 GHCND:USW00014895   333          S DLY-TMAX-NORMAL 2010-01-25
```


#### Plot data, super simple, but it's a start


```r
out <- noaa(datasetid = "NORMAL_DLY", stationid = "GHCND:USW00014895", datatypeid = "dly-tmax-normal")
noaa_plot(out)
```

![plot of chunk six](figure/six.png) 


### Plot data from many stations

#### Get table of all datasets

```r
noaa_datasets()
```

```
## $data
##            id                    name datacoverage    mindate    maxdate
## 1      ANNUAL        Annual Summaries         1.00 1831-02-01 2012-11-01
## 2       GHCND         Daily Summaries         1.00 1763-01-01 2013-11-19
## 3     GHCNDMS       Monthly Summaries         1.00 1763-01-01 2013-10-01
## 4     NEXRAD2         Nexrad Level II         0.95 1991-06-05 2013-11-19
## 5     NEXRAD3        Nexrad Level III         0.95 1994-05-20 2013-11-17
## 6  NORMAL_ANN Normals Annual/Seasonal         1.00 2010-01-01 2010-01-01
## 7  NORMAL_DLY           Normals Daily         1.00 2010-01-01 2010-12-31
## 8  NORMAL_HLY          Normals Hourly         1.00 2010-01-01 2010-12-31
## 9  NORMAL_MLY         Normals Monthly         1.00 2010-01-01 2010-12-01
## 10  PRECIP_15 Precipitation 15 Minute         0.25 1970-05-12 2013-03-01
## 11 PRECIP_HLY    Precipitation Hourly         1.00 1900-01-01 2013-03-01
## 
## $metadata
##   limit count offset
## 1    25    11      1
## 
## attr(,"class")
## [1] "noaa_datasets"
```


#### Search for GHCND stations within 500 km of a lat/long point, take 10 of them


```r
noaa_stations(datasetid = "GHCND", locationid = "FIPS:12017")
```

```
## $atts
## $atts$totalCount
## [1] 10
## 
## $atts$pageCount
## [1] 25
## 
## $atts$offset
## [1] 1
## 
## 
## $data
##                   id elevation                          name elevationUnit
## 2  GHCND:US1FLCT0002      36.9      INVERNESS 1.6 WSW, FL US        METERS
## 21 GHCND:US1FLCT0005      14.9      DUNNELLON 3.6 WSW, FL US        METERS
## 3  GHCND:US1FLCT0006       7.9  CRYSTAL RIVER 5.2 NNE, FL US        METERS
## 4  GHCND:US1FLCT0007      11.9  CRYSTAL RIVER 5.3 NNE, FL US        METERS
## 5  GHCND:US1FLCT0008      27.1  CRYSTAL RIVER 4.7 ESE, FL US        METERS
## 6  GHCND:US1FLCT0010      29.9 CITRUS SPRINGS 1.7 NNE, FL US        METERS
## 7  GHCND:US1FLCT0011      23.2         HERNANDO 1.6 N, FL US        METERS
## 8  GHCND:US1FLCT0012      34.4   CITRUS SPRINGS 1.7 E, FL US        METERS
## 9  GHCND:USC00084273       9.1             INGLIS 3 E, FL US        METERS
## 10 GHCND:USC00084289      12.2         INVERNESS 3 SE, FL US        METERS
##    datacoverage longitude    mindate latitude    maxdate
## 2        0.8905    -82.37 2007-09-28    28.83 2012-10-24
## 21       0.7928    -82.51 2007-11-09    29.04 2012-05-06
## 3        0.9616    -82.56 2007-10-01    28.97 2010-02-05
## 4        0.9928    -82.56 2007-10-11    28.97 2013-11-18
## 5        0.8815    -82.53 2008-04-13    28.87 2013-11-15
## 6        0.8308    -82.47 2008-10-11    29.02 2009-11-10
## 7        0.9933    -82.37 2009-05-19    28.93 2013-11-18
## 8        0.8209    -82.45 2012-05-01    29.00 2013-11-15
## 9        0.9542    -82.62 1948-08-01    29.03 1951-09-30
## 10       0.7951    -82.31 1899-02-01    28.80 2013-11-17
## 
## attr(,"class")
## [1] "noaa_stations"
```


### Get data category data and metadata


```r
noaa_datacats(locationid = "CITY:US390029")
```

```
## $atts
## $atts$totalCount
## [1] 37
## 
## $atts$pageCount
## [1] 25
## 
## $atts$offset
## [1] 1
## 
## 
## $data
##               id                  name
## 1         ANNAGR   Annual Agricultural
## 2          ANNDD    Annual Degree Days
## 3        ANNPRCP  Annual Precipitation
## 4        ANNTEMP    Annual Temperature
## 5          AUAGR   Autumn Agricultural
## 6           AUDD    Autumn Degree Days
## 7         AUPRCP  Autumn Precipitation
## 8         AUTEMP    Autumn Temperature
## 9           COMP              Computed
## 10       COMPAGR Computed Agricultural
## 11            DD           Degree Days
## 12 DUALPOLMOMENT      Dual-Pol Moments
## 13       ECHOTOP             Echo Tops
## 14   HYDROMETEOR      Hydrometeor Type
## 15         OTHER                 Other
## 16       OVERLAY               Overlay
## 17          PRCP         Precipitation
## 18  REFLECTIVITY          Reflectivity
## 19           SKY    Sky cover & clouds
## 20         SPAGR   Spring Agricultural
## 21          SPDD    Spring Degree Days
## 22        SPPRCP  Spring Precipitation
## 23        SPTEMP    Spring Temperature
## 24         SUAGR   Summer Agricultural
## 25          SUDD    Summer Degree Days
## 
## attr(,"class")
## [1] "noaa_datacats"
```

