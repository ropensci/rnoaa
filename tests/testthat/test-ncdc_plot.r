context("ncdc_plot")

key='YZJVDgzurxvMqiIcfpzrOozpRBVvTBhE'

Sys.sleep(time = 0.5)
out <- ncdc(datasetid='GHCND', stationid='GHCND:USW00014895', datatypeid='PRCP',
            startdate = '2010-05-01', enddate = '2010-10-31', limit=200, token=key)
p <- ncdc_plot(out)

test_that("ncdc_plot returns the correct class", {
  expect_is(p, "ggplot")
  expect_is(p$layers[[1]], "proto")
  expect_is(p$layers[[1]], "environment")
})
