# set up vcr
library("vcr")
invisible(vcr::vcr_configure(
  dir = "../fixtures",
  # dir = "tests/fixtures",
  filter_sensitive_data = list("<<ncdc_token>>" = Sys.getenv('NOAA_KEY')),
  # write_disk_path = "tests/files"
  write_disk_path = "../files"
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
