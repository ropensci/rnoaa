context("noaa_stations")

# Station 
bb <- noaa_stations(dataset='NORMAL_DLY', station='GHCND:USW00014895')
# Displays all stations within GHCN-Daily (Displaying page 10 of the results)
cc <- noaa_stations(dataset='GHCND', page=10)
# Specify dataset and location
dd <- noaa_stations(dataset='GHCND', location='FIPS:12017')
# Specify dataset, location, and station
ee <- noaa_stations(dataset='GHCND', location='FIPS:12017', station='GHCND:USC00084289')
# Specify dataset, locationtype, location, and station
ff <- noaa_stations(dataset='GHCND', locationtype='CNTY', location='FIPS:12017', station='GHCND:USC00084289')
# Displays list of stations within the specified county
gg <- noaa_stations(dataset='GHCND', locationtype='CNTY', location='FIPS:12017')

test_that("noaa_stations returns the correct class", {
  expect_is(bb, "list")
  expect_is(cc, "list")
  expect_is(dd, "list")
  expect_is(ee, "list")
  expect_is(ff, "list")
  expect_is(gg, "list")
  expect_is(bb$atts, "list")
  expect_is(bb$data, "list")
  expect_is(bb$data$meta, "list")
  expect_is(bb$data$lab, "data.frame")
  
  expect_is(cc$atts, "list")
  expect_is(cc$data, "list")
  expect_is(cc$data[[1]]$meta, "list")
  expect_is(cc$data[[1]]$lab, "data.frame")
  
  expect_is(gg$atts, "list")
  expect_is(gg$data, "list")
  expect_is(gg$data[[1]]$meta, "list")
  expect_is(gg$data[[1]]$lab, "data.frame")
  
  expect_is(bb$atts$totalCount, "numeric")
  expect_is(bb$data$lab$displayName, "factor")
})

test_that("noaa_stations returns the correct dimensions", {
  expect_equal(length(bb), 2)
  expect_equal(length(bb$atts), 2)
  expect_equal(dim(bb$data$lab), c(12,3))
  expect_equal(length(ee$atts), 2)
  expect_equal(dim(ee$data$lab), c(11,3))
  expect_equal(length(dd), 2)
  expect_equal(length(cc$data), 100)
})