#' Pull GHCND weather data for multiple weather monitors
#'
#' This function takes a vector of one or more weather station IDs. It will pull
#' the weather data from the Global Historical Climatology Network's daily
#' data (GHCND) for each of the stations and join them together in a single tidy
#' dataframe. For any weather stations that the user calls that are not
#' available by ftp from GHCND, the function will return a warning
#' giving the station ID.
#'
#' @param monitors A character vector listing the station IDs for all
#' weather stations the user would like to pull. To get a full and
#' current list of stations, the user can use the [ghcnd_stations()]
#' function. To identify stations within a certain radius of a location, the
#' user can use the [meteo_nearby_stations()] function.
#' @inheritParams meteo_tidy_ghcnd
#' @inheritParams ghcnd_search
#'
#' @return A data frame of daily weather data for multiple weather monitors,
#'    converted to a tidy format. All weather variables may not exist for all
#'    weather stations. Examples of variables returned are:
#'
#'    - `id`: Character string with the weather station site id
#'    - `date`: Date of the observation
#'    - `prcp`: Precipitation, in tenths of mm
#'    - `tavg`: Average temperature, in tenths of degrees Celsius
#'    - `tmax`: Maximum temperature, in tenths of degrees Celsius
#'    - `tmin`: Minimum temperature, in tenths of degrees Celsius
#'    - `awnd`: Average daily wind speed, in meters / second
#'    - `wsfg`: Peak gust wind speed, in meters / second
#'
#'    There are other possible weather variables in the Global Historical
#'    Climatology Network; see
#'    http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/readme.txt for a full
#'    list. If the \code{var} argument is something other than "all", then
#'    only variables included in that argument will be included in the output
#'    data frame. All variables are in the units specified in the linked file
#'    (note that, in many cases, measurements are given in tenths of the units
#'    more often used, e.g., tenths of degrees for temperature). All column names
#'    correspond to variable names in the linked file, but with  all uppercase
#'    letters changed to lowercase.
#'
#' @note The weather flags, which are kept by specifying
#' `keep_flags = TRUE` are:
#'
#' - `*_mflag`: Measurement flag, which gives some information on how
#'    the observation was measured.
#' - `*_qflag`: Quality flag, which gives quality information on the
#'    measurement, like if it failed to pass certain quality checks.
#' - `*_sflag`: Source flag. This gives some information on the
#'    weather collection system (e.g., U.S. Cooperative Summary of the Day,
#'    Australian Bureau of Meteorology) the weather observation comes from.
#'
#' More information on the interpretation of these flags can be found in the
#' README file for the NCDC's Daily Global Historical Climatology Network's
#' data at http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/readme.txt
#'
#' @note This function converts any value of -9999 to a missing value for the
#'    variables "prcp", "tmax", "tmin", "tavg", "snow", and "snwd". However,
#'    for some weather observations, there still may be missing values coded
#'    using a series of "9"s of some length. You will want to check your final
#'    data to see if there are lurking missing values given with series of "9"s.
#'
#' @note This function may take a while to run.
#'
#' @author Brooke Anderson \email{brooke.anderson@@colostate.edu}
#'
#' @references
#'
#' For more information about the data pulled with this function, see:
#'
#' Menne, M.J., I. Durre, R.S. Vose, B.E. Gleason, and T.G. Houston, 2012:
#' An overview of the Global Historical Climatology Network-Daily Database.
#' Journal of Atmospheric and Oceanic Technology, 29, 897-910,
#' doi:10.1175/JTECH-D-11-00103.1.
#'
#' @examples
#' \dontrun{
#'
#' monitors <- c("ASN00003003", "ASM00094299", "ASM00094995", "ASM00094998")
#' all_monitors_clean <- meteo_pull_monitors(monitors)
#'
#' }
#'
#' @export
meteo_pull_monitors <- function(monitors, keep_flags = FALSE, date_min = NULL,
                                date_max = NULL, var = "all"){
  monitors <- unique(monitors)

  safe_meteo_tidy_ghcnd <- purrr::safely(meteo_tidy_ghcnd)
  all_monitors_clean <- lapply(monitors, safe_meteo_tidy_ghcnd,
                               keep_flags = keep_flags, date_min = date_min,
                               date_max = date_max, var = var)

  check_station <- sapply(all_monitors_clean, function(x) is.null(x$result))
  bad_stations <- monitors[check_station]
  if (length(bad_stations) > 0) {
    warning(paste("The following stations could not be pulled from",
                  "the GHCN ftp:\n", paste(bad_stations, collapse = ", "),
                  "\nAny other monitors were successfully pulled from GHCN."))
  }

  all_monitors_out <- lapply(all_monitors_clean[!check_station],
                             function(x) x$result)
  all_monitors_out <- suppressWarnings(dplyr::bind_rows(all_monitors_out))
  return(all_monitors_out)
}

