context("coops")

test_that("coops works", {
  skip_on_cran()
  skip_on_travis()
  skip_on_appveyor()

  aa <- coops_search(station_name = 8723970, begin_date = 20140927, end_date = 20140928, product = "water_temperature")

  # class
  expect_is(aa$data, "data.frame")
  expect_is(aa$metadata$name, "character")

  # dimensions
  expect_equal(NCOL(aa$data), 3)
})

test_that("coops fails well", {
  skip_on_cran()
  skip_on_travis()
  skip_on_appveyor()

  expect_error(coops_search(), "argument \"product\" is missing, with no default")
})

test_that("coops fails well", {
  skip_on_cran()
  skip_on_travis()
  skip_on_appveyor()

  expect_error(coops_search(), "argument \"product\" is missing, with no default")
  expect_error(coops_search(station_name = 8775244, begin_date = 20140927, end_date = 20140928, product = "air_temperature"), "No data was found")

})

test_that("coops fails well", {
  skip_on_cran()
  skip_on_travis()
  skip_on_appveyor()

  expect_error(coops_search(station_name = 8775244, begin_date = 20140927, end_date = 20140928, product = "monthly_mean"), "Must specify a datum for water level products")

})

test_that("coops fails well", {
  skip_on_cran()
  skip_on_travis()
  skip_on_appveyor()

  expect_error(
    coops_search(station_name = 8724580, begin_date = 20040927,
                 end_date = 20140928, product = "high_low", datum = "stnd"),
    "The maximum duration the NOAA API"
  )
})

test_that("coops fails well", {
  skip_on_cran()
  skip_on_travis()
  skip_on_appveyor()

  expect_error(
    coops_search(station_name = "ps0401", begin_date = 20151121,
                 end_date = 20151231, product = "currents"),
    "The maximum duration the NOAA API"
  )
})
