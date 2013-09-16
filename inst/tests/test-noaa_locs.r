context("noaa_locs")

# Find locations within the Daily Normals dataset
tt <- noaa_locs(dataset='NORMAL_DLY', startdate='20100101')
# Displays the location CITY:CA000012 within the PRECIP_HLY dataset
uu <- noaa_locs(dataset='PRECIP_HLY', location='CITY:CA000012')
# Displays available countries within GHCN-Daily
vv <- noaa_locs(dataset='GHCND', locationtype='CNTRY')

test_that("noaa_locs returns the correct class", {
  expect_is(tt, "list")
  expect_is(uu, "list")
  expect_is(vv, "list")
  expect_is(tt$atts, "list")
  expect_is(tt$data, "data.frame")
  expect_is(tt$atts$totalCount, "numeric")
  expect_is(tt$data$minDate, "factor")
})

test_that("noaa_locs returns the correct dimensions", {
  expect_equal(length(tt$atts), 2)
  expect_equal(dim(tt$data), c(100,8))
  expect_equal(dim(uu$data), c(1,8))
  expect_equal(dim(vv$data), c(100,8))
  expect_equal(length(tt), 2)
  expect_equal(length(uu), 2)
  expect_equal(length(vv), 2)
})