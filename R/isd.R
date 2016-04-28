#' Get NOAA ISD/ISH data from NOAA FTP server.
#'
#' @export
#'
#' @param usaf,wban (character) USAF and WBAN code. Required
#' @param year (numeric) One of the years from 1901 to the current year.
#' Required.
#' @param path (character) A path to store the files, a directory. Default:
#' \code{~/.rnoaa/isd}. Required.
#' @param overwrite (logical) To overwrite the path to store files in or not,
#' Default: \code{TRUE}
#' @param cleanup (logical) If \code{TRUE}, remove compressed \code{.gz} file at end of
#' function execution. Processing data takes up a lot of time, so we cache a cleaned version
#' of the data. Cleaning up will save you on disk space. Default: \code{TRUE}
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' 
#' @references ftp://ftp.ncdc.noaa.gov/pub/data/noaa/
#' @seealso \code{\link{isd_stations}}
#' 
#' @details This function first looks for whether the data for your specific query has
#' already been downloaded previously in the directory given by the \code{path}
#' parameter. If not found, the data is requested form NOAA's FTP server. The first time
#' a dataset is pulled down we must a) download the data, b) process the data, and c) save
#' a compressed .rds file to disk. The next time the same data is requested, we only have 
#' to read back in the .rds file, and is quite fast. The benfit of writing to .rds files 
#' is that data is compressed, taking up less space on your disk, and data is read back in 
#' quickly, without changing any data classes in your data, whereas we'd have to jump 
#' through hoops to do that with reading in csv. The processing can take quite a long time
#' since the data is quite messy and takes a bunch of regex to split apart text strings. 
#' We hope to speed this process up in the future. See examples below for different behavior.
#' 
#' @examples \dontrun{
#' # Get station table
#' stations <- isd_stations()
#' head(stations)
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
#' (res <- isd(usaf="172007", wban="99999", year=2015))
#' (res <- isd(usaf="702700", wban="00489", year=2015))
#' (res <- isd(usaf="109711", wban=99999, year=1970))
#'
#' # The first time a dataset is requested takes longer
#' system.time( isd(usaf="782680", wban="99999", year=2011) )
#' system.time( isd(usaf="782680", wban="99999", year=2011) )
#'
#' # Optionally pass in curl options
#' res <- isd(usaf="011490", wban="99999", year=1986, config = verbose())
#'
#' # Plot data
#' ## get data for multiple stations
#' res1 <- isd(usaf="011690", wban="99999", year=1993)
#' res2 <- isd(usaf="172007", wban="99999", year=2015)
#' res3 <- isd(usaf="702700", wban="00489", year=2015)
#' res4 <- isd(usaf="109711", wban=99999, year=1970)
#' ## combine data
#' ### uses rbind.isd (all inputs of which must be of class isd)
#' res_all <- rbind(res1, res2, res3, res4)
#' # add date time
#' library("lubridate")
#' res_all$date_time <- ymd_hm(
#'   sprintf("%s %s", as.character(res_all$date), res_all$time)
#' )
#' ## remove 999's
#' library("dplyr")
#' res_all <- res_all %>% filter(temperature < 900)
#' ## plot
#' library("ggplot2")
#' ggplot(res_all, aes(date_time, temperature)) +
#'   geom_line() + 
#'   facet_wrap(~usaf_station, scales = "free_x")
#' }
isd <- function(usaf, wban, year, path = "~/.rnoaa/isd", overwrite = TRUE, cleanup = TRUE, ...) {
  rdspath <- isd_local(usaf, wban, year, path)
  if (!is_isd(x = rdspath)) {
    isd_GET(bp = path, usaf, wban, year, overwrite, ...)
  }
  message(sprintf("<path>%s", rdspath), "\n")
  structure(list(data = read_isd(x = rdspath, sections, cleanup)), class = "isd")
}

#' @export
#' @rdname isd
rbind.isd <- function(...) {
  input <- list(...)
  if (!all(sapply(input, class) == "isd")) {
    stop("All inputs must be of class isd", call. = FALSE)
  }
  input <- lapply(input, "[[", "data")
  bind_rows(input)
}

#' @export
print.isd <- function(x, ..., n = 10) {
  cat("<ISD Data>", sep = "\n")
  cat(sprintf("Size: %s X %s\n", NROW(x$data), NCOL(x$data)), sep = "\n")
  trunc_mat_(x$data, n = n)
}

isd_GET <- function(bp, usaf, wban, year, overwrite, ...) {
  dir.create(bp, showWarnings = FALSE, recursive = TRUE)
  fp <- isd_local(usaf, wban, year, bp)
  tryget <- tryCatch(suppressWarnings(GET(isd_remote(usaf, wban, year), write_disk(fp, overwrite), ...)), 
           error = function(e) e)
  if (inherits(tryget, "error")) {
    unlink(fp)
    stop("download failed for\n   ", isd_remote(usaf, wban, year), call. = FALSE)
  } else {
    tryget
  }
}

isd_remote <- function(usaf, wban, year) {
  file.path(isdbase(), year, sprintf("%s-%s-%s%s", usaf, wban, year, ".gz"))
}

