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
#> 1 PASO ROBLES MUNICIPAL AP, CA      35.6697     -120.6283   DDddddd
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
#> 1 PASO ROBLES MUNICIPAL AP, CA      35.6697     -120.6283   DDddddd
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
#>         .id latitude_rptd longitude_rptd latitude_dec longitude_dec
#> 1  30095009           6.2         -2.333          6.2        -2.333
#> 2  30095161         6.083           -.25        6.083         -0.25
#> 3  30095204         5.933          -.983        5.933        -0.983
#> 4  30095262         9.033         -2.483        9.033        -2.483
#> 5  30095272          7.75           -2.1         7.75          -2.1
#> 6  30095306        10.083         -2.508       10.083        -2.508
#> 7  30095319         9.557          -.863        9.557        -0.863
#> 8  30095440         5.783           .633        5.783         0.633
#> 9  30095471         4.867         -2.233        4.867        -2.233
#> 10 30095567           6.1           .117          6.1         0.117
#> 11 30095838         7.362         -2.329        7.362        -2.329
#> 12 30095905         5.617              0        5.617           0.0
#> 13 30095956          10.9           -1.1         10.9          -1.1
#> 14 30096063         7.817          -.033        7.817        -0.033
#> 15 30096177           6.6           .467          6.6         0.467
#> 16 30096242         5.605          -.167        5.605        -0.167
#> 17 30096313         6.715         -1.591        6.715        -1.591
#> 18 30096407         4.896         -1.775        4.896        -1.775
#> 19 30096986          5.85         -.1833         5.85       -0.1833
#> 20 30097966          5.55            -.2         5.55          -0.2
#> 21 30099309           9.4            -.9          9.4          -0.9
#> 22 30100184             5             -2          5.0          -2.0
#> 23 30100285          6.47            .33         6.47          0.33
#> 24 30100821           8.2            .57          8.2          0.57
#> 25 30104395           9.5           -.85          9.5         -0.85
#>    latitude_dms longitude_dms          date.beginDate
#> 1    06,12,00,N   002,19,59,W                 Unknown
#> 2    06,04,59,N   000,15,00,W                 Unknown
#> 3    05,55,59,N   000,58,59,W                 Unknown
#> 4    09,01,59,N   002,28,59,W                 Unknown
#> 5    07,45,00,N   002,06,00,W                 Unknown
#> 6    10,04,59,N   002,30,29,W                 Unknown
#> 7    09,33,25,N   000,51,47,W                 Unknown
#> 8    05,46,59,N   000,37,59,E                 Unknown
#> 9    04,52,01,N   002,13,59,W                 Unknown
#> 10   06,06,00,N   000,07,01,E                 Unknown
#> 11   07,21,43,N   002,19,44,W                 Unknown
#> 12   05,37,01,N   000,00,00,E                 Unknown
#> 13   10,54,00,N   001,06,00,W                 Unknown
#> 14   07,49,01,N   000,01,59,W                 Unknown
#> 15   06,36,00,N   000,28,01,E                 Unknown
#> 16   05,36,18,N   000,10,01,W                 Unknown
#> 17   06,42,54,N   001,35,28,W                 Unknown
#> 18   04,53,46,N   001,46,30,W                 Unknown
#> 19   05,51,00,N   000,11,00,W                 Unknown
#> 20   05,33,00,N   000,12,00,W                 Unknown
#> 21   09,24,00,N   000,54,00,W                 Unknown
#> 22   05,00,00,N   002,00,00,W                 Unknown
#> 23   06,28,12,N   000,19,48,E                 Unknown
#> 24   08,12,00,N   000,34,12,E                 Unknown
#> 25   09,30,00,N   000,51,00,W 1973-01-01T00:00:00.000
#>               date.endDate
#> 1                  Present
#> 2                  Present
#> 3                  Present
#> 4                  Present
#> 5                  Present
#> 6                  Present
#> 7                  Present
#> 8                  Present
#> 9                  Present
#> 10                 Present
#> 11                 Present
#> 12                 Present
#> 13                 Present
#> 14                 Present
#> 15                 Present
#> 16                 Present
#> 17                 Present
#> 18                 Present
#> 19                 Present
#> 20                 Present
#> 21                 Present
#> 22                 Present
#> 23                 Present
#> 24                 Present
#> 25 2008-12-31T00:00:00.000
```

By state and county


```r
res <- homr(state='NC', county='BUNCOMBE', headersOnly = TRUE)
head( ldply(res, "[[", "head") )
```

```
#>        .id            preferredName latitude_dec longitude_dec
#> 1 30077883    WEAVERVILLE 4.2 N, NC      35.7579      -82.5618
#> 2 30029796       FAIRVIEW 1.2 S, NC      35.5058      -82.4051
#> 3 30083542 BLACK MOUNTAIN 0.8 N, NC      35.6263      -82.3297
#> 4 20013839            LEICESTER, NC        35.65         -82.7
#> 5 20013817        SWANNANOA 2 E, NC         35.6     -82.36667
#> 6 20014046      SWANNANOA 2 SSE, NC     35.57333       -82.385
#>             por.beginDate             por.endDate precision
#> 1                 Unknown                 Present      <NA>
#> 2                 Unknown                 Present      <NA>
#> 3                 Unknown                 Present      <NA>
#> 4 1934-11-05T00:00:00.000 1962-03-31T00:00:00.000      DDMM
#> 5 1931-03-01T00:00:00.000 1987-08-26T00:00:00.000      DDMM
#> 6 1984-01-01T00:00:00.000 2008-03-31T00:00:00.000    DDMMSS
```

## Get header information only


```r
res <- homr(headersOnly=TRUE, state='DE')
head( ldply(res, "[[", "head") )
```

```
#>        .id           preferredName latitude_dec longitude_dec precision
#> 1 20004159     GEORGETOWN 5 SW, DE     38.63333        -75.45      DDMM
#> 2 30067636        LEWES 0.8 SE, DE      38.7731      -75.1385      <NA>
#> 3 30027455       DELMAR 2.8 NE, DE      38.4863      -75.5332      <NA>
#> 4 30075067 PRIME HOOK DELAWARE, DE      38.8333      -75.3333      <NA>
#> 5 20004158  REHOBOTH BEACH LBS, DE     38.61667     -75.06667      DDMM
#> 6 30039554    GREENWOOD 2.9 SE, DE      38.7731      -75.5616      <NA>
#>             por.beginDate             por.endDate
#> 1 1946-09-14T00:00:00.000 1997-06-01T00:00:00.000
#> 2                 Unknown                 Present
#> 3                 Unknown                 Present
#> 4                 Unknown                 Present
#> 5                 Unknown                 Present
#> 6                 Unknown                 Present
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
#> 6 MISCELLANEOUS IDENTIFIER THAT DOES NOT FALL INTO AN OFFICIALLY SOURCED CATEGORY AND IS NEEDED IN SUPPORT OF NCEI DATA PRODUCTS AND INGEST
#>   cssaName ghcndName
#> 1     <NA>      <NA>
#> 2     <NA>      <NA>
#> 3     <NA>      <NA>
#> 4     <NA>      <NA>
#> 5     <NA>      <NA>
#> 6     <NA>      <NA>
```
