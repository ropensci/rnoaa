<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{SWDI vignette}
%\VignetteEncoding{UTF-8}
-->



SWDI vignette
======

`SWDI` is the Severe Weather Data Inventory. SWDI is an (quoting)

> integrated database of severe weather records for the United States. The records in SWDI come from a variety of sources in the NCDC archive. SWDI provides the ability to search through all of these data to find records covering a particular time period and geographic region, and to download the results of your search in a variety of formats. The formats currently supported are Shapefile (for GIS), KMZ (for Google Earth), CSV (comma-separated), and XML.

Data available in SWDI are:

* Storm Cells from NEXRAD (Level-III Storm Structure Product)
* Hail Signatures from NEXRAD (Level-III Hail Product)
* Mesocyclone Signatures from NEXRAD (Level-III Meso Product)
* Digital Mesocyclone Detection Algorithm from NEXRAD (Level-III MDA Product)
* Tornado Signatures from NEXRAD (Level-III TVS Product)
* Preliminary Local Storm Reports from the NOAA National Weather Service
* Lightning Strikes from Vaisala NLDN

Find out more about SWDI at [http://www.ncdc.noaa.gov/swdi/#Intro](http://www.ncdc.noaa.gov/swdi/#Intro).


## Load rnoaa


```r
library('rnoaa')
library('plyr')
```

## Search for nx3tvs data from 5 May 2006 to 6 May 2006


```r
swdi(dataset='nx3tvs', startdate='20060505', enddate='20060506')
#> $meta
#> $meta$totalCount
#> numeric(0)
#> 
#> $meta$totalTimeInSeconds
#> [1] 0.105
#> 
#> 
#> $data
#>                   ztime wsr_id cell_id cell_type range azimuth max_shear
#> 1  2006-05-05T00:05:50Z   KBMX      Q0       TVS     7     217       403
#> 2  2006-05-05T00:10:02Z   KBMX      Q0       TVS     5     208       421
#> 3  2006-05-05T00:12:34Z   KSJT      P2       TVS    49     106        17
#> 4  2006-05-05T00:17:31Z   KSJT      B4       TVS    40     297        25
#> 5  2006-05-05T00:29:13Z   KMAF      H4       TVS    53     333        34
#> 6  2006-05-05T00:31:25Z   KLBB      N0       TVS    51     241        24
#> 7  2006-05-05T00:33:25Z   KMAF      H4       TVS    52     334        46
#> 8  2006-05-05T00:37:37Z   KMAF      H4       TVS    50     334        34
#> 9  2006-05-05T00:41:51Z   KMAF      H4       TVS    51     335        29
#> 10 2006-05-05T00:44:33Z   KLBB      N0       TVS    46     245        35
#> 11 2006-05-05T00:46:03Z   KMAF      H4       TVS    49     335        41
#> 12 2006-05-05T00:48:55Z   KLBB      N0       TVS    44     246        44
#> 13 2006-05-05T00:50:16Z   KMAF      H4       TVS    49     337        33
#> 14 2006-05-05T00:54:29Z   KMAF      H4       TVS    47     337        42
#> 15 2006-05-05T00:57:42Z   KLBB      N0       TVS    41     251        46
#> 16 2006-05-05T00:58:41Z   KMAF      H4       TVS    46     340        29
#> 17 2006-05-05T01:02:04Z   KLBB      N0       TVS    39     251        42
#> 18 2006-05-05T01:02:53Z   KMAF      H4       TVS    46     339        35
#> 19 2006-05-05T01:02:53Z   KMAF      H4       TVS    50     338        27
#> 20 2006-05-05T01:06:26Z   KLBB      N0       TVS    36     251        31
#> 21 2006-05-05T01:07:06Z   KMAF      F5       TVS    45     342        44
#> 22 2006-05-05T01:10:48Z   KLBB      N0       TVS    36     256        37
#> 23 2006-05-05T01:11:18Z   KMAF      F5       TVS    45     343        39
#> 24 2006-05-05T01:15:30Z   KMAF      F5       TVS    44     344        30
#> 25 2006-05-05T01:15:30Z   KMAF      H4       TVS    49     341        26
#>    mxdv
#> 1   116
#> 2   120
#> 3    52
#> 4    62
#> 5   111
#> 6    78
#> 7   145
#> 8   107
#> 9    91
#> 10  100
#> 11  127
#> 12  121
#> 13   98
#> 14  126
#> 15  117
#> 16   85
#> 17  102
#> 18  101
#> 19   84
#> 20   70
#> 21  120
#> 22   83
#> 23  108
#> 24   78
#> 25   81
#> 
#> $shape
#>                                         shape
#> 1  POINT (-86.8535716274277 33.0786326913943)
#> 2  POINT (-86.8165772540846 33.0982820681588)
#> 3  POINT (-99.5771091971025 31.1421609654838)
#> 4   POINT (-101.188161700093 31.672392833416)
#> 5  POINT (-102.664426480293 32.7306917937698)
#> 6   POINT (-102.70047613441 33.2380072329615)
#> 7    POINT (-102.6393683028 32.7226656893341)
#> 8  POINT (-102.621904684258 32.6927081076156)
#> 9   POINT (-102.614794815627 32.714139844846)
#> 10 POINT (-102.643380529494 33.3266446067682)
#> 11 POINT (-102.597961935071 32.6839260102062)
#> 12 POINT (-102.613894688178 33.3526192273658)
#> 13 POINT (-102.567153417051 32.6956373348052)
#> 14  POINT (-102.551596970251 32.664939580306)
#> 15 POINT (-102.586119971014 33.4287323151248)
#> 16 POINT (-102.499638479193 32.6644438090742)
#> 17   POINT (-102.5485490063 33.4398330734778)
#> 18  POINT (-102.51446954228 32.6597119240996)
#> 19 POINT (-102.559031583693 32.7166090376869)
#> 20 POINT (-102.492174522228 33.4564626989719)
#> 21 POINT (-102.463540844324 32.6573739036181)
#> 22 POINT (-102.510349454162 33.5066366303981)
#> 23 POINT (-102.448763863447 32.6613484943994)
#> 24   POINT (-102.42842159557 32.649061124799)
#> 25 POINT (-102.504158884526 32.7162751126854)
#> 
#> attr(,"class")
#> [1] "swdi"
```

## Use an id


```r
out <- swdi(dataset='warn', startdate='20060506', enddate='20060507', id=533623)
list(out$meta, head(out$data), head(out$shape))
#> [[1]]
#> [[1]]$totalCount
#> numeric(0)
#> 
#> [[1]]$totalTimeInSeconds
#> [1] 3.465
#> 
#> 
#> [[2]]
#>            ztime_start            ztime_end     id         warningtype
#> 1 2006-05-05T22:53:00Z 2006-05-06T00:00:00Z 397428 SEVERE THUNDERSTORM
#> 2 2006-05-05T22:55:00Z 2006-05-06T00:00:00Z 397429 SEVERE THUNDERSTORM
#> 3 2006-05-05T22:55:00Z 2006-05-06T00:00:00Z 397430 SEVERE THUNDERSTORM
#> 4 2006-05-05T22:57:00Z 2006-05-06T00:00:00Z 397431 SEVERE THUNDERSTORM
#> 5 2006-05-05T23:03:00Z 2006-05-06T00:00:00Z 397434 SEVERE THUNDERSTORM
#> 6 2006-05-05T23:14:00Z 2006-05-06T00:15:00Z 397437 SEVERE THUNDERSTORM
#>   issuewfo messageid
#> 1     KLCH    052252
#> 2     KLUB    052256
#> 3     KLUB    052256
#> 4     KMAF    052258
#> 5     KMAF    052305
#> 6     KLUB    052315
#> 
#> [[3]]
#>                                                                                                                                                          shape
#> 1                                                                             POLYGON ((-93.27 30.38, -93.29 30.18, -93.02 30.18, -93.04 30.37, -93.27 30.38))
#> 2                                                                        POLYGON ((-101.93 34.74, -101.96 34.35, -101.48 34.42, -101.49 34.74, -101.93 34.74))
#> 3                POLYGON ((-100.36 33.03, -99.99 33.3, -99.99 33.39, -100.28 33.39, -100.5 33.18, -100.51 33.02, -100.45 32.97, -100.37 33.03, -100.36 33.03))
#> 4                                            POLYGON ((-102.8 30.74, -102.78 30.57, -102.15 30.61, -102.15 30.66, -101.92 30.68, -102.07 30.83, -102.8 30.74))
#> 5                                                                        POLYGON ((-103.02 32.94, -103.03 32.66, -102.21 32.53, -102.22 32.95, -103.02 32.94))
#> 6 POLYGON ((-101.6 33.32, -101.57 33.31, -101.57 33.51, -101.65 33.51, -101.66 33.5, -101.75 33.5, -101.77 33.49, -101.84 33.49, -101.84 33.32, -101.6 33.32))
```

## Get all 'plsr' within the bounding box (-91,30,-90,31)


```r
swdi(dataset='plsr', startdate='20060505', enddate='20060510', bbox=c(-91,30,-90,31))
#> $meta
#> $meta$totalCount
#> numeric(0)
#> 
#> $meta$totalTimeInSeconds
#> [1] 0
#> 
#> 
#> $data
#>                  ztime     id        event magnitude            city
#> 1 2006-05-09T02:20:00Z 427540         HAIL         1    5 E KENTWOOD
#> 2 2006-05-09T02:40:00Z 427536         HAIL         1    MOUNT HERMAN
#> 3 2006-05-09T02:40:00Z 427537 TSTM WND DMG     -9999    MOUNT HERMAN
#> 4 2006-05-09T03:00:00Z 427199         HAIL         0     FRANKLINTON
#> 5 2006-05-09T03:17:00Z 427200      TORNADO     -9999 5 S FRANKLINTON
#>       county state          source
#> 1 TANGIPAHOA    LA TRAINED SPOTTER
#> 2 WASHINGTON    LA TRAINED SPOTTER
#> 3 WASHINGTON    LA TRAINED SPOTTER
#> 4 WASHINGTON    LA   AMATEUR RADIO
#> 5 WASHINGTON    LA LAW ENFORCEMENT
#> 
#> $shape
#>                  shape
#> 1 POINT (-90.43 30.93)
#> 2  POINT (-90.3 30.96)
#> 3  POINT (-90.3 30.96)
#> 4 POINT (-90.14 30.85)
#> 5 POINT (-90.14 30.78)
#> 
#> attr(,"class")
#> [1] "swdi"
```

## Get all 'nx3tvs' within the tile -102.1/32.6 (-102.15,32.55,-102.25,32.65)


```r
swdi(dataset='nx3tvs', startdate='20060506', enddate='20060507', tile=c(-102.12,32.62))
#> $meta
#> $meta$totalCount
#> numeric(0)
#> 
#> $meta$totalTimeInSeconds
#> [1] 0.001
#> 
#> 
#> $data
#>                  ztime wsr_id cell_id cell_type range azimuth max_shear
#> 1 2006-05-06T00:41:29Z   KMAF      D9       TVS    37       6        39
#> 2 2006-05-06T03:56:18Z   KMAF      N4       TVS    39       3        30
#> 3 2006-05-06T03:56:18Z   KMAF      N4       TVS    42       4        20
#> 4 2006-05-06T04:00:30Z   KMAF      N4       TVS    38       5        35
#> 5 2006-05-06T04:04:44Z   KMAF      N4       TVS    41       8        24
#>   mxdv
#> 1   85
#> 2   73
#> 3   52
#> 4   86
#> 5   62
#> 
#> $shape
#>                                        shape
#> 1 POINT (-102.112726356403 32.5574494581267)
#> 2  POINT (-102.14873079873 32.5933553250156)
#> 3 POINT (-102.131167022161 32.6426287452898)
#> 4 POINT (-102.123671677514 32.5751241756203)
#> 5 POINT (-102.076389686189 32.6209390786829)
#> 
#> attr(,"class")
#> [1] "swdi"
```

## Counts

Notes:

* stat='count' will only return metadata, nothing in the data or shape slots
* stat='tilesum:...' returns counts in the data slot for each date for that tile, and shape data
* Get number of 'nx3tvs' within 15 miles of latitude = 32.7 and longitude = -102.0

Get daily count nx3tvs features on .1 degree grid centered at `latitude = 32.7` and `longitude = -102.0`


```r
swdi(dataset='nx3tvs', startdate='20060505', enddate='20090516', stat='tilesum:-102.0,32.7')
#> $meta
#> $meta$totalCount
#> numeric(0)
#> 
#> $meta$totalTimeInSeconds
#> [1] 0.001
#> 
#> 
#> $data
#>          day centerlat centerlon fcount
#> 1 2007-09-07      32.7      -102      1
#> 2 2008-05-27      32.7      -102      4
#> 3 2009-04-11      32.7      -102      1
#> 4 2007-03-29      32.7      -102      2
#> 5 2008-06-20      32.7      -102      2
#> 
#> $shape
#>                                                                                   shape
#> 1 POLYGON ((-102.05 32.65, -102.05 32.75, -101.95 32.75, -101.95 32.65, -102.05 32.65))
#> 2 POLYGON ((-102.05 32.65, -102.05 32.75, -101.95 32.75, -101.95 32.65, -102.05 32.65))
#> 3 POLYGON ((-102.05 32.65, -102.05 32.75, -101.95 32.75, -101.95 32.65, -102.05 32.65))
#> 4 POLYGON ((-102.05 32.65, -102.05 32.75, -101.95 32.75, -101.95 32.65, -102.05 32.65))
#> 5 POLYGON ((-102.05 32.65, -102.05 32.75, -101.95 32.75, -101.95 32.65, -102.05 32.65))
#> 
#> attr(,"class")
#> [1] "swdi"
```

## Get data in different formats

### CSV format


```r
head(swdi(dataset='nx3tvs', startdate='20060505', enddate='20060506', format='csv')$data)
#>                  ztime wsr_id cell_id cell_type range azimuth max_shear
#> 1 2006-05-05T00:05:50Z   KBMX      Q0       TVS     7     217       403
#> 2 2006-05-05T00:10:02Z   KBMX      Q0       TVS     5     208       421
#> 3 2006-05-05T00:12:34Z   KSJT      P2       TVS    49     106        17
#> 4 2006-05-05T00:17:31Z   KSJT      B4       TVS    40     297        25
#> 5 2006-05-05T00:29:13Z   KMAF      H4       TVS    53     333        34
#> 6 2006-05-05T00:31:25Z   KLBB      N0       TVS    51     241        24
#>   mxdv    lat      lon
#> 1  116 33.079  -86.854
#> 2  120 33.098  -86.817
#> 3   52 31.142  -99.577
#> 4   62 31.672 -101.188
#> 5  111 32.731 -102.664
#> 6   78 33.238 -102.700
```

### SHP format


```r
swdi(dataset='nx3tvs', startdate='20060505', enddate='20060506', format='shp', filepath='myfile')
```

### KMZ format


```r
swdi(dataset='nx3tvs', startdate='20060505', enddate='20060506', format='kmz', radius=15, filepath='myfile.kmz')
```
