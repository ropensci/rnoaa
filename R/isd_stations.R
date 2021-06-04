#' Get NOAA ISD/ISH station data from NOAA FTP server.
#'
#' @export
#' @param refresh (logical) Download station data from NOAA ftp server again.
#' Default: `FALSE`
#' @references https://ftp.ncdc.noaa.gov/pub/data/noaa/
#' @family isd
#' @details The data table is cached, but you can force download of data from
#' NOAA by setting `refresh=TRUE`
#' @return a tibble (data.frame) with the columns:
#'
#' - usaf - USAF number, character
#' - wban - WBAN number, character
#' - station_name - station name, character
#' - ctry - Country, if given, character
#' - state - State, if given, character
#' - icao - ICAO number, if given, character
#' - lat - Latitude, if given, numeric
#' - lon - Longitude, if given, numeric
#' - elev_m - Elevation, if given, numeric
#' - begin - Begin date of data coverage, of form YYYYMMDD, numeric
#' - end - End date of data coverage, of form YYYYMMDD, numeric
#'
#' @note See [isd_cache] for managing cached files
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
#' }
isd_stations <- function(refresh = FALSE) {
  isd_cache$mkdir()
  path <- suppressWarnings(normalizePath(file.path(isd_cache$cache_path_get(),
    "isd_stations.rds")))
  basedir <- normalizePath(dirname(path), winslash = "/")
  if (refresh || !file.exists(path)) {
    df <- read.csv(paste0(isdbase(), "/isd-history.csv"),
                   header = TRUE, colClasses = 'character',
                   encoding = "UTF-8")
    df$LAT <- as.numeric(df$LAT)
    df$LON <- as.numeric(df$LON)
    df$ELEV.M. <- as.numeric(df$ELEV.M.)
    df$BEGIN <- as.numeric(df$BEGIN)
    df$END <- as.numeric(df$END)
    dat <- stats::setNames(df,
      gsub("_$", "", gsub("\\.", "_", tolower(names(df)))))
    if (!file.exists(basedir)) dir.create(basedir, recursive = TRUE)
    saveRDS(dat, file = path)
    as_tibble(dat)
  } else {
    cache_mssg(path)
    as_tibble(readRDS(path))
  }
}
