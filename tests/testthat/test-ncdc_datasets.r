context("ncdc_datasets")

test_that("ncdc_datasets returns the correct class", {
  skip_on_cran()
  
  Sys.sleep(time = 0.5)
  tt <- ncdc_datasets()
  Sys.sleep(time = 0.5)
  uu <- ncdc_datasets(datasetid='ANNUAL')
  
  # class
  expect_is(tt, "ncdc_datasets")
  expect_is(tt$data, "data.frame")
  expect_is(tt$data$mindate, "character")
  expect_is(uu, "ncdc_datasets")
  expect_is(uu$data, "data.frame")
  expect_is(uu$meta, "NULL")

  # dimensions
  expect_equal(dim(tt$data), c(11,6))
  expect_equal(length(tt$data$id), 11)
  expect_equal(length(uu), 2)
  expect_equal(dim(uu$data), c(1,5))
})
