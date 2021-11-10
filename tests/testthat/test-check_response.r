context("check_response")

skip_on_cran()
skip_on_ci()
skip_if_government_down()
skip_if_noaa_ncdc_down()

test_that("check_response works correctly on bad response content-type", {
  skip_if_not_installed("webmockr")
  webmockr::enable()
  webmockr::stub_request("get", 'https://www.ncdc.noaa.gov/cdo-web/api/v2/data?datasetid=GHCND&startdate=2013-10-01&enddate=2013-12-01&limit=25&includemetadata=TRUE&stationid=GHCND%3AUSW00014895') %>%
    webmockr::to_return(headers = list(`content-type` = "application/xml"))
  expect_error(
    ncdc(datasetid='GHCND', stationid='GHCND:USW00014895',
       startdate = '2013-10-01', enddate = '2013-12-01'),
    "wrong response type, open an issue"
  )
  webmockr::disable()
})

test_that("check_response returns an error", {
  # Sys.sleep(time = 0.5)
  expect_warning(ncdc_locs_cats(startdate='2100-01-01'), "no data found")
  # Sys.sleep(time = 0.5)
  expect_warning(ncdc_locs_cats(startdate='1990-01-0'), "An error occured")
  # Sys.sleep(time = 0.5)
  expect_warning(
    ncdc(datasetid='GHCNDS', locationid='FIPS:BR', datatypeid='PRCP',
         startdate = '2010-05-01', enddate = '2010-05-10')
  , "Error:.+")
  # Sys.sleep(time = 0.5)
  expect_warning(
    ncdc(datasetid='GHCND')
  , "Required parameter 'startdate' is missing")
})

test_that("check_response returns the correct error messages", {
  # no data found
  # Sys.sleep(time = 0.5)
  expect_warning(ncdc_locs_cats(startdate='2100-01-01'), "no data found")
  # wrong date input
  # Sys.sleep(time = 0.5)
  expect_warning(ncdc_locs_cats(startdate='1990-01-0'), "error occured while servicing your request")
  # missing startdate parameter
  # Sys.sleep(time = 0.5)
  expect_warning(ncdc(datasetid='GHCND'), "Required parameter 'startdate' is missing")
  # internal server error
  # Sys.sleep(time = 0.5)
  expect_warning(
      ncdc(datasetid='GHCNDS', locationid='FIPS:BR', datatypeid='PRCP',
           startdate = '2010-05-01', enddate = '2010-05-10'),
    "Error:.+"
  )
  # no data found
  # Sys.sleep(time = 0.5)
  expect_warning(ncdc_datacats(startdate = '2013-10-01', locationid = "234234234"), "no data found")
  # bad key
  # Sys.sleep(time = 0.5)
  expect_warning(ncdc_datacats(datacategoryid="ANNAGR", token = "asdfs"), "400")
  # Sys.sleep(time = 0.5)
  # invalid longitude value - no useful server error message, gives 200 status, but empty JSON array
  expect_warning(ncdc_stations(extent=c(47.5204,-122.2047,47.6139,-192.1065)), "no data found")
})
