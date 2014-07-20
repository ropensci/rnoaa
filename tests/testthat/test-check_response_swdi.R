context("check_response_swdi")

test_that("check_response returns an error", {
  # Get a warning if startdate and enddate are not provided
  expect_error(swdi(dataset='warn', id=533623), "startdate")
  # Error in radius, has to be 25 miles or less
  expect_warning(swdi(dataset='nx3tvs',
                           startdate='20060505',
                           enddate='20060516',
                           radius=50,
                           center=c(-102.0,32.7),
                           stat='count'), "ERROR VALIDATING 'radius'")
})
