context("buoy")

test_that("buoys works", {
  skip_on_cran()
  
  aa <- buoys(dataset = 'cwind')
  
  # class
  expect_is(aa, "data.frame")
  expect_is(aa$id, "character")
  
  # dimensions
  expect_equal(NCOL(aa), 2)
})  

test_that("buoys fails well", {
  skip_on_cran()
  
  expect_error(buoys(), "argument \"dataset\" is missing")
})

test_that("buoy works", {
  skip_on_cran()
  
  one <- buoy(dataset = 'cwind', buoyid = 41001, year = 2008, datatype = "cc")
  
  # class
  expect_is(one, "buoy")
  expect_is(unclass(one), "list")
  expect_is(one$meta, "list")
  expect_is(one$data, "data.frame")
  
  # dimensions
  expect_equal(length(one), 2)
})

test_that("buoys fails well", {
  skip_on_cran()
  
  expect_error(buoy(), "argument \"dataset\" is missing")
  expect_error(buoy(dataset = 'ocean', buoyid = 41012), "No data files found")
})
