context("tornadoes")

test_that("tornadoes works", {
  skip_on_cran()
  skip_on_ci()
  skip_if_government_down()

  torn <- tornadoes()
  expect_is(torn, "SpatialLinesDataFrame")
})
