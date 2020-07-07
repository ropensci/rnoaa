context("vis_miss")

test_that("Valid ggplot object is produced",{
  skip_on_cran()
  skip_on_ci()

  monitors <- c("ASN00003003", "ASM00094299")
  weather_df <- suppressMessages(meteo_pull_monitors(monitors))
  out <- vis_miss(weather_df)

  expect_is(out, "ggplot")
})
