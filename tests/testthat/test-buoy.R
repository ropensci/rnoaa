context("buoy")

test_that("buoys works", {
  skip_on_cran()
  skip_on_ci()

  vcr::use_cassette("buoys", {
    aa <- buoys(dataset = 'cwind')
  })

  # class
  expect_is(aa, "data.frame")
  expect_is(aa$id, "character")

  # dimensions
  expect_equal(NCOL(aa), 2)
})

test_that("buoys fails well", {
  skip_on_cran()
  skip_on_ci()

  expect_error(buoys(), "argument \"dataset\" is missing")
})

test_that("buoy works", {
  skip_on_cran()
  skip_on_ci()

  vcr::use_cassette("buoy_disk", {
    one <- buoy(dataset = 'cwind', buoyid = 41001, year = 1997, datatype = "c")
  })

  # class
  expect_is(one, "buoy")
  expect_is(unclass(one), "list")
  expect_is(one$meta, "list") 
  expect_is(one$data, "data.frame")

  # dimensions
  expect_equal(length(one), 2)
})

test_that("buoy works with character buoy ids", {
  skip_on_cran()
  skip_on_ci()

  vcr::use_cassette("buoy_buoyid_param", {
    aa <- buoy(dataset = "stdmet", buoyid = "wplf1")
  })

  expect_is(aa, "buoy")
  expect_is(unclass(aa), "list")
  expect_is(aa$meta, "list")
  expect_is(aa$data, "data.frame")
  expect_equal(length(aa), 2)
})

test_that("buoy works regardless of buoyid case", {
  skip_on_cran()
  skip_on_ci()

  vcr::use_cassette("buoy_buoyid_case", {
    aa <- buoy(dataset = "stdmet", buoyid = "vcaf1")
    bb <- buoy(dataset = "stdmet", buoyid = "VCAF1")
  })

  expect_identical(aa, bb)
})

test_that("buoys fails well", {
  skip_on_cran()
  skip_on_ci()

  expect_error(buoy(), "argument \"dataset\" is missing")

  # failure is actually caught from the buoys() call, not the buoy() call
  vcr::use_cassette("buoy_fail_well", {
    expect_error(buoy(dataset = 'ocean', buoyid = 41012),
      "No data files found")
  })
})


test_that("buoy works as expected with buoy id's without lat/lon data", {
  skip_on_cran()
  skip_on_ci()

  vcr::use_cassette("buoy_buoyid_no_latlon", {
    nn <- suppressWarnings(buoy(dataset='adcp2', buoyid=46081))
  })

  expect_is(nn, "buoy")
  expect_is(nn$data, "data.frame")
  expect_equal(NROW(nn$data), 0)
  expect_is(nn$meta, "ncdf4")
})
