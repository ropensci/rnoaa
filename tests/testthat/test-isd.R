context("isd")

test_that("list stations", {
  skip_on_cran()
  
  aa <- isd_stations()

  expect_is(aa, "data.frame")
  expect_is(aa$usaf, "integer")
  
  expect_equal(NCOL(aa), 11)
})

test_that("get data", {
  skip_on_cran()
     
  data_a <- suppressMessages(isd(usaf = "011490", wban = "99999", year = 1986))
  data_b <- suppressMessages(isd(usaf = "011490", wban = "99999", year = 1985))
  
  expect_is(data_a, "isd")
  expect_is(data_a$data, "data.frame")
  expect_is(data_a$data$latitude, "integer")
  expect_is(data_a$data$quality, "character")
  
  expect_less_than(NROW(data_a$data), NROW(data_b$data))
})
