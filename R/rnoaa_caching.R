#' @title rnoaa caching
#' @description Manage data caches
#' @name rnoaa_caching
#' @details To get the cache directory for a data source, see the method
#' `x$cache_path_get()`
#'
#' `cache_delete` only accepts 1 file name, while
#' `cache_delete_all` doesn't accept any names, but deletes all files.
#' For deleting many specific files, use `cache_delete` in a [lapply()]
#' type call
#'
#' Note that cached files will continue to be used until they are deleted.
#' It's possible to run into problems when changes happen in your R
#' setup. For example, at least one user reported changing versions
#' of this package and running into problems because a cached data
#' file from a previous version of rnoaa did not work with the newer
#' version of rnoaa. You should occasionally delete all cached files.
#'
#' @seealso [rnoaa_options()] for managing whether you see messages
#' about cached files when you request data
#'
#' @section Useful user functions:
#'
#' Assuming x is a `HoardClient` class object, e.g., `lcd_cache`
#'
#' - `x$cache_path_get()` get cache path
#' - `x$cache_path_set()` set cache path
#' - `x$list()` returns a character vector of full path file names
#' - `x$files()` returns file objects with metadata
#' - `x$details()` returns files with details
#' - `x$delete()` delete specific files
#' - `x$delete_all()` delete all files, returns nothing
#'
#' @section Caching objects for each data source:
#'
#' - `isd()`/`isd_stations()`: `isd_cache`
#' - `cpc_prcp()`: `cpc_cache`
#' - `arc2()`: `arc2_cache`
#' - `lcd()`: `lcd_cache`
#' - `bsw()`: `bsw_cache`
#' - `ersst()`: `ersst_cache`
#' - `tornadoes()`: `torn_cache`
#' - `ghcnd()`/`ghcnd_search()`: `ghcnd_cache`
#' - `se_data()`/`se_files()`: `stormevents_cache`
#'
NULL

#' @rdname rnoaa_caching
#' @format NULL
#' @usage NULL
#' @export
"isd_cache"

#' @rdname rnoaa_caching
#' @format NULL
#' @usage NULL
#' @export
"cpc_cache"

#' @rdname rnoaa_caching
#' @format NULL
#' @usage NULL
#' @export
"arc2_cache"

#' @rdname rnoaa_caching
#' @format NULL
#' @usage NULL
#' @export
"lcd_cache"

#' @rdname rnoaa_caching
#' @format NULL
#' @usage NULL
#' @export
"bsw_cache"

#' @rdname rnoaa_caching
#' @format NULL
#' @usage NULL
#' @export
"ersst_cache"

#' @rdname rnoaa_caching
#' @format NULL
#' @usage NULL
#' @export
"torn_cache"

#' @rdname rnoaa_caching
#' @format NULL
#' @usage NULL
#' @export
"ghcnd_cache"

#' @rdname rnoaa_caching
#' @format NULL
#' @usage NULL
#' @export
"stormevents_cache"
