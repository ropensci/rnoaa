context("defunct")

test_that("Defunct functions return error messages", {
  expect_error(gefs(), "is defunct", class="error")
  expect_error(gefs_dimension_values(), "is defunct", class="error")
  expect_error(gefs_dimensions(), "is defunct", class="error")
  expect_error(gefs_ensembles(), "is defunct", class="error")
  expect_error(gefs_latitudes(), "is defunct", class="error")
  expect_error(gefs_longitudes(), "is defunct", class="error")
  expect_error(gefs_times(), "is defunct", class="error")
  expect_error(gefs_variables(), "is defunct", class="error")
})
