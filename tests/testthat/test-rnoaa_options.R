# delete any cached files
arc2_cache$delete_all()

test_that("rnoaa_options", {
  skip_on_cran()

  expect_is(rnoaa_options, "function")
  expect_null(rnoaa_options())

  # after setting param its in the env var
  expect_true(roenv$cache_messages)
  rnoaa_options(FALSE)
  expect_false(roenv$cache_messages)

  # reset options
  rnoaa_options()
})

arc2_cache$delete_all()
