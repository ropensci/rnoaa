context("ncdc_locs")

test_that("ncdc_locs returns the correct class", {
  skip_on_cran()

  vcr::use_cassette("ncdc_locs", {
    tt <- ncdc_locs(datasetid='NORMAL_DLY', startdate='20100101')
    uu <- ncdc_locs(locationcategoryid='ST', limit=52)
    
    # class
    expect_is(tt, "ncdc_locs")
    expect_is(uu, "ncdc_locs")
    expect_is(tt$meta, "list")
    expect_is(tt$data, "data.frame")
    expect_is(tt$meta$totalCount, "integer")
    expect_is(tt$data$mindate, "character")

    # dimensions
    expect_equal(length(tt$meta), 3)
    expect_equal(dim(tt$data), c(25,5))
    expect_equal(NCOL(uu$data), 5)
    expect_equal(length(tt), 2)
    expect_equal(length(uu), 2)
  })
})
