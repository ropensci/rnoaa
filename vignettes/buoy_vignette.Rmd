<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{buoy vignette}
-->



buoy vignette
======

This vignette covers NOAA buoy data from the National Buoy Data Center. The
main function is `noaa_buoy`, but there are a variety of helper functions that
are used in `noaa_buoy` that you can also use. `noaa_buoy_buoys` can be used to
get the buoy IDs and web pages for each buoy. `noaa_buoy_files` gives the available
files for a given buoy. `noaa_buoy_single_file_url` constructs the URL that is used to
get the actual file from the web. `get_ncdf_file` downloads a single ncdf file.
`buoy_collect_data` collects data and makes a `data.frame` from a local ncdf file.

### Install `rnoaa`

Install and load `rnoaa` into the R session.


```r
install.packages("devtools")
library(devtools)
ropensci::install_github("ropensci/rnoaa")
```


```r
library(rnoaa)
```

### Find out what stations are available in a dataset


```r
buoys <- noaa_buoy_buoys(dataset = "cwind")
```

```
## 41001 41002 41004 41006 41008 41009 41010 41012 41013 41021 41022 41023 41025 41035 41036 41040 41041 41043 41044 41046 41047 41048 41049 42001 42002 42003 42007 42012 42019 42020 42035 42036 42038 42039 42040 42041 42054 42055 42056 42057 42058 42059 42060 42065 42otp 44004 44005 44007 44008 44009 44011 44013 44014 44017 44018 44020 44025 44027 44028 44065 44066 45001 45002 45003 45004 45005 45006 45007 45008 45011 45012 46001 46002 46003 46005 46006 46011 46012 46013 46014 46015 46022 46023 46025 46026 46027 46028 46029 46030 46035 46041 46042 46044 46045 46047 46050 46051 46053 46054 46059 46060 46061 46062 46063 46066 46069 46070 46071 46072 46073 46075 46076 46077 46078 46079 46080 46081 46082 46083 46084 46085 46086 46087 46088 46089 46106 46270 51000 51001 51002 51003 51004 51028 51100 51101 alsn6 amaa2 amps2 amps3 amps4 auga2 blia2 burl1 buzm3 caro3 cdrf1 chlv2 clkn7 csbf1 dbln6 desw1 disw3 dpia1 drfa2 dryf1 dsln7 ducn7 fbis1 ffia2 fila2 fpsn7 fwyf1 gbcl1 gdil1 glln6 iosn3 ktnf1 lkwf1 lmbv4 lonf1 lscm4 mdrm1 mism1 mlrf1 mpcl1 mrka2 nwpo3 ostf1 pila2 pilm4 plsf1 pota2 ptac1 ptat2 ptgc1 roam4 sacv4 sanf1 sauf1 sbio1 sgnw3 sgof1 sisw1 smkf1 spgf1 srst2 stdm4 svls1 tplm2 ttiw1 venf1 verv4 wpow1
```

This function uses `cat` to print out the available buoy ids so you can quickly skim and find the one you want and then proceed, or you can inspect further the buoy ids, and the urls for them


```r
buoys[1:2]
```

```
##                                                                     41001 
## "http://dods.ndbc.noaa.gov/thredds/catalog/data/cwind/41001/catalog.html" 
##                                                                     41002 
## "http://dods.ndbc.noaa.gov/thredds/catalog/data/cwind/41002/catalog.html"
```

Or browse them on the web


```r
browseURL(buoys[[1]])
```

![](../img/buoy_screenshot.png)


### Find out what files are available for a single buoy


```r
files <- noaa_buoy_files(buoys[[1]], 41001)
```

```
## c1990.nc c1991.nc c1992.nc c1993.nc c1996.nc c1997.nc c1998.nc c1999.nc c2000.nc c2001.nc c2002.nc c2003.nc c2004.nc c2005.nc c2006.nc c2007.nc c2008.nc c2010.nc c2011.nc c2012.nc cc2008.nc cc2011.nc
```

As the previous function, this one prints what files are available, and returns a character string of the file names. Note that for each of these, the letters at the beginning are the data types, and the numbers afterwards are the years, and the `.nc` at the end is the file extension (meaning NCDF). 


```r
files
```

