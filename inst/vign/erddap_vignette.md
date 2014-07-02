<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{ERDDAP vignette}
-->

ERDDAP vignette
======

### ERDDAP vignette

`ERDDAP` is a service provided by NOAA that

ERDDAP gives a simple, consistent way to download subsets of gridded and tabular scientific datasets in common file formats and make graphs and maps. This ERDDAP installation has oceanographic data (for example, data from satellites and buoys).

Find out more about ERDDAP at [http://coastwatch.pfeg.noaa.gov/erddap/index.html](http://coastwatch.pfeg.noaa.gov/erddap/index.html).

********************

### Install `rnoaa`

Install and load `rnoaa` into the R session.

If you're on Windows, you may have to install Rtools. Run `devtools::has_devel()`. If you get a `TRUE`, you're okay. If not, [install Rtools](http://cran.r-project.org/bin/windows/Rtools/).


```r
install.packages("devtools")
library(devtools)
ropensci::install_github("ropensci/rnoaa")
```


```r
library('rnoaa')
library('plyr')
```

#### Passing the datasetid without fields gives all columns back


```r
out <- erddap_data(datasetid='erdCalCOFIfshsiz')
nrow(out)
```

```
## [1] 20939
```

#### Pass time constraints


```r
head(erddap_data(datasetid='erdCalCOFIfshsiz', 'time>=2001-07-07', 'time<=2001-07-08')[,c(1:4)])
```

```
##   cruise               ship ship_code order_occupied
## 2 200106 DAVID STARR JORDAN        JD             43
## 3 200106 DAVID STARR JORDAN        JD             43
## 4 200106 DAVID STARR JORDAN        JD             43
## 5 200106 DAVID STARR JORDAN        JD             43
## 6 200106 DAVID STARR JORDAN        JD             43
## 7 200106 DAVID STARR JORDAN        JD             43
```

#### Pass in fields (i.e., columns to retrieve) & time constraints


```r
head(erddap_data(datasetid='erdCalCOFIfshsiz', fields=c('longitude','latitude','fish_size','itis_tsn'), 'time>=2001-07-07','time<=2001-07-10'))
```

```
##    longitude  latitude fish_size itis_tsn
## 2    -118.26    33.255      22.9   623745
## 3    -118.26    33.255      22.9   623745
## 4 -118.10667 32.738335      31.5   623625
## 5 -118.10667 32.738335      48.3   623625
## 6 -118.10667 32.738335      15.5   162221
## 7 -118.10667 32.738335      16.3   162221
```


```r
head(erddap_data(datasetid='erdCinpKfmBT', fields=c('latitude','longitude',
   'Aplysia_californica_Mean_Density','Muricea_californica_Mean_Density'),
   'time>=2007-06-24','time<=2007-07-01'))
```

```
##           latitude         longitude Aplysia_californica_Mean_Density
## 2             34.0 -119.416666666667                      0.009722223
## 3             34.0 -119.383333333333                              0.0
## 4             34.0 -119.366666666667                              0.0
## 5             34.0 -119.383333333333                             0.16
## 6             34.0 -119.416666666667                             0.03
## 7 34.0166666666667           -119.35                              0.0
##   Muricea_californica_Mean_Density
## 2                             0.01
## 3                     0.0013888889
## 4                              0.0
## 5                             0.01
## 6                             0.04
## 7                              0.0
```

#### An example workflow

Search for data


```r
(out <- erddap_search(query='fish size'))
```

```
## 7 results, showing first 20 
##                                         title          dataset_id
## 1                          CalCOFI Fish Sizes    erdCalCOFIfshsiz
## 2                        CalCOFI Larvae Sizes    erdCalCOFIlrvsiz
## 3                                CalCOFI Tows      erdCalCOFItows
## 4     GLOBEC NEP MOCNESS Plankton (MOC1) Data       erdGlobecMoc1
## 5 GLOBEC NEP Vertical Plankton Tow (VPT) Data        erdGlobecVpt
## 6         CalCOFI Larvae Counts Positive Tows erdCalCOFIlrvcntpos
## 7  OBIS - ARGOS Satellite Tracking of Animals           aadcArgos
```

Using a datasetid, search for information on a datasetid


```r
id <- out$info$dataset_id[1]
erddap_info(datasetid=id)$variables
```

```
##           variable_name data_type           actual_range
## 1  calcofi_species_code       int               19, 1550
## 2           common_name    String                       
## 3                cruise    String                       
## 4           fish_1000m3     float                       
## 5            fish_count     float                       
## 6             fish_size     float                       
## 7              itis_tsn       int                       
## 8              latitude     float         32.515, 38.502
## 9                  line     float             46.6, 93.3
## 10            longitude     float        -128.5, -117.33
## 11         net_location    String                       
## 12             net_type    String                       
## 13       order_occupied       int                       
## 14       percent_sorted     float                       
## 15       sample_quality     float                       
## 16      scientific_name    String                       
## 17                 ship    String                       
## 18            ship_code    String                       
## 19 standard_haul_factor     float                       
## 20              station     float            28.0, 114.9
## 21                 time    double 9.94464E8, 9.9510582E8
## 22           tow_number       int                  2, 10
## 23             tow_type    String                       
## 24       volume_sampled     float
```

Get data from the dataset


```r
head(erddap_data(datasetid = id, fields = c('latitude','longitude','scientific_name')))
```

```
##    latitude  longitude       scientific_name
## 2 35.038334 -120.88333 Microstomus pacificus
## 3  34.97167 -121.02333    Cyclothone signata
## 4  34.97167 -121.02333    Cyclothone signata
## 5  34.97167 -121.02333    Cyclothone signata
## 6  34.97167 -121.02333    Cyclothone signata
## 7  34.97167 -121.02333    Cyclothone signata
```

#### Time constraint

Limit by time with date only


```r
head(erddap_data(datasetid = id, fields = c('latitude','longitude','scientific_name'),
   'time>=2001-07-14'))
```

```
##   latitude   longitude       scientific_name
## 2   33.045 -118.113335  Lipolagus ochotensis
## 3   33.045 -118.113335  Lipolagus ochotensis
## 4   33.045 -118.113335  Lipolagus ochotensis
## 5   33.045 -118.113335  Lipolagus ochotensis
## 6   33.045 -118.113335 Bathylagoides wesethi
## 7   33.045 -118.113335 Bathylagoides wesethi
```

#### Use distinct parameter


```r
head(erddap_data(datasetid='erdCalCOFIfshsiz',fields=c('longitude','latitude','fish_size','itis_tsn'), 'time>=2001-07-07','time<=2001-07-10', distinct=TRUE))
```

```
##    longitude  latitude fish_size itis_tsn
## 2 -118.74333 32.873333      14.2   162584
## 3 -118.74333 32.873333      15.0   162221
## 4 -118.74333 32.873333      15.2   170085
## 5 -118.74333 32.873333      17.2   162221
## 6 -118.74333 32.873333      18.3   162221
## 7 -118.74333 32.873333      18.7   170085
```

#### The units parameter

In this example, values are the same, but sometimes they can be different given the units value passed


```r
head(erddap_data(datasetid='erdCinpKfmT', fields=c('longitude','latitude','time','temperature'), 'time>=2007-09-19', 'time<=2007-09-21', units='udunits'))
```

```
##   longitude  latitude                 time temperature
## 2    -120.1 33.883335 2007-09-19T00:13:00Z       16.22
## 3    -120.1 33.883335 2007-09-19T01:13:00Z       16.38
## 4    -120.1 33.883335 2007-09-19T02:13:00Z       16.38
## 5    -120.1 33.883335 2007-09-19T03:13:00Z       16.38
## 6    -120.1 33.883335 2007-09-19T04:13:00Z       14.48
## 7    -120.1 33.883335 2007-09-19T05:13:00Z       13.86
```

```r
head(erddap_data(datasetid='erdCinpKfmT', fields=c('longitude','latitude','time','temperature'), 'time>=2007-09-19', 'time<=2007-09-21', units='ucum'))
```

```
##   longitude  latitude                 time temperature
## 2    -120.1 33.883335 2007-09-19T00:13:00Z       16.22
## 3    -120.1 33.883335 2007-09-19T01:13:00Z       16.38
## 4    -120.1 33.883335 2007-09-19T02:13:00Z       16.38
## 5    -120.1 33.883335 2007-09-19T03:13:00Z       16.38
## 6    -120.1 33.883335 2007-09-19T04:13:00Z       14.48
## 7    -120.1 33.883335 2007-09-19T05:13:00Z       13.86
```

#### The orderby parameter


```r
head(erddap_data(datasetid='erdCinpKfmT', fields=c('longitude','latitude','time','temperature'), 'time>=2007-09-19', 'time<=2007-09-21', orderby='temperature'))
```

```
##   longitude  latitude                 time temperature
## 2    -120.1 33.883335 2007-09-20T12:13:00Z        12.0
## 3    -120.1 33.883335 2007-09-20T13:13:00Z        12.0
## 4    -120.1 33.883335 2007-09-20T14:13:00Z        12.0
## 5    -120.1 33.883335 2007-09-20T11:13:00Z       12.16
## 6    -120.1 33.883335 2007-09-20T15:13:00Z       12.16
## 7    -120.1 33.883335 2007-09-20T10:13:00Z       12.31
```

#### The orderbymax parameter


```r
erddap_data(datasetid='erdCinpKfmT', fields=c('longitude','latitude','time','temperature'), 'time>=2007-09-19', 'time<=2007-09-21', orderbymax='temperature')
```

```
##   longitude  latitude                 time temperature
## 2    -120.1 33.883335 2007-09-19T03:13:00Z       16.38
```

#### The orderbymin parameter


```r
erddap_data(datasetid='erdCinpKfmT', fields=c('longitude','latitude','time','temperature'), 'time>=2007-09-19', 'time<=2007-09-21', orderbymin='temperature')
```

```
##   longitude  latitude                 time temperature
## 2    -120.1 33.883335 2007-09-20T12:13:00Z        12.0
```

#### The orderbyminmax parameter


```r
erddap_data(datasetid='erdCinpKfmT', fields=c('longitude','latitude','time','temperature'), 'time>=2007-09-19', 'time<=2007-09-21', orderbyminmax='temperature')
```

```
##   longitude  latitude                 time temperature
## 2    -120.1 33.883335 2007-09-20T12:13:00Z        12.0
## 3    -120.1 33.883335 2007-09-19T03:13:00Z       16.38
```

#### The orderbymin parameter with multiple values


```r
erddap_data(datasetid='erdCinpKfmT', fields=c('longitude','latitude','time','depth','temperature'), 'time>=2007-06-10', 'time<=2007-09-21', orderbymax=c('depth','temperature'))
```

```
##      longitude  latitude                 time depth temperature
## 2   -119.53333 34.033333 2007-08-07T02:40:00Z     5       20.54
## 3   -119.36667      34.0 2007-07-05T03:42:00Z     6       19.72
## 4      -119.35      34.0 2007-08-05T18:32:00Z     8       21.23
## 5   -119.51667 34.033333 2007-08-06T04:02:00Z     9       20.47
## 6   -120.13333      33.9 2007-08-04T22:34:00Z    10       19.35
## 7   -119.38333      34.0 2007-08-02T15:38:00Z    11       20.86
## 8  -120.183334 33.916668 2007-08-04T23:50:00Z    12       19.92
## 9       -119.6 34.033333 2007-08-08T02:47:00Z    13       20.43
## 10 -119.816666 33.933334 2007-07-17T02:21:00Z    15       18.47
## 11 -119.416664      34.0 2007-07-10T23:25:00Z    16       19.14
## 12  -119.38333      34.0 2007-08-05T08:42:00Z    17       20.51
```

#### Spatial delimitation


```r
head(erddap_data(datasetid = 'erdCalCOFIfshsiz', fields = c('latitude','longitude','scientific_name'), 'latitude>=34.8', 'latitude<=35', 'longitude>=-125', 'longitude<=-124'))
```

```
##    latitude longitude        scientific_name
## 2 34.881668   -124.48     Cyclothone atraria
## 3 34.881668   -124.48   Lipolagus ochotensis
## 4 34.881668   -124.48  Bathylagoides wesethi
## 5 34.881668   -124.48 Cyclothone acclinidens
## 6 34.881668   -124.48 Cyclothone acclinidens
## 7 34.881668   -124.48     Cyclothone signata
```

#### Integrate with taxize


```r
out <- erddap_data(datasetid = 'erdCalCOFIfshsiz', fields = c('latitude','longitude','scientific_name','itis_tsn'))
tsns <- unique(out$itis_tsn[1:100])
library("taxize")
```

```
## 
## 
## New to taxize? Tutorial at http://ropensci.org/tutorials/taxize_tutorial.html 
## citation(package='taxize') for the citation for this package 
## API key names have changed. Use tropicosApiKey, eolApiKey, ubioApiKey, and pmApiKey in your .Rprofile file. 
## Use suppressPackageStartupMessages() to suppress these startup messages in the future
```

```r
classif <- classification(tsns, db = "itis")
```

```
## http://www.itis.gov/ITISWebService/services/ITISService/getFullHierarchyFromTSN?tsn=172887
## http://www.itis.gov/ITISWebService/services/ITISService/getFullHierarchyFromTSN?tsn=162168
## http://www.itis.gov/ITISWebService/services/ITISService/getFullHierarchyFromTSN?tsn=623625
## http://www.itis.gov/ITISWebService/services/ITISService/getFullHierarchyFromTSN?tsn=162172
## http://www.itis.gov/ITISWebService/services/ITISService/getFullHierarchyFromTSN?tsn=162301
## http://www.itis.gov/ITISWebService/services/ITISService/getFullHierarchyFromTSN?tsn=162685
## http://www.itis.gov/ITISWebService/services/ITISService/getFullHierarchyFromTSN?tsn=162664
## http://www.itis.gov/ITISWebService/services/ITISService/getFullHierarchyFromTSN?tsn=162221
## http://www.itis.gov/ITISWebService/services/ITISService/getFullHierarchyFromTSN?tsn=164792
## http://www.itis.gov/ITISWebService/services/ITISService/getFullHierarchyFromTSN?tsn=162167
## http://www.itis.gov/ITISWebService/services/ITISService/getFullHierarchyFromTSN?tsn=162092
```

```r
head(rbind(classif)); tail(rbind(classif))
```

```
##   source taxonid          name         rank
## 1   itis  172887      Animalia      Kingdom
## 2   itis  172887     Bilateria   Subkingdom
## 3   itis  172887 Deuterostomia Infrakingdom
## 4   itis  172887      Chordata       Phylum
## 5   itis  172887    Vertebrata    Subphylum
## 6   itis  172887 Gnathostomata  Infraphylum
```

```
##     source taxonid               name     rank
## 161   itis  162167       Stomiiformes    Order
## 162   itis  162167    Gonostomatoidei Suborder
## 163   itis  162167     Gonostomatidae   Family
## 164   itis  162167         Cyclothone    Genus
## 165   itis  162167 Cyclothone pallida  Species
## 166   itis  162092 Bathylagus wesethi  Species
```
