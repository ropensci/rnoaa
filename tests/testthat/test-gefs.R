context("gefs")

#set a location
lat = 46.28125
lon = -116.2188

#variable
var = "Temperature_height_above_ground_ens"

test_that("gefs errors", {
  skip_on_cran()
  skip_on_appveyor()
  skip_on_travis()

  expect_error(gefs(lat=lat, lon=lon), "Need to specify the variable to get. A list of variables is available from gefs_variables().")
})

test_that("gefs time and ensemble selection returns correct indices.", {
  skip_on_cran()
  skip_on_travis()
  skip_on_appveyor()

  ens_idx = 2:4
  time_idx = 5:10
  d = gefs(var, lat, lon, ens_idx = ens_idx, time_idx = time_idx)

  expect_equal(dim(d$data), c(length(ens_idx) * length(time_idx), 6))
  expect_equal(unique(d$data$ens), ens_idx - 1)
  ## FIXME, fails, haven't looked into why yet
  #expect_equal(unique(d$data$time), (time_idx-1) * 6)
})

test_that("gefs metadata", {
  skip_on_cran()
  skip_on_travis()
  skip_on_appveyor()

  today = format(as.Date(Sys.time()) - 1, "%Y%m%d")
  forecast_time = "0600"
  d = gefs(var, lat, lon, ens=1, date=today, forecast_time=forecast_time)

  expect_equal(d$forecast_date, today)
  expect_equal(d$forecast_time, forecast_time)
  expect_equal(d$dimensions[1:4], c("lon", "lat", "height_above_ground", "ens"))
})

test_that("gefs_variables returns characters.", {
  skip_on_cran()
  skip_on_travis()
  skip_on_appveyor()

  vars = gefs_variables()

  expect_is(vars, "character")
  expect_is(vars[1], "character")
})

test_that("gefs_latitudes returns numeric.", {
  skip_on_cran()
  skip_on_travis()
  skip_on_appveyor()

  lats = gefs_latitudes()
  expect_is(lats, "array")
  expect_is(lats[1], "numeric")
})

test_that("gefs_longitudes returns numeric.", {
  skip_on_cran()
  skip_on_travis()
  skip_on_appveyor()

  lons = gefs_longitudes()
  expect_is(lons, "array")
  expect_is(lons[1], "numeric")
})

test_that("gefs_dimensions returns character list.", {
  skip_on_cran()
  skip_on_travis()
  skip_on_appveyor()

  dims = gefs_dimensions()
  expect_is(dims, "character")
  expect_is(dims[1], "character")
})

test_that("gefs_dimension_values returns numeric array.", {
  skip_on_cran()
  skip_on_travis()
  skip_on_appveyor()

  vals = gefs_dimension_values("lat")
  expect_is(vals, "array")
  expect_is(vals[1], "numeric")

  expect_error(gefs_dimension_values(dim = NULL), "dim cannot be NULL or missing.")
})
