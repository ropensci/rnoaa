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
    cleaned_df <- gather(ghcnd_data$data, what, value,
             -id, -year, -month, -element) %>%
      mutate(day = as.numeric(gsub("[A-Z]", "", what)),
             what = gsub("[0-9]", "", what),
             what = paste(tolower(element), tolower(what), sep = "_"),
             what = gsub("_value", "", what),
             value = ifelse(value == -9999, NA, as.character(value))) %>%
      mutate(date = lubridate::ymd(paste0(year, sprintf("%02s", month),
                                          sprintf("%02s", day)))) %>%
      filter(!is.na(date)) %>%
      select(id, date, what, value) %>%
      spread(what, value) %>%
      arrange(date)

    #which_flags <- grep("flag", colnames(cleaned_df))
    #cleaned_df[, which_flags] <- apply(cleaned_df[, which_flags],
    #                                          MARGIN = 2,
    #                                          function(x) as.factor(x))
  } else {
    cleaned_df <- select(ghcnd_data$data, -matches("FLAG")) %>%
      gather(what, value,
             -id, -year, -month, -element) %>%
      mutate(day = as.numeric(gsub("[A-Z]", "", what)),
             what = gsub("[0-9]", "", what),
             what = paste(tolower(element), tolower(what), sep = "_"),
             what = gsub("_value", "", what),
             value = ifelse(value == -9999, NA, as.character(value))) %>%
      mutate(date = lubridate::ymd(paste0(year, sprintf("%02s", month),
                                          sprintf("%02s", day)))) %>%
      filter(!is.na(date)) %>%
      select(id, date, what, value) %>%
      spread(what, value) %>%
      arrange(date)
  }
  which_weather_vars <- which(colnames(cleaned_df) %in%
                                c("prcp", "tavg", "tmax", "tmin"))
  cleaned_df[, which_weather_vars] <- apply(cleaned_df[, which_weather_vars],
                                             MARGIN = 2,
                                             function(x) as.numeric(x) / 10)
  return(cleaned_df)
}
