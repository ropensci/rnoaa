rnoaa
========

Still early days, so not much here yet, but look quick start below...

### Info

* The older version of the NOAA API is on the master branch of this repo for now, and the docs for that API are [here](http://www.ncdc.noaa.gov/cdo-web/webservices)
* The docs for the new API, which this dev branch is based on are [here](http://www.ncdc.noaa.gov/cdo-web/webservices/v2)

### API key

You'll need an API key to use this package (essentially a password). Go [here](http://www.ncdc.noaa.gov/cdo-web/token) to get one. 

### Install from Github (not on CRAN yet)

```coffee
install.packages("devtools")
library(devtools)
install_github("rnoaa", "ropensci", ref="newapi")
library(rnoaa)
```

### Quick start

####  Search for hrly precip stations within 25km of a lat/long point in Kansas

```coffee
noaa_loc_search(dataset='PRECIP_HLY', latitude=38.002511, longitude=-98.514404, radius=25)$data

$data
           id    minDate    maxDate             name score    type number inCart inDateRange
1 COOP:146469 1948-08-01 1978-03-01    PLEVNA, KS US    19 station      1  FALSE       FALSE
2 COOP:140326 1978-10-01 2012-08-01 ARLINGTON, KS US    23 station      2  FALSE       FALSE
```

#### Get info on a station by specifcying a dataset, locationtype, location, and station

```coffee
noaa_stations(dataset='GHCND', locationtype='CNTY', location='FIPS:12017', station='GHCND:USC00084289')$data

$meta
$meta$id
[1] "GHCND:USC00084289"

$meta$displayName
[1] "INVERNESS 3 SE, FL US"

$meta$minDate
[1] "1948-07-01"

$meta$maxDate
[1] "2013-07-22"

$meta$latitude
[1] 28.8029

$meta$longitude
[1] -82.3126

$meta$elevation
[1] 12.2

$meta$coverage
[1] 0.7945


$lab
       type            id                            displayName
1       ZIP     ZIP:34450                    Inverness, FL 34450
2   HYD_CAT  HUC:03100208          Withlacoochee Hydrologic Unit
3   HYD_ACC    HUC:031002              Tampa Bay Hydrologic Unit
4   HYD_SUB      HUC:0310        Peace-Tampa Bay Hydrologic Unit
5   HYD_REG        HUC:03    South Atlantic-Gulf Hydrologic Unit
6      CITY CITY:US120016               Homosassa Springs, FL US
7      CNTY    FIPS:12017                      Citrus County, FL
8        ST       FIPS:12                                Florida
9  CLIM_DIV     CLIM:1203 North Central Florida Climate Division
10 CLIM_REG      CLIM:104               Southeast Climate Region
11    CNTRY       FIPS:US                          United States
```

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

### Plot data from many stations

#### Get table of all datasets
```coffee
noaa_datasets()

           id                    name                         description    minDate    maxDate
1      ANNUAL        Annual Summaries       Annual Climatological Summary 1831-02-01 2012-11-01
2       GHCND         Daily Summaries                          GHCN-Daily 1763-01-01 2013-08-02
3     GHCNDMS       Monthly Summaries             GHCND-Monthly Summaries 1763-01-01 2013-06-01
4     NEXRAD2         Nexrad Level II  NWS Next Generation Radar Level II 1991-06-05 2013-08-02
5     NEXRAD3        Nexrad Level III NWS Next Generation Radar Level III 1994-05-20 2013-07-31
6  NORMAL_ANN Normals Annual/Seasonal Annual and Seasonal Climate Normals 2010-01-01 2010-01-01
7  NORMAL_DLY           Normals Daily               Daily Climate Normals 2010-01-01 2010-12-31
8  NORMAL_HLY          Normals Hourly              Hourly Climate Normals 2010-01-01 2010-12-31
9  NORMAL_MLY         Normals Monthly             Monthly Climate Normals 2010-01-01 2010-12-01
10  PRECIP_15 Precipitation 15 Minute             15 Minute Precipitation 1970-05-12 2012-08-01
11 PRECIP_HLY    Precipitation Hourly                Hourly Precipitation 1900-01-01 2012-08-01
```

#### Search for GHCND stations within 500 km of a lat/long point, take 10 of them
```coffee
stations <- noaa_loc_search(dataset='GHCND', radius=500, enddate='20121201', latitude=35.59528, longitude=-82.55667)
(res <- stations[['data']][sample.int(100,10),1])

[1] GHCND:US1NCHN0016 GHCND:US1NCMS0001 GHCND:USC00314764 GHCND:USC00311624 GHCND:US1NCBC0028
[6] GHCND:US1NCBC0062 GHCND:US1NCBC0005 GHCND:USC00315356 GHCND:USC00310724 GHCND:USC00316380
```

##### Get data for all data types for those 10 stations

Some stations may not have data for a particular data type. Only using first 7 stations - the 8th had no data.

```coffee
library(doMC)
registerDoMC(cores=4)
dat <- llply(as.character(res)[1:7], function(x) noaa(dataset='GHCND', station=x, year=2010, month=7), .parallel=TRUE)
```

##### Plot precipitation by day for each station

```coffee
df <- ldply(dat, function(x) x$data)
df$date <- ymd(str_replace(as.character(df$date), "T00:00:00\\.000", ''))
df <- df[df$dataType == 'PRCP',]
ggplot(df, aes(date, value)) +
  theme_bw(base_size=18) + 
  geom_line(size=2) +
  facet_grid(station~., scales="free") +
  scale_x_datetime(breaks = date_breaks("7 days"), labels = date_format('%d/%m/%y')) +
  labs(y=as.character(df[1,'dataType']), x="Date") +
  noaa_theme()
```
![](/inst/img/stationsplot.png)


### Get data category data and metadata

```coffee
noaa_datacats(locationid='CITY:US390029')

$atts
$atts$totalCount
[1] 37

$atts$pageCount
[1] 25

$atts$offset
[1] 1


$data
              id                  name
2         ANNAGR   Annual Agricultural
26         ANNDD    Annual Degree Days
3        ANNPRCP  Annual Precipitation
4        ANNTEMP    Annual Temperature
5          AUAGR   Autumn Agricultural
6           AUDD    Autumn Degree Days
7         AUPRCP  Autumn Precipitation
8         AUTEMP    Autumn Temperature
9           COMP              Computed
10       COMPAGR Computed Agricultural
11            DD           Degree Days
12 DUALPOLMOMENT      Dual-Pol Moments
13       ECHOTOP             Echo Tops
14   HYDROMETEOR      Hydrometeor Type
15         OTHER                 Other
16       OVERLAY               Overlay
17          PRCP         Precipitation
18  REFLECTIVITY          Reflectivity
19           SKY    Sky cover & clouds
20         SPAGR   Spring Agricultural
21          SPDD    Spring Degree Days
22        SPPRCP  Spring Precipitation
23        SPTEMP    Spring Temperature
24         SUAGR   Summer Agricultural
25          SUDD    Summer Degree Days

attr(,"class")
[1] "noaa"
```

[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)