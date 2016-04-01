#' Clean the daily summary data
#'
#' This function inputs an object created by \code{\link{ghcnd}} and cleans up the
#' data into a tidy form.
#'
#' The following reference has more information on this data:
#'
#' Menne, M.J., I. Durre, R.S. Vose, B.E. Gleason, and T.G. Houston, 2012:
#' An overview of the Global Historical Climatology Network-Daily Database.
#' Journal of Atmospheric and Oceanic Technology, 29, 897-910,
#' doi:10.1175/JTECH-D-11-00103.1.
#'
#' @param ghcnd_data An object of class "ghcnd", as generated for a single weather
#'    station using \code{\link{ghcnd}}.
#' @param keep_flags TRUE / FALSE for whether the user would like to keep all the flags
#'    for each weather varialbe. The default is to not keep the flags (FALSE).
#'
#' @return A data frame of daily weather data for a single weather monitor,
#'    converted to a tidy format. All weather variables may not exist for all
#'    weather stations, but the returned dataset would have at most the
#'    following columns:
#'    \itemize{
#'    \item \code{id}: Character string with the weather station site id
#'    \item \code{date}: Date of the observation
#'    \item \code{prcp}: Precipitation, in mm
#'    \item \code{tavg}: Average temperature, in degrees Celsius
#'    \item \code{tmax}: Maximum temperature, in degrees Celsius
#'    \item \code{tmin}: Minimum temperature, in degrees Celsius
#'    \item \code{awnd}: Average daily wind speed, in meters / second
#'    \item \code{wsfg}: Peak gust wind speed, in meters / second
#'    }
#'    There are other possible weather variables in the Global Historical
#'    Climatology Network, but we have not implemented cleaning them through
#'    this function. See
#'    \url{http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/readme.txt} for a full
#'    list. If you are interested in having other weather variables from this
#'    list added to this function, you can submit a request to this package's
#'    GitHub issues page and we may be able to add it.
#'
#' @note The weather flags, which are kept by specifying
#' \code{keep_flags = TRUE} are:
#' \itemize{
#' \item \code{*_mflag}: Measurement flag, which gives some information on how
#'    the observation was measured.
#' \item \code{*_qflag}: Quality flag, which gives quality information on the
#'    measurement, like if it failed to pass certain quality checks.
#' \item \code{*_sflag}: Source flag. This gives some information on the
#'    weather collection system (e.g., U.S. Cooperative Summary of the Day,
#'    Australian Bureau of Meteorology) the weather observation comes from.
#' }
#' More information on the interpretation of these flags can be found in the
#' README file for the NCDC's Daily Global Historical Climatology Network's
#' data at \url{http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/readme.txt}.
#'
#' @examples
#' \dontrun{
#' # You must have your NOAA API key saved as `steve`
#' options("noaakey" = steve)
#'
#' # One station in Australia is ASM00094275
#' ghcnd_data <- ghcnd(stationid = "ASN00003003")
#' cleaned_df <- clean_daily(ghcnd_data)
#' }
#'
#' @importFrom dplyr %>%
#'
#' @export
clean_daily <- function(ghcnd_data, keep_flags = FALSE){
  if(keep_flags){
    cleaned_df <- dplyr::filter(ghcnd_data$data,
                                element %in% c("TMAX", "TMIN", "PRCP",
                                               "SNOW", "SNWD", "AWND",
                                               "WSFG")) %>%
      tidyr::gather(what, value, -id, -year, -month, -element) %>%
      dplyr::mutate(day = as.numeric(gsub("[A-Z]", "", what)),
             what = gsub("[0-9]", "", what),
             what = paste(tolower(element), tolower(what), sep = "_"),
             what = gsub("_value", "", what),
             value = ifelse(value == -9999, NA, as.character(value))) %>%
      dplyr::mutate(date = suppressWarnings(
        lubridate::ymd(paste0(year, sprintf("%02s", month),
                              sprintf("%02s", day))))) %>%
      dplyr::filter(!is.na(date)) %>%
      dplyr::select(id, date, what, value) %>%
      tidyr::spread(what, value) %>%
      dplyr::arrange(date)
  } else {
    cleaned_df <- dplyr::filter(ghcnd_data$data,
                                element %in% c("TMAX", "TMIN", "PRCP",
                                               "SNOW", "SNWD", "AWND",
                                               "WSFG")) %>%
      dplyr::select(-matches("FLAG")) %>%
      tidyr::gather(what, value, -id, -year, -month, -element) %>%
      dplyr::mutate(day = as.numeric(gsub("[A-Z]", "", what)),
             what = gsub("[0-9]", "", what),
             what = paste(tolower(element), tolower(what), sep = "_"),
             what = gsub("_value", "", what),
             value = ifelse(value == -9999, NA, as.character(value))) %>%
      dplyr::mutate(date = suppressWarnings(
        lubridate::ymd(paste0(year, sprintf("%02s", month),
                                          sprintf("%02s", day))))) %>%
      dplyr::filter(!is.na(date)) %>%
      dplyr::select(id, date, what, value) %>%
      tidyr::spread(what, value) %>%
      dplyr::arrange(date)
  }
  which_weather_vars <- which(colnames(cleaned_df) %in%
                                c("prcp", "tavg", "tmax", "tmin", "awnd",
                                  "wsfg"))
  cleaned_df <- tbl_df(cleaned_df)
  # All these variables are in tenths of units
  cleaned_df[, which_weather_vars] <- vapply(cleaned_df[, which_weather_vars],
                                             FUN.VALUE = numeric(nrow(cleaned_df)),
                                             FUN = function(x) as.numeric(x) / 10)
  which_snow_vars <- which(colnames(cleaned_df) %in%
                             c("snow", "snwd"))
  cleaned_df[, which_weather_vars] <- vapply(cleaned_df[, which_weather_vars],
                                             FUN.VALUE = numeric(nrow(cleaned_df)),
                                             FUN = function(x) as.numeric(x))
  return(cleaned_df)
}

