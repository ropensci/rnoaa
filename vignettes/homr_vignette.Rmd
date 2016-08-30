<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{HOMR metadata}
%\VignetteEncoding{UTF-8}
-->




HOMR metadata
======

`HOMR` (Historical Observing Metadata Repository) provides climate station metadata. It's a NOAA service.

Find out more about HOMR at [http://www.ncdc.noaa.gov/homr/](http://www.ncdc.noaa.gov/homr/) and the HOMR API at [http://www.ncdc.noaa.gov/homr/api](http://www.ncdc.noaa.gov/homr/api).

## Load rnoaa


```r
library('rnoaa')
```

## Search by station identifier

You can do this in various ways. Using the `qid` parameter (stands or qualified ID, as far as I know), you can search by suffix (e.g., `046742`), or both separated by a colon (e.g., `COOP:046742`). 

By station suffix


```r
res <- homr(qid = ':046742')
names(res)
```

```
#> [1] "20002078"
```

```r
names(res[['20002078']])
```

```
#>  [1] "id"          "head"        "namez"       "identifiers" "status"     
#>  [6] "platform"    "relocations" "remarks"     "updates"     "elements"   
#> [11] "location"
```

```r
res$`20002078`[1:3]
```

```
#> $id
#> [1] "20002078"
#> 
#> $head
#>                  preferredName latitude_dec longitude_dec precision
#> 1 PASO ROBLES MUNICIPAL AP, CA      35.6697     -120.6283    DDMMSS
#>             por.beginDate por.endDate
#> 1 1949-10-05T00:00:00.000     Present
#> 
#> $namez
#>                         name  nameType
#> 1   PASO ROBLES MUNICIPAL AP      COOP
#> 2   PASO ROBLES MUNICIPAL AP PRINCIPAL
#> 3 PASO ROBLES MUNICIPAL ARPT       PUB
```

By both


```r
res <- homr(qid = 'COOP:046742')
names(res)
```

```
#> [1] "20002078"
```

```r
names(res[['20002078']])
```

```
#>  [1] "id"          "head"        "namez"       "identifiers" "status"     
#>  [6] "platform"    "relocations" "remarks"     "updates"     "elements"   
#> [11] "location"
```

```r
res$`20002078`[1:5]
```

```
#> $id
#> [1] "20002078"
#> 
#> $head
#>                  preferredName latitude_dec longitude_dec precision
#> 1 PASO ROBLES MUNICIPAL AP, CA      35.6697     -120.6283    DDMMSS
#>             por.beginDate por.endDate
#> 1 1949-10-05T00:00:00.000     Present
#> 
#> $namez
#>                         name  nameType
#> 1   PASO ROBLES MUNICIPAL AP      COOP
#> 2   PASO ROBLES MUNICIPAL AP PRINCIPAL
#> 3 PASO ROBLES MUNICIPAL ARPT       PUB
#> 
#> $identifiers
#>      idType          id
#> 1     GHCND USW00093209
#> 2   GHCNMLT USW00093209
#> 3      COOP      046742
#> 4      WBAN       93209
#> 5       FAA         PRB
#> 6      ICAO        KPRB
#> 7     NWSLI         PRB
#> 8 NCDCSTNID    20002078
#> 
#> $status
#> NULL
```

## Search by station parameter

You can also search by station identifier, which is different from the `qid` above. 


```r
res <- homr(station=20002078)
names(res)
```

```
#> [1] "20002078"
```

```r
names(res[['20002078']])
```

```
#>  [1] "id"          "head"        "namez"       "identifiers" "status"     
#>  [6] "platform"    "relocations" "remarks"     "updates"     "elements"   
#> [11] "location"
```

```r
res$`20002078`[4:6]
```

```
#> $identifiers
#>      idType          id
#> 1     GHCND USW00093209
#> 2   GHCNMLT USW00093209
#> 3      COOP      046742
#> 4      WBAN       93209
#> 5       FAA         PRB
#> 6      ICAO        KPRB
#> 7     NWSLI         PRB
#> 8 NCDCSTNID    20002078
#> 
#> $status
#> NULL
#> 
#> $platform
#> [1] "COOP"
```

## Search by state and county

By state


```r
res <- homr(state='DE', begindate='2005-01-01', enddate='2005-02-01')
names(res)
```

```
#>  [1] "10001871" "10100161" "10100162" "10100164" "10100166" "20004155"
#>  [7] "20004158" "20004160" "20004162" "20004163" "20004167" "20004168"
#> [13] "20004171" "20004176" "20004178" "20004179" "20004180" "20004182"
#> [19] "20004184" "20004185" "30001464" "30001561" "30001831" "30017384"
#> [25] "30020917" "30021161" "30021998" "30022674" "30026770" "30027455"
#> [31] "30032423" "30032685" "30034222" "30039554" "30043742" "30046662"
#> [37] "30046814" "30051475" "30057217" "30063570" "30064900" "30065901"
#> [43] "30067636" "30069663" "30075067" "30077378" "30077857" "30077923"
#> [49] "30077988" "30079088" "30079240" "30082430" "30084216" "30084262"
#> [55] "30084537" "30084796" "30094582" "30094639" "30094664" "30094670"
#> [61] "30094683" "30094730" "30094806" "30094830" "30094917" "30094931"
#> [67] "30094936" "30101120" "30101186" "30101294" "30101341" "30101363"
#> [73] "30101370" "30102005"
```

By country


```r
res <- homr(country='GHANA', begindate='2005-01-01', enddate='2005-02-01')
library("plyr")
ldply(res, function(x) x$location$latlon)
```

```
#>         .id latitude_dec longitude_dec          date.beginDate            date.endDate
#> 1  30095009          6.2        -2.333                 Unknown                 Present
#> 2  30095161        6.083         -0.25                 Unknown                 Present
#> 3  30095204        5.933        -0.983                 Unknown                 Present
#> 4  30095262        9.033        -2.483                 Unknown                 Present
#> 5  30095272         7.75          -2.1                 Unknown                 Present
#> 6  30095306       10.083        -2.508                 Unknown                 Present
#> 7  30095319        9.557        -0.863                 Unknown                 Present
#> 8  30095440        5.783         0.633                 Unknown                 Present
#> 9  30095471        4.867        -2.233                 Unknown                 Present
#> 10 30095567          6.1         0.117                 Unknown                 Present
#> 11 30095838        7.362        -2.329                 Unknown                 Present
#> 12 30095905        5.617           0.0                 Unknown                 Present
#> 13 30095956         10.9          -1.1                 Unknown                 Present
#> 14 30096063        7.817        -0.033                 Unknown                 Present
#> 15 30096177          6.6         0.467                 Unknown                 Present
#> 16 30096242        5.605        -0.167                 Unknown                 Present
#> 17 30096313        6.715        -1.591                 Unknown                 Present
#> 18 30096407        4.896        -1.775                 Unknown                 Present
#> 19 30096986         5.85       -0.1833                 Unknown                 Present
#> 20 30097966         5.55          -0.2                 Unknown                 Present
#> 21 30099309          9.4          -0.9                 Unknown                 Present
#> 22 30100184          5.0          -2.0                 Unknown                 Present
#> 23 30100285         6.47          0.33                 Unknown                 Present
#> 24 30100821          8.2          0.57                 Unknown                 Present
#> 25 30104395          9.5         -0.85 1973-01-01T00:00:00.000 2008-12-31T00:00:00.000
```

By state and county


```r
res <- homr(state='NC', county='BUNCOMBE', headersOnly = TRUE)
head( ldply(res, "[[", "head") )
```

```
#>        .id            preferredName latitude_dec longitude_dec por.beginDate por.endDate precision
#> 1 30083542 BLACK MOUNTAIN 0.8 N, NC      35.6263      -82.3297       Unknown     Present      <NA>
#> 2 30077883    WEAVERVILLE 4.2 N, NC      35.7579      -82.5618       Unknown     Present      <NA>
#> 3 30029796       FAIRVIEW 1.2 S, NC      35.5058      -82.4051       Unknown     Present      <NA>
#> 4 30061838    ASHEVILLE 4.2 ESE, NC        35.55        -82.48       Unknown     Present      <NA>
#> 5 30093502        ARDEN 2.8 WSW, NC      35.4589      -82.5652       Unknown     Present      <NA>
#> 6 30103070    ASHEVILLE 1.1 NNE, NC       35.589      -82.5428       Unknown     Present      <NA>
```

## Get header information only


```r
res <- homr(headersOnly=TRUE, state='DE')
head( ldply(res, "[[", "head") )
```

```
#>        .id                   preferredName latitude_dec longitude_dec precision           por.beginDate             por.endDate
#> 1 10001871 WILMINGTON NEW CASTLE CO AP, DE      39.6728      -75.6008    DDMMSS 1929-06-01T00:00:00.000                 Present
#> 2 10013243              NEW CASTLE AAB, DE     39.68333     -75.58333      DDMM 1942-08-01T00:00:00.000 1957-07-31T00:00:00.000
#> 3 10100160            BRIDGEVILLE 1 NW, DE        38.75     -75.61667      DDMM 1890-01-01T00:00:00.000 1985-12-31T00:00:00.000
#> 4 10100161               GREENWOOD 2NE, DE      38.8161      -75.5761    DDMMSS 1986-01-01T00:00:00.000 2010-08-04T00:00:00.000
#> 5 10100162                       DOVER, DE      39.1467      -75.5055    DDMMSS 1870-07-01T00:00:00.000                 Present
#> 6 10100163                MILFORD 2 SE, DE      38.8983       -75.425    DDMMSS 1857-12-01T00:00:00.000 2004-06-25T00:00:00.000
```

## Data definitions

The data returned is the same format for all, so a separate function is provided to get metadata. The function `homr_definitions()` does query the HOMR API, so does get updated metadata - i.e., it's not a static dataset stored locally. 


```r
head( homr_definitions() )
```

```
#>   defType  abbr                fullName    displayName
#> 1     ids GHCND        GHCND IDENTIFIER       GHCND ID
#> 2     ids  COOP             COOP NUMBER        COOP ID
#> 3     ids  WBAN             WBAN NUMBER        WBAN ID
#> 4     ids   FAA FAA LOCATION IDENTIFIER         FAA ID
#> 5     ids  ICAO                 ICAO ID        ICAO ID
#> 6     ids TRANS          TRANSMITTAL ID Transmittal ID
#>                                                                                                                                 description cssaName
#> 1                                                                          GLOBAL HISTORICAL CLIMATOLOGY NETWORK - DAILY (GHCND) IDENTIFIER     <NA>
#> 2                                                                                   NATIONAL WEATHER SERVICE COOPERATIVE NETWORK IDENTIFIER     <NA>
#> 3                                                                                                       WEATHER-BUREAU-ARMY-NAVY IDENTIFIER     <NA>
#> 4                                                                                                FEDERAL AVIATION ADMINISTRATION IDENTIFIER     <NA>
#> 5                                                                                      INTERNATIONAL CIVIL AVIATION ORGANIZATION IDENTIFIER     <NA>
#> 6 MISCELLANEOUS IDENTIFIER THAT DOES NOT FALL INTO AN OFFICIALLY SOURCED CATEGORY AND IS NEEDED IN SUPPORT OF NCDC DATA PRODUCTS AND INGEST     <NA>
#>   ghcndName
#> 1      <NA>
#> 2      <NA>
#> 3      <NA>
#> 4      <NA>
#> 5      <NA>
#> 6      <NA>
```
