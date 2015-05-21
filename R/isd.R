#' Get NOAA ISD/ISH data from NOAA FTP server.
#'
#' @export
#' @name isd
#'
#' @param usaf,wban (character) USAF and WBAN code. Required
#' @param year (numeric) One of the years from 1901 to the current year. 
#' Required.
#' @param path (character) A path to store the files, a directory. Default: 
#' \code{~/.rnoaa/isd}. Required.
#' @param overwrite (logical) To overwrite the path to store files in or not, 
#' Default: \code{TRUE}
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @references ftp://ftp.ncdc.noaa.gov/pub/data/noaa/
#' @details This function first looks for whether the data for your specific query has
#' already been downloaded previously in the directory given by the \code{path} 
#' parameter. If not found, the data is requested form NOAA's FTP server. The first time 
#' a dataset is pulled down we must a) download the data, b) process the data, and c) save
#' a .csv file to disk. The next time the same data is requested, we only have to read 
#' back in the .csv file, and is quite fast. The processing can take quite a long time 
#' since the data is quite messy and takes a bunch of regex to split apart text strings.
#' See examples below for different behavior.
#' @examples \dontrun{
#' # Get station table
#' stations <- isd_stations()
#' head(stations)
#'
#' # Get data
#' (res <- isd(usaf="011490", wban="99999", year=1986))
#' (res <- isd(usaf="011690", wban="99999", year=1993))
#' (res <- isd(usaf="172007", wban="99999", year=2015))
#' (res <- isd(usaf="702700", wban="00489", year=2015))
#' 
#' # The first time a dataset is requested takes longer
#' system.time( isd(usaf="782680", wban="99999", year=2011) )
#' system.time( isd(usaf="782680", wban="99999", year=2011) )
#' }

#' @export
#' @rdname isd
isd <- function(usaf, wban, year, path = "~/.rnoaa/isd", overwrite = TRUE) {
  csvpath <- isd_local(usaf, wban, year, path)
  if (!is_isd(x = csvpath)) {
    isd_GET(path, usaf, wban, year, overwrite)
  }
  message(sprintf("<path>%s", csvpath), "\n")
  structure(list(data = read_isd(csvpath, sections)), class = "isd")
}

#' @export
#' @rdname isd
isd_stations <- function(...) {
  res <- suppressWarnings(GET("ftp://ftp.ncdc.noaa.gov/pub/data/noaa/isd-history.csv", ...))
  df <- read.csv(text = content(res, "text"), header = TRUE)
  setNames(df, gsub("_$", "", gsub("\\.", "_", tolower(names(df)))))
}

#' @export
print.isd <- function(x, ..., n = 10) {
  cat("<ISD Data>", sep = "\n")
  cat(sprintf("Size: %s X %s\n", NROW(x$data), NCOL(x$data)), sep = "\n")
  trunc_mat_(x$data, n = n)
}

isd_GET <- function(bp, usaf, wban, year, overwrite) {
  dir.create(bp, showWarnings = FALSE, recursive = TRUE)
  fp <- isd_local(usaf, wban, year, bp)
  suppressWarnings(GET(isd_remote(usaf, wban, year), write_disk(fp, overwrite)))
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

read_isd <- function(x, sections) {
  path_csv <- sub("gz", "csv", x)
  if (file.exists(path_csv)) {
    df <- read.csv(path_csv, stringsAsFactors = FALSE)
  } else {
    lns <- readLines(x)
    linesproc <- lapply(lns, each_line, sections = sections)
    df <- dplyr::rbind_all(linesproc)
    cache_csv(path_csv, df)
  }
  return(df)
}

cache_csv <- function(x, y) {
  if (!file.exists(x)) {
    write.csv(y, file = x, row.names = FALSE)
  }
}

each_line <- function(y, sections){
  pluck <- function(input, x) vapply(input, "[[", numeric(1), x)
  subs <- function(z, start, stop) substring(z, start, stop)
  normal <- Map(function(a,b) subs(y, a, b), pluck(sections, "start"), pluck(sections, "stop"))
  other <- gsub("\\s+$", "", substring(y, 106, nchar(y)))
  data.frame(normal, proc_other(other), stringsAsFactors = FALSE)
}

sections <- list(
  total_chars=list(start=1,stop=4),
  usaf_station=list(start=5,stop=10),
  wban_station=list(start=11,stop=15),
  date=list(start=16,stop=23),
  time=list(start=24,stop=27),
  date_flag=list(start=28,stop=28),
  latitude=list(start=29,stop=34),
  longitude=list(start=35,stop=41),
  type_code=list(start=42,stop=46),
  elevation=list(start=47,stop=51),
  call_letter=list(start=52,stop=56),
  quality=list(start=57,stop=60),
  wind_direction=list(start=61,stop=63),
  wind_direction_quality=list(start=64,stop=64),
  wind_code=list(start=65,stop=65),
  wind_speed=list(start=66,stop=69),
  wind_speed_quality=list(start=70,stop=70),
  ceiling_height=list(start=71,stop=75),
  ceiling_height_quality=list(start=76,stop=76),
  ceiling_height_determination=list(start=77,stop=77),
  ceiling_height_cavok=list(start=78,stop=78),
  visibility_distance=list(start=79,stop=84),
  visibility_distance_quality=list(start=85,stop=85),
  visibility_code=list(start=86,stop=86),
  visibility_code_quality=list(start=87,stop=87),
  temperature=list(start=88,stop=92),
  temperature_quality=list(start=93,stop=93),
  temperature_dewpoint=list(start=94,stop=98),
  temperature_dewpoint_quality=list(start=99,stop=99),
  air_pressure=list(start=100,stop=104),
  air_pressure_quality=list(start=105,stop=105)
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
  other <- tt[!sapply(tt, function(x) is.null(x[[1]]))]
  do.call(cbind, lapply(other, data.frame, stringsAsFactors = FALSE))
}

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
