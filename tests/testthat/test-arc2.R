context("arc2")

# delete any cached files
arc2_cache$delete_all()

test_that("arc2 returns the expected output", {
  skip_on_cran()
  skip_on_ci()
  skip_if_government_down()

  vcr::use_cassette("arc2_1", {
    arc2_result <- arc2(date = "1983-01-01")
  })

  expect_is(arc2_result, "list")
  expect_is(arc2_result[[1]], "tbl_df")
  expect_equal(names(arc2_result[[1]]), c("date", "lon", "lat", "precip"))
})

test_that("arc2 - many dates works", {
  skip_on_cran()
  skip_on_ci()
  skip_if_government_down()

  # vcr::use_cassette("arc2_many_dates", {
  bb <- arc2(date = c("1983-01-01", "1990-02-05"))
  # })

  expect_is(bb, "list")
  expect_equal(length(bb), 2)
  expect_is(bb[[1]], "tbl_df")
  expect_is(bb[[2]], "tbl_df")
  expect_equal(names(bb[[1]]), c("date", "lon", "lat", "precip"))
  expect_equal(names(bb[[2]]), c("date", "lon", "lat", "precip"))
})

test_that("arc2 - bounding box works", {
  skip_on_cran()
  skip_on_ci()
  skip_if_government_down()

  arc2_cache$delete_all()

  vcr::use_cassette("arc2_bounding_box", {
    box <- c(xmin = 9, ymin = 4, xmax = 10, ymax = 5)
    cc <- suppressWarnings(arc2(date = c("1983-01-01", "1990-02-05"), box = box))
  })

  expect_is(cc, "list")
  expect_equal(length(cc), 2)
  expect_is(cc[[1]], "tbl_df")
  expect_is(cc[[2]], "tbl_df")
  expect_equal(names(cc[[1]]), c("date", "lon", "lat", "precip"))
  expect_equal(names(cc[[2]]), c("date", "lon", "lat", "precip"))
  expect_gte(min(cc[[1]]$lon), 9)
  expect_lte(max(cc[[1]]$lon), 10)
  expect_gte(min(cc[[1]]$lat), 4)
  expect_lte(max(cc[[1]]$lat), 5)
  expect_gte(min(cc[[2]]$lon), 9)
  expect_lte(max(cc[[2]]$lon), 10)
  expect_gte(min(cc[[2]]$lat), 4)
  expect_lte(max(cc[[2]]$lat), 5)
})

test_that("arc2 fails with appropriate error messages", {
  skip_on_cran()

  expect_error(arc2(date = 19830101), "must be of class character, Date")
  expect_error(arc2(date = "1978-01-01"),
    paste0("must be between 1979 and ", format(Sys.Date(), "%Y")))
  expect_error(arc2(date = "1983-13-01"), "must be between 1 and 12")
  expect_error(arc2(date = "1983-01-32"), "must be between 1 and 31")
})

# delete any cached files
arc2_cache$delete_all()

