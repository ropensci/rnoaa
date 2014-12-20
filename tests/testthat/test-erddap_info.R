context("testing erddap_info")

a <- erddap_info('noaa_pfeg_696e_ec99_6fa6')
out <- erddap_search(query='temperature')
b <- erddap_info(out$info$dataset_id[5])

test_that("erddap_info returns the right classes", {
  expect_is(a, "erddap_info")
  expect_is(b, "erddap_info")

  expect_is(a$variables, "data.frame")
  expect_is(a$variables$data_type, "character")
})

test_that("erddap_info lat/long query returns correct results", {
  expect_equal(b$alldata$longitude$variable_name[1], "longitude")
})

test_that("erddap_info fails correctly", {
  expect_error(erddap_info(), "is missing, with no default")
  expect_error(erddap_info(datasetid = 'erdCalCOFIfshsi4'), "client error")
})
