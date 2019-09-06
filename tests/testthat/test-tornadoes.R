context("tornadoes")

test_that("tornadoes works", {
  skip_on_cran()
  skip_if_government_down()

  expect_warning(torn <- tornadoes(), regexp = "Dropping null geometries")
  expect_is(torn, "SpatialLinesDataFrame")
})
