context("noaa_loc_types")

tt <- noaa_loc_types(dataset='GHCND')
uu <- noaa_loc_types(dataset='GHCND', locationtype='HYD_CAT')

test_that("noaa_loc_types returns the correct class", {
  expect_is(tt, "data.frame")
  expect_is(tt$name, "factor")
  expect_is(uu, "data.frame")
  expect_is(uu$id, "factor")
})

test_that("noaa_loc_types returns the correct dimensions", {
  expect_equal(dim(tt), c(11,2))
  expect_equal(dim(uu), c(1,2))
})