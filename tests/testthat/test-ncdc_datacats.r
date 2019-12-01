context("ncdc_datacats")

test_that("ncdc_datacats returns the correct ...", {
  skip_on_cran()
  
  vcr::use_cassette("ncdc_datacats", {
    tt <- ncdc_datacats()
    uu <- ncdc_datacats(datacategoryid="ANNAGR")
    
    # class
    expect_is(tt, "ncdc_datacats")
    expect_is(tt$data, "data.frame")
    expect_is(tt$data$name, "character")
    expect_is(uu$data, "data.frame")
    expect_is(uu$data$name, "character")
    
    # dimensions
    expect_equal(dim(tt$data), c(25,2))
    expect_equal(length(tt$data$id), 25)
    expect_equal(dim(uu$data), c(1,2))
    expect_equal(dim(uu[[1]]), NULL)
  })
})

# no internet required
test_that("ncdc_datacats fails well", {
  skip_on_cran()

  # unload vcr namespace
  unloadNamespace("vcr")

  webmockr::enable()
  url <- 'https://www.ncdc.noaa.gov/cdo-web/api/v2/datacategories/ANNAGR?limit=25'
  ss <- webmockr::stub_request('get', url)
  webmockr::to_return(ss, body = "<!DOCTYPE HTML PUBLIC><>")
  expect_error(ncdc_datacats(datacategoryid="ANNAGR"), "lexical error")
  webmockr::disable()

  # re-attach vcr namespace
  attachNamespace("vcr")
  vcr_set()
})
