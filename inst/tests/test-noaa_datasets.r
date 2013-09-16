context("noaa_datasets")

tt <- noaa_datasets() 
uu <- noaa_datasets(dataset='ANNUAL')

test_that("noaa_datasets returns the correct class", {
  expect_is(tt, "data.frame")
  expect_is(tt$name, "factor")
  expect_is(tt$minDate, "factor")
  expect_is(uu, "list")
  expect_is(uu[[1]], "data.frame")
  expect_is(uu[[2]], "data.frame")
})

test_that("noaa_datasets returns the correct dimensions", {
  expect_equal(dim(tt), c(11,5))
  expect_equal(length(tt$id), 11)
  expect_equal(length(uu), 2)
  expect_equal(dim(uu[[1]]), c(1,5))
  expect_equal(dim(uu[[2]]), c(4,3))
})