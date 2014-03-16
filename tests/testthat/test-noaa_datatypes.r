context("noaa_datatypes")

key='hzGfPCLWFGWdVSkjVIljzQVfkHvlNmeQ'

tt <- noaa_datatypes(datasetid="ANNUAL", token=key)

test_that("noaa_datatypes returns the correct class", {
  expect_is(tt, "noaa_datatypes")
  expect_is(tt$data, "data.frame")
  expect_is(tt$data$id, "character")
})

test_that("noaa_datatypes returns the correct dimensions", {
  expect_equal(dim(tt$data), c(25,5))
})