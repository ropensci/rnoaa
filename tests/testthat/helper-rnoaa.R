# set up vcr
library("vcr")
vcr_set <- function() {
  invisible(vcr::vcr_configure(
    dir = "../fixtures",
    filter_sensitive_data = list("<<ncdc_token>>" = Sys.getenv('NOAA_KEY')),
    write_disk_path = "../files"
  ))
}
vcr_set()

# check if there's a government shutdown
has_government <- function() {
  res <- crul::HttpClient$new("https://ncdc.noaa.gov")$get()
  !(grepl("html", res$response_headers$`content-type`) &&
      grepl("shutdown", res$parse("UTF-8")))
}

skip_if_government_down <- function() {
  if (has_government()) return()
  testthat::skip("no government")
}

# check if noaa ncdc is having some down time
has_noaa_ncdc <- function() {
  x <- 'https://www.ncdc.noaa.gov/cdo-web/api/v2/stations/COOP:010008'
  res <- crul::HttpClient$new(x)$get()
  !(grepl("html", res$response_headers$`content-type`) &&
      grepl("[Ee]rror|[Uu]navailable", res$parse("UTF-8")))
}

skip_if_noaa_ncdc_down <- function() {
  if (has_noaa_ncdc()) return()
  testthat::skip("no noaa ncdc")
}
