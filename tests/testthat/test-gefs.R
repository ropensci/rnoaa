context("gefs")

#set a location
lons <- c(-1.1, 0, 0.8, 2)
lats <- c(50.1, 51, 51.9, 53, 54)

#variable
temp = "Temperature_height_above_ground_ens"

test_that("gefs errors", {
  skip_on_cran()
  skip_on_appveyor()
  skip_on_travis()
  skip_on_os("windows")

  expect_error(gefs(lat=lat, lon=lon), "Need to specify the variable to get. A list of variables is available from gefs_variables().")
  expect_error(gefs(var = temp, lat = c(-43, -41), lon = lons, ens = 1, time = 6), "Latitudes must be sequential.", fixed = TRUE)
  expect_error(gefs(var = temp, lat = lats, lon = c(213, 211), ens = 1, time = 6), "Longitudes must be sequential.", fixed = TRUE)
  expect_error(gefs(var = temp, lat = -91, lon = lons, ens = 1, time = 6), "Latitudes must be in c(-90,90).", fixed = TRUE)
  expect_error(gefs(var = temp, lat = 91, lon = lons, ens = 1, time = 6), "Latitudes must be in c(-90,90).", fixed = TRUE)
  expect_error(gefs(var = temp, lat = lats, lon = 361, ens = 1, time = 6), "Longitudes must be in c(-180,180) or c(0,360).", fixed = TRUE)
  expect_error(gefs(var = temp, lat = lats, lon = -181, ens = 1, time = 6), "Longitudes must be in c(-180,180) or c(0,360).", fixed = TRUE)
  expect_error(gefs(var = temp, lat = lats, lon = lons, ens_idx = 22, time_idx = 1), "'ens_idx' is out of bounds, check the dimension values with 'gefs_dimension_values(dim = 'ens').", fixed = TRUE)
  expect_error(gefs(var = temp, lat = lats, lon = lons, ens_idx = 1, time_idx = 67), "'time_idx' is out of bounds, check the dimension values with 'gefs_dimension_values(dim = 'time').", fixed = TRUE)
})

test_that("gefs HTTP requests", {
  skip_on_cran()
  skip_on_travis()
  skip_on_appveyor()
  skip_on_os("windows")

  ### Get raw and processed data
  d_raw <- gefs(var = temp,
                ens = 1:2,
                time = c(6,12),
                forecast_time = "0000",
                lon = lons, lat = lats, raw = TRUE)
  d <- gefs(var = temp,
            ens = 0:1,
            time = c(6,12),
            forecast_time = "0000",
            lon = lons, lat = lats)

  ### Tests of object type
  expect_type(d, "list")
  expect_equal(names(d),
               c("forecast_date", "forecast_time", "dimensions", "data"))
  expect_equal(d$forecast_date, format(Sys.time(), "%Y%m%d"))
  expect_equal(d$forecast_time, "0000")
  expect_s3_class(d$data, "data.frame")

  ### Tests of indices
  expect_true(all(sort(unique(d$data$lon)) == sort(round(lons %% 360, 0))))
  expect_true(all(sort(unique(d$data$lat)) == sort(round(lats, 0))))

  ### Tests of data transformation from multidimensional array to data frame
  grid <- expand.grid(lon = round(lons %% 360, 0), lat = round(lats, 0),
                      ens  = 1:2, time = 1:2)

  expect_equal(nrow(d$data), nrow(grid))

  # NOTE: Remember that GEFS returns latitude in reverse order, i.e. -90:90

  # 2nd lon, all lats, 1st ens, 2nd time
  expect_true(all(d_raw$data[2,,1,2] == d$data[d$data$lon == lons[[2]] &
                                               d$data$ens == 0 &
                                               d$data$time2 == 1,][[temp]]))

  # All lons, last lat, 1st ens, 1st time
  expect_true(all(d_raw$data[,length(lats),1,2] == d$data[
    d$data$lat == round(sort(lats, decreasing = TRUE)[[length(lats)]]) &
    d$data$ens == 0 &
    d$data$time2 == 1,][[temp]]))

})

test_that("ens_idx and time_idx replace ens and time values", {
  skip_on_cran()
  skip_on_travis()
  skip_on_appveyor()
  skip_on_os("windows")

  d <- gefs(var = temp,
            ens = 0,
            time = 6,
            ens_idx = 1:2,
            forecast_time = "0000",
            lon = lons, lat = lats)
  expect_true(all(0:1 %in% unique(d$data$ens)))

  d <- gefs(var = temp,
            ens = 0,
            time = 6,
            time_idx = 3:4,
            forecast_time = "0000",
            lon = lons, lat = lats)
  expect_true(all(c(12,18) %in% unique(d$data$time2)))
})

test_that("gefs_variables returns characters.", {
  skip_on_cran()
  skip_on_travis()
  skip_on_appveyor()
  skip_on_os("windows")

  vars = gefs_variables()

  expect_is(vars, "character")
  expect_is(vars[1], "character")
})

test_that("gefs_latitudes returns numeric.", {
  skip_on_cran()
  skip_on_travis()
  skip_on_appveyor()
  skip_on_os("windows")

  lats = gefs_latitudes()
  expect_is(lats, "array")
  expect_is(lats[1], "numeric")
})

test_that("gefs_longitudes returns numeric.", {
  skip_on_cran()
  skip_on_travis()
  skip_on_appveyor()
  skip_on_os("windows")

  lons = gefs_longitudes()
  expect_is(lons, "array")
  expect_is(lons[1], "numeric")
})

test_that("gefs_dimensions returns character list.", {
  skip_on_cran()
  skip_on_travis()
  skip_on_appveyor()
  skip_on_os("windows")

  dims = gefs_dimensions()
  expect_is(dims, "character")
  expect_is(dims[1], "character")
})

test_that("gefs_dimension_values errors", {
  skip_on_os("windows")
  
  # FIXME: this doesn't error anymore, ask Potter
  # expect_error(gefs_dimension_values(dim = "time2", var = temp),
  #   "time2 is not in variable dimensions: lon, lat, height_above_ground, ens, time1.",
  #   fixed = TRUE)
  expect_error(gefs_dimension_values(),
    "dim cannot be NULL or missing.", fixed = TRUE)
  expect_error(gefs_dimension_values(dim = "ens1"),
    "ens1 is not a valid GEFS dimension. Check with 'gefs_dimensions()'.",
    fixed = TRUE)
})

test_that("gefs_dimension_values returns numeric array.", {
  skip_on_cran()
  skip_on_travis()
  skip_on_appveyor()
  skip_on_os("windows")

  vals = gefs_dimension_values("lat")
  expect_is(vals, "array")
  expect_is(vals[1], "numeric")
})
