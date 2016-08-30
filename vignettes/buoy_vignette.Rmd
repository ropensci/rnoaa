<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{buoy vignette}
%\VignetteEncoding{UTF-8}
-->



buoy vignette
======

This vignette covers NOAA buoy data from the National Buoy Data Center. The
main function to get data is `buoy`, while `buoys` can be used to
get the buoy IDs and web pages for each buoy.


```r
library('rnoaa')
```

## Find out what buoys are available in a dataset


```r
res <- buoys(dataset = "cwind")
```

Inspect the buoy ids, and the urls for them


```r
head(res)
```

```
#>      id
#> 1 41001
#> 2 41002
#> 3 41004
#> 4 41006
#> 5 41008
#> 6 41009
#>                                                                       url
#> 1 http://dods.ndbc.noaa.gov/thredds/catalog/data/cwind/41001/catalog.html
#> 2 http://dods.ndbc.noaa.gov/thredds/catalog/data/cwind/41002/catalog.html
#> 3 http://dods.ndbc.noaa.gov/thredds/catalog/data/cwind/41004/catalog.html
#> 4 http://dods.ndbc.noaa.gov/thredds/catalog/data/cwind/41006/catalog.html
#> 5 http://dods.ndbc.noaa.gov/thredds/catalog/data/cwind/41008/catalog.html
#> 6 http://dods.ndbc.noaa.gov/thredds/catalog/data/cwind/41009/catalog.html
```

Or browse them on the web


```r
browseURL(res[1, 2])
```

## Get buoy data

With `buoy` you can get data for a particular dataset, buoy id, year, and datatype. 

Get data for a buoy

> if no year or datatype specified, we get the first file


```r
buoy(dataset = 'cwind', buoyid = 46085)
```

```
#> Dimensions (rows/cols): [33486 X 5] 
#> 2 variables: [wind_dir, wind_spd] 
#> 
#>                    time    lat      lon wind_dir wind_spd
#> 1  2007-05-05T02:00:00Z 55.855 -142.559      331      2.8
#> 2  2007-05-05T02:10:00Z 55.855 -142.559      328      2.6
#> 3  2007-05-05T02:20:00Z 55.855 -142.559      329      2.2
#> 4  2007-05-05T02:30:00Z 55.855 -142.559      356      2.1
#> 5  2007-05-05T02:40:00Z 55.855 -142.559      360      1.5
#> 6  2007-05-05T02:50:00Z 55.855 -142.559       10      1.9
#> 7  2007-05-05T03:00:00Z 55.855 -142.559       10      2.2
#> 8  2007-05-05T03:10:00Z 55.855 -142.559       14      2.2
#> 9  2007-05-05T03:20:00Z 55.855 -142.559       16      2.1
#> 10 2007-05-05T03:30:00Z 55.855 -142.559       22      1.6
#> ..                  ...    ...      ...      ...      ...
```

Including year


```r
buoy(dataset = 'cwind', buoyid = 41001, year = 1999)
```

```
#> Dimensions (rows/cols): [52554 X 5] 
#> 2 variables: [wind_dir, wind_spd] 
#> 
#>                    time   lat    lon wind_dir wind_spd
#> 1  1999-01-01T00:00:00Z 34.68 -72.66      272     11.7
#> 2  1999-01-01T00:10:00Z 34.68 -72.66      260     11.0
#> 3  1999-01-01T00:20:00Z 34.68 -72.66      249      8.7
#> 4  1999-01-01T00:30:00Z 34.68 -72.66      247      8.4
#> 5  1999-01-01T00:40:00Z 34.68 -72.66      240      7.1
#> 6  1999-01-01T00:50:00Z 34.68 -72.66      242      7.9
#> 7  1999-01-01T01:00:00Z 34.68 -72.66      246      8.3
#> 8  1999-01-01T01:10:00Z 34.68 -72.66      297     10.9
#> 9  1999-01-01T01:20:00Z 34.68 -72.66      299     11.3
#> 10 1999-01-01T01:30:00Z 34.68 -72.66      299     11.1
#> ..                  ...   ...    ...      ...      ...
```

Including year and datatype


```r
buoy(dataset = 'cwind', buoyid = 41001, year = 2008, datatype = "cc")
```

```
#> Dimensions (rows/cols): [1585 X 5] 
#> 2 variables: [wind_dir, wind_spd] 
#> 
#>                    time    lat     lon wind_dir wind_spd
#> 1  2008-05-28T16:00:00Z 34.704 -72.734      230      8.6
#> 2  2008-05-28T16:10:00Z 34.704 -72.734      230      8.7
#> 3  2008-05-28T16:20:00Z 34.704 -72.734      229      8.5
#> 4  2008-05-28T16:30:00Z 34.704 -72.734      231      8.8
#> 5  2008-05-28T16:40:00Z 34.704 -72.734      236      8.5
#> 6  2008-05-28T16:50:00Z 34.704 -72.734      235      8.9
#> 7  2008-05-28T17:00:00Z 34.704 -72.734      233      8.2
#> 8  2008-05-28T17:10:00Z 34.704 -72.734      233      8.2
#> 9  2008-05-28T17:20:00Z 34.704 -72.734      231      8.3
#> 10 2008-05-28T17:30:00Z 34.704 -72.734      232      7.8
#> ..                  ...    ...     ...      ...      ...
```

Including just datatype


```r
buoy(dataset = 'cwind', buoyid = 41001, datatype = "cc")
```

```
#> Dimensions (rows/cols): [1585 X 5] 
#> 2 variables: [wind_dir, wind_spd] 
#> 
#>                    time    lat     lon wind_dir wind_spd
#> 1  2008-05-28T16:00:00Z 34.704 -72.734      230      8.6
#> 2  2008-05-28T16:10:00Z 34.704 -72.734      230      8.7
#> 3  2008-05-28T16:20:00Z 34.704 -72.734      229      8.5
#> 4  2008-05-28T16:30:00Z 34.704 -72.734      231      8.8
#> 5  2008-05-28T16:40:00Z 34.704 -72.734      236      8.5
#> 6  2008-05-28T16:50:00Z 34.704 -72.734      235      8.9
#> 7  2008-05-28T17:00:00Z 34.704 -72.734      233      8.2
#> 8  2008-05-28T17:10:00Z 34.704 -72.734      233      8.2
#> 9  2008-05-28T17:20:00Z 34.704 -72.734      231      8.3
#> 10 2008-05-28T17:30:00Z 34.704 -72.734      232      7.8
#> ..                  ...    ...     ...      ...      ...
```
