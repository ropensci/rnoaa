context("ncdc_plot")

# call used to make dataset saved, and used below
# out <- ncdc(datasetid='GHCND', stationid='GHCND:USW00014895', datatypeid='PRCP',
#             startdate = '2010-05-01', enddate = '2010-10-31', limit=200)
out <- readRDS("plot_data.Rds")

test_that("ncdc_plot returns the correct class", {
  skip_on_cran()
  
  p <- ncdc_plot(out)
  
  expect_is(p, "ggplot")
  expect_is(p$mapping$x, "quosure")
  expect_is(p$mapping$x, "formula")
  expect_named(p$mapping, c("x", "y"))
})
