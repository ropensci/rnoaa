#' Get NOAA ISD/ISH station data from NOAA FTP server.
#'
#' @export
#' @param refresh (logical) Download station data from NOAA ftp server again.
#' Default: \code{FALSE}
#'
#' @references ftp://ftp.ncdc.noaa.gov/pub/data/noaa/
#' @family isd
#' @details The data table is cached, but you can force download of data from NOAA
#' by setting \code{refresh=TRUE}
#' @return a tibble (data.frame) with the columns:
#' \itemize{
#'  \item usaf - USAF number, character
#'  \item wban - WBAN number, character
#'  \item station_name - station name, character
#'  \item ctry - Country, if given, character
#'  \item state - State, if given, character
#'  \item icao - ICAO number, if given, character
#'  \item lat - Latitude, if given, numeric
#'  \item lon - Longitude, if given, numeric
#'  \item elev_m - Elevation, if given, numeric
#'  \item begin - Begin date of data coverage, of form YYYYMMDD, numeric
#'  \item end - End date of data coverage, of form YYYYMMDD, numeric
#' }
#'
#' @section File storage:
#' We use \pkg{rappdirs} to store files, see
#' \code{\link[rappdirs]{user_cache_dir}} for how we determine the directory on
#' your machine to save files to, and run
#' \code{rappdirs::user_cache_dir("rnoaa")} to get that directory.
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
#' }
isd_stations <- function(refresh = FALSE) {
  path <- normalizePath(file.path(rnoaa_cache_dir(), "isd_stations.rds"))
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
    dat <- stats::setNames(df, gsub("_$", "", gsub("\\.", "_", tolower(names(df)))))
    if (!file.exists(basedir)) dir.create(basedir, recursive = TRUE)
    saveRDS(dat, file = path)
    as_data_frame(dat)
  } else {
    as_data_frame(readRDS(path))
  }
}
