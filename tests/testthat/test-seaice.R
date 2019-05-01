test_that("seaice", {
  skip_on_cran()
  skip_on_travis()

  url <- seaiceeurls(yr = 1980, mo = 'Feb', pole = 'S')
  out <- seaice(url)

  expect_is(url, "character")
  expect_match(url, "ftp")

  expect_is(out, "data.frame")
  expect_is(out$long, "numeric")
})

test_that("seaice_tabular", {
  skip_on_cran()
  skip_on_travis()

  out <- seaice_tabular()

  expect_is(seaice_tabular, "function")
  expect_is(out, "data.frame")
  expect_is(out$year, "integer")
  expect_is(out$mo, "integer")
  expect_is(out$data.type, "character")
  expect_is(out$region, "character")
  expect_is(out$extent, "numeric")
  expect_is(out$area, "numeric")
})

