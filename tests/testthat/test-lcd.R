context("lcd")

# clean up first
# lcd_cache$delete_all()

test_that("lcd", {
  skip_on_cran()
  skip_if_government_down()

  vcr::use_cassette("lcd_1", {
    aa <- lcd(station = "01338099999", year = 2017)
  })

  expect_is(aa, "tbl_df")

  expect_type(aa$station, 'integer')
  expect_type(aa$date, 'character')
  expect_type(aa$latitude, 'double')
  expect_type(aa$longitude, 'double')
  expect_type(aa$elevation, 'double')
  expect_type(aa$hourlysealevelpressure, 'double')
})

test_that("lcd fails well", {
  skip_on_cran()
  skip_if_government_down()

  # a station/year combination that doesn't exist
  vcr::use_cassette("lcd_not_found", {
    expect_error(lcd(station = "02413099999", year = "1945"),
                 "Not Found", class = "error")
  })

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

test_that("lcd fails well when trying to read a bad file", {
  skip_on_cran()

  lcd_cache$cache_path_set(full_path = file.path(tempdir(), "foo_bar"))
  lcd_cache$mkdir()
  path <- file.path(tempdir(), "foo_bar", "2020_72517014737.csv")
  file.create(path)
  expect_error(lcd(72517014737, 2020), "malformed", class = "error")
  unlink(path)
})
