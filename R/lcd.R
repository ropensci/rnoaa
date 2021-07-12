#' Local Climatological Data from NOAA
#'
#' @export
#' @param station (character) station code, e.g., "02413099999". we will allow
#'   integer/numeric passed here, but station ids can have leading zeros, so
#'   it's a good idea to keep stations as character class. required
#' @param year (integer) year, e.g., 2017. required
#' @param col_types (named character vector) defaults to NULL. Use this argument
#'   to change the returned column type. For example,"character" instead of
#'   "numeric". See or use [lcd_columns] to create a named vector with allowed
#'   column names. If the user specified type is not compatible, the function
#'   will choose a type automatically and raise a message. optional
#' @param ... curl options passed on to [crul::verb-GET]
#' @note See [lcd_cache] for managing cached files
#' @references Docs:
#' https://www.ncei.noaa.gov/data/local-climatological-data/doc/LCD_documentation.pdf
#' Data comes from:
#' https://www.ncei.noaa.gov/data/local-climatological-data/access
#'
#' @return a data.frame with many columns. the first 10 are metadata:
#'
#'   - station 
#'   - date 
#'   - latitude 
#'   - longitude 
#'   - elevation 
#'   - name 
#'   - report_type 
#'   - source
#'
#'   And the rest should be all data columns. The first part of many column
#'   names is the time period, being one of:
#'
#'   - hourly 
#'   - daily 
#'   - monthly 
#'   - shortduration
#'
#'   So the variable you are looking for may not be the first part of the column
#'   name
#'
#' @examples \dontrun{
#' x = lcd(station = "01338099999", year = 2017)
#' lcd(station = "01338099999", year = 2015)
#' lcd(station = "02413099999", year = 2009)
#' lcd(station = "02413099999", year = 2001)
#'
#' # pass curl options
#' lcd(station = "02413099999", year = 2002, verbose = TRUE)
#' }
lcd <- function(station, year, col_types = NULL, ...) {
  assert(station, c("character", "numeric", "integer"))
  assert(year, c("character", "numeric", "integer"))
  assert_range(year, 1901:format(Sys.Date(), "%Y"))

  path <- lcd_get(station = station, year = year, ...)
  # check that user specified values are proper R classes,
  # trying to minimize chances this gets run twice,
  # however users can create the col_type vector without using lcd_columns
  # and this checks for valid user specified values in that case.
  if (!is.null(col_types)) {
    # check that input values are proper R classes
    column_error <- check_lcd_columns(col_types)
    if (!is.null(column_error)) {
      stop(column_error)
    }
  } else {
    # this is already checked
    col_types <- lcd_columns()
  }
  # check that col_types is character
  assert(col_types, c("character"))
  tmp <- safe_read_csv(path, col_types = col_types)
  names(tmp) <- tolower(names(tmp))
  tibble::as_tibble(tmp)
}

