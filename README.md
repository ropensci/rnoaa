rnoaa
========

Still early days, so not much here yet, but look quick start below...

### Info

[NOAA web services documentation](http://www.ncdc.noaa.gov/cdo-web/webservices)

### API key

You'll need an API key to use this package (essentially a password). Go [here](http://www.ncdc.noaa.gov/cdo-web/token) to get one. 


### Install from Github (not on CRAN yet)

```coffee
install.packages("devtools")
library(devtools)
install_github("rnoaa", "ropensci")
library(rnoaa)
```

### Quick start

#### Search for data and get a data.frame or list

```coffee
out <- noaa(dataset='NORMAL_DLY', station='GHCND:USW00014895', datatype='dly-tmax-normal', year=2010, month=4)
```

##### See a data.frame

```coffee
head( noaa_data(out) )

                     date        dataType           station value
1 2010-04-01T00:00:00.000 DLY-TMAX-NORMAL GHCND:USW00014895   536
2 2010-04-02T00:00:00.000 DLY-TMAX-NORMAL GHCND:USW00014895   540
3 2010-04-03T00:00:00.000 DLY-TMAX-NORMAL GHCND:USW00014895   545
4 2010-04-04T00:00:00.000 DLY-TMAX-NORMAL GHCND:USW00014895   549
5 2010-04-05T00:00:00.000 DLY-TMAX-NORMAL GHCND:USW00014895   554
6 2010-04-06T00:00:00.000 DLY-TMAX-NORMAL GHCND:USW00014895   558
```

##### See a list (just first two elements)

```coffee
noaa_data(out, "list")[1:2]

[[1]]
[[1]]$date
[1] "2010-04-01T00:00:00.000"

[[1]]$dataType
[1] "DLY-TMAX-NORMAL"

[[1]]$station
[1] "GHCND:USW00014895"

[[1]]$value
[1] 536


[[2]]
[[2]]$date
[1] "2010-04-02T00:00:00.000"

[[2]]$dataType
[1] "DLY-TMAX-NORMAL"

[[2]]$station
[1] "GHCND:USW00014895"

[[2]]$value
[1] 540
````

#### Plot data, super simple, but it's a start

```coffee
out <- noaa(dataset='NORMAL_DLY', station='GHCND:USW00014895', datatype='dly-tmax-normal', year=2010, month=4)
noaa_plot(out)
```

![](/inst/img/plot.png)