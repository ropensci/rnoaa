context("cpc_prcp")

# delete any cached files
cpc_cache$delete_all()

test_that("cpc_prcp works", {
  skip_on_cran()
  skip_on_ci()

  # 2017, us = FALSE
  vcr::use_cassette("cpc_prcp_us_false1", {
    aa <- cpc_prcp(date = "2017-01-15", us = FALSE)
  })
  # 2017, us = TRUE
  vcr::use_cassette("cpc_prcp_us_true1", {
    aa_us <- cpc_prcp(date = "2017-01-15", us = TRUE)
  })

  # 1998, us = FALSE
  vcr::use_cassette("cpc_prcp_us_false2", {
    bb <- cpc_prcp(date = "1998-07-09", us = FALSE)
  })
  # 1998, us = TRUE
  vcr::use_cassette("cpc_prcp_us_true2", {
    bb_us <- cpc_prcp(date = "1998-07-09", us = TRUE)
  })

  # 2006, us = FALSE
  vcr::use_cassette("cpc_prcp_us_false3", {
    cc <- cpc_prcp(date = "2006-07-09", us = FALSE)
  })
  # 2006, us = TRUE
  vcr::use_cassette("cpc_prcp_us_true3", {
    cc_us <- cpc_prcp(date = "2006-07-09", us = TRUE)
  })

  expect_is(aa, "tbl_df")
  expect_is(aa_us, "tbl_df")
  expect_is(bb, "tbl_df")
  expect_is(bb_us, "tbl_df")
  expect_is(cc, "tbl_df")
  expect_is(cc_us, "tbl_df")

  expect_named(aa, c('lon', 'lat', 'precip'))
  expect_named(aa_us, c('lon', 'lat', 'precip'))
  expect_named(bb, c('lon', 'lat', 'precip'))
  expect_named(bb_us, c('lon', 'lat', 'precip'))
  expect_named(cc, c('lon', 'lat', 'precip'))
  expect_named(cc_us, c('lon', 'lat', 'precip'))

  expect_type(aa$lon, 'double')
  expect_type(aa$lat, 'double')
  expect_type(aa$precip, 'double')
  expect_type(bb$lon, 'double')
  expect_type(bb$lat, 'double')
  expect_type(bb$precip, 'double')
  expect_type(cc$lon, 'double')
  expect_type(cc$lat, 'double')
  expect_type(cc$precip, 'double')

  ## world data has more rows
  expect_gt(NROW(aa), NROW(aa_us))
  expect_gt(NROW(bb), NROW(bb_us))
  expect_gt(NROW(cc), NROW(cc_us))
})

test_that("cpc_prcp fails well", {
  skip_on_cran()

  # required param
  expect_error(cpc_prcp(),
               "argument \"date\" is missing, with no default")

  # class
  expect_error(cpc_prcp(5),
               "date must be of class character, Date")
  expect_error(cpc_prcp("2017-01-15", us = 5),
               "us must be of class logical")

  # acceptable years
  ## non us
  expect_error(cpc_prcp("1945-01-01"), "must be between")
  expect_error(cpc_prcp(Sys.Date() + 365), "must be between")
  ## us
  expect_error(cpc_prcp("1947-12-31", us = TRUE), "must be between")
  expect_error(cpc_prcp(Sys.Date() + 365, us = TRUE), "must be between")
})

# delete any cached files
cpc_cache$delete_all()
cpc_dir <- cpc_cache$cache_path_get()
unlink(list.files(cpc_dir, full.names = TRUE))
