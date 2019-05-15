#' Local Climitalogical Data from NOAA
#'
#' @export
#' @param station (character) station code, e.g., "02413099999". we will
#' allow integer/numeric passed here, but station ids can have leading
#' zeros, so it's a good idea to keep stations as character class. required
#' @param year (integer) year, e.g., 2017. required
#' @param ... curl options passed on to [crul::verb-GET]
#' @param x result of a call to `lcd()`. required
#' @return a data.frame, with many columns, and variable rows
#' depending on how frequently data was collected in the given year
#'
#' @references <https://www.ncdc.noaa.gov/cdo-web/datatools/lcd>
#' <https://www1.ncdc.noaa.gov/pub/data/cdo/documentation/LCD_documentation.pdf>
#' 
#' @note Beware that there are multiple columns with comma-delimited data 
#' joined together. In the next version of this package we'll try to have the
#' data cleaning done for you. 
#' 
#' @details `lcd_cleanup()` takes the output of `lcd()` and parses additional
#' columns that have comma separated strings into separate columns with 
#' headings; so `lcd_cleanup()` adds many additional columns
#' 
#' @return a data.frame with many columns. the first 10 are metadata:
#' 
#' - station
#' - date
#' - source
#' - latitude
#' - longitude
#' - elevation
#' - name
#' - report_type
#' - call_sign
#' - quality_control
#' 
#' And the rest should be all data columns. See Note about data joined
#' together.
#' 
#' Other groups of fields under the following:
#' 
#' - wnd: wind
#' - tmp: air temperature
#' - aa: LIQUID-PRECIPITATION
#' - aj: snow depth
#' - ay: PAST-WEATHER-OBSERVATION
#' - oc: WIND-GUST-OBSERVATION
#' - dew: dew point
#' - slp: sea level pressure
#' - cig: sky condition
#' - ka: extreme air temperature
#' - ma: atmospheric pressure
#' - md: atmospheric pressure change
#' - ga: SKY-COVER-LAYER
#' - ge: SKY-CONDITION-OBSERVATION
#' - gf: SKY-CONDITION-OBSERVATION
#' - ia: GROUND-SURFACE-OBSERVATION
#' - mw: PRESENT-WEATHER-OBSERVATION
#' - rem: remarks
#'
#' @examples \dontrun{
#' lcd(station = "01338099999", year = "2017")
#' lcd(station = "01338099999", year = "2015")
#'
#' lcd(station = "02413099999", year = "2009")
#' lcd(station = "02413099999", year = "2001")
#'
#' # pass curl options
#' lcd(station = "02413099999", year = "2002", verbose = TRUE)
#' 
#' # clean up columns
#' w <- lcd(station = "01338099999", year = "2017")
#' w
#' lcd_cleanup(w)
#' }
lcd <- function(station, year, ...) {
  assert(station, c("character", "numeric", "integer"))
  assert(year, c("character", "numeric", "integer"))
  assert_range(year, 1901:format(Sys.Date(), "%Y"))

  path <- lcd_get(station = station, year = year, ...)
  tmp <- read.csv(path, header = TRUE, sep = ",", stringsAsFactors = FALSE)
  names(tmp) <- tolower(names(tmp))
  df <- tibble::as_tibble(tmp)
  structure(df, class = c(class(df), "lcd"))
}

lcd_cols_to_clean <- c("wnd", "cig", "vis", "tmp", "dew", "slp", "aa1",
  "aa2", "aj1", "ay1", "ay2", "ga1", "ga2", "ga3", "ge1", "gf1", "ia1",
  "ka1", "ka2", "ma1", "md1", "mw1", "oc1", "od1", "rem", "eqd")

aa_cols <- c("aa%s_hrs", "aa%s_mm", "aa%s_code", "aa%s_qa")
aj_cols <- c("aj%s_depth_cm", "aj%s_code", "aj%s_code_qa", "aj%s_eq_water_mm",
  "aj%s_eq_water_code", "aj%s_eq_water_code_qa")
ay_cols <- c("ay%s_code", "ay%s_code_qa", "ay%s_period_hrs",
  "ay%s_period_hrs_qa")
ka_cols <- c("ka%s_hrs", "ka%s_min", "ka%s_cel", "ka%s_cel_qa")
ga_cols <- c("ga%s_cov", "ga%s_cov_qa", "ga%s_height_m", "ga%s_height_qa",
  "ga%s_cloud_type", "ga%s_cloud_type_qa")
