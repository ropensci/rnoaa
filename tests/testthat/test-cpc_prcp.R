context("cpc_prcp")

test_that("cpc_prcp works", {
  skip_on_cran()

  aa <- cpc_prcp(date = "2017-01-15")
  bb <- cpc_prcp(date = "2005-07-09", us = TRUE)

  expect_is(aa, "tbl_df")
  expect_is(bb, "tbl_df")

  expect_named(aa, c('lon', 'lat', 'precip'))
  expect_named(bb, c('lon', 'lat', 'precip'))

  expect_type(aa$lon, 'double')
  expect_type(aa$lat, 'double')
  expect_type(aa$precip, 'double')
  expect_type(bb$lon, 'double')
  expect_type(bb$lat, 'double')
  expect_type(bb$precip, 'double')

  ## world data has more rows
  expect_gt(NROW(aa), NROW(bb))
})

test_that("cpc_prcp fails well", {
  skip_on_cran()

  # required param
  expect_error(cpc_prcp(),
               "argument \"date\" is missing, with no default")

  # class
  expect_error(cpc_prcp(5),
               "date must be of class character, Date")
  expect_error(cpc_prcp("2017-01-15", us = 5),
               "us must be of class logical")
})