```
##  [1] "c1990.nc"  "c1991.nc"  "c1992.nc"  "c1993.nc"  "c1996.nc" 
##  [6] "c1997.nc"  "c1998.nc"  "c1999.nc"  "c2000.nc"  "c2001.nc" 
## [11] "c2002.nc"  "c2003.nc"  "c2004.nc"  "c2005.nc"  "c2006.nc" 
## [16] "c2007.nc"  "c2008.nc"  "c2010.nc"  "c2011.nc"  "c2012.nc" 
## [21] "cc2008.nc" "cc2011.nc"
```

```r
files[[1]]
```

```
## [1] "c1990.nc"
```


### Get a single ncdf file

Using the last function `noaa_buoy_files` gives us file names. Using those and the function `noaa_buoy_single_file_url` will give us the full URL to get a single NCDF file. Then we can use `get_ncdf_file` to download the file.


```r
url <- noaa_buoy_single_file_url(dataset = "cwind", buoyid = 41001, file = files[[1]])
filepath <- get_ncdf_file(path = url, buoyid = 41001, file = files[[1]], output = "~")
```


### Read in NCDF buoy data to a data.frame


```r
buoy_collect_data(filepath)
```

```
## 
## Dimensions: [rows 48696, cols 2] 
## 2 variables: [wind_dir, wind_spd] 
## 
##    wind_dir wind_spd
## 1       197     20.0
## 2       194     21.4
## 3       196     19.2
## 4       196     19.4
## 5       186     19.8
## 6       191     20.0
## 7       193     19.6
## 8       192     19.2
## 9       195     19.6
## 10      194     19.0
```


### Bring it all together

The above functions are all wrapped up into a single function, `noaa_buoy`. You can use each function as you like to construct your perfect workflow, or use `noaa_buoy` to do everything for you.  Right now, `noaa_buoy` gets the first year of data, but this will be flexible via parameters soon. 


```r
noaa_buoy(dataset = 'cwind', buoyid = 41001)
```

```
## 41001 41002 41004 41006 41008 41009 41010 41012 41013 41021 41022 41023 41025 41035 41036 41040 41041 41043 41044 41046 41047 41048 41049 42001 42002 42003 42007 42012 42019 42020 42035 42036 42038 42039 42040 42041 42054 42055 42056 42057 42058 42059 42060 42065 42otp 44004 44005 44007 44008 44009 44011 44013 44014 44017 44018 44020 44025 44027 44028 44065 44066 45001 45002 45003 45004 45005 45006 45007 45008 45011 45012 46001 46002 46003 46005 46006 46011 46012 46013 46014 46015 46022 46023 46025 46026 46027 46028 46029 46030 46035 46041 46042 46044 46045 46047 46050 46051 46053 46054 46059 46060 46061 46062 46063 46066 46069 46070 46071 46072 46073 46075 46076 46077 46078 46079 46080 46081 46082 46083 46084 46085 46086 46087 46088 46089 46106 46270 51000 51001 51002 51003 51004 51028 51100 51101 alsn6 amaa2 amps2 amps3 amps4 auga2 blia2 burl1 buzm3 caro3 cdrf1 chlv2 clkn7 csbf1 dbln6 desw1 disw3 dpia1 drfa2 dryf1 dsln7 ducn7 fbis1 ffia2 fila2 fpsn7 fwyf1 gbcl1 gdil1 glln6 iosn3 ktnf1 lkwf1 lmbv4 lonf1 lscm4 mdrm1 mism1 mlrf1 mpcl1 mrka2 nwpo3 ostf1 pila2 pilm4 plsf1 pota2 ptac1 ptat2 ptgc1 roam4 sacv4 sanf1 sauf1 sbio1 sgnw3 sgof1 sisw1 smkf1 spgf1 srst2 stdm4 svls1 tplm2 ttiw1 venf1 verv4 wpow1c1990.nc c1991.nc c1992.nc c1993.nc c1996.nc c1997.nc c1998.nc c1999.nc c2000.nc c2001.nc c2002.nc c2003.nc c2004.nc c2005.nc c2006.nc c2007.nc c2008.nc c2010.nc c2011.nc c2012.nc cc2008.nc cc2011.nc
```

```
## 
## Dimensions: [rows 48696, cols 2] 
## 2 variables: [wind_dir, wind_spd] 
## 
##    wind_dir wind_spd
## 1       197     20.0
## 2       194     21.4
## 3       196     19.2
## 4       196     19.4
## 5       186     19.8
## 6       191     20.0
## 7       193     19.6
## 8       192     19.2
## 9       195     19.6
## 10      194     19.0
```
