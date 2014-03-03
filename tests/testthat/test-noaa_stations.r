context("noaa_stations")

bb <- noaa_stations(stationid='COOP:010008')
cc <- noaa_stations(datasetid='NORMAL_DLY', stationid='GHCND:USW00014895')
dd <- noaa_stations(datasetid='GHCND', locationid='FIPS:12017')

test_that("noaa_stations returns the correct class", {
  expect_is(bb$data, "data.frame")
  expect_is(cc$data, "data.frame")
  expect_is(dd, "noaa_stations")
  expect_is(dd$atts, "list")
  expect_is(dd$data, "data.frame")
  expect_is(dd$atts, "list")
  expect_is(dd$data$longitude, "numeric")
})

test_that("noaa_stations returns the correct dimensions", {
  expect_equal(length(bb), 2)
  expect_equal(length(dd$atts), 3)
  expect_equal(dim(dd$data), c(11,9))
  expect_equal(length(dd), 2)
  expect_equal(dim(cc$data), c(1,5))
})