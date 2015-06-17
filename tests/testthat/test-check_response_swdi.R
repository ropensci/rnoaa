context("check_response_swdi")

test_that("check_response returns an error", {
  skip_on_cran()
  
  # Get a warning if startdate and enddate are not provided
  expect_error(swdi(dataset = 'warn', id = 533623), "startdate")
})
