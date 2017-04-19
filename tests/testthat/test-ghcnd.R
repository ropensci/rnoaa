context("ghcnd")

test_that("states metadata", {
  skip_on_cran()

  states <- ghcnd_states()

  expect_is(states, "data.frame")
  expect_is(states$code, "character")
  expect_is(states$name, "character")

  expect_equal(NCOL(states), 2)
})

test_that("countries metadata", {
  skip_on_cran()

  countries <- ghcnd_countries()

  expect_is(countries, "data.frame")
  expect_is(countries$code, "character")
  expect_is(countries$name, "character")

  expect_equal(NCOL(countries), 2)
})

test_that("version metadata", {
  skip_on_cran()

  ver <- ghcnd_version()

  expect_is(ver, "character")
  expect_gt(nchar(ver), 200)
})

test_that("search for data", {
  skip_on_cran()

  search_a <- ghcnd_search("AGE00147704", var = "PRCP")
  search_b <- ghcnd_search("AGE00147704", var = "PRCP", date_min = "1920-01-01")
  search_c <- ghcnd_search("AGE00147704", var = "PRCP", date_min = "1920-01-01", date_max = "1925-01-01")
  search_d <- ghcnd_search("AGE00147704", var = c("PRCP","TMIN"), date_min = "1920-01-01")

  expect_is(search_a, "list")
  expect_is(search_a$prcp, "tbl_df")
  expect_is(search_b$prcp, "data.frame")
  expect_is(search_c$prcp, "data.frame")
  expect_is(search_d$prcp, "data.frame")

  expect_named(search_a, "prcp")
  expect_named(search_b, "prcp")
  expect_named(search_c, "prcp")
  expect_named(search_d, c("prcp", "tmin"))

  expect_lt(NROW(search_b$prcp), NROW(search_a$prcp))
})

test_that("get data", {
  skip_on_cran()

  aa <- ghcnd(stationid = "AGE00147704")
  bb <- ghcnd(stationid = "AGE00135039")
  cc <- ghcnd(stationid = "ASN00008264")

  expect_is(aa, "tbl_df")
  expect_is(bb, "tbl_df")
  expect_is(cc, "tbl_df")

  expect_is(aa, "data.frame")
  expect_is(bb, "data.frame")
  expect_is(cc, "data.frame")

  expect_is(aa$id, "character")
  expect_is(aa$year, "integer")
  expect_is(aa$month, "integer")
  expect_is(aa$element, "character")
  expect_is(aa$VALUE1, "integer")
  expect_is(aa$MFLAG1, "character")
  expect_is(aa$QFLAG1, "character")
  expect_is(aa$SFLAG1, "character")

  expect_lt(NROW(cc), NROW(aa))
  expect_lt(NROW(aa), NROW(bb))
  expect_lt(NROW(cc), NROW(bb))
})
