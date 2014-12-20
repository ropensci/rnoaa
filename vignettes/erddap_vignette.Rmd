<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{ERDDAP vignette}
-->



ERDDAP vignette
======

ERDDAP gives a simple, consistent way to download subsets of gridded and tabular scientific datasets in common file formats and make graphs and maps. This ERDDAP installation has oceanographic data (for example, data from satellites and buoys).

Find out more about ERDDAP at [http://coastwatch.pfeg.noaa.gov/erddap/index.html](http://coastwatch.pfeg.noaa.gov/erddap/index.html).

## Load rnoaa


```r
library('rnoaa')
```

## Passing the datasetid without fields gives all columns back


```r
erddap_table('erdCalCOFIfshsiz')
#> <NOAA ERDDAP tabledap> erdCalCOFIfshsiz
#>    Path: [/Users/sacmac/.rnoaa/erddap/f18cc75d8bf5ca831a96f42486a7bd5d.csv]
#>    Last updated: [2014-12-19 15:47:55]
#>    File size:    [4.6 MB]
#>    Dimensions:   [20939 X 24]
#> 
#>    cruise               ship ship_code order_occupied   tow_type net_type
#> 2  199104 DAVID STARR JORDAN        JD              1 MOCNESS_1m       M1
#> 3  199104 DAVID STARR JORDAN        JD              2 MOCNESS_1m       M1
#> 4  199104 DAVID STARR JORDAN        JD              2 MOCNESS_1m       M1
#> 5  199104 DAVID STARR JORDAN        JD              2 MOCNESS_1m       M1
#> 6  199104 DAVID STARR JORDAN        JD              4 MOCNESS_1m       M1
#> 7  199104 DAVID STARR JORDAN        JD              5 MOCNESS_1m       M1
#> 8  199104 DAVID STARR JORDAN        JD              6 MOCNESS_1m       M1
#> 9  199104 DAVID STARR JORDAN        JD              7 MOCNESS_1m       M1
#> 10 199104 DAVID STARR JORDAN        JD             11 MOCNESS_1m       M1
#> 11 199104 DAVID STARR JORDAN        JD             32 MOCNESS_1m       M1
#> ..    ...                ...       ...            ...        ...      ...
#> Variables not shown: tow_number (int), net_location (chr),
#>      standard_haul_factor (dbl), volume_sampled (chr), percent_sorted
#>      (chr), sample_quality (dbl), latitude (chr), longitude (chr), line
#>      (dbl), station (dbl), time (chr), scientific_name (chr), common_name
#>      (chr), itis_tsn (int), calcofi_species_code (int), fish_size (chr),
#>      fish_count (dbl), fish_1000m3 (chr)
```

## Pass time constraints


```r
erddap_table('erdCalCOFIfshsiz', 'time>=2001-07-07', 'time<=2001-07-08')
#> <NOAA ERDDAP tabledap> erdCalCOFIfshsiz
#>    Path: [/Users/sacmac/.rnoaa/erddap/9e5119eb5c8ed63b9619be1367b0344c.csv]
#>    Last updated: [2014-12-19 18:07:32]
#>    File size:    [0.05 MB]
#>    Dimensions:   [217 X 24]
#> 
#>    cruise               ship ship_code order_occupied    tow_type net_type
#> 2  200106 DAVID STARR JORDAN        JD             43 MOCNESS_10m       M2
#> 3  200106 DAVID STARR JORDAN        JD             43 MOCNESS_10m       M2
#> 4  200106 DAVID STARR JORDAN        JD             43 MOCNESS_10m       M2
#> 5  200106 DAVID STARR JORDAN        JD             43 MOCNESS_10m       M2
#> 6  200106 DAVID STARR JORDAN        JD             43 MOCNESS_10m       M2
#> 7  200106 DAVID STARR JORDAN        JD             43 MOCNESS_10m       M2
#> 8  200106 DAVID STARR JORDAN        JD             43 MOCNESS_10m       M2
#> 9  200106 DAVID STARR JORDAN        JD             43 MOCNESS_10m       M2
#> 10 200106 DAVID STARR JORDAN        JD             43 MOCNESS_10m       M2
#> 11 200106 DAVID STARR JORDAN        JD             43 MOCNESS_10m       M2
#> ..    ...                ...       ...            ...         ...      ...
#> Variables not shown: tow_number (int), net_location (chr),
#>      standard_haul_factor (dbl), volume_sampled (chr), percent_sorted
#>      (chr), sample_quality (dbl), latitude (chr), longitude (chr), line
#>      (dbl), station (dbl), time (chr), scientific_name (chr), common_name
#>      (chr), itis_tsn (int), calcofi_species_code (int), fish_size (chr),
#>      fish_count (dbl), fish_1000m3 (chr)
```

## Pass in fields (i.e., columns to retrieve) & time constraints


```r
erddap_table('erdCalCOFIfshsiz', fields=c('longitude','latitude','fish_size','itis_tsn'), 'time>=2001-07-07','time<=2001-07-10')
#> <NOAA ERDDAP tabledap> erdCalCOFIfshsiz
#>    Path: [/Users/sacmac/.rnoaa/erddap/7b04d4ddfe4ad3540ec6213129fa050c.csv]
#>    Last updated: [2014-12-19 18:07:47]
#>    File size:    [0.02 MB]
#>    Dimensions:   [558 X 4]
#> 
#>     longitude  latitude fish_size itis_tsn
#> 2     -118.26    33.255      22.9   623745
#> 3     -118.26    33.255      22.9   623745
#> 4  -118.10667 32.738335      31.5   623625
#> 5  -118.10667 32.738335      48.3   623625
#> 6  -118.10667 32.738335      15.5   162221
#> 7  -118.10667 32.738335      16.3   162221
#> 8  -118.10667 32.738335      17.8   162221
#> 9  -118.10667 32.738335      18.2   162221
#> 10 -118.10667 32.738335      19.2   162221
#> 11 -118.10667 32.738335      20.0   162221
#> ..        ...       ...       ...      ...
```


```r
erddap_table('erdCinpKfmBT', fields=c('latitude','longitude','Aplysia_californica_Mean_Density','Muricea_californica_Mean_Density'), 'time>=2007-06-24','time<=2007-07-01')
#> <NOAA ERDDAP tabledap> erdCinpKfmBT
#>    Path: [/Users/sacmac/.rnoaa/erddap/681451f3fee8ee9e426012609975a89e.csv]
#>    Last updated: [2014-12-19 18:08:22]
#>    File size:    [1.49 KB]
#>    Dimensions:   [37 X 4]
#> 
#>            latitude         longitude Aplysia_californica_Mean_Density
#> 2              34.0 -119.416666666667                      0.009722223
#> 3              34.0 -119.383333333333                              0.0
#> 4              34.0 -119.366666666667                              0.0
#> 5              34.0 -119.383333333333                             0.16
#> 6              34.0 -119.416666666667                             0.03
#> 7  34.0166666666667           -119.35                              0.0
#> 8              34.0           -119.35                      0.008333334
#> 9              33.0 -118.533333333333                              NaN
#> 10            32.95 -118.533333333333                              NaN
#> 11             32.8            -118.4                              NaN
#> ..              ...               ...                              ...
#> Variables not shown: Muricea_californica_Mean_Density (chr)
```

## An example workflow

Search for data


```r
(out <- erddap_search(query='size'))
#> 6 results, showing first 20 
#>                                                            title
#> 11               NOAA Global Coral Bleaching Monitoring Products
#> 12        Coawst 4 use, Best Time Series [time][eta_rho][xi_rho]
#> 13            Coawst 4 use, Best Time Series [time][eta_u][xi_u]
#> 14            Coawst 4 use, Best Time Series [time][eta_v][xi_v]
#> 15 Coawst 4 use, Best Time Series [time][s_rho][eta_rho][xi_rho]
#> 16  Coawst 4 use, Best Time Series [time][Nbed][eta_rho][xi_rho]
#>             dataset_id
#> 11            NOAA_DHW
#> 12 whoi_ed12_89ce_9592
#> 13 whoi_61c3_0b5d_cd61
#> 14 whoi_62d0_9d64_c8ff
#> 15 whoi_7dd7_db97_4bbe
#> 16 whoi_a4fb_2c9c_16a7
```

Or, list datasets


```r
tdp <- erddap_datasets('table')
```

Using a datasetid, search for information on a datasetid


```r
id <- as.character(tdp$Dataset.ID[8])
erddap_info(id)$variables
#>               variable_name data_type     actual_range
#> 1                      cndc     float                 
#> 2             cndc_adjusted     float                 
#> 3       cndc_adjusted_error     float                 
#> 4          cndc_adjusted_qc     float                 
#> 5                   cndc_qc     float                 
#> 6                      doxy     float                 
#> 7             doxy_adjusted     float                 
#> 8       doxy_adjusted_error     float                 
#> 9          doxy_adjusted_qc     float                 
#> 10                  doxy_qc     float                 
#> 11                       id       int                 
#> 12                 latitude     float      -90.0, 90.0
#> 13                longitude     float       0.0, 360.0
#> 14                     pres     float                 
#> 15            pres_adjusted     float                 
#> 16      pres_adjusted_error     float                 
#> 17         pres_adjusted_qc     float                 
#> 18                  pres_qc     float                 
#> 19                     psal     float                 
#> 20            psal_adjusted     float                 
#> 21      psal_adjusted_error     float                 
#> 22         psal_adjusted_qc     float                 
#> 23                  psal_qc     float                 
#> 24                     temp     float                 
#> 25            temp_adjusted     float                 
#> 26      temp_adjusted_error     float                 
#> 27         temp_adjusted_qc     float                 
#> 28                temp_doxy     float                 
#> 29       temp_doxy_adjusted     float                 
#> 30 temp_doxy_adjusted_error     float                 
#> 31    temp_doxy_adjusted_qc     float                 
#> 32             temp_doxy_qc     float                 
#> 33                  temp_qc     float                 
#> 34                     time    double 8.1048066E8, NaN
```

Get data from the dataset


```r
erddap_table(id, fields = c('latitude','longitude'))
#> <NOAA ERDDAP tabledap> apdrcArgoAll
#>    Path: [/Users/sacmac/.rnoaa/erddap/7b238871e478bf43df2e1f703e6e85e5.csv]
#>    Last updated: [2014-12-19 18:15:39]
#>    File size:    [0.07 MB]
#>    Dimensions:   [5000 X 2]
#> 
#>    latitude longitude
#> 2    49.868   215.335
#> 3    50.023    215.47
#> 4    50.115   215.676
#> 5    50.156   215.676
#> 6    50.132   215.601
#> 7      50.1   215.544
#> 8    50.158   215.582
#> 9    50.278   215.585
#> 10   50.417   215.702
#> 11   50.548   215.779
#> ..      ...       ...
```

## Time constraint

Limit by time with date only


```r
erddap_table(id, fields = c('latitude','longitude','time'), 'time>=2001-07-14', 'time<=2001-09-14')
#> <NOAA ERDDAP tabledap> apdrcArgoAll
#>    Path: [/Users/sacmac/.rnoaa/erddap/d449b321be463619aab879c8ca2e40e7.csv]
#>    Last updated: [2014-12-19 18:22:51]
#>    File size:    [0.05 MB]
#>    Dimensions:   [1490 X 3]
#> 
#>    latitude longitude                 time
#> 2    75.005     0.583 2001-07-14T04:29:00Z
#> 3    73.819     1.418 2001-07-14T01:01:59Z
#> 4   -24.702    106.08 2001-07-14T00:33:23Z
#> 5   -12.953   108.299 2001-07-14T04:23:12Z
#> 6     4.943   164.673 2001-07-14T18:36:46Z
#> 7    -4.769   189.924 2001-07-14T21:49:35Z
#> 8    11.312   195.319 2001-07-14T06:15:47Z
#> 9    48.906   229.489 2001-07-14T14:50:00Z
#> 10   -10.93   235.776 2001-07-14T08:47:12Z
#> 11   11.672   264.219 2001-07-14T05:31:14Z
#> ..      ...       ...                  ...
```

## Use distinct parameter


```r
erddap_table('erdCalCOFIfshsiz', fields=c('longitude','latitude','fish_size','itis_tsn'), 'time>=2001-07-07','time<=2001-07-10', distinct=TRUE)
#> <NOAA ERDDAP tabledap> erdCalCOFIfshsiz
#>    Path: [/Users/sacmac/.rnoaa/erddap/e05d5adb0fecd3bb2276c920e1bd2457.csv]
#>    Last updated: [2014-12-19 18:16:09]
#>    File size:    [0.02 MB]
#>    Dimensions:   [518 X 4]
#> 
#>     longitude  latitude fish_size itis_tsn
#> 2  -118.74333 32.873333      14.2   162584
#> 3  -118.74333 32.873333      15.0   162221
#> 4  -118.74333 32.873333      15.2   170085
#> 5  -118.74333 32.873333      17.2   162221
#> 6  -118.74333 32.873333      18.3   162221
#> 7  -118.74333 32.873333      18.7   170085
#> 8  -118.74333 32.873333      20.0   162664
#> 9  -118.74333 32.873333      20.2   162664
#> 10 -118.74333 32.873333      20.4   623745
#> 11 -118.74333 32.873333      23.1   623745
#> ..        ...       ...       ...      ...
```

## The units parameter

In this example, values are the same, but sometimes they can be different given the units value passed


```r
erddap_table('erdCinpKfmT', fields=c('longitude','latitude','time','temperature'), 'time>=2007-09-19', 'time<=2007-09-21', units='udunits')
#> <NOAA ERDDAP tabledap> erdCinpKfmT
#>    Path: [/Users/sacmac/.rnoaa/erddap/d1aaf6eca896d080b1c2251f7a8cec17.csv]
#>    Last updated: [2014-12-19 18:16:21]
#>    File size:    [2.18 KB]
#>    Dimensions:   [48 X 4]
#> 
#>    longitude  latitude                 time temperature
#> 2     -120.1 33.883335 2007-09-19T00:13:00Z       16.22
#> 3     -120.1 33.883335 2007-09-19T01:13:00Z       16.38
#> 4     -120.1 33.883335 2007-09-19T02:13:00Z       16.38
#> 5     -120.1 33.883335 2007-09-19T03:13:00Z       16.38
#> 6     -120.1 33.883335 2007-09-19T04:13:00Z       14.48
#> 7     -120.1 33.883335 2007-09-19T05:13:00Z       13.86
#> 8     -120.1 33.883335 2007-09-19T06:13:00Z       13.55
#> 9     -120.1 33.883335 2007-09-19T07:13:00Z       13.24
#> 10    -120.1 33.883335 2007-09-19T08:13:00Z       13.09
#> 11    -120.1 33.883335 2007-09-19T09:13:00Z       12.78
#> ..       ...       ...                  ...         ...
```


```r
erddap_table('erdCinpKfmT', fields=c('longitude','latitude','time','temperature'), 'time>=2007-09-19', 'time<=2007-09-21', units='ucum')
#> <NOAA ERDDAP tabledap> erdCinpKfmT
#>    Path: [/Users/sacmac/.rnoaa/erddap/a53175d2b882b8054906b46d4efe8218.csv]
#>    Last updated: [2014-12-19 18:16:34]
#>    File size:    [2.17 KB]
#>    Dimensions:   [48 X 4]
#> 
#>    longitude  latitude                 time temperature
#> 2     -120.1 33.883335 2007-09-19T00:13:00Z       16.22
#> 3     -120.1 33.883335 2007-09-19T01:13:00Z       16.38
#> 4     -120.1 33.883335 2007-09-19T02:13:00Z       16.38
#> 5     -120.1 33.883335 2007-09-19T03:13:00Z       16.38
#> 6     -120.1 33.883335 2007-09-19T04:13:00Z       14.48
#> 7     -120.1 33.883335 2007-09-19T05:13:00Z       13.86
#> 8     -120.1 33.883335 2007-09-19T06:13:00Z       13.55
#> 9     -120.1 33.883335 2007-09-19T07:13:00Z       13.24
#> 10    -120.1 33.883335 2007-09-19T08:13:00Z       13.09
#> 11    -120.1 33.883335 2007-09-19T09:13:00Z       12.78
#> ..       ...       ...                  ...         ...
```

## The orderby parameter


```r
erddap_table('erdCinpKfmT', fields=c('longitude','latitude','time','temperature'), 'time>=2007-09-19', 'time<=2007-09-21', orderby='temperature')
#> <NOAA ERDDAP tabledap> erdCinpKfmT
#>    Path: [/Users/sacmac/.rnoaa/erddap/9339183f5e454127988667d44e8fb0ca.csv]
#>    Last updated: [2014-12-19 18:16:44]
#>    File size:    [2.18 KB]
#>    Dimensions:   [48 X 4]
#> 
#>    longitude  latitude                 time temperature
#> 2     -120.1 33.883335 2007-09-20T12:13:00Z        12.0
#> 3     -120.1 33.883335 2007-09-20T13:13:00Z        12.0
#> 4     -120.1 33.883335 2007-09-20T14:13:00Z        12.0
#> 5     -120.1 33.883335 2007-09-20T11:13:00Z       12.16
#> 6     -120.1 33.883335 2007-09-20T15:13:00Z       12.16
#> 7     -120.1 33.883335 2007-09-20T10:13:00Z       12.31
#> 8     -120.1 33.883335 2007-09-20T16:13:00Z       12.31
#> 9     -120.1 33.883335 2007-09-20T17:13:00Z       12.62
#> 10    -120.1 33.883335 2007-09-19T09:13:00Z       12.78
#> 11    -120.1 33.883335 2007-09-20T09:13:00Z       12.78
#> ..       ...       ...                  ...         ...
```

## The orderbymax parameter


```r
erddap_table('erdCinpKfmT', fields=c('longitude','latitude','time','temperature'), 'time>=2007-09-19', 'time<=2007-09-21', orderbymax='temperature')
#> <NOAA ERDDAP tabledap> erdCinpKfmT
#>    Path: [/Users/sacmac/.rnoaa/erddap/e6e6116b3870afc9c093f6dab56ce6ba.csv]
#>    Last updated: [2014-12-19 18:16:53]
#>    File size:    [0.12 KB]
#>    Dimensions:   [1 X 4]
#> 
#>   longitude  latitude                 time temperature
#> 2    -120.1 33.883335 2007-09-19T03:13:00Z       16.38
```

## The orderbymin parameter


```r
erddap_table('erdCinpKfmT', fields=c('longitude','latitude','time','temperature'), 'time>=2007-09-19', 'time<=2007-09-21', orderbymin='temperature')
#> <NOAA ERDDAP tabledap> erdCinpKfmT
#>    Path: [/Users/sacmac/.rnoaa/erddap/04557d97f6ecec410b114fc90da503d1.csv]
#>    Last updated: [2014-12-19 18:17:12]
#>    File size:    [0.12 KB]
#>    Dimensions:   [1 X 4]
#> 
#>   longitude  latitude                 time temperature
#> 2    -120.1 33.883335 2007-09-20T12:13:00Z        12.0
```

## The orderbyminmax parameter


```r
erddap_table('erdCinpKfmT', fields=c('longitude','latitude','time','temperature'), 'time>=2007-09-19', 'time<=2007-09-21', orderbyminmax='temperature')
#> <NOAA ERDDAP tabledap> erdCinpKfmT
#>    Path: [/Users/sacmac/.rnoaa/erddap/4bd33e3b4de0d050b250fbccfd436ab7.csv]
#>    Last updated: [2014-12-19 18:17:15]
#>    File size:    [0.16 KB]
#>    Dimensions:   [2 X 4]
#> 
#>   longitude  latitude                 time temperature
#> 2    -120.1 33.883335 2007-09-20T12:13:00Z        12.0
#> 3    -120.1 33.883335 2007-09-19T03:13:00Z       16.38
```

## The orderbymin parameter with multiple values


```r
erddap_table('erdCinpKfmT', fields=c('longitude','latitude','time','depth','temperature'), 'time>=2007-06-10', 'time<=2007-09-21', orderbymax=c('depth','temperature'))
#> <NOAA ERDDAP tabledap> erdCinpKfmT
#>    Path: [/Users/sacmac/.rnoaa/erddap/e84ec03c5003845e4df2208ae39a975a.csv]
#>    Last updated: [2014-12-19 18:17:24]
#>    File size:    [0.61 KB]
#>    Dimensions:   [11 X 5]
#> 
#>      longitude  latitude                 time depth temperature
#> 2   -119.53333 34.033333 2007-08-07T02:40:00Z     5       20.54
#> 3   -119.36667      34.0 2007-07-05T03:42:00Z     6       19.72
#> 4      -119.35      34.0 2007-08-05T18:32:00Z     8       21.23
#> 5   -119.51667 34.033333 2007-08-06T04:02:00Z     9       20.47
#> 6   -120.13333      33.9 2007-08-04T22:34:00Z    10       19.35
#> 7   -119.38333      34.0 2007-08-02T15:38:00Z    11       20.86
#> 8  -120.183334 33.916668 2007-08-04T23:50:00Z    12       19.92
#> 9       -119.6 34.033333 2007-08-08T02:47:00Z    13       20.43
#> 10 -119.816666 33.933334 2007-07-17T02:21:00Z    15       18.47
#> 11 -119.416664      34.0 2007-07-10T23:25:00Z    16       19.14
#> ..         ...       ...                  ...   ...         ...
```

## Spatial delimitation


```r
erddap_table('erdCalCOFIfshsiz', fields = c('latitude','longitude','scientific_name'), 'latitude>=34.8', 'latitude<=35', 'longitude>=-125', 'longitude<=-124')
#> <NOAA ERDDAP tabledap> erdCalCOFIfshsiz
#>    Path: [/Users/sacmac/.rnoaa/erddap/8137b5814735d58e2d939b33a975c1a9.csv]
#>    Last updated: [2014-12-19 15:48:00]
#>    File size:    [2.2 KB]
#>    Dimensions:   [56 X 3]
#> 
#>     latitude longitude        scientific_name
#> 2  34.881668   -124.48     Cyclothone atraria
#> 3  34.881668   -124.48   Lipolagus ochotensis
#> 4  34.881668   -124.48  Bathylagoides wesethi
#> 5  34.881668   -124.48 Cyclothone acclinidens
#> 6  34.881668   -124.48 Cyclothone acclinidens
#> 7  34.881668   -124.48     Cyclothone signata
#> 8  34.881668   -124.48     Cyclothone signata
#> 9  34.881668   -124.48     Cyclothone signata
#> 10 34.881668   -124.48     Cyclothone signata
#> 11 34.881668   -124.48     Cyclothone signata
#> ..       ...       ...                    ...
```

## Integrate with taxize


```r
out <- erddap_table('erdCalCOFIfshsiz', fields = c('latitude','longitude','scientific_name','itis_tsn'))
tsns <- unique(out$itis_tsn[1:100])
library("taxize")
classif <- classification(tsns, db = "itis")
head(rbind(classif)); tail(rbind(classif))
#>            name         rank     id  query   db
#> 1      Animalia      Kingdom 202423 172887 itis
#> 2     Bilateria   Subkingdom 914154 172887 itis
#> 3 Deuterostomia Infrakingdom 914156 172887 itis
#> 4      Chordata       Phylum 158852 172887 itis
#> 5    Vertebrata    Subphylum 331030 172887 itis
#> 6 Gnathostomata  Infraphylum 914179 172887 itis
#>                   name     rank     id  query   db
#> 161       Stomiiformes    Order 553138 162167 itis
#> 162    Gonostomatoidei Suborder 553151 162167 itis
#> 163     Gonostomatidae   Family 162163 162167 itis
#> 164         Cyclothone    Genus 162164 162167 itis
#> 165 Cyclothone pallida  Species 162167 162167 itis
#> 166 Bathylagus wesethi  Species 162092 162092 itis
```
