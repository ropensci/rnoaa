context("arc2")

test_that("arc2 returns the expected output", {
  skip_on_cran()
  skip_if_government_down()
      
  arc2_result <- arc2(date = "1983-01-01")
  expect_is(arc2_result, "tbl_df")
  expect_equal(names(arc2_result), c("lon", "lat", "precip"))
})

test_that("arc2 fails with appropriate error messages", {
  expect_error(arc2(date = 19830101), "must be of class character, Date")
  expect_error(arc2(date = "1978-01-01"), 
    paste0("must be between 1979 and ", format(Sys.Date(), "%Y")))
  expect_error(arc2(date = "1983-13-01"), "must be between 1 and 12")
  expect_error(arc2(date = "1983-01-32"), "must be between 1 and 31")
})
