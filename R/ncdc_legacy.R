#' Search the NOAA NCDC legacy API - main purpose to get ISD daily data.
#' @name ncdc_legacy
#' @param dataset Dataset id, default: isd
#' @param variable Variable to get.
#' @param token Your token. Store as environment variable as NOAA_LEG_TOKEN or option variable 
#' as noaalegtoken.
#' @param state_id State ID
#' @param state_abbrev State abbreviation
#' @param country_id Country id
#' @param country_abbrev Country abbreviation
#' @param ... Further args passed to \code{\link[httr]{GET}}
#' @examples \donttest{
#' ncdc_leg_variables()
#' ncdc_leg_variables(variable = 'TMP')
#' ncdc_leg_variables(variable = 474)
#' head( ncdc_leg_sites() )
#' 
#' # Site information
#' ncdc_leg_sites(country_id = 1)
#' ncdc_leg_sites(country_abbrev = 'US')
#' ncdc_leg_sites(state_id = 11)
#' ncdc_leg_sites(state_abbrev = 'HI')
#' }

#' @export
#' @rdname ncdc_legacy
ncdc_leg_variables <- function(dataset = "isd", variable = NULL, token = NULL, ...){
  base <- paste0(ncdclb(), "variables/")
  url <- if(is.null(variable)) paste0(base, dataset) else paste0(base, dataset, '/', variable)
  args <- list(output = "csv", token = check_token_leg(token))
  res <- ncdcl_GET(url, args, ...)
  read.delim(text = res, sep = ",", stringsAsFactors = FALSE, header = FALSE)
}

#' @export
#' @rdname ncdc_legacy
ncdc_leg_sites <- function(dataset = "isd", state_id = NULL, state_abbrev = NULL, 
  country_id = NULL, country_abbrev = NULL, token = NULL, ...)
{
  base <- paste0(ncdclb(), "sites/")
  param <- noaa_compact(list(state_id=state_id, state_abbrev=state_abbrev, 
                    country_id=country_id, country_abbrev=country_abbrev))
  url <- if(length(param) == 0) 
    paste0(base, dataset) 
  else 
    paste0(base, dataset, '/', switch_name(names(param)), '/', param[[1]])
  args <- list(output = "csv", token = check_token_leg(token))
  res <- ncdcl_GET(url, args, ...)
  read.delim(text = res, sep = ",", stringsAsFactors = FALSE, header = FALSE)
}

switch_name <- function(x){
  switch(x, state_id='stateId', state_abbrev='stateAbbrev', 
         country_id='countryId', country_abbrev='countryAbbrev')
}

ncdclb <- function() 'http://www7.ncdc.noaa.gov/rest/services/'

ncdcl_GET <- function(url, args, ...){
  res <- GET(url, query = args, ...)
  stop_for_status(res)
  stopifnot(res$headers$`content-type` == "text/plain; charset=UTF-8")
  content(res, "text")
}

check_token_leg <- function(x){
  tmp <- if(is.null(x)) Sys.getenv("NOAA_LEG_TOKEN", "") else x
  if(tmp == "") getOption("noaalegtoken", stop("need an API token for NOAA legacy API")) else tmp
}
