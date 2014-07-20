context("ncdc_datatypes")

key='YZJVDgzurxvMqiIcfpzrOozpRBVvTBhE'

Sys.sleep(time = 0.5)
tt <- ncdc_datatypes(datasetid="ANNUAL", token=key)

test_that("ncdc_datatypes returns the correct class", {
  expect_is(tt, "ncdc_datatypes")
  expect_is(tt$data, "data.frame")
  expect_is(tt$data$id, "character")
})

test_that("ncdc_datatypes returns the correct dimensions", {
  expect_equal(dim(tt$data), c(25,5))
})
