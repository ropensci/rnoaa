context("storms")

test_that("storms meta", {
  meta_1 <- storm_meta()
  meta_2 <- storm_meta("storm_columns")
  meta_3 <- storm_meta("storm_names")

  expect_is(meta_1, "data.frame")
  expect_is(meta_2, "data.frame")
  expect_is(meta_3, "data.frame")

  expect_equal(NCOL(meta_1), NCOL(meta_2))
  expect_lt(NCOL(meta_3), NCOL(meta_2))
})

# delete any cached files
storms_dir <- rappdirs::user_cache_dir("rnoaa/storms")
storms_basin <- file.path(storms_dir, "basin")
storms_storm <- file.path(storms_dir, "storm")
storms_year <- file.path(storms_dir, "year")
list.files(storms_storm, full.names = TRUE)
list.files(storms_year, full.names = TRUE)
unlink(list.files(storms_storm, full.names = TRUE))
unlink(list.files(storms_year, full.names = TRUE))

test_that("storms data", {
  skip_on_cran()
  skip_on_ci()

  vcr::use_cassette("storm_data", {
    storm <- suppressMessages(storm_data(storm = '1970143N19091'))
    yr <- suppressMessages(storm_data(year = 1940))
  })

  expect_is(storm, "tbl_df")
  expect_is(yr, "tbl_df")
  expect_is(storm, "data.frame")
  expect_is(yr, "data.frame")
  expect_is(storm$serial_num, "character")

  expect_equal(unique(storm$serial_num), '1970143N19091')
})

# test_that("storms shape data", {
#   skip_on_cran()
#   skip_on_travis()

#   # basin
#   res <- storm_shp(basin = 'EP')

#   # storm
#   res2 <- storm_shp(storm = '1970143N19091')

#   # year
#   res3 <- storm_shp(year = 1940)
#   shpread <- storm_shp_read(res3)

#   expect_is(res, "storm_shp")
#   expect_is(res2, "storm_shp")
#   expect_is(res3, "storm_shp")

#   expect_is(res$path, "character")
#   expect_equal(attr(res, "basin"), "EP")

#   expect_is(shpread, "SpatialPointsDataFrame")
#   expect_is(shpread@data, "data.frame")
# })
