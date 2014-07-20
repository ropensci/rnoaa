context("ncdc_stations")

key='YZJVDgzurxvMqiIcfpzrOozpRBVvTBhE'

Sys.sleep(time = 0.5)
bb <- ncdc_stations(stationid='COOP:010008', token=key)
Sys.sleep(time = 0.5)
cc <- ncdc_stations(datasetid='NORMAL_DLY', stationid='GHCND:USW00014895', token=key)
Sys.sleep(time = 0.5)
dd <- ncdc_stations(datasetid='GHCND', locationid='FIPS:12017', token=key)

test_that("ncdc_stations returns the correct class", {
  expect_is(bb$data, "data.frame")
  expect_is(cc$data, "data.frame")
  expect_is(dd, "ncdc_stations")
  expect_is(dd$meta, "list")
  expect_is(dd$data, "data.frame")
  expect_is(dd$meta, "list")
  expect_is(dd$data$longitude, "numeric")
})

test_that("ncdc_stations returns the correct dimensions", {
  expect_equal(length(bb), 2)
  expect_equal(length(dd$meta), 3)
  expect_equal(dim(dd$data), c(11,9))
  expect_equal(length(dd), 2)
  expect_equal(dim(cc$data), c(1,9))
})
