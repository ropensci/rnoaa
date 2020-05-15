#' Get information on the GHCND weather stations
#'
#' This function returns an object with a dataframe with meta-information
#' about all available GHCND weather stations.
#'
#' @export
#' @inheritParams ghcnd
#'
#' @return This function returns a tibble (dataframe) with a weather
#' station on each row with the following columns:
#' 
#' - `id`: The weather station's ID number. The first two letters
#'    denote the country (using FIPS country codes).
#' - `latitude`: The station's latitude, in decimal degrees.
#'    Southern latitudes will be negative.
#' - `longitude`: The station's longitude, in decimal degrees.
#'    Western longitudes will be negative.
#' - `elevation`: The station's elevation, in meters.
#' - `name`: The station's name.
#' - `gsn_flag`: "GSN" if the monitor belongs to the GCOS Surface
#'    Network (GSN). Otherwise either blank or missing.
#' - `wmo_id`: If the station has a WMO number, this column gives
#'    that number. Otherwise either blank or missing.
#' - `element`: A weather variable recorded at some point during
#'    that station's history. See the link below in "References" for
#'    definitions of the abbreviations used for this variable.
#' - `first_year`: The first year of data available at that station
#'    for that weather element.
#' - `last_year`: The last year of data available at that station
#'    for that weather element.
#'
#' If a weather station has data on more than one weather variable,
#' it will be represented in multiple rows of this output dataframe.
#'
#' @note Since this function is pulling a large dataset by ftp, it may take
#' a while to run.
#' @references For more documentation on the returned dataset, see
#' http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/readme.txt
#' @examples \dontrun{
#' # Get stations, ghcnd-stations and ghcnd-inventory merged
#' (stations <- ghcnd_stations())
#'
#' library(dplyr)
#' # filter by state
#' stations %>% filter(state == "IL")
#' stations %>% filter(state == "OR")
#' # those without state values
#' stations %>% filter(state == "")
#' # filter by element
#' stations %>% filter(element == "PRCP")
#' # filter by id prefix
#' stations %>% filter(grepl("^AF", id))
#' stations %>% filter(grepl("^AFM", id))
#' # filter by station long name
#' stations %>% filter(name == "CALLATHARRA")
#' }
ghcnd_stations <- function(refresh = FALSE, ...) {
  assert(refresh, "logical")
  stopifnot(length(refresh) == 1)
  sta <- get_stations(refresh, ...)
  inv <- get_inventory(refresh, ...)
  df <- merge(sta, inv[, -c(2, 3)], by = "id")
  tibble::as_tibble(df[stats::complete.cases(df), ])
}

get_stations <- function(refresh = FALSE, ...) {
  ff <- file.path(ghcnd_cache$cache_path_get(), "ghcnd-stations.txt")
  ffrds <- file.path(ghcnd_cache$cache_path_get(), "ghcnd-stations.rds")
  if (file.exists(ffrds) && !refresh) {
    cache_mssg(ffrds)
    return(readRDS(ffrds))
  } else {
    if (file.exists(ff)) unlink(ff)
    if (file.exists(ffrds)) unlink(ffrds)
    ghcnd_cache$mkdir()
    res <- GET_retry(
      "ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-stations.txt",
      disk = ff, ...)
    df <- read.fwf(as_tc_p(res),
      widths = c(11, 9, 11, 7, 2, 31, 5, 10),
      header = FALSE, strip.white = TRUE, comment.char = "",
      stringsAsFactors = FALSE)
    nms <- c("id","latitude", "longitude", "elevation",
             "state", "name", "gsn_flag", "wmo_id")
    df <- stats::setNames(df, nms)
    saveRDS(df, file = ffrds)
    unlink(ff)
    return(df)
  }
}

get_inventory <- function(refresh = FALSE, ...) {
  gg <- file.path(ghcnd_cache$cache_path_get(), "ghcnd-inventory.txt")
  ggrds <- file.path(ghcnd_cache$cache_path_get(), "ghcnd-inventory.rds")
  if (file.exists(ggrds) && !refresh) {
    cache_mssg(ggrds)
    return(readRDS(ggrds))
  } else {
    if (file.exists(gg)) unlink(gg)
    if (file.exists(ggrds)) unlink(ggrds)
    ghcnd_cache$mkdir()
    res <- GET_retry(
      "ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-inventory.txt",
      disk = gg, ...)
    df <- read.fwf(as_tc_p(res),
      widths = c(11, 9, 10, 5, 5, 5),
      header = FALSE, strip.white = TRUE, comment.char = "",
      stringsAsFactors = FALSE)
    nms <- c("id","latitude", "longitude",
             "element", "first_year", "last_year")
    df <- stats::setNames(df, nms)
    saveRDS(df, file = ggrds)
    unlink(gg)
    return(df)
  }
}
