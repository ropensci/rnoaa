<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{HOMR metadata}
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
#> [67] "30094936"
```

By country


```r
res <- homr(country='GHANA', begindate='2005-01-01', enddate='2005-02-01')
library("plyr")
ldply(res, function(x) x$location$latlon)
```

```
#>         .id latitude_dec longitude_dec date.beginDate date.endDate
#> 1  30087748          9.1           0.0        Unknown      Present
#> 2  30087749         10.9          -1.1        Unknown      Present
#> 3  30087750        10.05          -2.5        Unknown      Present
#> 4  30087751         7.75          -2.1        Unknown      Present
#> 5  30087752       4.8667       -2.2333        Unknown      Present
#> 6  30087753         5.55          -0.2        Unknown      Present
#> 7  30087754         9.42         -0.88        Unknown      Present
#> 8  30087755         6.47          0.33        Unknown      Present
#> 9  30087756          5.6          -0.2        Unknown      Present
#> 10 30087757          5.0          -2.0        Unknown      Present
#> 11 30087758         5.85       -0.1833        Unknown      Present
#> 12 30087759         6.68         -1.62        Unknown      Present
#> 13 30087760          8.2          0.57        Unknown      Present
#> 14 30087761         4.88         -1.77        Unknown      Present
```

By state and county


```r
res <- homr(state='NC', county='BUNCOMBE', headersOnly = TRUE)
head( ldply(res, "[[", "head") )
```

```
#>        .id            preferredName latitude_dec longitude_dec precision
#> 1 20013818        BEETREE DAM 2, NC     35.63333         -82.4      DDMM
#> 2 20013838          BEETREE GAP, NC         35.7         -82.4      DDMM
#> 3 20014046      SWANNANOA 2 SSE, NC     35.57333       -82.385    DDMMSS
#> 4 30083542 BLACK MOUNTAIN 0.8 N, NC      35.6263      -82.3297      <NA>
#> 5 20013839            LEICESTER, NC        35.65         -82.7      DDMM
#> 6 30077883    WEAVERVILLE 4.2 N, NC      35.7579      -82.5618      <NA>
#>             por.beginDate             por.endDate
#> 1 1949-01-01T00:00:00.000 1962-03-31T00:00:00.000
#> 2 1948-08-01T00:00:00.000 1950-12-31T00:00:00.000
#> 3 1984-01-01T00:00:00.000 2008-03-31T00:00:00.000
#> 4                 Unknown                 Present
#> 5 1949-01-01T00:00:00.000 1962-03-31T00:00:00.000
#> 6                 Unknown                 Present
```

## Get header information only


```r
res <- homr(headersOnly=TRUE, state='DE')
head( ldply(res, "[[", "head") )
```

```
#>        .id                   preferredName latitude_dec longitude_dec
#> 1 20004159             GEORGETOWN 5 SW, DE     38.63333        -75.45
#> 2 30075067         PRIME HOOK DELAWARE, DE      38.8333      -75.3333
#> 3 20004158          REHOBOTH BEACH LBS, DE     38.61667     -75.06667
#> 4 30039554            GREENWOOD 2.9 SE, DE      38.7731      -75.5616
#> 5 30067636                LEWES 0.8 SE, DE      38.7731      -75.1385
#> 6 20004174 BRANDYWINE SHOALS LIGHT STN, DE     38.98333         -75.1
#>   precision           por.beginDate             por.endDate
#> 1      DDMM 1948-08-01T00:00:00.000 1997-06-01T00:00:00.000
#> 2      <NA>                 Unknown                 Present
#> 3      DDMM                 Unknown                 Present
#> 4      <NA>                 Unknown                 Present
#> 5      <NA>                 Unknown                 Present
#> 6      DDMM 1972-10-01T00:00:00.000 1973-04-30T00:00:00.000
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
#>                                                                                                                                 description
#> 1                                                                          GLOBAL HISTORICAL CLIMATOLOGY NETWORK - DAILY (GHCND) IDENTIFIER
#> 2                                                                                   NATIONAL WEATHER SERVICE COOPERATIVE NETWORK IDENTIFIER
#> 3                                                                                                       WEATHER-BUREAU-ARMY-NAVY IDENTIFIER
#> 4                                                                                                FEDERAL AVIATION ADMINISTRATION IDENTIFIER
#> 5                                                                                      INTERNATIONAL CIVIL AVIATION ORGANIZATION IDENTIFIER
#> 6 MISCELLANEOUS IDENTIFIER THAT DOES NOT FALL INTO AN OFFICIALLY SOURCED CATEGORY AND IS NEEDED IN SUPPORT OF NCDC DATA PRODUCTS AND INGEST
#>   cssaName ghcndName
#> 1     <NA>      <NA>
#> 2     <NA>      <NA>
#> 3     <NA>      <NA>
#> 4     <NA>      <NA>
#> 5     <NA>      <NA>
#> 6     <NA>      <NA>
```
