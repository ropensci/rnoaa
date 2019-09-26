<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{ncdc workflow}
%\VignetteEncoding{UTF-8}
-->



NCDC workflow
======

This vignette is intended to demonstrate a workflow for using the NOAA NCDC data using the `ncdc*()` functions. It can be confusing to understand how to get at data you want - that's the motivation for this vignette. Other vignettes show more thorough and different examples for specific data sources.


## Load rnoaa


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
#>   elevation    mindate    maxdate latitude                     name
#> 1      36.9 2007-09-01 2012-10-24  28.8303 INVERNESS 1.6 WSW, FL US
#>   datacoverage                id elevationUnit longitude
#> 1       0.9995 GHCND:US1FLCT0002        METERS  -82.3688
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
#>            name   id
#> 1      Computed COMP
#> 2 Precipitation PRCP
#> 
#> attr(,"class")
#> [1] "ncdc_datacats"
```

Another way is looking for __data sets__:


```r
ncdc_datasets(stationid = id)
#> $meta
#> $meta$offset
#> [1] 1
#> 
#> $meta$count
#> [1] 2
#> 
#> $meta$limit
#> [1] 25
#> 
#> 
#> $data
#>                    uid    mindate    maxdate                        name
#> 1 gov.noaa.ncdc:C00861 1763-01-01 2019-09-20             Daily Summaries
#> 2 gov.noaa.ncdc:C00946 1763-01-01 2019-08-01 Global Summary of the Month
#>   datacoverage    id
#> 1            1 GHCND
#> 2            1  GSOM
#> 
#> attr(,"class")
#> [1] "ncdc_datasets"
```

Yet another way is looking for __data types__:


```r
ncdc_datatypes(datasetid = "GHCND", stationid = id)
#> $meta
#>   offset count limit
#> 1      1     4    25
#> 
#> $data
#>      mindate    maxdate
#> 1 1832-05-11 2019-09-20
#> 2 1832-05-11 2019-09-20
#> 3 1781-01-01 2019-09-20
#> 4 1840-05-01 2019-09-20
#>                                                                  name
#> 1  Number of days included in the multiday precipitation total (MDPR)
#> 2 Multiday precipitation total (use with DAPR and DWPR, if available)
#> 3                                                       Precipitation
#> 4                                                            Snowfall
#>   datacoverage   id
#> 1            1 DAPR
#> 2            1 MDPR
#> 3            1 PRCP
#> 4            1 SNOW
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
#> # A tibble: 22 x 8
#>    date              datatype station         value fl_m  fl_q  fl_so fl_t 
#>    <chr>             <chr>    <chr>           <int> <chr> <chr> <chr> <chr>
#>  1 2012-10-01T00:00… PRCP     GHCND:US1FLCT0…    13 ""    ""    N     ""   
#>  2 2012-10-02T00:00… PRCP     GHCND:US1FLCT0…     3 ""    ""    N     ""   
#>  3 2012-10-03T00:00… PRCP     GHCND:US1FLCT0…    15 ""    ""    N     ""   
#>  4 2012-10-04T00:00… PRCP     GHCND:US1FLCT0…   142 ""    ""    N     ""   
#>  5 2012-10-05T00:00… PRCP     GHCND:US1FLCT0…   244 ""    ""    N     ""   
#>  6 2012-10-06T00:00… PRCP     GHCND:US1FLCT0…   655 ""    ""    N     ""   
#>  7 2012-10-07T00:00… PRCP     GHCND:US1FLCT0…    23 ""    ""    N     ""   
#>  8 2012-10-08T00:00… PRCP     GHCND:US1FLCT0…     0 ""    ""    N     ""   
#>  9 2012-10-09T00:00… PRCP     GHCND:US1FLCT0…     3 ""    ""    N     ""   
#> 10 2012-10-10T00:00… PRCP     GHCND:US1FLCT0…     0 ""    ""    N     ""   
#> # … with 12 more rows
#> 
#> attr(,"class")
#> [1] "ncdc_data"
```
