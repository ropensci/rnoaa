context("noaa_datatypes")

tt <- noaa_datatypes(dataset="ANNUAL")
## With a filter
uu <- noaa_datatypes(dataset="Annual",filter="precip")
### with a two filters
vv <- noaa_datatypes(dataset="Annual",filter = c("precip","sod"))

test_that("noaa_datatypes returns the correct class", {
  expect_is(tt, "data.frame")
  expect_is(uu, "data.frame")
  expect_is(vv, "data.frame")
  expect_is(tt$ID, "factor")
  expect_is(uu$Description, "factor")
  expect_is(vv$Name, "factor")
})

test_that("noaa_datatypes returns the correct dimensions", {
  expect_equal(dim(tt), c(576,3))
  expect_equal(dim(uu), c(6,3))
  expect_equal(dim(vv), c(114,3))
})