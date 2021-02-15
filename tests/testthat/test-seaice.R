test_that("seaiceurls", {
  skip_on_cran()
  skip_on_ci()

  url <- seaiceeurls(yr = 1980, mo = 'Feb', pole = 'S')
  expect_is(url, "character")
  expect_match(url, "ftp")
})

test_that("sea_ice", {
  skip_on_cran()
  skip_on_ci()

  # single
  out <- sea_ice(year = 1990, month = "Apr", pole = "N")
  expect_is(out, "list")
  expect_equal(length(out), 1)
  expect_is(out[[1]], "data.frame")
  expect_is(out[[1]]$long, "numeric")

  # many
  out <- sea_ice(year = 2010, month = "Jun")
  expect_is(out, "list")
  expect_equal(length(out), 2)
  expect_is(out[[1]], "data.frame")
  expect_is(out[[1]]$long, "numeric")
  expect_is(out[[2]], "data.frame")
  expect_is(out[[2]]$long, "numeric")

  # single - geotiff - extent
  out <- sea_ice(year = 2001, month = "Mar", pole = "S",
    format = "geotiff-extent")
  expect_is(out, "list")
  expect_equal(length(out), 1)
  expect_is(out[[1]], "RasterLayer")

  # single - geotiff - concentration
  out <- sea_ice(year = 2001, month = "Mar", pole = "S",
    format = "geotiff-conc")
  expect_is(out, "list")
  expect_equal(length(out), 1)
  expect_is(out[[1]], "RasterLayer")
})

test_that("sea_ice fails well", {
  expect_error(sea_ice("foobar"), "year must be of class", class="error")
  expect_error(sea_ice(month = 5), "month must be of class", class="error")
  expect_error(sea_ice(pole = 5), "pole must be of class", class="error")
  expect_error(sea_ice(format = 5), "format must be of class", class="error")
  expect_error(sea_ice(format = "foo"), "'format' must be one of", class="error")
})

test_that("sea_ice_tabular", {
  skip_on_cran()
  skip_on_ci()

  out <- sea_ice_tabular()

  expect_is(sea_ice_tabular, "function")
  expect_is(out, "data.frame")
  expect_is(out$year, "integer")
  expect_is(out$mo, "integer")
  expect_is(out$data.type, "character")
  expect_is(out$region, "character")
  expect_is(out$extent, "numeric")
  expect_is(out$area, "numeric")
})
