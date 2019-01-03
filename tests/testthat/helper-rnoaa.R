# set up vcr
library("vcr")
invisible(vcr::vcr_configure(
  dir = "../fixtures",
  filter_sensitive_data = list("<<ncdc_token>>" = Sys.getenv('NOAA_KEY'))
))

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
