context("noaa_data")

# Normals Daily GHCND:USW00014895 dly-tmax-normal data
aa <- noaa(datasetid='NORMAL_DLY', stationid='GHCND:USW00014895')
# Datasetid, locationid and datatypeid
dd <- noaa(datasetid='PRECIP_HLY', locationid='ZIP:28801', datatypeid='HPCP')
# Datasetid, locationid, stationid and datatypeid
ee <- noaa(datasetid='PRECIP_HLY', locationid='ZIP:28801', stationid='COOP:310301', datatypeid='HPCP')
# Normals Daily GHCND dly-tmax-normal data
gg <- noaa(datasetid='NORMAL_DLY', datatypeid='dly-tmax-normal')
# Hourly Precipitation data for ZIP code 28801
ii <- noaa(datasetid='PRECIP_HLY', locationid='ZIP:28801', datatypeid='HPCP')

test_that("noaa returns the correct class", {
  expect_is(aa, "noaa_data")
  expect_is(dd, "noaa_data")
  expect_is(ee, "noaa_data")
  expect_is(gg, "noaa_data")
  expect_is(ii, "noaa_data")
  expect_is(aa$atts, "list")
  expect_is(aa$data, "data.frame")
  expect_is(aa$atts$totalCount, "numeric")
  expect_is(aa$data$date, "character")
})

test_that("noaa returns the correct dimensions", {
  expect_equal(length(aa$atts), 3)
  expect_equal(dim(aa$data), c(25,5))
  expect_equal(dim(ii$data), c(22,5))
  expect_equal(length(ii$atts), 3)
})