isd_local <- function(usaf, wban, year, path) {
  file.path(path, sprintf("%s-%s-%s%s", usaf, wban, year, ".gz"))
}

is_isd <- function(x) {
  if (file.exists(x)) TRUE else FALSE
}

isdbase <- function() 'ftp://ftp.ncdc.noaa.gov/pub/data/noaa'

read_isd <- function(x, sections, cleanup) {
  path_rds <- sub("gz", "rds", x)
  if (file.exists(path_rds)) {
    df <- readRDS(path_rds)
  } else {
    lns <- readLines(x)
    linesproc <- lapply(lns, each_line, sections = sections)
    df <- bind_rows(linesproc)
    df <- trans_vars(df)
    cache_rds(path_rds, df)
    if (cleanup) {
      unlink(x)
    }
  }
  return(df)
}

cache_rds <- function(x, y) {
  if (!file.exists(x)) {
    saveRDS(y, file = x)
  }
}

# cache_csv <- function(x, y) {
#   if (!file.exists(x)) {
#     write.csv(y, file = x, row.names = FALSE)
#   }
# }

trans_vars <- function(w) {
  # fix scaled variables
  w$latitude <- trans_var(trycol(w$latitude), 1000)
  w$longitude <- trans_var(trycol(w$longitude), 1000)
  w$elevation <- trans_var(trycol(w$elevation), 10)
  w$wind_speed <- trans_var(trycol(w$wind_speed), 10)
  w$temperature <- trans_var(trycol(w$temperature), 10)
  w$temperature_dewpoint <- trans_var(trycol(w$temperature_dewpoint), 10)
  w$air_pressure <- trans_var(trycol(w$air_pressure), 10)
  w$precipitation <- trans_var(trycol(w$precipitation), 10)
  
  # as date
  w$date <- as.Date(w$date, "%Y%m%d")
  
  # change class
  w$wind_direction <- as.numeric(w$wind_direction)
  w$total_chars <- as.numeric(w$total_chars)
  
  return(w)
}

trycol <- function(x) {
  tt <- tryCatch(x, error = function(e) e)
  if (inherits(tt, "error")) NULL else tt
}

trans_var <- function(x, n) {
  if (is.null(x)) {
    x
  } else {
    as.numeric(x)/n
  }
}

each_line <- function(y, sections){
  normal <- Map(function(a,b) subs(y, a, b), pluck(sections, "start"), pluck(sections, "stop"))
  other <- gsub("\\s+$", "", substring(y, 106, nchar(y)))
  oth <- proc_other(other)
  if (is.null(oth)) {
    dplyr::as_data_frame(normal)
    #data.frame(normal, stringsAsFactors = FALSE)
  } else {
    dplyr::as_data_frame(c(normal, oth))
    #data.frame(normal, oth, stringsAsFactors = FALSE)
  }
}

pluck <- function(input, x) vapply(input, "[[", numeric(1), x)

subs <- function(z, start, stop) substring(z, start, stop)

sections <- list(
  total_chars = list(start = 1,stop = 4),
  usaf_station = list(start = 5,stop = 10),
  wban_station = list(start = 11,stop = 15),
  date = list(start = 16,stop = 23),
  time = list(start = 24,stop = 27),
  date_flag = list(start = 28,stop = 28),
  latitude = list(start = 29,stop = 34),
  longitude = list(start = 35,stop = 41),
  type_code = list(start = 42,stop = 46),
  elevation = list(start = 47,stop = 51),
  call_letter = list(start = 52,stop = 56),
  quality = list(start = 57,stop = 60),
  wind_direction = list(start = 61,stop = 63),
  wind_direction_quality = list(start = 64,stop = 64),
  wind_code = list(start = 65,stop = 65),
  wind_speed = list(start = 66,stop = 69),
  wind_speed_quality = list(start = 70,stop = 70),
  ceiling_height = list(start = 71,stop = 75),
  ceiling_height_quality = list(start = 76,stop = 76),
  ceiling_height_determination = list(start = 77,stop = 77),
  ceiling_height_cavok = list(start = 78,stop = 78),
  visibility_distance = list(start = 79,stop = 84),
  visibility_distance_quality = list(start = 85,stop = 85),
  visibility_code = list(start = 86,stop = 86),
  visibility_code_quality = list(start = 87,stop = 87),
  temperature = list(start = 88,stop = 92),
  temperature_quality = list(start = 93,stop = 93),
  temperature_dewpoint = list(start = 94,stop = 98),
  temperature_dewpoint_quality = list(start = 99,stop = 99),
  air_pressure = list(start = 100,stop = 104),
  air_pressure_quality = list(start = 105,stop = 105)
)

