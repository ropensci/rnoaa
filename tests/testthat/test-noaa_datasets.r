context("ncdc_datasets")

key='YZJVDgzurxvMqiIcfpzrOozpRBVvTBhE'

Sys.sleep(time = 0.5)
tt <- ncdc_datasets(token=key)
Sys.sleep(time = 0.5)
uu <- ncdc_datasets(datasetid='ANNUAL', token=key)

test_that("ncdc_datasets returns the correct class", {
  expect_is(tt, "ncdc_datasets")
  expect_is(tt$data, "data.frame")
  expect_is(tt$data$mindate, "character")
  expect_is(uu, "ncdc_datasets")
  expect_is(uu$data, "data.frame")
  expect_is(uu$meta, "NULL")
})

test_that("ncdc_datasets returns the correct dimensions", {
  expect_equal(dim(tt$data), c(11,6))
  expect_equal(length(tt$data$id), 11)
  expect_equal(length(uu), 2)
  expect_equal(dim(uu$data), c(1,5))
})
