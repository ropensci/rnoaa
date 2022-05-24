context("isd")

# delete any cached files
isd_cache$delete_all()
isd_dir <- isd_cache$cache_path_get()
# list.files(isd_dir, full.names = TRUE)
unlink(list.files(isd_dir, full.names = TRUE))

test_that("isd gets data", {
  skip_on_cran()
  skip_if_government_down()

  # FIXME: getting a "file not found" error when running this with vcr
  # probably something about internals, checking for cached files and such
  # vcr::use_cassette("isd_query", {
  data_a <- suppressMessages(isd(usaf = "011490", wban = "99999", year = 1986))
  data_b <- suppressMessages(isd(usaf = "011490", wban = "99999", year = 1985))
  # })

  expect_is(data_a, "tbl_df")
  # no longer a df in a list
  expect_null(suppressWarnings(data_a$data))
  expect_is(data_a$quality, "character")

  expect_lt(NROW(data_a), NROW(data_b))
})

test_that("isd fails well", {
  skip_on_cran()

  expect_error(isd(usaf = "702700", wban = "489", year = 2044),
               "download failed for")
})

# delete any cached files
isd_cache$delete_all()
isd_dir <- isd_cache$cache_path_get()
unlink(list.files(isd_dir, full.names = TRUE))
