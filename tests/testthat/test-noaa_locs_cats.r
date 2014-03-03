context("noaa_locs_cats")

tt <- noaa_locs_cats()
uu <- noaa_locs_cats(locationcategoryid='CLIM_REG')
vv <- noaa_locs_cats(startdate='1970-01-01')

test_that("noaa_locs_cats returns the correct class", {
  expect_is(tt, "noaa_locs_cats")
  expect_is(uu$data, "data.frame")
  expect_is(vv, "noaa_locs_cats")
  expect_is(tt$atts, "list")
  expect_is(tt$data, "data.frame")
  expect_is(tt$atts$totalCount, "numeric")
  expect_is(tt$data$id, "character")
})

test_that("noaa_locs_cats returns the correct dimensions", {
  expect_equal(length(tt$atts), 3)
  expect_equal(dim(tt$data), c(11,2))
  expect_equal(dim(uu$data), c(1,2))
  expect_equal(dim(vv$data), c(11,2))
  expect_equal(length(tt), 2)
  expect_equal(length(uu), 2)
  expect_equal(length(vv), 2)
})