ge_cols <- c("ge%s_conn_cloud", "ge%s_vert", "ge%s_hgt_upper_m",
  "ge%s_hgt_lower_m")
gf_cols <- c("gf%s_code", "gf%s_opaque_code", "gf%s_code_qa",
  "gf%s_lowest_code", "gf%s_lowest_code_qa", "gf%s_low_code",
  "gf%s_low_code_qa", "gf%s_low_hgt_m", "gf%s_low_hgt_qa",
  "gf%s_mid_code", "gf%s_mide_code_qa", "gf%s_high_code",
  "gf%s_high_code_qa")
ia_cols <- c("ia%s_code", "ia%s_code_qa")
mw_cols <- c("mw%s_code", "mw%s_code_qa")

lcd_cols <- list(
  wnd = c("w_angle", "w_a_qa", "w_type", "w_speed_mps", "w_s_qa"),
  tmp = c("t_degree_c", "t_qa"),
  aa1 = sprintf(aa_cols, 1),
  aa2 = sprintf(aa_cols, 2),
  aj1 = sprintf(aj_cols, 1),
  ay1 = sprintf(ay_cols, 1),
  ay2 = sprintf(ay_cols, 2),
  oc1 = c("wg_speed_mps", "wg_qa"),
  dew = c("dew_temp", "dew_qa"),
  slp = c("slp_hg", "slp_qa"),
  # cig = c("cig_", ""),
  vis = c("vis_m", "vis_m_qa", "vis_var", "vis_var_qa"),
  ka1 = sprintf(ka_cols, 1),
  ka2 = sprintf(ka_cols, 2),
  ma1 = c("ma1_hg", "ma1_hPa", "ma1_hPa_aq", "ma1_hPa_qa"),
  md1 = c("md1_tendency", "md1_tendency_qa", "md1_hPa", "md1_hPa_qa",
    "md1_hPa_24hr", "md1_hPa_24hr_qa"),
  od1 = c("od1_type", "od1_period_hrs", "od1_speed_mps",
    "od1_speed_qa", "od1_anular_deg"),
  ga1 = sprintf(ga_cols, 1),
  ga2 = sprintf(ga_cols, 2),
  ga3 = sprintf(ga_cols, 3),
  ge1 = sprintf(ge_cols, 1),
  gf1 = sprintf(gf_cols, 1),
  ia1 = sprintf(ia_cols, 1),
  mw1 = sprintf(mw_cols, 1)
)

separ_ate <- function(x, col, new_cols) {
  tidyr::separate(x, col, new_cols, sep = ",",
    remove = TRUE, convert = TRUE, extra = "drop")
}

#' @export
#' @rdname lcd
lcd_cleanup <- function(x) {
  assert(x, "lcd")
  for (i in seq_along(lcd_cols)) {
    x <- separ_ate(x, names(lcd_cols)[i], lcd_cols[[names(lcd_cols)[i]]])
  }
  return(x)
}

lcd_get <- function(station, year, overwrite = FALSE, ...) {
  lcd_cache$mkdir()
  key <- lcd_key(station, year)
  file <- file.path(lcd_cache$cache_path_get(),
    sprintf("%s_%s.csv", year, station))
  if (!file.exists(file)) {
    suppressMessages(lcd_GET_write(key, file, overwrite, ...))
  }
  return(file)
}

lcd_GET_write <- function(url, path, overwrite = TRUE, ...) {
  cli <- crul::HttpClient$new(url = url, opts = list(...))
  if (!overwrite) {
    if (file.exists(path)) {
      stop("file exists and ovewrite != TRUE", call. = FALSE)
    }
  }
  res <- tryCatch(cli$get(disk = path), error = function(e) e)
  if (!res$success()) {
    on.exit(unlink(path), add = TRUE)
    res$raise_for_status()
  }
  # government shutdown check
  if (any(grepl("shutdown", unlist(res$response_headers_all)))) {
    on.exit(unlink(path), add = TRUE)
    stop("there's a government shutdown; check back later")
  }
  return(res)
}

lcd_base <- function() {
  "https://www.ncei.noaa.gov/data/global-hourly/access"
}

lcd_key <- function(station, year) {
  file.path(lcd_base(), year, paste0(station, ".csv"))
}
