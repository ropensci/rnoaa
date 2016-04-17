#' Pull GHCND weather data for multiple weather monitors
#'
#' This function takes a vector of one or more weather station IDs. It will pull
#' the weather data from the Global Historical Climatology Network's daily
#' data for each of the stations and join them together in a single tidy
#' dataframe. For any weather stations that the user calls that are not
#' available by ftp from GHCN, the function will return a warning
#' giving the station ID.
#'
#' @param monitors A character vector listing the station IDs for all
#'    weather stations the user would like to pull.
#' @inheritParams meteo_tidy_ghcnd
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
meteo_pull_monitors <- function(monitors, keep_flags = FALSE, date_min = NULL,
                                date_max = NULL, var = "all"){
  monitors <- unique(monitors)
  #safe_ghcnd <- purrr::safely(ghcnd)
  #all_monitors_ghcnd <- lapply(monitors, safe_ghcnd)

  safe_meteo_tidy_ghcnd <- purrr::safely(meteo_tidy_ghcnd)
  all_monitors_clean <- lapply(monitors, safe_meteo_tidy_ghcnd,
                               keep_flags = keep_flags, date_min = date_min,
                               date_max = date_max, var = var)

  check_station <- sapply(all_monitors_clean, function(x) is.null(x$result))
  bad_stations <- monitors[check_station]
  if(length(bad_stations) > 0){
    warning(paste("The following stations could not be pulled from",
                  "the GHCN ftp:\n", paste(bad_stations, collapse = ", "),
                  "\nAll other monitors were successfully pulled from GHCN."))
  }

  all_monitors_out <- lapply(all_monitors_clean[!check_station],
                             function(x) x$result)
  all_monitors_out <- suppressWarnings(dplyr::bind_rows(all_monitors_out))
  return(all_monitors_out)
}

#' Create a tidy GHCND dataset from a single monitor
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
#' @param keep_flags TRUE / FALSE for whether the user would like to keep all the flags
#'    for each weather varialbe. The default is to not keep the flags (FALSE).
#' @inheritParams ghcnd_search
#'
#' @return A data frame of daily weather data for a single weather monitor,
#'    converted to a tidy format. All weather variables may not exist for all
#'    weather stations Examples of variables returned are:
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
#'    Climatology Network; see
#'    \url{http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/readme.txt} for a full
#'    list. The variables \code{prcp}, \code{tmax}, \code{tmin}, and \code{tavg}
#'    have all been converted from tenths of their metric to the metric (e.g.,
#'    from tenths of degrees Celsius to degrees Celsius). All other variables
#'    are in the units specified in the linked file.
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
#' # One station in Australia is ASM00094275
#' cleaned_df <- meteo_tidy_ghcnd(stationid = "ASN00003003")
#' }
#'
#' @importFrom dplyr %>%
#'
#' @export
meteo_tidy_ghcnd <- function(stationid, keep_flags = FALSE, var = "all",
                        date_min = NULL, date_max = NULL){

    dat <- suppressWarnings(ghcnd_search(stationid = stationid, var = var,
                                         date_min = date_min,
                                         date_max = date_max)) %>%
      lapply(meteo_tidy_ghncd_element, keep_flags = keep_flags)
    cleaned_df <- do.call(rbind.data.frame, dat) %>%
      tidyr::spread(key = key, value = value)

  which_vars_tenths <- which(colnames(cleaned_df) %in%
                                c("prcp", "tmax", "tmin", "tavg"))
  cleaned_df <- tbl_df(cleaned_df)
  # All these variables are in tenths of units
  cleaned_df[, which_vars_tenths] <- vapply(cleaned_df[, which_vars_tenths],
                                             FUN.VALUE = numeric(nrow(cleaned_df)),
                                             FUN = function(x){
                                               x <- ifelse(x == -9999, NA, x)
                                               x <- as.numeric(x) / 10
                                             })

  which_other_vars <- which(colnames(cleaned_df) %in%
                             c("snow", "snwd"))
  cleaned_df[, which_other_vars] <- vapply(cleaned_df[, which_other_vars],
                                             FUN.VALUE = numeric(nrow(cleaned_df)),
                                             FUN = function(x){
                                               x <- ifelse(x == -9999, NA, x)
                                               x <- as.numeric(x)
                                             })
  return(cleaned_df)
}

#' Restructure element of ghncd_search list
#'
#' This function restructures a single element of the list object created
#' by \code{\link{ghncd_search}}, to add a column giving the variable name
#' (\code{key}) and change the name of the variable column to \code{value}.
#' These changes facilitate combining all elements from the list created by
#' \code{\link{ghncd_search}}, to create a tidy dataframe of the weather
#' observations from the station.
#'
#' @param x A dataframe with daily observations for a single monitor for a
#'    single weather variable. This dataframe is one of the elements returned
#'    by \code{\link{ghncd_search}}.
#' @inheritParams meteo_tidy_ghcnd
#'
#' @return A dataframe reformatted to allow easy aggregation of all weather
#'    variables for a single monitor.
meteo_tidy_ghncd_element <- function(x, keep_flags = FALSE){
  var_name <- colnames(x)[2]
  if(keep_flags){
    flag_locs <- grep("flag", colnames(x))
    colnames(x)[flag_locs] <- paste(colnames(x)[flag_locs], var_name, sep = "_")
    x <- tidyr::gather(x, key, value, -id, -date)
  } else {
    x <- dplyr::select(x, -ends_with("flag")) %>%
      tidyr::gather(key, value, -id, -date)
  }
  return(x)
}

