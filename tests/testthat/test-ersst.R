context("ersst")

# delete any cached files
ersst_cache$delete_all()
ersst_dir <- ersst_cache$cache_path_get()
unlink(list.files(ersst_dir, full.names = TRUE))

test_that("errst works with valid character and numeric input", {
  skip_on_cran()
  skip_if_government_down()

  vcr::use_cassette("ersst1", {
    expect_is(ersst(year = 2016, month = 06), "ncdf4")
  })

  vcr::use_cassette("ersst2", {
    expect_is(ersst(year = 2016, month = 7), "ncdf4")
  })

  vcr::use_cassette("ersst3", {
    expect_is(ersst(year = "2016", month = 8), "ncdf4")
  })

  vcr::use_cassette("ersst4", {
    expect_is(ersst(year = "2016", month = "09"), "ncdf4")
  })
})

test_that("errst fails well", {
  skip_on_cran()

  expect_error(ersst(year = 2016), "argument \"month\" is missing")
  expect_error(ersst(month = 10), "argument \"year\" is missing")
  expect_error(ersst(year = 1853, month = 10), "year must be > 1853")
  expect_error(ersst(year = 2015, month = 100),
               "month must be a length 1 or 2 month value")
  expect_error(ersst(year = 2015, month = 13),
               "month must be a number between 1 and 12")
})

# delete any cached files
ersst_cache$delete_all()
ersst_dir <- ersst_cache$cache_path_get()
unlink(list.files(ersst_dir, full.names = TRUE))
