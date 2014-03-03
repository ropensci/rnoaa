context("noaa_locs")

tt <- noaa_locs(datasetid='NORMAL_DLY', startdate='20100101')
uu <- noaa_locs(locationcategoryid='ST', limit=52)

test_that("noaa_locs returns the correct class", {
  expect_is(tt, "noaa_locs")
  expect_is(uu, "noaa_locs")
  expect_is(tt$meta, "list")
  expect_is(tt$data, "data.frame")
  expect_is(tt$meta$totalCount, "numeric")
  expect_is(tt$data$mindate, "character")
})

test_that("noaa_locs returns the correct dimensions", {
  expect_equal(length(tt$meta), 3)
  expect_equal(dim(tt$data), c(25,5))
  expect_equal(dim(uu$data), c(52,5))
  expect_equal(length(tt), 2)
  expect_equal(length(uu), 2)
})