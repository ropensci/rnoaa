context("ncdc_stations")

test_that("ncdc_stations returns the correct...", {
  skip_on_cran()

  vcr::use_cassette("ncdc_stations", {
    bb <- ncdc_stations(stationid='COOP:010008')
    cc <- ncdc_stations(datasetid='NORMAL_DLY', stationid='GHCND:USW00014895')
    dd <- ncdc_stations(datasetid='GHCND', locationid='FIPS:12017')
    
    # classes
    expect_is(bb$data, "data.frame")
    expect_is(cc$data, "data.frame")
    expect_is(dd, "ncdc_stations")
    expect_is(dd$meta, "list")
    expect_is(dd$data, "data.frame")
    expect_is(dd$meta, "list")
    expect_is(dd$data$longitude, "numeric")

    # dimensions
    expect_equal(length(bb), 2)
    expect_equal(length(dd$meta), 3)
    expect_equal(NCOL(dd$data), 9)
    expect_equal(length(dd), 2)
    expect_equal(NCOL(cc$data), 9)
  })
})

# no internet required
test_that("ncdc_stations fails well", {
  skip_on_cran()

  # unload vcr namespace
  unloadNamespace("vcr")

  webmockr::enable()
  url <- 'https://www.ncdc.noaa.gov/cdo-web/api/v2/stations/COOP:010008'
  ss <- webmockr::stub_request('get', url)
  webmockr::to_return(ss, body = "<!DOCTYPE HTML PUBLIC><>")
  expect_error(ncdc_stations(stationid='COOP:010008'), "lexical error")
  webmockr::disable()

  # re-attach vcr namespace
  attachNamespace("vcr")
  vcr_set()
})
