#' @param token This must be a valid token token supplied to you by NCDC's
#' Climate Data Online access token generator. (required) See
#' \strong{Authentication} section below for more details.
#'
#' @section Authentication:
#' Get an API key (aka, token) at \url{http://www.ncdc.noaa.gov/cdo-web/token}.
#' You can pass your token in as an argument or store it one of two places:
#'
#' \itemize{
#'   \item your .Rprofile file with an entry like
#'   \code{options(noaakey = "your-noaa-token")}
#'   \item your .Renviron file with an entry like
#'   \code{NOAA_KEY=your-noaa-token}
#' }
#'
#' See \code{\link{Startup}} for information on how to create/find your
#' .Rrofile and .Renviron files

