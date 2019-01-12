context("meteo")

test_that("search for multi-monitor data", {
  skip_on_cran()
  skip_on_travis()
  skip_if_government_down()

  monitors <- c("ASN00003003", "ASM00094299")
  search_a <- meteo_pull_monitors(monitors)
  search_b <- meteo_pull_monitors(monitors, var = "PRCP")

  expect_is(search_a, "data.frame")
  expect_is(search_a$prcp, "numeric")
})

test_that("determine monitors' data coverage", {
  skip_on_cran()
  skip_on_travis()
  skip_if_government_down()

  monitors <- c("ASN00003003", "ASM00094299")
  search_a <- meteo_pull_monitors(monitors)
  obs_covr <- meteo_coverage(search_a)

  expect_is(obs_covr, "data.frame")
  expect_is(obs_covr$start_date, "Date")
  expect_is(obs_covr$total_obs, "integer")
  expect_is(obs_covr$prcp, "numeric")

  expect_equal(NROW(obs_covr), length(monitors))
})