#' Pull daily weather data for multiple weather monitors
#'
#' This function takes a vector of one or more weather station IDs. It will pull
#' the weather data from the Global Historical Climatology Network's daily
#' data for each of the stations and join them together in a single tidy
#' dataframe.
#'
#' @param monitors A character vector listing the station IDs for all
#'    weather stations the user would like to pull.
#' @inheritParams clean_daily
#'
#' @return A data frame of daily weather data for a multiple weather monitors,
#'    converted to a tidy format. All weather variables may not exist for all
#'    weather stations, but the returned dataset would have at most the
#'    following columns:
#'    \itemize{
#'    \item \code{id}: Character string with the weather station site id
#'    \item \code{date}: Date of the observation
#'    \item \code{prcp}: Precipitation, in mm
#'    \item \code{tavg}: Average temperature, in degrees Celsius
#'    \item \code{tmax}: Maximum temperature, in degrees Celsius
#'    \item \code{tmin}: Minimum temperature, in degrees Celsius
#'    \item \code{awnd}: Average daily wind speed, in meters / second
#'    \item \code{wsfg}: Peak gust wind speed, in meters / second
#'    }
#'    There are other possible weather variables in the Global Historical
#'    Climatology Network, but we have not implemented cleaning them through
#'    this function. See
#'    \url{http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/readme.txt} for a full
#'    list. If you are interested in having other weather variables from this
#'    list added to this function, you can submit a request to this package's
#'    GitHub issues page and we may be able to add it.
#'
#' @note This function may take a while to run.
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
meteo_pull_monitors <- function(monitors, keep_flags = FALSE){
  monitors <- unique(monitors)
  safe_ghcnd <- purrr::safely(ghcnd)
  all_monitors_ghcnd <- lapply(monitors, safe_ghcnd)

  check_station <- sapply(all_monitors_ghcnd, function(x) is.null(x$result))
  bad_stations <- monitors[check_station]
  if(length(bad_stations) > 0){
    warning(paste("The following stations could not be pulled from",
                  "the GHCN ftp:\n", paste(bad_stations, collapse = ", "),
                  "\nAll other monitors were successfully pulled from GHCN."))
  }

  all_monitors_ghcnd <- lapply(all_monitors_ghcnd[!check_station],
                               function(x) x$result)
  all_monitors_clean <- lapply(all_monitors_ghcnd, clean_daily,
                               keep_flags = keep_flags)
  all_monitors_clean <- suppressWarnings(dplyr::bind_rows(all_monitors_clean))
  return(all_monitors_clean)
}

