context("noaa_plot")

out <- noaa(dataset='NORMAL_DLY', station='GHCND:USW00014895', datatype='dly-tmax-normal', year=2010, month=4)
p <- noaa_plot(out)

test_that("noaa_plot returns the correct class", {
  expect_is(p, "pp")
  expect_is(p, "ggplot")
  expect_is(p$layers[[1]], "proto")
  expect_is(p$layers[[1]], "environment")
})