lcd_get <- function(station, year, overwrite = FALSE, ...) {
  lcd_cache$mkdir()
  key <- lcd_key(station, year)
  file <- file.path(lcd_cache$cache_path_get(),
    sprintf("%s_%s.csv", year, station))
  if (!file.exists(file)) {
    suppressMessages(lcd_GET_write(key, file, overwrite, ...))
  } else {
    cache_mssg(file)
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
  "https://www.ncei.noaa.gov/data/local-climatological-data/access"
}

lcd_key <- function(station, year) {
  file.path(lcd_base(), year, paste0(station, ".csv"))
}

#' Specify Variable Types in Local Climatological Data from NOAA
#'
#' Use this function to specify what variable types will be returned by
#' [lcd]. The function returns a named vector with specified column
#' classes. The defaults are specified in the argument descriptions below.
#'
#' @param STATION (character) string indicating variable or column type that is returned, default is "character". optional
#' @param LATITUDE (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param LONGITUDE (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param ELEVATION (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param NAME (character) string indicating variable or column type that is returned, default is "character". optional
#' @param REPORT_TYPE (character) string indicating variable or column type that is returned, default is "character". optional
#' @param SOURCE (character) string indicating variable or column type that is returned, default is "character". optional
#' @param HourlyAltimeterSetting (character) string indicating variable or column type that is returned, default is "character". optional
#' @param HourlyDewPointTemperature (character) string indicating variable or column type that is returned, default is "character". optional
#' @param HourlyDryBulbTemperature (character) string indicating variable or column type that is returned, default is "character". optional
#' @param HourlyPrecipitation (character) string indicating variable or column type that is returned, default is "character". optional
#' @param HourlyPresentWeatherType (character) string indicating variable or column type that is returned, default is "character". optional
#' @param HourlyPressureChange (character) string indicating variable or column type that is returned, default is "character". optional
#' @param HourlyPressureTendency (character) string indicating variable or column type that is returned, default is "integer". optional
#' @param HourlyRelativeHumidity (character) string indicating variable or column type that is returned, default is "character". optional
#' @param HourlySkyConditions (character) string indicating variable or column type that is returned, default is "character". optional
#' @param HourlySeaLevelPressure (character) string indicating variable or column type that is returned, default is "character". optional
#' @param HourlyStationPressure (character)string indicating variable or column type that is returned, default is "character". optional
#' @param HourlyVisibility (character) string indicating variable or column type that is returned, default is "character". optional
#' @param HourlyWetBulbTemperature (character) string indicating variable or column type that is returned, default is "character". optional
#' @param HourlyWindDirection (character) string indicating variable or column type that is returned, default is "character". optional
#' @param HourlyWindGustSpeed (character) string indicating variable or column type that is returned, default is "character". optional
#' @param HourlyWindSpeed (character) string indicating variable or column type that is returned, default is "character". optional
#' @param Sunrise (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param Sunset (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param DailyAverageDewPointTemperature (character) string indicating variable or column type that is returned, default is "character". optional
#' @param DailyAverageDryBulbTemperature (character) string indicating variable or column type that is returned, default is "character". optional
#' @param DailyAverageRelativeHumidity (character) string indicating variable or column type that is returned, default is "character". optional
#' @param DailyAverageSeaLevelPressure (character) string indicating variable or column type that is returned, default is "character". optional
#' @param DailyAverageStationPressure (character) string indicating variable or column type that is returned, default is "character". optional
#' @param DailyAverageWetBulbTemperature (character) string indicating variable or column type that is returned, default is "character". optional
#' @param DailyAverageWindSpeed (character) string indicating variable or column type that is returned, default is "character". optional
#' @param DailyCoolingDegreeDays (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param DailyDepartureFromNormalAverageTemperature (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param DailyHeatingDegreeDays (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param DailyMaximumDryBulbTemperature (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param DailyMinimumDryBulbTemperature (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param DailyPeakWindDirection (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param DailyPeakWindSpeed (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param DailyPrecipitation (character) string indicating variable or column type that is returned, default is "character". optional
#' @param DailySnowDepth (character) string indicating variable or column type that is returned, default is "character". optional
#' @param DailySnowfall (character) string indicating variable or column type that is returned, default is "character". optional
#' @param DailySustainedWindDirection (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param DailySustainedWindSpeed (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param DailyWeather (character) string indicating variable or column type that is returned, default is "character". optional
#' @param MonthlyAverageRH (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyDaysWithGT001Precip (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyDaysWithGT010Precip (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyDaysWithGT32Temp (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyDaysWithGT90Temp (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyDaysWithLT0Temp (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyDaysWithLT32Temp (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyDepartureFromNormalAverageTemperature (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyDepartureFromNormalCoolingDegreeDays (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyDepartureFromNormalHeatingDegreeDays (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyDepartureFromNormalMaximumTemperature (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyDepartureFromNormalMinimumTemperature (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyDepartureFromNormalPrecipitation (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyDewpointTemperature (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyGreatestPrecip (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyGreatestPrecipDate (character) string indicating variable or column type that is returned, default is "character". optional
#' @param MonthlyGreatestSnowDepth (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyGreatestSnowDepthDate (character) string indicating variable or column type that is returned, default is "character". optional
#' @param MonthlyGreatestSnowfall (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyGreatestSnowfallDate (character) string indicating variable or column type that is returned, default is "character". optional
#' @param MonthlyMaxSeaLevelPressureValue (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyMaxSeaLevelPressureValueDate (character) string indicating variable or column type that is returned, default is "character". optional
#' @param MonthlyMaxSeaLevelPressureValueTime (character) string indicating variable or column type that is returned, default is "character". optional
#' @param MonthlyMaximumTemperature (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyMeanTemperature (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyMinSeaLevelPressureValue (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyMinSeaLevelPressureValueDate (character) string indicating variable or column type that is returned, default is "character". optional
#' @param MonthlyMinSeaLevelPressureValueTime (character) string indicating variable or column type that is returned, default is "character". optional
#' @param MonthlyMinimumTemperature (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlySeaLevelPressure (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyStationPressure (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyTotalLiquidPrecipitation (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyTotalSnowfall (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param MonthlyWetBulb (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param AWND (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param CDSD (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param CLDD (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param DSNW (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param HDSD (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param HTDD (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param NormalsCoolingDegreeDay (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param NormalsHeatingDegreeDay (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param ShortDurationEndDate005 (character) string indicating variable or column type that is returned, default is "character". optional
#' @param ShortDurationEndDate010 (character) string indicating variable or column type that is returned, default is "character". optional
#' @param ShortDurationEndDate015 (character) string indicating variable or column type that is returned, default is "character". optional
#' @param ShortDurationEndDate020 (character) string indicating variable or column type that is returned, default is "character". optional
#' @param ShortDurationEndDate030 (character) string indicating variable or column type that is returned, default is "character". optional
#' @param ShortDurationEndDate045 (character) string indicating variable or column type that is returned, default is "character". optional
#' @param ShortDurationEndDate060 (character) string indicating variable or column type that is returned, default is "character". optional
#' @param ShortDurationEndDate080 (character) string indicating variable or column type that is returned, default is "character". optional
#' @param ShortDurationEndDate100 (character) string indicating variable or column type that is returned, default is "character". optional
#' @param ShortDurationEndDate120 (character) string indicating variable or column type that is returned, default is "character". optional
#' @param ShortDurationEndDate150 (character) string indicating variable or column type that is returned, default is "character". optional
#' @param ShortDurationEndDate180 (character) string indicating variable or column type that is returned, default is "character". optional
#' @param ShortDurationPrecipitationValue005 (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param ShortDurationPrecipitationValue010 (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param ShortDurationPrecipitationValue015 (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param ShortDurationPrecipitationValue020 (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param ShortDurationPrecipitationValue030 (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param ShortDurationPrecipitationValue045 (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param ShortDurationPrecipitationValue060 (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param ShortDurationPrecipitationValue080 (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param ShortDurationPrecipitationValue100 (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param ShortDurationPrecipitationValue120 (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param ShortDurationPrecipitationValue150 (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param ShortDurationPrecipitationValue180 (character) string indicating variable or column type that is returned, default is "numeric". optional
#' @param REM (character) string indicating variable or column type that is returned, default is "character". optional
#' @param BackupDirection (character) string indicating variable or column type that is returned, default is "character". optional
#' @param BackupDistance (character) string indicating variable or column type that is returned, default is "character". optional
#' @param BackupDistanceUnit (character) string indicating variable or column type that is returned, default is "character". optional
#' @param BackupElements (character) string indicating variable or column type that is returned, default is "character". optional
#' @param BackupElevation (character) string indicating variable or column type that is returned, default is "character". optional
#' @param BackupEquipment (character) string indicating variable or column type that is returned, default is "character". optional
#' @param BackupLatitude (character) string indicating variable or column type that is returned, default is "character". optional
#' @param BackupLongitude (character) string indicating variable or column type that is returned, default is "character". optional
#' @param BackupName (character) string indicating variable or column type that is returned, default is "character". optional
#' @param WindEquipmentChangeDate (character) string indicating variable or column type that is returned, default is "character". optional
#'
#' @return a vector indicating column classes types
#' @note if the column type is not compatible, [lcd] will return a
#'   dataframe with the most appropriate column type and a message indicating
#'   the column was not changed to the specified type.
#' @export
#' @keywords internal
#'   
lcd_columns <- function(    
  # Control Data
  STATION="character",
  DATE="POSIXct",
  LATITUDE="numeric",
  LONGITUDE="numeric",
  ELEVATION="numeric",
  NAME="character",
  REPORT_TYPE="character",
  SOURCE="character",
  # Hourly Data
  HourlyAltimeterSetting="character",
  HourlyDewPointTemperature="character",
  HourlyDryBulbTemperature="character",
  HourlyPrecipitation="character",
  HourlyPresentWeatherType="character",
  HourlyPressureChange="character",
  HourlyPressureTendency="integer",
  HourlyRelativeHumidity="character",
  HourlySkyConditions="character",
  HourlySeaLevelPressure="character",
  HourlyStationPressure="character",
  HourlyVisibility="character",
  HourlyWetBulbTemperature="character",
  HourlyWindDirection="character",
  HourlyWindGustSpeed="character",
  HourlyWindSpeed="character",
  Sunrise="numeric",
  Sunset="numeric",
  # Daily data
  DailyAverageDewPointTemperature="character",
  DailyAverageDryBulbTemperature="character",
  DailyAverageRelativeHumidity="character",
  DailyAverageSeaLevelPressure="character",
  DailyAverageStationPressure="character",
  DailyAverageWetBulbTemperature="character",
  DailyAverageWindSpeed="character",
  DailyCoolingDegreeDays="numeric",
  DailyDepartureFromNormalAverageTemperature="numeric",
  DailyHeatingDegreeDays="numeric",
  DailyMaximumDryBulbTemperature="numeric",
  DailyMinimumDryBulbTemperature="numeric",
  DailyPeakWindDirection="numeric",
  DailyPeakWindSpeed="numeric",
  DailyPrecipitation="character",
  DailySnowDepth="character",
  DailySnowfall="character",
  DailySustainedWindDirection="numeric",
  DailySustainedWindSpeed="numeric",
  DailyWeather="character",
  # Monthly Summaries
  MonthlyAverageRH="numeric",
  MonthlyDaysWithGT001Precip="numeric",
  MonthlyDaysWithGT010Precip="numeric",
  MonthlyDaysWithGT32Temp="numeric",
  MonthlyDaysWithGT90Temp="numeric",
  MonthlyDaysWithLT0Temp="numeric",
  MonthlyDaysWithLT32Temp="numeric",
  MonthlyDepartureFromNormalAverageTemperature="numeric",
  MonthlyDepartureFromNormalCoolingDegreeDays="numeric",
  MonthlyDepartureFromNormalHeatingDegreeDays="numeric",
  MonthlyDepartureFromNormalMaximumTemperature="numeric",
  MonthlyDepartureFromNormalMinimumTemperature="numeric",
  MonthlyDepartureFromNormalPrecipitation="numeric",
  MonthlyDewpointTemperature="numeric",
  MonthlyGreatestPrecip="numeric",
  MonthlyGreatestPrecipDate="character",
  MonthlyGreatestSnowDepth="numeric",
  MonthlyGreatestSnowDepthDate="character",
  MonthlyGreatestSnowfall="numeric",
  MonthlyGreatestSnowfallDate="character",
  MonthlyMaxSeaLevelPressureValue="numeric",
  MonthlyMaxSeaLevelPressureValueDate="character",
  MonthlyMaxSeaLevelPressureValueTime="character",
  MonthlyMaximumTemperature="numeric",
  MonthlyMeanTemperature="numeric",
  MonthlyMinSeaLevelPressureValue="numeric",
  MonthlyMinSeaLevelPressureValueDate="character",
  MonthlyMinSeaLevelPressureValueTime="character",
  MonthlyMinimumTemperature="numeric",
  MonthlySeaLevelPressure="numeric",
  MonthlyStationPressure="numeric",
  MonthlyTotalLiquidPrecipitation="numeric",
  MonthlyTotalSnowfall="numeric",
  MonthlyWetBulb="numeric",
  AWND="numeric",
  CDSD="numeric",
  CLDD="numeric",
  DSNW="numeric",
  HDSD="numeric",
  HTDD="numeric",
  NormalsCoolingDegreeDay="numeric",
  NormalsHeatingDegreeDay="numeric",
  ShortDurationEndDate005="character",
  ShortDurationEndDate010="character",
  ShortDurationEndDate015="character",
  ShortDurationEndDate020="character",
  ShortDurationEndDate030="character",
  ShortDurationEndDate045="character",
  ShortDurationEndDate060="character",
  ShortDurationEndDate080="character",
  ShortDurationEndDate100="character",
  ShortDurationEndDate120="character",
  ShortDurationEndDate150="character",
  ShortDurationEndDate180="character",
  ShortDurationPrecipitationValue005="numeric",
  ShortDurationPrecipitationValue010="numeric",
  ShortDurationPrecipitationValue015="numeric",
  ShortDurationPrecipitationValue020="numeric",
  ShortDurationPrecipitationValue030="numeric",
  ShortDurationPrecipitationValue045="numeric",
  ShortDurationPrecipitationValue060="numeric",
  ShortDurationPrecipitationValue080="numeric",
  ShortDurationPrecipitationValue100="numeric",
  ShortDurationPrecipitationValue120="numeric",
  ShortDurationPrecipitationValue150="numeric",
  ShortDurationPrecipitationValue180="numeric",
  REM="character",
  BackupDirection="character",
  BackupDistance="character",
  BackupDistanceUnit="character",
  BackupElements="character",
  BackupElevation="character",
  BackupEquipment="character",
  BackupLatitude="character",
  BackupLongitude="character",
  BackupName="character",
  WindEquipmentChangeDate="character") {
  # setting the column types for data as described in:
  # https://www1.ncdc.noaa.gov/pub/data/ish/ish-format-document.pdf
  # and: https://www.ncei.noaa.gov/data/local-climatological-data/doc/LCD_documentation.pdf
  # daily and monthly values might include special indicators with the value or
  # instead of a value
  # s = suspect value, T = Trace, M = missing, * extreme max or min for month
  # to retain this information, values are kept as character for user to handle
  argg <- unlist(c(as.list(environment())))
  # check that input values are proper R classes
  column_error <- check_lcd_columns(argg)
  if(!is.null(column_error)) stop(column_error)
  
  return(argg)
}