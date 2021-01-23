context("ghcnd")

test_that("states metadata", {
  skip_on_cran()
  vcr::use_cassette("ghcnd_states", {  
    states <- ghcnd_states()

    expect_is(states, "data.frame")
    expect_is(states$code, "character")
    expect_is(states$name, "character")

    expect_equal(NCOL(states), 2)
  })
})

test_that("countries metadata", {
  skip_on_cran()
  vcr::use_cassette("ghcnd_countries", {  
    countries <- ghcnd_countries()

    expect_is(countries, "data.frame")
    expect_is(countries$code, "character")
    expect_is(countries$name, "character")

    expect_equal(NCOL(countries), 2)
  })
})

test_that("version metadata", {
  skip_on_cran()
  vcr::use_cassette("ghcnd_version", {  
    ver <- ghcnd_version()

    expect_is(ver, "character")
    expect_gt(nchar(ver), 200)
  })
})

test_that("search for data", {
  skip_on_cran()
  skip_on_ci()
  skip_if_government_down()
  
  stations <- sort(c("ACW00011604", "ACW00011647", "AE000041196", "AGE00147704"))
  
  search_a <- ghcnd_search("AGE00147704", var = "PRCP")
  search_b <- ghcnd_search("AGE00147704", var = "PRCP", date_min = "1920-01-01")
  search_c <- ghcnd_search("AGE00147704", var = "PRCP", date_min = "1920-01-01", date_max = "1925-01-01")
  search_d <- ghcnd_search("AGE00147704", var = c("PRCP","TMIN"), date_min = "1920-01-01")
  search_vector <- ghcnd_search(stations, var = "PRCP")
  
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
  
  expect_equal(sort(unique(search_vector$prcp$id)), stations)
  expect_equal(search_a$prcp, search_vector$prcp[search_vector$prcp$id == "AGE00147704", ])
})



test_that("get data", {
  skip_on_cran()
  skip_on_ci()
  skip_if_government_down()

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


test_that("bad station ids", {
  skip_on_cran()
  skip_on_ci()
  skip_if_government_down()

  aa <- ghcnd(stationid = c("badid", "anotherbadid"))

  expect_is(aa, "tbl_df")
  expect_equal(NROW(aa), 0)
  expect_equal(attr(aa, "source"), c("", ""))
  expect_equal(attr(aa, "file_modified"), c("", ""))
})


test_that("ghncd accepts vector input", {
  skip_on_cran()
  skip_on_ci()
  skip_if_government_down()
  
  stations <- c("ACW00011604", "ACW00011647", "AE000041196")
  data <- ghcnd(stations)
  
  expect_is(data, "tbl_df")
  expect_equal(unique(data$id), stations)
  
})

test_that("meteo_tidy_ghcnd accepts vector input", {
  skip_on_cran()
  stations <- c("ACW00011604", "ACW00011647", "AE000041196")
  data <- meteo_tidy_ghcnd(stations)
  
  expect_is(data, "tbl_df")
  expect_is(data, "data.frame")
  expect_equal(unique(data$id), stations)
})
          


test_that("alternative base urls", {
  skip_on_cran()
  expect_equal(Sys.getenv("RNOAA_GHCND_BASE_URL"), "")

  Sys.setenv(RNOAA_GHCND_BASE_URL = "https://google.com")
  expect_error(ghcnd("ASN00008179"), "must be in set")

  Sys.unsetenv("RNOAA_GHCND_BASE_URL")
})



