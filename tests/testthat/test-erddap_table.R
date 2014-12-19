context("testing erddap_table")

a <- erddap_table('erdCalCOFIfshsiz')
b <- erddap_table('erdCalCOFIfshsiz', 'time>=2001-07-07', 'time<=2001-07-08')
c <- erddap_info('erdCalCOFIlrvsiz')$variables
d <- erddap_table("erdCAMarCatSM", fields = c('fish','landings','year'))
  
test_that("erddap_table returns the right classes", {
  expect_is(a, c("erddap_table","data.frame"))
  expect_is(b, c("erddap_table","data.frame"))
  expect_is(c, "data.frame")
  expect_is(d, c("erddap_table","data.frame"))
  
  expect_is(a$tow_type, "character")
  expect_is(d$landings, "character")
})

test_that("erddap_table fails correctly", {
  # x param missing
  expect_error(erddap_table(), "is missing, with no default")
  # dataset id not found
  expect_error(erddap_table(x = 'erdCalCOFIfshsi4'), "client error")
  # field name not found
  expect_error(erddap_table('erdCAMarCatSM', fields = "adf"), "Unrecognized variable=adf")
})