#' Create a tidy GHCND dataset from a single monitor
#'
#' This function inputs an object created by \code{\link{ghcnd}} and cleans up
#' the data into a tidy form.
#'
#' @param keep_flags TRUE / FALSE for whether the user would like to keep all
#' the flags for each weather variable. The default is to not keep the
#' flags (FALSE). See the note below for more information on these flags.
#' @inheritParams ghcnd_search
#'
#' @return A data frame of daily weather data for a single weather monitor,
#'    converted to a tidy format. All weather variables may not exist for all
#'    weather stations. Examples of variables returned are:
#'
#'    - `id`: Character string with the weather station site id
#'    - `date`: Date of the observation
#'    - `prcp`: Precipitation, in tenths of mm
#'    - `tavg`: Average temperature, in degrees Celsius
#'    - `tmax`: Maximum temperature, in degrees Celsius
#'    - `tmin`: Minimum temperature, in degrees Celsius
#'    - `awnd`: Average daily wind speed, in meters / second
#'    - `wsfg`: Peak gust wind speed, in meters / second
#'
#'    There are other possible weather variables in the Global Historical
#'    Climatology Network; see
#'    http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/readme.txt for a full
#'    list. The variables `prcp`, `tmax`, `tmin`, and `tavg`
#'    have all been converted from tenths of their metric to the metric (e.g.,
#'    from tenths of degrees Celsius to degrees Celsius). All other variables
#'    are in the units specified in the linked file.
#'
#' @note The weather flags, which are kept by specifying
#' `keep_flags = TRUE` are:
#' 
#' - `*_mflag`: Measurement flag, which gives some information on how
#'    the observation was measured.
#' - `*_qflag`: Quality flag, which gives quality information on the
#'    measurement, like if it failed to pass certain quality checks.
#' - `*_sflag`: Source flag. This gives some information on the
#'    weather collection system (e.g., U.S. Cooperative Summary of the Day,
#'    Australian Bureau of Meteorology) the weather observation comes from.
#' 
#' More information on the interpretation of these flags can be found in the
#' README file for the NCDC's Daily Global Historical Climatology Network's
#' data at http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/readme.txt
#'
#' @author Brooke Anderson \email{brooke.anderson@@colostate.edu}
#'
#' @seealso [meteo_pull_monitors()]
#'
#' @examples
#' \dontrun{
#' # One station in Australia is ASM00094275
#' meteo_tidy_ghcnd(stationid = "ASN00003003")
#' meteo_tidy_ghcnd(stationid = "ASN00003003", var = "tavg")
#' meteo_tidy_ghcnd(stationid = "ASN00003003", date_min = "1989-01-01")
#' }
#'
#' @export
meteo_tidy_ghcnd <- function(stationid, keep_flags = FALSE, var = "all",
  date_min = NULL, date_max = NULL) {

  dat <- suppressWarnings(
    ghcnd_search(stationid = stationid, var = var, date_min = date_min,
      date_max = date_max))
  dat <- lapply(dat, meteo_tidy_ghcnd_element, keep_flags = keep_flags)
  cleaned_df <- do.call(rbind.data.frame, dat) %>%
    tidyr::spread("key", "value")
  to_clean <- c("prcp", "tmax", "tmin", "tavg", "snow", "snwd")
  for (i in seq_along(to_clean)) {
    if (to_clean[i] %in% names(cleaned_df)) {
      cleaned_df[[to_clean[i]]][cleaned_df[[to_clean[i]]] == -9999] <- NA_real_
    }
  }
  return(cleaned_df)
}

#' Restructure element of ghcnd_search list
#'
#' This function restructures the output of [ghcnd_search()]
#' to add a column giving the variable name (`key`) and change the
#' name of the variable column to `value`. These changes facilitate
#' combining all elements from the list created by [ghcnd_search()],
#' to create a tidy dataframe of the weather observations from the station.
#'
#' @param x A dataframe with daily observations for a single monitor for a
#'    single weather variable. This dataframe is one of the elements returned
#'    by [ghcnd_search()]
#' @inheritParams meteo_tidy_ghcnd
#'
#' @return A dataframe reformatted to allow easy aggregation of all weather
#'    variables for a single monitor.
#'
#' @author Brooke Anderson \email{brooke.anderson@@colostate.edu}
meteo_tidy_ghcnd_element <- function(x, keep_flags = FALSE){
  var_name <- colnames(x)[2]
  if (keep_flags) {
    flag_locs <- grep("flag", colnames(x))
    colnames(x)[flag_locs] <-
      paste(colnames(x)[flag_locs], var_name, sep = "_")
    x <- tidyr::gather(x, "key", "value", 
      tidyselect::vars_select(names(x), -id, -date))
  } else {
    x <- dplyr::select(x, -dplyr::ends_with('flag'))
    x <- tidyr::gather(x, "key", "value",
      tidyselect::vars_select(names(x), -id, -date))
  }
  return(x)
}

