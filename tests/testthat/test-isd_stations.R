context("isd_stations")

test_that("list stations", {
  skip_on_cran()

  aa <- isd_stations()

  expect_is(aa, "data.frame")
  expect_is(aa$usaf, "character")

  expect_equal(NCOL(aa), 11)
})

test_that("search for stations - by bounding box", {
  skip_on_cran()

  bbox <- c(-125.0, 38.4, -121.8, 40.9)
  out <- suppressMessages(isd_stations_search(bbox = bbox))

  expect_is(out, "data.frame")

  expect_lt(bbox[1], min(out$lon))
  expect_gt(bbox[3], max(out$lon))

  expect_lt(bbox[2], min(out$lat))
  expect_gt(bbox[4], max(out$lat))
})

# test_that("search for stations - by lat/lon/radius", {
#   skip_on_cran()
#
#   lat = 38.4
#   lon = -123
#   radius = 250
#   out <- suppressMessages(isd_stations_search(lat = lat, lon = lon, radius = radius))
#
#   expect_is(out, "data.frame")
#   expect_is(out$lon, "numeric")
#   expect_is(out$lat, "numeric")
#   expect_is(out$state, "character")
# })
