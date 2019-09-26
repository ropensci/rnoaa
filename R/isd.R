#' Get and parse NOAA ISD/ISH data
#'
#' @export
#'
#' @param usaf,wban (character) USAF and WBAN code. Required
#' @param year (numeric) One of the years from 1901 to the current year.
#' Required.
#' @param overwrite (logical) To overwrite the path to store files in or not,
#' Default: `TRUE`
#' @param cleanup (logical) If `TRUE`, remove compressed `.gz` file
#' at end of function execution. Processing data takes up a lot of time, so we
#' cache a cleaned version of the data. Cleaning up will save you on disk
#' space. Default: `TRUE`
#' @param additional (logical) include additional and remarks data sections
#' in output. Default: `TRUE`. Passed on to
#' [isdparser::isd_parse()]
#' @param parallel (logical) do processing in parallel. Default: `FALSE`
#' @param cores (integer) number of cores to use: Default: 2. We look in
#' your option "cl.cores", but use default value if not found.
#' @param progress (logical) print progress - ignored if \code{parallel=TRUE}.
#' The default is `FALSE` because printing progress adds a small bit of
#' time, so if processing time is important, then keep as `FALSE`
#' @param force (logical) force download? Default: `FALSE`
#' We use a cached version (an .rds compressed file) if it exists, but
#' this will override that behavior.
#' @param ... Curl options passed on to [crul::verb-GET]
#'
#' @references ftp://ftp.ncdc.noaa.gov/pub/data/noaa/
#' @family isd
#'
#' @details `isd` saves the full set of weather data for the queried
#' site locally in the directory specified by the `path` argument. You
#' can access the path for the cached file via `attr(x, "source")`
#'
#' We use \pkg{isdparser} internally to parse ISD files. They are
#' relatively complex to parse, so a separate package takes care of that.
#'
#' @note There are now no transformations (scaling, class changes, etc.)
#' done on the output data. This may change in the future with parameters
#' to toggle transformations, but none are done for now. See
#' [isdparser::isd_transform()] for transformation help.
#' Comprehensive transformations for all variables are not yet available
#' but should be available in the next version of this package.
#'
#' @return A tibble (data.frame).
#'
#' @details This function first looks for whether the data for your specific
#' query has already been downloaded previously in the directory given by
#' the `path` parameter. If not found, the data is requested form NOAA's
#' FTP server. The first time a dataset is pulled down we must a) download the
#' data, b) process the data, and c) save a compressed .rds file to disk. The
#' next time the same data is requested, we only have to read back in the
#' .rds file, and is quite fast. The benfit of writing to .rds files is that
#' data is compressed, taking up less space on your disk, and data is read
#' back in quickly, without changing any data classes in your data, whereas
#' we'd have to jump through hoops to do that with reading in csv. The
#' processing can take quite a long time since the data is quite messy and
#' takes a bunch of regex to split apart text strings. We hope to speed
#' this process up in the future. See examples below for different behavior.
#'
#' @section Errors:
#' Note that when you get an error similar to `Error: download failed for
#' ftp://ftp.ncdc.noaa.gov/pub/data/noaa/1955/011490-99999-1955.gz`, the
#' file does not exist on NOAA's ftp servers. If your internet is down,
#' you'll get a different error.
#'
#' @section File storage:
#' We use \pkg{rappdirs} to store files, see
#' [rappdirs::user_cache_dir()] for how we determine the directory on
#' your machine to save files to, and run
#' `rappdirs::user_cache_dir("rnoaa/isd")` to get that directory.
#' 
#' Note that cached files will continue to be used until they are deleted.
#' It's possible to run into problems when changes happen in your R 
#' setup. For example, at least one user reported changing versions
#' of this package and running into problems because a cached data
#' file from a previous version of rnoaa did not work with the newer
#' version of rnoaa. You may want to occassionally delete all cached
#' files.
#'
#' @examples \dontrun{
#' # Get station table
#' (stations <- isd_stations())
#'
#' ## plot stations
#' ### remove incomplete cases, those at 0,0
#' df <- stations[complete.cases(stations$lat, stations$lon), ]
#' df <- df[df$lat != 0, ]
#' ### make plot
#' library("leaflet")
#' leaflet(data = df) %>%
#'   addTiles() %>%
#'   addCircles()
#'
#' # Get data
#' (res <- isd(usaf="011490", wban="99999", year=1986))
#' (res <- isd(usaf="011690", wban="99999", year=1993))
#' (res <- isd(usaf="109711", wban=99999, year=1970))
#'
#' # "additional" and "remarks" data sections included by default
#' # can toggle that parameter to not include those in output, saves time
#' (res1 <- isd(usaf="011490", wban="99999", year=1986, force = TRUE))
#' (res2 <- isd(usaf="011490", wban="99999", year=1986, force = TRUE,
#'   additional = FALSE))
#'
#' # The first time a dataset is requested takes longer
#' system.time( isd(usaf="782680", wban="99999", year=2011) )
#' system.time( isd(usaf="782680", wban="99999", year=2011) )
#'
#' # Plot data
#' ## get data for multiple stations
#' res1 <- isd(usaf="011690", wban="99999", year=1993)
#' res2 <- isd(usaf="782680", wban="99999", year=2011)
#' res3 <- isd(usaf="008415", wban="99999", year=2016)
#' res4 <- isd(usaf="109711", wban=99999, year=1970)
#' ## combine data
#' library(dplyr)
#' res_all <- bind_rows(res1, res2, res3, res4)
#' # add date time
#' library("lubridate")
#' res_all$date_time <- ymd_hm(
#'   sprintf("%s %s", as.character(res_all$date), res_all$time)
#' )
#' ## remove 999's
#' res_all <- res_all %>% filter(temperature < 900)
#' ## plot
#' library("ggplot2")
#' ggplot(res_all, aes(date_time, temperature)) +
#'   geom_line() +
#'   facet_wrap(~usaf_station, scales = "free_x")
#'
#' # print progress
#' (res <- isd(usaf="011690", wban="99999", year=1993, progress=TRUE))
#'
#' # parallelize processing
#' (res <- isd(usaf="172007", wban="99999", year=2016, parallel=TRUE))
#' }
isd <- function(usaf, wban, year, overwrite = TRUE, cleanup = TRUE,
                additional = TRUE, parallel = FALSE,
                cores = getOption("cl.cores", 2), progress = FALSE,
                force = FALSE, ...) {

  calls <- names(sapply(match.call(), deparse))[-1]
  calls_vec <- "path" %in% calls
  if (any(calls_vec)) {
    stop("The parameter path has been removed, see docs for ?isd",
         call. = FALSE)
  }

  path <- file.path(rnoaa_cache_dir(), "isd")
  rdspath <- isd_local(usaf, wban, year, path, ".rds")
  if (!is_isd(x = rdspath) || force) {
    isd_GET(bp = path, usaf, wban, year, overwrite, ...)
  }
  df <- read_isd(x = rdspath, cleanup, force, additional,
                 parallel, cores, progress)
  attr(df, "source") <- rdspath
  df
}

