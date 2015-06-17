context("ncdc_datacats")

test_that("ncdc_datacats returns the correct ...", {
  skip_on_cran()
  
  Sys.sleep(time = 0.5)
  tt <- ncdc_datacats()
  Sys.sleep(time = 0.5)
  uu <- ncdc_datacats(datacategoryid="ANNAGR")
  
  # class
  expect_is(tt, "ncdc_datacats")
  expect_is(tt$data, "data.frame")
  expect_is(tt$data$name, "character")
  expect_is(uu$data, "data.frame")
  expect_is(uu$data$name, "character")
  
  # dimensions
  expect_equal(dim(tt$data), c(25,2))
  expect_equal(length(tt$data$id), 25)
  expect_equal(dim(uu$data), c(1,2))
  expect_equal(dim(uu[[1]]), NULL)
})
