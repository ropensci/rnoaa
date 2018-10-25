context("isd_stations")

expect_is_valid_generic_df <- function(stations) {
  expect_is(stations, "data.frame")
  expect_is(stations$usaf, "character")
  expect_is(stations$wban, "character")
  expect_is(stations$station_name, "character")
  expect_is(stations$ctry, "character")
  expect_is(stations$state, "character")
  expect_is(stations$icao, "character")
  expect_is(stations$elev_m, "numeric")
  expect_is(stations$begin, "numeric")
  expect_is(stations$end, "numeric")
}


test_that("list stations", {
  skip_on_cran()

  out <- isd_stations()

  #Valid type and dimension tests
  expect_is_valid_generic_df(out)
  expect_is(out$lat, "numeric")
  expect_is(out$lon, "numeric")
  expect_equal(NCOL(out), 11)

})

test_that("search for stations - by bounding box", {
  skip_on_cran()

  bbox <- c(-125.0, 38.4, -121.8, 40.9)
  out <- suppressMessages(isd_stations_search(bbox = bbox))

  #Valid type and dimension tests
  expect_is_valid_generic_df(out)
  expect_is(out$lat, "numeric")
  expect_is(out$lon, "numeric")
  expect_equal(NCOL(out), 11)

  #Logic tests
  expect_lt(bbox[1], min(out$lon))
  expect_gt(bbox[3], max(out$lon))

  expect_lt(bbox[2], min(out$lat))
  expect_gt(bbox[4], max(out$lat))
})

test_that("search for stations - by lat/lon/radius", {
  skip_on_cran()

  lat = 38.4
  lon = -123
  radius = 250
  out <- suppressMessages(isd_stations_search(lat = lat, lon = lon, radius = radius))

  #Valid type and dimension tests
  expect_is_valid_generic_df(out)
  expect_is(out$lat, "numeric")
  expect_is(out$lon, "numeric")
  expect_is(out$distance, "numeric")
  expect_equal(NCOL(out), 12)

  #Logic tests
  expect_lt(max(out$distance), radius)
})