isd_GET <- function(bp, usaf, wban, year, overwrite, ...) {
  dir.create(bp, showWarnings = FALSE, recursive = TRUE)
  fp <- isd_local(usaf, wban, year, bp, ".gz")
  cli <- crul::HttpClient$new(isd_remote(usaf, wban, year), opts = list(...))
  tryget <- tryCatch(
    suppressWarnings(cli$get(disk = fp)),
    error = function(e) e
  )
  if (inherits(tryget, "error")) {
    unlink(fp)
    stop("download failed for\n   ", isd_remote(usaf, wban, year),
         call. = FALSE)
  } else {
    tryget
  }
}

isd_remote <- function(usaf, wban, year) {
  file.path(isdbase(), year, sprintf("%s-%s-%s%s", usaf, wban, year, ".gz"))
}

isd_local <- function(usaf, wban, year, path, ext) {
  file.path(path, sprintf("%s-%s-%s%s", usaf, wban, year, ext))
}

is_isd <- function(x) {
  if (file.exists(x)) TRUE else FALSE
}

isdbase <- function() 'ftp://ftp.ncdc.noaa.gov/pub/data/noaa'

read_isd <- function(x, cleanup, force, additional, parallel, cores, progress) {
  path_rds <- x
  if (file.exists(path_rds) && !force) {
    message("found in cache")
    df <- readRDS(path_rds)
  } else {
    df <- isdparser::isd_parse(
      sub("rds", "gz", x), additional = additional, parallel = parallel,
      cores = cores, progress = progress
    )
    cache_rds(path_rds, df)
    if (cleanup) {
      unlink(sub("rds", "gz", x))
    }
  }
  return(df)
}

cache_rds <- function(x, y) {
  if (!file.exists(x)) {
    saveRDS(y, file = x)
  }
}
