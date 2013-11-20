context("noaa_data")

out <- noaa(dataset='NORMAL_DLY', station='GHCND:USW00014895', datatype='dly-tmax-normal', year=2010, month=4)
tt <- noaa_data(input=out) # data.frame output by default
uu <- noaa_data(input=out, datatype="list") # list if you want it

test_that("noaa_data returns the correct class", {
  expect_is(tt, "data.frame")
  expect_is(tt$station, "factor")
  expect_is(tt$value, "numeric")
  expect_is(uu, "noaa")
  expect_is(uu$atts, "list")
  expect_is(uu$data, "data.frame")
})

test_that("noaa_data returns the correct dimensions", {
  expect_equal(dim(tt), c(30,5))
  expect_equal(length(uu), 2)
  expect_equal(length(uu$atts), 2)
})