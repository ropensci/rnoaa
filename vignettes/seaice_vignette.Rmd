<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{Sea ice vignette}
%\VignetteEncoding{UTF-8}
-->



Sea ice vignette
======

Get sea ice data at [ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/shapefiles](ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/shapefiles).

********************

### Install `rnoaa`

Install and load `rnoaa` into the R session.

If you're on Windows, you may have to install Rtools. Run `devtools::has_devel()`. If you get a `TRUE`, you're okay. If not, [install Rtools](https://cran.r-project.org/bin/windows/Rtools/).


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
urls <- sapply(seq(1979, 1990, 1), function(x) seaiceeurls(yr = x, mo = 'Feb', pole = 'S'))
out <- lapply(urls, seaice)
head(out[[1]])
#>       long     lat order  hole piece id group
#> 1 -2125000 1950000     1 FALSE     1  0   0.1
#> 2 -2050000 1950000     2 FALSE     1  0   0.1
#> 3 -2050000 1925000     3 FALSE     1  0   0.1
#> 4 -1925000 1925000     4 FALSE     1  0   0.1
#> 5 -1925000 1900000     5 FALSE     1  0   0.1
#> 6 -1875000 1900000     6 FALSE     1  0   0.1
```

### Map a single year/month/pole combo


```r
urls <- seaiceeurls(mo = 'Apr', pole = 'N', yr = 1990)
out <- seaice(urls)
library('ggplot2')
ggplot(out, aes(long, lat, group = group)) +
   geom_polygon(fill = "steelblue") +
   theme_ice()
```

![plot of chunk seaice1](figure/seaice1-1.png)

### Map all years for April only for North pole


```r
urls <- seaiceeurls(mo = 'Apr', pole = 'N')[1:10]
out <- lapply(urls, seaice)
names(out) <- seq(1979, 1988, 1)
df <- ldply(out)
library('ggplot2')
ggplot(df, aes(long, lat, group = group)) +
  geom_polygon(fill = "steelblue") +
  theme_ice() +
  facet_wrap(~.id)
```

![plot of chunk seaice2](figure/seaice2-1.png)
