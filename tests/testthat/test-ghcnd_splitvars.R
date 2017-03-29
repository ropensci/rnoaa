context("ghcnd_splitvars")

test_that("ghcnd_splitvars for data", {
  skip_on_cran()

  dat <- ghcnd(stationid = "AGE00147704")
  aa <- ghcnd_splitvars(dat)

  expect_is(aa, "list")
  expect_is(aa$prcp, "tbl_df")
  expect_is(aa$prcp, "data.frame")
  expect_is(aa$tmax, "data.frame")
  expect_is(aa$tmin, "data.frame")

  expect_equal(length(unique(aa$tmin$id)), 1)
})

test_that("ghcnd_splitvars fails well", {
  expect_error(ghcnd_splitvars("adfadfs"), "input must be a data.frame")
  expect_error(ghcnd_splitvars(5), "input must be a data.frame")
  expect_error(ghcnd_splitvars(list(4)), "input must be a data.frame")
  expect_error(ghcnd_splitvars(matrix()), "input must be a data.frame")
  expect_error(ghcnd_splitvars(mtcars), "input not of correct format")
})
