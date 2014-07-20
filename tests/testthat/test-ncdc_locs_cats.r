context("ncdc_locs_cats")

key='YZJVDgzurxvMqiIcfpzrOozpRBVvTBhE'

Sys.sleep(time = 0.5)
tt <- ncdc_locs_cats(token=key)
Sys.sleep(time = 0.5)
uu <- ncdc_locs_cats(locationcategoryid='CLIM_REG', token=key)
Sys.sleep(time = 0.5)
vv <- ncdc_locs_cats(startdate='1970-01-01', token=key)

test_that("ncdc_locs_cats returns the correct class", {
  expect_is(tt, "ncdc_locs_cats")
  expect_is(uu$data, "data.frame")
  expect_is(vv, "ncdc_locs_cats")
  expect_is(tt$meta, "list")
  expect_is(tt$data, "data.frame")
  expect_is(tt$meta$totalCount, "numeric")
  expect_is(tt$data$id, "character")
})

test_that("ncdc_locs_cats returns the correct dimensions", {
  expect_equal(length(tt$meta), 3)
  expect_equal(dim(tt$data), c(11,2))
  expect_equal(dim(uu$data), c(1,2))
  expect_equal(dim(vv$data), c(11,2))
  expect_equal(length(tt), 2)
  expect_equal(length(uu), 2)
  expect_equal(length(vv), 2)
})
