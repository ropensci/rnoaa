context("noaa_datasets")

tt <- noaa_datasets()
uu <- noaa_datasets(datasetid='ANNUAL')

test_that("noaa_datasets returns the correct class", {
  expect_is(tt, "noaa_datasets")
  expect_is(tt$data, "data.frame")
  expect_is(tt$data$mindate, "character")
  expect_is(uu, "noaa_datasets")
  expect_is(uu[[1]], "data.frame")
  expect_is(uu[[2]], "NULL")
})

test_that("noaa_datasets returns the correct dimensions", {
  expect_equal(dim(tt$data), c(11,5))
  expect_equal(length(tt$data$id), 11)
  expect_equal(length(uu), 2)
  expect_equal(dim(uu[[1]]), c(1,5))
})