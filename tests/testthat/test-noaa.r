context("noaa")

# Normals Daily GHCND:USW00014895 dly-tmax-normal data
aa <- noaa(dataset='NORMAL_DLY', station='GHCND:USW00014895', year=2010, month=4)
# Dataset, location and datatype
dd <- noaa(dataset='PRECIP_HLY', location='ZIP:28801', datatype='HPCP', year=2001, month=4)
# Dataset, location, station and datatype
ee <- noaa(dataset='PRECIP_HLY', location='ZIP:28801', station='COOP:310301', datatype='HPCP', year=2001, month=4)
# Normals Daily GHCND dly-tmax-normal data
gg <- noaa(dataset='NORMAL_DLY', datatype='dly-tmax-normal', year=2010, month=4)
# Hourly Precipitation data for ZIP code 28801
ii <- noaa(dataset='PRECIP_HLY', location='ZIP:28801', datatype='HPCP', year=1980, month=7, day=17)

test_that("noaa returns the correct class", {
  expect_is(aa, "noaa")
  expect_is(dd, "noaa")
  expect_is(ee, "noaa")
  expect_is(gg, "noaa")
  expect_is(ii, "noaa")
  expect_is(aa$atts, "list")
  expect_is(aa$data, "data.frame")
  expect_is(aa$atts$totalCount, "numeric")
  expect_is(aa$data$date, "factor")
})

test_that("noaa returns the correct dimensions", {
  expect_equal(length(aa$atts), 2)
  expect_equal(dim(aa$data), c(100,5))
  expect_equal(dim(ii$data), c(17,5))
  expect_equal(length(ii$atts), 2)
})