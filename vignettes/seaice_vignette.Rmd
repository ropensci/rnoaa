<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{Sea ice vignette}
-->

Sea ice vignette
======

Get sea ice data at [ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/shapefiles](ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/shapefiles).

********************

### Install `rnoaa`

Install and load `rnoaa` into the R session.

If you're on Windows, you may have to install Rtools. Run `devtools::has_devel()`. If you get a `TRUE`, you're okay. If not, [install Rtools](http://cran.r-project.org/bin/windows/Rtools/).


```r
install.packages("devtools")
devtools::install_github("ropensci/rnoaa")
```


```r
library('rnoaa')
library('plyr')
```

### Look at data.frame's for a series of years for Feb, South pole


```r
urls <- sapply(seq(1979,1990,1), function(x) seaiceeurls(yr=x, mo='Feb', pole='S'))
out <- lapply(urls, seaice)
```


```r
head(out[[1]])
```

```
##       long     lat order  hole piece group id
## 1 -2125000 1950000     1 FALSE     1   0.1  0
## 2 -2050000 1950000     2 FALSE     1   0.1  0
## 3 -2050000 1925000     3 FALSE     1   0.1  0
## 4 -1950000 1925000     4 FALSE     1   0.1  0
## 5 -1950000 1900000     5 FALSE     1   0.1  0
## 6 -1875000 1900000     6 FALSE     1   0.1  0
```

### Map a single year/month/pole combo


```r
urls <- seaiceeurls(mo='Apr', pole='N', yr=1990)
out <- seaice(urls)
```

```
## OGR data source with driver: ESRI Shapefile 
## Source: "/var/folders/gs/4khph0xs0436gmd2gdnwsg080000gn/T//RtmpBQH6xq/extent_N_199004_polygon", layer: "extent_N_199004_polygon"
## with 147 features
## It has 1 fields
```

```
## Regions defined for each Polygons
```

```r
library('ggplot2')
ggplot(out, aes(long, lat, group=group)) +
   geom_polygon(fill="steelblue") +
   theme_ice()
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png) 

### Map all years for April only for North pole


```r
urls <- seaiceeurls(mo='Apr', pole='N')[1:10]
out <- lapply(urls, seaice)
```


```r
names(out) <- seq(1979,1988,1)
df <- ldply(out)
library('ggplot2')
ggplot(df, aes(long, lat, group=group)) +
  geom_polygon(fill="steelblue") +
  theme_ice() +
  facet_wrap(~ .id)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png) 
