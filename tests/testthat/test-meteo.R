context("meteo")

test_that("search for multi-monitor data", {
  skip_on_cran()
  skip_on_ci()
  skip_if_government_down()

  monitors <- c("ASN00003003", "ASM00094299")
  search_a <- meteo_pull_monitors(monitors)
  search_b <- meteo_pull_monitors(monitors, var = "PRCP")

  expect_is(search_a, "data.frame")
  expect_is(search_a$prcp, "numeric")
})

test_that("determine monitors' data coverage", {
  skip_on_cran()
  skip_on_ci()
  skip_if_government_down()

  monitors <- c("ASN00003003", "ASM00094299")
  search_a <- meteo_pull_monitors(monitors)
  obs_covr <- meteo_coverage(search_a)

  expect_is(obs_covr, "list")
  expect_is(obs_covr[[1]]$start_date, "Date")
  expect_is(obs_covr[[1]]$total_obs, "integer")
  expect_is(obs_covr[[1]]$prcp, "numeric")
  
  expect_equal(NROW(obs_covr[[1]]), length(monitors))
  
  expect_is(obs_covr[[2]]$date, "Date")
  expect_is(obs_covr[[2]]$id, "character")
  expect_is(obs_covr[[2]]$prcp, "numeric")
})
