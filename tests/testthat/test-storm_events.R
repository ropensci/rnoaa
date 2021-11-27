context("storm_events: se_files")

test_that("se_files works", {
  skip_on_cran()
  skip_if_government_down()

  vcr::use_cassette("se_files", {
    aa <- se_files()
  })

  expect_is(aa, "data.frame")
  expect_is(aa$type, "character")
  expect_is(aa$year, "numeric")
  expect_is(aa$created, "numeric")
  expect_is(aa$url, "character")
})

context("storm_events: se_data")

test_that("se_data works", {
  skip_on_cran()
  skip_if_government_down()

  aa <- se_data(year = 2013, type = "details")

  expect_is(aa, "data.frame")
  expect_is(aa, "tbl_df")
})

test_that("se_data fails well", {
  skip_on_cran()
  skip_if_government_down()

  expect_error(se_data(), "'year' missing")
  expect_error(se_data(5), "'type' missing")
  expect_error(se_data('a', 'adf'), "year must be of")
  expect_error(se_data(5, 5), "type must be of")
  expect_error(se_data(5, 'f'), "year must be between")
  expect_error(se_data(2008, 'f'), "'type' must be one of")
})

