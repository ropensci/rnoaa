context("isd_read")

test_that("isd_read gets data", {
  skip_on_cran()

  file <- system.file("examples", "011490-99999-1986.gz", package = "rnoaa")
  aa <- suppressMessages(isd_read(file))

  expect_is(aa, "tbl_df")
  expect_is(aa$quality, "character")
  expect_type(aa$total_chars, "character")
  expect_type(aa$latitude, "character")
  expect_type(aa$longitude, "character")
})

test_that("isd fails well", {
  skip_on_cran()

  expect_error(isd_read(),
               "\"path\" is missing")

  expect_error(isd_read(5),
               "invalid 'file' argument")

  expect_error(isd_read("stuffthings"),
               "file not found")
})
