context("lcd")

test_that("lcd works", {
  skip_on_cran()
  skip_if_government_down()

  # clean up first
  lcd_cache$delete_all()

  # get data
  aa <- lcd(station = "01338099999", year = "2017")

  expect_is(aa, "tbl_df")

  expect_type(aa$station, 'integer')
  expect_type(aa$date, 'character')
  expect_type(aa$latitude, 'double')
  expect_type(aa$longitude, 'double')
  expect_type(aa$elevation, 'double')
  expect_type(aa$wnd, 'character')
})

test_that("lcd fails well", {
  skip_on_cran()
  skip_if_government_down()

  # a station/year combination that doesn't exist
  expect_error(lcd(station = "02413099999", year = "1945"),
               "Not Found")

  # class
  expect_error(lcd(5),
               "\"year\" is missing, with no default")
  expect_error(lcd(5, 5),
               "year must be between 1901")
  expect_error(lcd(list(1), 5),
               "station must be of class")
  expect_error(lcd(5, list(1)),
               "year must be of class")
})
