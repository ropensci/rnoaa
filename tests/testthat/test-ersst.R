context("ersst")

test_that("errst works with valid character and numeric input", {
  skip_on_cran()
  skip_if_government_down()

  expect_is(ersst(year = 2016, month = 06), "ncdf4")
  expect_is(ersst(year = 2016, month = 6), "ncdf4")
  expect_is(ersst(year = "2016", month = 6), "ncdf4")
  expect_is(ersst(year = "2016", month = "06"), "ncdf4")

})

test_that("errst fails well", {

  expect_error(ersst(year = 2016), "argument \"month\" is missing")
  expect_error(ersst(month = 10), "argument \"year\" is missing")
  expect_error(ersst(year = 1853, month = 10), "year must be > 1853")
  expect_error(ersst(year = 2015, month = 100),
               "month must be a length 1 or 2 month value")
  expect_error(ersst(year = 2015, month = 13),
               "month must be a number between 1 and 12")

})
