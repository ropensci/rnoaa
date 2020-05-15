gcdftp <- "ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/"
ghcnd_x <- function(path) {
  function(...) {
    res <- GET_retry(file.path(gcdftp, path), ...)
    df <- read.fwf(as_tc_p(res), widths = c(2, 47),
                   header = FALSE, strip.white = TRUE, comment.char = "",
                   stringsAsFactors = FALSE, col.names = c("code","name"))
    df[ -NROW(df) ,]
  }
}

#' Get meta-data on the GHCND daily data
#'
#' These function allow you to pull the current versions of certain meta-datasets
#' for the GHCND, including lists of country and state abbreviations used in some
#' of the weather station IDs and information about the current version of the
#' data.
#'
#' @export
#' @inheritParams ghcnd
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com},
#' Adam Erickson \email{adam.erickson@@ubc.ca}
#' @details Functions:
#'
#' - `ghcnd_version`: Get current version of GHCND data
#' - `ghcnd_states`: Get US/Canada state names and 2-letter codes
#' - `ghcnd_countries`: Get country names and 2-letter codes
#'
#' @examples \dontrun{
#' ghcnd_states()
#' ghcnd_countries()
#' ghcnd_version()
#' }
ghcnd_states <- ghcnd_x("ghcnd-states.txt")

#' @export
#' @rdname ghcnd_states
ghcnd_countries <- ghcnd_x("ghcnd-countries.txt")

#' @export
#' @rdname ghcnd_states
ghcnd_version <- function(...){
  res <- GET_retry(file.path(gcdftp, "ghcnd-version.txt"), ...)
  rawToChar(res$content)
}
