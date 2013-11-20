context("noaa_loc_search")

tt <- noaa_loc_search(dataset='GHCND', latitude=35.59528, longitude=-82.55667)
uu <- noaa_loc_search(dataset='PRECIP_HLY', latitude=38.002511, longitude=-98.514404, radius=25)

test_that("noaa_loc_search returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt$atts, "list")
  expect_is(tt$atts$totalCount, "numeric")
  expect_is(tt$data, "data.frame")
  expect_is(tt$data$score, "numeric")
  expect_is(uu, "list")
  expect_is(uu$atts, "list")
  expect_is(uu$atts$totalCount, "numeric")
  expect_is(uu$data, "data.frame")
  expect_is(uu$data$number, "numeric")
})

test_that("noaa_loc_search returns the correct dimensions", {
  expect_equal(length(tt), 2)
  expect_equal(length(uu), 2)
  expect_equal(dim(tt$data), c(100,9))
  expect_equal(dim(uu$data), c(2,9))
})