proc_other <- function(x){
  # x <- substring(x, 4, nchar(x))
  tt <- list(check_get(x, "SA1", sa1),
       check_get(x, "REM", rem),
       check_get(x, "AY1", ay1),
       check_get(x, "AY2", ay2),
       check_get(x, "AG1", ag1),
       check_get(x, "GF1", gf1),
       check_get(x, "KA1", ka1),
       check_get(x, "EQD", eqd),
       check_get(x, "MD1", md1),
       check_get(x, "MW1", mw1)
  )
  other <- tt[!vapply(tt, function(x) is.null(x[[1]]), TRUE)]
  unlist(lapply(other, function(z) {
    nms <- names(z)
    tmp <- if (!is_named(z[[1]])) z[[1]][[1]] else z[[1]]
    setNames(tmp, paste(nms, names(tmp), sep = "_"))
  }), FALSE)
}

is_named <- function(x) !is.null(names(x))

check_get <- function(string, pattern, fxn) {
  yy <- regexpr(pattern, string)
  tt <- if (yy > 0) fxn(string) else NULL
  setNames(list(tt), pattern)
}

# str_match_len(x, "SA1", 8)
str_match_len <- function(x, index, length){
  sa1 <- regexpr(index, x)
  if (sa1 > 0) {
    substring(x, sa1[1], sa1[1] + (length - 1))
  } else {
    NULL
  }
}

str_from_to <- function(x, a, b){
  substring(x, a, a + b)
}

str_pieces <- function(z, pieces, nms=NULL){
  tmp <- lapply(pieces, function(x) substring(z, x[1], if (x[2] == 999) nchar(z) else x[2]))
  if (is.null(nms)) tmp else setNames(tmp, nms)
}

# sea surface temperature data
# sa1(x)
sa1 <- function(x) {
  str_pieces(
    str_match_len(x, "SA1", 8),
    list(c(1,3),c(4,7),c(8,8)),
    c('sea_surface','temp','quality')
  )
}

# remarks section
# rem(x)
rem <- function(x){
  str_pieces(
    str_match_len(x, "REM", nchar(x)),
    list(c(1,3),c(4,6),c(7,9),c(10,999)),
    c('remarks','identifier','length_quantity','comment')
  )
}

# past weather manual observation
# ay1(x)
ay1 <- function(x){
  str_pieces(
    str_match_len(x, "AY1", 8),
    list(c(1,3),c(4,4),c(5,5),c(6,7),c(8,8)),
    c('manual_occurrence','condition_code','condition_quality','period','period_quality')
  )
}

# past weather manual observation
# ay2(x)
ay2 <- function(x){
  str_pieces(
    str_match_len(x, "AY2", 8),
    list(c(1,3),c(4,4),c(5,5),c(6,7),c(8,8)),
    c('manual_occurrence','condition_code','condition_quality','period','period_quality')
  )
}

# PRECIPITATION-ESTIMATED-OBSERVATION identifier
# ag1(x)
ag1 <- function(x){
  str_pieces(
    str_match_len(x, "AG1", 7),
    list(c(1,3),c(4,4),c(5,7)),
    c('precipitation','discrepancy','est_water_depth')
  )
}

# sky condition
# gf1(x)
gf1 <- function(x){
  str_pieces(
    str_match_len(x, "GF1", 26),
    list(c(1,3),c(4,5),c(6,7),c(8,8),c(9,10),c(11,11),c(12,13),c(14,14),c(15,19),c(20,20),c(21,22),c(23,23),c(24,25),c(26,26)),
    c('sky_condition','coverage','opaque_coverage','coverage_quality','lowest_cover','lowest_cover_quality',
      'low_cloud_genus','low_cloud_genus_quality','lowest_cloud_base_height','lowest_cloud_base_height_quality',
      'mid_cloud_genus','mid_cloud_genus_quality','high_cloud_genus','high_cloud_genus_quality')
  )
}

# extreme air temperature
# ka1(x)
ka1 <- function(x){
  str_pieces(
    str_match_len(x, "KA1", 13),
    list(c(1,3),c(4,6),c(7,7),c(8,12),c(13,13)),
    c('extreme_temp','period_quantity','max_min','temp','temp_quality')
  )
}

# element data quality section
# eqd(x)
eqd <- function(x){
  eqdtmp <- str_match_len(x, "EQD", nchar(x))
  eqdmtchs <- gregexpr("Q[0-9]{2}", eqdtmp)
  segments <- str_from_to(eqdtmp, eqdmtchs[[1]], 13)
  lapply(segments, function(m){
    str_pieces(m,
               list(c(1,3),c(4,9),c(10,10),c(11,16)),
               c('observation_identifier','observation_text','reason_code','parameter')
    )
  })
}

# atmospheric pressure change
# md1(x)
md1 <- function(x){
  str_pieces(
    str_match_len(x, "MD1", 14),
    list(c(1,3),c(4,4),c(5,5),c(6,8),c(9,9),c(10,13),c(14,14)),
    c('atmospheric_change','tendency','tendency_quality','three_hr','three_hr_quality',
      'twentyfour_hr','twentyfour_hr_quality')
  )
}

# PRESENT-WEATHER-OBSERVATION manual occurrence identifier, MW1=first weather reported
# mw1(x)
mw1 <- function(x){
  str_pieces(
    str_match_len(x, "MW1", 6),
    list(c(1,3),c(4,5),c(6,6)),
    c('first_weather_reported','condition','condition_quality')
  )
}
