rnoaa 0.7.0
===========

Note that some NOAA datasets have changed names:

* `GHCNDMS` is now `GSOM` (Global Summary of the Month)
* `ANNUAL` is now `GSOY` (Global Summary of the Year)

### NEW FEATURES

* `isd()` gains new parameters `additional` to toggle whether the 
non-mandatory ISD fields (additional + remarks) are parsed and 
returned & `force` to toggle whether download new version or use
cached version. `isd_read()` gains new parameter `additional` 
(see description above) (#190)
* New function for Climate Prediction Center data: `cpc_prcp()` (#193)
* New function `arc2()` to get data from Africa Rainfall Climatology 
version 2 (#201)

### MINOR IMPROVEMENTS

* A number of NOAA services now use `https` - changed internal code 
to use `https` from `http` for coops, swdi, ersst, and tornadoes
data sources (#187)
* Changes to sea ice URLs - just internal (#185)
* Fixes to `coops_search()` to handle requests better: only certain
date combinations allowed for certain COOPS products (#213) (#214) 
thanks @tphilippi !
* Now using `hoardr` package to manage caching in some functions. Will
roll out to all functions that cache soon (#191)
* README img location fix requested by CRAN (#207)
* `GHCNDMS` is now `GSOM` and `ANNUAL` is now `GSOY` - added to docs
and examples of using GSOM and GSOY (#189)

### BUG FIXES

* A number of fixes to `isd()` (#168)
* Fixes to `coops_search()` to fix time zone problems (#184) thanks @drf5n
* Fixes to `ghcnd()` - fix some column types that were of inappropriate
type before (#211)
* Fix to `ghcnd()`: we were coercing factors to integers, which caused
nonsense output - first coercing to character now, then integer (#221)
* There were problems in parsing flags (attributes) for some datasets 
via `ncdc()` function. Added metadata to the package to help parse 
flags (#199)


rnoaa 0.6.6
===========

### NEW FEATURES

* `isd()` now using a new package `isdparser` to parse
NOAA ISD files. We still fetch the file within `rnoaa`, but the
file parsing is done by `isdparser` (#176) (#177) (#180) thanks @mrubayet
for the push

### MINOR IMPROVEMENTS

* Fixed precipitation units in docs for `meteo_*` functions (#178)
thanks @mrubayet

### BUG FIXES

* Fixed bug in `ghcnd()` where internal unexported function
was not found (#179)
* Fix to `isd_stations()` and `isd_stations_search()` to work
correctly on Windows (#181) thanks @GuodongZhu
* Changed base URL for all NOAA NCDC functions (those starting with
`ncdc`) to `https` from `http` (#182) thanks @maspotts
* Changed base URL for all NOAA HOMR functions (those starting with
`homr`) to `https` from `http` (#183)


rnoaa 0.6.5
===========

### MINOR IMPROVEMENTS

* Added notes to docs of functions that do file caching - where
to find cached files.
* `meteo_clear_cache` gains parameter `force` to control `force`
parameter in `unlink()`
* Removed `lubridate` usage in `seaiceurls()` function, just using
base R functions.

### BUG FIXES

* Fixed bug which was affecting binary installs only. We accidentally
determined a path on package build, such that the user
of the CRAN binary build machine got inserted into the path.
This is now fixed. (#173)


rnoaa 0.6.4
===========

### NEW FEATURES

* New function `isd_read()` to read ISD output from `isd()` manually
instead of letting `isd()` read in the data. This is useful when you
use `isd()` but need to read the file in later when it's already cached.
(#169)
* Some functions in `rnoaa` cache files that are downloaded from
various NOAA web services. File caching is usually done when data comes
from FTP servers. In some of these functions where we cache data, we used
to write to your home directory, but have now changed all these functions
to write to a proper cache directory in a platform independent way.
We determine the cache directory using `rappdirs::user_cache_dir()`.
Note that this may change your workflow if you'd been depending on
cached files to be a in particular place on your file system. In addition,
the `path` parameter in the changed functions is now defunct, but you
get an informative warning about it (#171)

### MINOR IMPROVEMENTS

* `storm_data()` now returns a tibble/data.frame not inside of a list. We used
to return a list with a single slot `data` with a data.frame, but this was
unnecessary.
* `ghcnd_stations()` now outputs a data.frame (`tbl_df`) by itself,
instead of a data.frame nested in a list. This may change how
you access data from this function. (#163)
* Improved docs on token usage for NCDC functions (with prefix
`ncdc_*()`) (#167)
* Added note to `isd()` docs that when you get an error similar to
`Error: download failed for ftp://ftp.ncdc.noaa.gov/pub/data/noaa/1955/011490-99999-1955.gz`,
the file does not exist on NOAA's ftp servers. If your internet is down,
you'll get a different error saying as much (#170)

rnoaa 0.6.0
===============

### NEW FEATURES

* A large PR was merged with a suite of functions. Most functions added
a prefixed with `meteo_*`, and are meant to find weather monitors near
locations (`meteo_nearby_stations`), find all monitors within a radius
of a location (`meteo_distance`), calculate the distances between a
location and all available stations (`meteo_process_geographic_data`),
calculate the distance between two locations (`meteo_spherical_distance`),
pull GHCND weather data for multiple weather monitors (`meteo_pull_monitors`),
create a tidy GHCND dataset from a single monitor (`meteo_tidy_ghcnd`),
and determine the "coverage" for a station data frame (`meteo_coverage()`).
In addition, `vis_miss()` added to visualize missingness in a data.frame. See
the [PR diff against master](https://github.com/ropensci/rnoaa/pull/159/files)
for all the changes. (#159) Thanks a ton to @geanders _et al_. (@hrbrmstr,
@maelle, @jdunic, @njtierney, @leighseverson, @RyanGan, @mandilin, @jferreri,
@cpatrizio88, @ryan-hicks, @Ewen2015, @mgutilla, @hakessler, @rodlammers)

### MINOR IMPROVEMENTS

* `isd_stations_search()` changed internal structure. We replaced
usage of `geojsonio` and `lawn` for faster `dplyr::filter` for
bbox inputs, and `meteo_distance()` for `lat/long/radius` inputs
. This speeds up this function significantly. Thanks to @lukas-rokka
(#157)
* `isd_stations_search()` and `isd_stations()` now return
tibble's instead of data.frame's
* Removed cached ISD stations dataset within package to reduce
package size. Only change is now that on first use of the function
the user has to download the entire thing, but on subsquent
uses it will pull from the cached version on the users machine.
`isd_stations_search()` now caches using `rappdirs` (#161)
* Convert all `is()` uses to `inherits()`

### BUG FIXES

* Fixed `seaiceeurls()` function that's used to generate urls for
the `seaice()` function - due to change in NOAA urls (#160)
* Fix to function `ghncd_split_vars()` to not fail on `dplyr::contains`
call (#156) thanks @lawinslow !

rnoaa 0.5.6
===============

### MINOR IMPROVEMENTS

* Fixes for new `httr` version to call encoding explicitly (#135)
* Fix to broken link for reference to source code used in `gefs` functions (#121)
* Speed ups implemented for the `isd()` function - it's a time consuming task
as we have to parse a nasty string of characters line by line - more speed
ups to come in future versions (#146)
* Replace `dplyr::rbind_all()` with `dplyr::bind_rows()` as the former is
being deprecated (#152)

### BUG FIXES

* Fix for `isd()` function - was failing on some station names that had
leading zeros. (#136)
* Fix for `ncdc_stations()` - used to allow more than one station id to
be passed in, but internally only handled one. This is a restriction
due to the NOAA NCDC API. Documentation now shows an example of how
to deal with many station ids (#138)
* Fixes to the suite of `ncdc_*()` functions to allow multiple inputs
to those parameters where allowed (#139)
* Fixed bug in `ncdc_plot()` due to new `ggplot2` version (#153)
* Fixed bugs in `argo()` functions: a) with new `httr`, box input of a vector
no longer works, now manually make a character vector; b) errant file param
being passed into the http request, removed (#155)

rnoaa 0.5.2
===============

### NEW FEATURES

* New data source added: ARGO buoy data. See functions starting with `argo()` (#123)
for more, see http://www.argo.ucsd.edu/
* New data source added: CO-OPS tide and current data. See function `coops_search()`
(#111) for idea from @fmichonneau (#124) for implementing @jsta See http://co-ops.nos.noaa.gov/api/
also (#126) (#128)

### MINOR IMPROVEMENTS

* `rgdal` moved to Suggests to make usage easier (#125)
* Changes to `ncdc_plot()` - made default brakes to just default to what
`ggplot2` does, but you can still pass in your own breaks (#131)

rnoaa 0.5.0
===============

### NEW FEATURES

* New data source added: NOAA Global Ensemble Forecast System (GEFS) data.
See functions `gefs()`, `gefs_dimension_values()`, `gefs_dimensions()`, `gefs_latitudes()`,
`gefs_longitudes()`, and `gefs_variables()` (#106) (#119)  thanks @potterzot - he's
now an author too
* New data source added: NOAA Extended Reconstructed Sea Surface Temperature
(ERSST) data. See function `ersst()` (#96)
* New function `isd_stations()` to get ISD station data.
* Added code of conduct to code repository

### MINOR IMPROVEMENTS

* Swapped `ncdf` package for `ncdf4` package. Windows binaries weren't
availiable for `ncdf4` prior to now. (#117)
* Proper license info added for javascript modules used inside the
package (#116)
* Improvements to `isd()` function to do transformations of certain
variables to give back data that makes more sense (#115)
* `leaflet`, `geojsonio`, and `lawn` added in Suggests, used in a few
functions.
* Note added to `swdi()` function man page that the `nldn` dataset is
available to military users only (#107)

### BUG FIXES

* Fix to `buoy()` function to accept character class inputs for the
`buoyid` parameter. the error occurred because matching was not
case-insensitive, now works regardless of case (#118)
* Fixes for new `ggplot2` version (#113)
* Built in `GET` request retries for `ghncd` functions as
some URLs fail unpredictably (#110)

rnoaa 0.4.2
===============

### MINOR IMPROVEMENTS

* Explicitly import non-base R pkg functions, so importing from `utils`, `methods`, and `stats` (#103)
* All NCDC legacy API functions are now defunct. See `?rnoaa-defunct` for more information (#104)
* `radius` parameter removed from `ncdc_stations()` function (#102), was already removed internally within the function in the last version, now not in the function definition, see also (#98) and (#99)
* Dropped `plyr` and `data.table` from imports. `plyr::rbind.fill()` and `data.table::rbindlist()` replaced with `dplyr::bind_rows()`.

### BUG FIXES

* Fixed problem with `httr` `v1` where empty list not allowed to pass to
the `query` parameter in `GET` (#101)

rnoaa 0.4.0
===============

### NEW FEATURES

+ Gains a suite of new functions for working with NOAA GHCND data, including
`ghcnd()`, `ghcnd_clear_cache()`, `ghcnd_countries()`, `ghcnd_search()`, `ghcnd_splitvars()`
`ghcnd_states()`, `ghcnd_stations()`, and `ghcnd_version()` (#85) (#86) (#87) (#88) (#94)
+ New contributor Adam Erickson (@DougFirErickson)
+ All NOAA buoy functions put back into the package. They were previously
on a separate branch in the GitHub repository. (#37) (#71) (#100)

### MINOR IMPROVEMENTS

+ Minor adjustments to `isd()` functions, including better man file.
+ Cleaner package imports - importing mostly only functions used in dependencies.
+ Startup message gone.
+ `callopts` parameter changed to `...` in function `swdi()`.
+ More robust test suite.
+ `ncdc()` requires that users do their own paging - previously this was done internally (#77)
+ Many dependencies dropped, simplifying package: `RCurl`, `maptools`, `stringr`, `digest`.
A few new ones added: `dplyr`, `tidyr`.

### DEPRECATED AND DEFUNCT

+ All `erddap` functions now defunct - see the package [rerddap](https://github.com/ropensci/rerddap),
a general purpose R client for ERDDAP servers. (#51) (#73) (#90) (#95)
+ The `extent` function in `noaa_stations()` used to accept either a bounding
box or a point defined by lat/long. The lat/long option dropped as it required
two packages, one of which is a pain to install for many users (#98) (#99)

rnoaa 0.3.3
===============

### NEW FEATURES

+ New data source NOAA legacy API with ISD, daily, and ish data via function
`ncdc_legacy()`. (#54)
+ New function `isd()` to get ISD data from NOAA FTP server. (#76)
+ ERDDAP gridded data sets added. Now tabledap datasets are accessible via
`erddap_table()`, while gridded datasets are available via `erddap_grid()`. Helper
function `erddap_search()` was modified to search for either tabledap or griddap
datasets, and `erddap_info()` gets and prints summary information differently
for tabledap and griddap datasets. (#63)

### MINOR IMPROVEMENTS

+ `erddap_data()` defunct, now as functions `erddap_table()` and `erddap_grid()`, uses new
`store` parameter which takes a function, either `disk(path, overwrite)` to store
on disk or `memory()` to store in R memory.
+ `assertthat` library removed, replaced with `stopifnot()`

rnoaa 0.3.0
===============

### NEW FEATURES

+ New data source added (NOAA torndoes data) via function `tornadoes()`. (#56)
+ New data source added (NOAA storm data from IBTrACS) via functions
`storm_*()`. (#57)
+ New data source added (NOAA weather station metadata from HOMR) via functions
`homr_*()` (#59)
+ New vignettes for storm data and homr data.
+ Some functions in rnoaa now print data.frame outputs as `dplyr`-like outputs
with a summary of the data.frame, as appropriate.

### MINOR IMPROVEMENTS

+ Across all `ncdc_*` functions changed `callopts` parameter to `...`. This parameter
allow you to pass in options to `httr::GET` to modify curl requests. (#61)
+ A new helper function `check_key()` looks for one of two stored keys, as an
environment variable under the name `NOAA_KEY`, or an option variable under the name
`noaakey`. Environment variables can be set during session like `Sys.setenv(VAR = "...")`,
or stored long term in your `.Renviron` file. Option variables can be set during session
like `options(var = "...")`, or stored long term in your `.Rprofile` file.
+ `is.*` and `print.*` functions no longer have public man files, but can be seen via
`rnoaa:::` if needed.

rnoaa 0.2.0
===============

### NEW FEATURES

* New package imports: `sp`, `rgeos`, `assertthat`, `jsonlite`, and `ncdf4`, and new package Suggests: `knitr`, `taxize`
* Most function names changed. All `noaa*()` functions for NCDC data changed to `ncdc*()`. `noaa_buoy()` changed to `buoy()`. `noaa_seaice()` changed to `seaice()`. When you call the old versions an error is thrown, with a message pointing you to the new function name. See ?rnoaa-defunct.
* New vignettes: NCDC attributes, NCDC workflow, Seaice vignette, SWDI vignette, ERDDAP vignette, NOAA buoy vignette.
* New functions to interact with NOAA ERDDAP data: `erddap_info()`, `erddap_data()`, and `erddap_search()`.
* New functions to interact with NOAA buoy data: `buoy()`, including a number of helper functions.
* `ncdc()` now splits apart attributes. Previously, the attributes were returned as a single column, but now there is column for each attribute so data can be easily retrieved. Attribute columns differ for each different `datasetid`.
* `buoy()` function has been removed from the CRAN version of `rnoaa`. Install the version with `buoy()` and associated functions via `devtools::install_github("ropensci/rnoaa", ref="buoy")`

### MINOR IMPROVEMENTS

* `noaa_swdi()` (function changed to `swdi()`) gains new parameter `filepath` to specify path to write a file to if `format=kmz` or `format=shp`. Examples added for using `format=` csv, shp, and kmz.
* Now using internal version of `plyr::compact`.
* Added API response checker/handler to all functions to pass on helpful messages on server errors.
* `ncdc()` gains new parameter `includemetadata`. If TRUE, includes metadata, if not, does not, and response should be faster as does not take time to calculate metadata.
* `noaa_stations()` gains new parameter `radius`. If `extent` is a vector of length 4 (for a bounding box) then radius is ignored, but if you pass in two points to `extent`, it is interpreted as a point, and then `radius` is used as the distance upon which to construct a bounding box. `radius` default is 10 km.

### BUG FIXES

* `datasetid`, `startdate`, and `enddate` are often required parameters, and changes were made to help users with this.


rnoaa 0.1.0
===============

### NEW FEATURES

* Submitted to CRAN.


rnoaa 0.0.8
===============

### NEW FEATURES

* Wrote new functions for NOAA API v2.
* A working vignette now.


rnoaa 0.0.1
===============

### NEW FEATURES

* Wrappers for NOAA API v1 were written, not on CRAN at this point.
