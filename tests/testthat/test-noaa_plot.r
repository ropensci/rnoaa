context("noaa_plot")

out <- noaa(datasetid='NORMAL_DLY', stationid='GHCND:USW00014895', datatypeid='dly-tmax-normal')
p <- noaa_plot(out)

test_that("noaa_plot returns the correct class", {
  expect_is(p, "ggplot")
  expect_is(p$layers[[1]], "proto")
  expect_is(p$layers[[1]], "environment")
})