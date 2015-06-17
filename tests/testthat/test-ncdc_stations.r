context("ncdc_stations")

test_that("ncdc_stations returns the correct...", {
  skip_on_cran()
  
  Sys.sleep(time = 0.5)
  bb <- ncdc_stations(stationid='COOP:010008')
  Sys.sleep(time = 0.5)
  cc <- ncdc_stations(datasetid='NORMAL_DLY', stationid='GHCND:USW00014895')
  Sys.sleep(time = 0.5)
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
