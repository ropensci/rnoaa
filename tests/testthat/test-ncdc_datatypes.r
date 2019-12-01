context("ncdc_datatypes")

test_that("ncdc_datatypes returns the correct class", {
  skip_on_cran()
  
  vcr::use_cassette("ncdc_datatypes", {
    tt <- ncdc_datatypes(datasetid = "ANNUAL")
    
    # class
    expect_is(tt, "ncdc_datatypes")
    expect_is(tt$data, "data.frame")
    expect_is(tt$data$id, "character")

    # dimensions
    expect_equal(dim(tt$data), c(25,5))
  })
})

# no internet required
test_that("ncdc_datatypes fails well", {
  skip_on_cran()

  # unload vcr namespace
  unloadNamespace("vcr")

  webmockr::enable()
  url <- 'https://www.ncdc.noaa.gov/cdo-web/api/v2/datatypes?limit=25&datasetid=ANNUAL'
  ss <- webmockr::stub_request('get', url)
  webmockr::to_return(ss, body = "<!DOCTYPE HTML PUBLIC><>")
  expect_error(ncdc_datatypes(datasetid='ANNUAL'), "lexical error")
  webmockr::disable()

  # re-attach vcr namespace
  attachNamespace("vcr")
  vcr_set()
})
