# set up vcr
library("vcr")
invisible(vcr::vcr_configure(
  dir = "../fixtures",
  filter_sensitive_data = list("<<ncdc_token>>" = Sys.getenv('NOAA_KEY'))
))
