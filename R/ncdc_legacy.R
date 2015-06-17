#' Search the NOAA NCDC legacy API - main purpose to get ISD daily data.
#'
#' @name ncdc_legacy
#' @param dataset Dataset id, one of isd (default), ish, or daily.
#' @param variable A variable id.
#' @param station A station id.
#' @param token Your token. Store as environment variable as NOAA_LEG_TOKEN or option variable
#' as noaalegtoken.
#' @param state_id State ID
#' @param state_abbrev State abbreviation
#' @param country_id Country id
#' @param country_abbrev Country abbreviation
#' @param start_date,end_date Date to start and end search for. Valid formats include, YYYY,
#' YYYYMM, YYYYMMDD, YYYYMMDDhh, and YYYYMMDDhhmm.
#' @param ... Further args passed to \code{\link[httr]{GET}}
#' @references \url{http://www7.ncdc.noaa.gov/wsregistration/ws_home.html},
#' \url{http://www7.ncdc.noaa.gov/rest/},
#' \url{http://www7.ncdc.noaa.gov/wsregistration/CDOServices.html}
#' @details BEWARE: This service, as far as I can tell, enforces a wait time between successive
#' data requests of 60 seconds. This is indeed a long time.
#' @examples \dontrun{
#' # Variables
#' ## All variables
#' ncdc_leg_variables()
#' ## Specific variables
#' ### Air Temperature Observation
#' ncdc_leg_variables(variable = "TMP")
#' ### Snow Accumulation For The Month
#' ncdc_leg_variables(variable = "AN1")
#'
#' # Sites
#' head( ncdc_leg_sites() )
#' ncdc_leg_sites(country_id = 1)
#' ncdc_leg_sites(country_abbrev = 'CA')
#' ncdc_leg_sites(state_id = 11)
#' ncdc_leg_sites(state_abbrev = 'HI')
#' ## site info
#' ncdc_leg_site_info(station=71238099999)
#'
#' # Data
#' ncdc_leg_data('isd', 71238099999, 'TMP', 200101010000, 200101312359)
#' ncdc_leg_data('isd', 71238099999, 'TMP', 200101, 200201)
#' }

#' @export
#' @rdname ncdc_legacy
ncdc_leg_variables <- function(dataset = "isd", variable = NULL, token = NULL, ...){
  url <- if (is.null(variable)) {
    file.path(ncdclb(), "variables", dataset) 
  } else { 
    file.path(ncdclb(), "variableinfo", dataset, variable)
  }
  args <- list(output = "csv", token = check_token_leg(token))
  ncdcl_GET(url, args, ...)
}

#' @export
#' @rdname ncdc_legacy
ncdc_leg_sites <- function(dataset = "isd", state_id = NULL, state_abbrev = NULL,
  country_id = NULL, country_abbrev = NULL, token = NULL, ...) {
  
  base <- file.path(ncdclb(), "sites")
  param <- noaa_compact(list(state_id = state_id, state_abbrev = state_abbrev,
                    country_id = country_id, country_abbrev = country_abbrev))
  url <- if (length(param) == 0) {
    file.path(base, dataset) 
  } else {
    file.path(base, dataset, switch_name(names(param)), param[[1]])
  }
  args <- list(output = "csv", token = check_token_leg(token))
  ncdcl_GET(url, args, ...)
}

#' @export
#' @rdname ncdc_legacy
ncdc_leg_site_info <- function(dataset = "isd", station, token = NULL, ...) {
  url <- file.path(ncdclb(), "siteinfo", dataset, station)
  args <- list(output = "csv", token = check_token_leg(token))
  ncdcl_GET(url, args, ...)
}

#' @export
#' @rdname ncdc_legacy
ncdc_leg_data <- function(dataset = "isd", station, variable, start_date, end_date, token = NULL, ...) {
  base <- file.path(ncdclb(), "values", dataset, station, variable, start_date, end_date)
  args <- list(output = "csv", token = check_token_leg(token))
  ncdcl_GET(base, args, ...)
}

switch_name <- function(x){
  switch(x, state_id = 'stateId', state_abbrev = 'stateAbbrev',
         country_id = 'countryId', country_abbrev = 'countryAbbrev')
}

ncdcl_GET <- function(url, args, ...){
  res <- GET(url, query = args, ...)
  if (res$status_code > 200) {
    if (res$status_code == 503) stop(get_retry(res), call. = FALSE) else stop_for_status(res)
  } else {
    stopifnot(res$headers$`content-type` == "text/plain; charset=UTF-8")
    txt <- content(res, "text")
    read.delim(text = txt, sep = ",", stringsAsFactors = FALSE, header = FALSE)
  }
}

check_token_leg <- function(x){
  tmp <- if (is.null(x)) Sys.getenv("NOAA_LEG_TOKEN", "") else x
  if (tmp == "") getOption("noaalegtoken", stop("need an API token for NOAA legacy API")) else tmp
}

get_retry <- function(x){
  sprintf("503: Retry after %s seconds", as.numeric(x$headers$`retry-after`))
}

get_error <- function(x){
  html <- content(x)
  title <- xpathSApply(html, "//title", xmlValue)
  desc <- paste0(xpathApply(html, "//u", xmlValue), collapse = "")
  paste0(" - ", title, desc, collapse = "")
}

ncdclb <- function() 'http://www7.ncdc.noaa.gov/rest/services'
