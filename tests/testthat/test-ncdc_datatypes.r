context("ncdc_datatypes")

test_that("ncdc_datatypes returns the correct class", {
  skip_on_cran()
  
  Sys.sleep(time = 0.5)
  tt <- ncdc_datatypes(datasetid = "ANNUAL")
  
  # class
  expect_is(tt, "ncdc_datatypes")
  expect_is(tt$data, "data.frame")
  expect_is(tt$data$id, "character")

  # dimensions
  expect_equal(dim(tt$data), c(25,5))
})
