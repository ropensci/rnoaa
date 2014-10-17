<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{ncdc workflow}
-->



NCDC workflow
======

This vignette is intended to demonstrate a workflow for using the NOAA NCDC data using the `ncdc*()` functions. It can be confusing to understand how to get at data you want - that's the motivation for this vignette. Other vignettes show more thorough and different examples for specific data sources.

Load `rnoaa` into the R session.


```r
library('rnoaa')
```

## The workflow

* Look for weather stations & get station id(s)
* Find out what type of data is available for those stations
* Search for climate data for stations (optionally specify type of data to get)

### Look for weather stations & get station id(s)



```r
ids <- ncdc_stations(locationid='FIPS:12017')$data$id[1:13]
id <- "GHCND:US1FLCT0002"
```

Just information for one station


```r
ncdc_stations(stationid = id)
#> $meta
#> NULL
#> 
#> $data
#>                  id elevation                     name elevationUnit
#> 1 GHCND:US1FLCT0002      36.9 INVERNESS 1.6 WSW, FL US        METERS
#>   datacoverage longitude    mindate latitude    maxdate
#> 1       0.9995    -82.37 2007-09-01    28.83 2012-10-24
#> 
#> attr(,"class")
#> [1] "ncdc_stations"
```


### Find out what type of data is available for those stations

There are various ways to look for data types available. First, __data categories__:


```r
ncdc_datacats(stationid = id)
#> $meta
#> $meta$totalCount
#> [1] 2
#> 
#> $meta$pageCount
#> [1] 25
#> 
#> $meta$offset
#> [1] 1
#> 
#> 
#> $data
#>     id          name
#> 1 COMP      Computed
#> 2 PRCP Precipitation
#> 
#> attr(,"class")
#> [1] "ncdc_datacats"
```

Another way is looking for __data sets__:


```r
ncdc_datasets(stationid = id)
#> $meta
#> $meta$limit
#> [1] 25
#> 
#> $meta$count
#> [1] 2
#> 
#> $meta$offset
#> [1] 1
#> 
#> 
#> $data
#>                    uid      id              name datacoverage    mindate
#> 1 gov.noaa.ncdc:C00861   GHCND   Daily Summaries            1 1763-01-01
#> 2 gov.noaa.ncdc:C00841 GHCNDMS Monthly Summaries            1 1763-01-01
#>      maxdate
#> 1 2014-10-15
#> 2 2014-09-01
#> 
#> attr(,"class")
#> [1] "ncdc_datasets"
```

Yet another way is looking for __data types__:


```r
ncdc_datatypes(datasetid = "GHCND", stationid = id)
#> $meta
#>   limit count offset
#> 1    25     2      1
#> 
#> $data
#>     id                         name datacoverage    mindate    maxdate
#> 1 PRCP Precipitation (tenths of mm)            1 1781-01-01 2014-10-15
#> 2 SNOW                Snowfall (mm)            1 1846-11-25 2014-10-15
#> 
#> attr(,"class")
#> [1] "ncdc_datatypes"
```

### Search for climate data for stations (optionally specify type of data to get)

Now that you know what kinds of data categories, data sets, and data types are available for your station you can search for data with any of those as filters.

Importantly, note that you have to specify three things in a call to the `ncdc` function:

* `datasetid`
* `startdate`
* `enddate`

Here, we are specifying the `datasetid`, `stationid`, `datatypeid`, `startdate`, and `enddate`


```r
ncdc(datasetid = "GHCND", stationid = id, datatypeid = "PRCP", startdate = "2012-10-01", enddate = "2013-01-01")
#> $meta
#> $meta$totalCount
#> [1] 22
#> 
#> $meta$pageCount
#> [1] 25
#> 
#> $meta$offset
#> [1] 1
#> 
#> 
#> $data
#>              station value datatype                date fl_m fl_q fl_so
#> 1  GHCND:US1FLCT0002    13     PRCP 2012-10-01T00:00:00               N
#> 2  GHCND:US1FLCT0002     3     PRCP 2012-10-02T00:00:00               N
#> 3  GHCND:US1FLCT0002    15     PRCP 2012-10-03T00:00:00               N
#> 4  GHCND:US1FLCT0002   142     PRCP 2012-10-04T00:00:00               N
#> 5  GHCND:US1FLCT0002   244     PRCP 2012-10-05T00:00:00               N
#> 6  GHCND:US1FLCT0002   655     PRCP 2012-10-06T00:00:00               N
#> 7  GHCND:US1FLCT0002    23     PRCP 2012-10-07T00:00:00               N
#> 8  GHCND:US1FLCT0002     0     PRCP 2012-10-08T00:00:00               N
#> 9  GHCND:US1FLCT0002     3     PRCP 2012-10-09T00:00:00               N
#> 10 GHCND:US1FLCT0002     0     PRCP 2012-10-10T00:00:00               N
#> 11 GHCND:US1FLCT0002     0     PRCP 2012-10-11T00:00:00               N
#> 12 GHCND:US1FLCT0002     0     PRCP 2012-10-12T00:00:00               N
#> 13 GHCND:US1FLCT0002     0     PRCP 2012-10-13T00:00:00               N
#> 14 GHCND:US1FLCT0002     0     PRCP 2012-10-14T00:00:00               N
#> 15 GHCND:US1FLCT0002     0     PRCP 2012-10-15T00:00:00               N
#> 16 GHCND:US1FLCT0002     0     PRCP 2012-10-16T00:00:00               N
#> 17 GHCND:US1FLCT0002     0     PRCP 2012-10-17T00:00:00               N
#> 18 GHCND:US1FLCT0002     0     PRCP 2012-10-18T00:00:00    T          N
#> 19 GHCND:US1FLCT0002     0     PRCP 2012-10-19T00:00:00               N
#> 20 GHCND:US1FLCT0002     0     PRCP 2012-10-20T00:00:00               N
#> 21 GHCND:US1FLCT0002     0     PRCP 2012-10-21T00:00:00               N
#> 22 GHCND:US1FLCT0002     0     PRCP 2012-10-24T00:00:00               N
#>    fl_t
#> 1      
#> 2      
#> 3      
#> 4      
#> 5      
#> 6      
#> 7      
#> 8      
#> 9      
#> 10     
#> 11     
#> 12     
#> 13     
#> 14     
#> 15     
#> 16     
#> 17     
#> 18     
#> 19     
#> 20     
#> 21     
#> 22     
#> 
#> attr(,"class")
#> [1] "ncdc_data"
```
