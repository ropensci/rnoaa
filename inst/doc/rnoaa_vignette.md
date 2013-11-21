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
## Error: could not find function "as"
```


#### Search for data and get a data.frame or list


```r
out <- noaa(datasetid = "NORMAL_DLY", stationid = "GHCND:USW00014895", datatypeid = "dly-tmax-normal")
```

```
## Error: could not find function "as"
```


##### See a data.frame


```r
out$data
```

```
## Error: object 'out' not found
```


#### Plot data, super simple, but it's a start


```r
out <- noaa(datasetid = "NORMAL_DLY", stationid = "GHCND:USW00014895", datatypeid = "dly-tmax-normal")
```

```
## Error: could not find function "as"
```

```r
noaa_plot(out)
```

```
## Error: object 'out' not found
```


### Plot data from many stations

#### Get table of all datasets

```r
noaa_datasets()
```

```
## Error: could not find function "as"
```


#### Search for GHCND stations within 500 km of a lat/long point, take 10 of them


```r
noaa_stations(datasetid = "GHCND", locationid = "FIPS:12017")
```

```
## Error: could not find function "as"
```


### Get data category data and metadata


```r
noaa_datacats(locationid = "CITY:US390029")
```

```
## Error: could not find function "as"
```

