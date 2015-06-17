context("ncdc_legacy")

test_that("basic functionality works", {
  skip_on_cran()
  
  res <- ncdc_leg_data('isd', 71238099999, 'TMP', 200101010000, 200101312359)
  
  expect_is(res, "data.frame")
  expect_equal(unique(res$V12), "null")
})
