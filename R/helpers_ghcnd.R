#' Clean the daily summary data
#'
#' This function inputs an object created by \code{\link{ghcnd}} and cleans up the
#' data into a tidy form.
#'
#' @param ghcnd_data An object of class "ghcnd", as generated for a single weather
#'    station using \code{\link{ghcnd}}.
#' @param keep_flags TRUE / FALSE for whether the user would like to keep all the flags
#'    for each weather varialbe. The default is to not keep the flags (FALSE).
#'
#' @return A data frame of daily weather data for a single weather monitor,
#'    converted to a tidy format.
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
clean_daily <- function(ghcnd_data, keep_flags = FALSE){
  if(keep_flags){
    cleaned_df <- tidyr::gather(ghcnd_data$data, what, value,
             -id, -year, -month, -element) %>%
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
    cleaned_df <- dplyr::select(ghcnd_data$data, -matches("FLAG")) %>%
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
                                c("prcp", "tavg", "tmax", "tmin"))
  cleaned_df[, which_weather_vars] <- vapply(cleaned_df[, which_weather_vars],
                                             FUN.VALUE = numeric(nrow(cleaned_df)),
                                             FUN = function(x) as.numeric(x) / 10)
  return(cleaned_df)
}
