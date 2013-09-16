context("noaa_search")

tt <- noaa_search(dataset='GHCND', resulttype='station', text='Boulder')
uu <- noaa_search(dataset='GHCND', resulttype='station', text='United States')

test_that("noaa_search returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt$atts, "list")
  expect_is(tt$atts$pageCount, "numeric")
  expect_is(tt$data, "data.frame")
  expect_is(tt$data$name, "factor")
  expect_is(uu, "list")
  expect_is(uu$atts, "list")
  expect_is(uu$atts$pageCount, "numeric")
  expect_is(uu$data, "data.frame")
  expect_is(uu$data$name, "factor")
})

test_that("noaa_search returns the correct dimensions", {
  expect_equal(length(tt), 2)
  expect_equal(length(tt$atts), 2)
  expect_equal(dim(tt$data), c(88,9))
  expect_equal(length(uu), 2)
  expect_equal(length(uu$atts), 2)
  expect_equal(dim(uu$data), c(1,9))
})