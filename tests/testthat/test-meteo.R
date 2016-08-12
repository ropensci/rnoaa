context("meteo")

test_that("search for multi-monitor data", {
  skip_on_cran()

  monitors <- c("ASN00003003", "ASM00094299")
  search_a <- meteo_pull_monitors(monitors)
  search_b <- meteo_pull_monitors(monitors, var = "PRCP")

  expect_is(search_a, "data.frame")
  expect_is(search_a$prcp, "numeric")
})
