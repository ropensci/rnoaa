context("seaice")

test_that("seaice functions work", {
  skip_on_cran()
  skip_on_travis()

  url <- seaiceeurls(1980, mo = 'Feb', pole = 'S')
  out <- seaice(url)

  expect_is(url, "character")
  expect_match(url, "ftp")

  expect_is(out, "data.frame")
  expect_is(out$long, "numeric")
})
