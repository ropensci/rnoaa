context("testing erddap_table")

a <- erddap_table('erdCalCOFIfshsiz')
a_mem <- erddap_table('erdCalCOFIfshsiz', store = memory())
b <- erddap_table(x='erdCalCOFIfshsiz', fields = c('latitude','longitude','scientific_name'),
                  'latitude>=34.8', 'latitude<=35', 'longitude>=-125', 'longitude<=-124')
c <- erddap_info('erdCalCOFIlrvsiz')$variables
  
test_that("erddap_table returns the right classes", {
  expect_is(a, c("erddap_table","data.frame"))
  expect_is(b, c("erddap_table","data.frame"))
  expect_is(c, "data.frame")
  
  expect_is(a$tow_type, "character")
})

test_that("erddap_table lat/long query returns correct results", {
  lat <- as.numeric(b$latitude)
  expect_less_than(34.8, min(lat))
  expect_less_than(max(lat), 35)
  expect_equal(names(c), c('variable_name','data_type','actual_range'))
})

test_that("erddap_table variables returned are correct", {
  expect_equal(c$variable_name[[1]], "calcofi_species_code")
  expect_equal(names(c), c('variable_name','data_type','actual_range'))
})

test_that("erddap_table memory and disk give the same results", {
  expect_equal(a_mem$cruise, a$cruise)
})

test_that("erddap_table fails correctly", {
  # x param missing
  expect_error(erddap_table(), "is missing, with no default")
  # dataset id not found
  expect_error(erddap_table(x = 'erdCalCOFIfshsi4'), "client error")
  # field name not found
  expect_warning(erddap_table('erdCAMarCatSM', fields = "adf"), "incomplete final line")
})
