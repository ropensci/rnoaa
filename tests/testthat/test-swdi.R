context("swdi")

get_cordinates_df <- function(swdi_output) {
  swdi_output$shape %>%
    dplyr::mutate(shape = sub(".*POINT.*\\(","",shape)) %>%
    dplyr::mutate(shape = sub(")","",shape)) %>%
    tidyr::separate(shape, c("lon", "lat"), sep = " ") %>%
    dplyr::mutate(lat = as.numeric(lat), lon = as.numeric(lon))
}

valid_dataset <- function(dataset_name) {
  out <- swdi(dataset= dataset_name, startdate='20060505', enddate='20060506')
  expect_is(out$meta$totalCount, "numeric")
  expect_is(out$meta$totalTimeInSeconds, "numeric")
  expect_is(out$data, "data.frame")
  expect_is(out$shape, "data.frame")
}

test_that("Each data set is accessible", {
  vcr::use_cassette("swdi_accessible", {
    valid_dataset('nx3tvs')
    valid_dataset('nx3meso')
    # valid_dataset('nx3hail')
    # valid_dataset('nx3structure')
    # valid_dataset('plsr')
    valid_dataset('warn')
  })
})

# test_that("Correct date range is returned", {
#   skip_on_cran()
#
#   startdate <- lubridate::as_datetime('2006-05-05')
#   enddate <- lubridate::as_datetime('2006-05-06')
#   swdi_startdate <-  stringi::stri_datetime_format(startdate, format = "uuuuMMdd")
#   swdi_enddate <-  stringi::stri_datetime_format(enddate, format = "uuuuMMdd")
#
#
#   out <- swdi(dataset = 'nx3tvs', startdate = swdi_startdate, enddate = swdi_enddate)
#
#   expect_true(lubridate::as_datetime(min(out$data$ztime)) >=  startdate)
#   expect_true(lubridate::as_datetime(max(out$data$ztime)) <=  enddate)
# })


test_that("Box co-ordinates return correctly", {
  vcr::use_cassette("swdi_bbox", {
    bbox <- c(-91,30,-90,31)

    out <- swdi(dataset='plsr', startdate='20060505', 
      enddate='20060510', bbox = bbox)

    coordinates <- get_cordinates_df(out)

    expect_lt(bbox[1], min(coordinates$lon))
    expect_gt(bbox[3], max(coordinates$lon))

    expect_lt(bbox[2], min(coordinates$lat))
    expect_gt(bbox[4], max(coordinates$lat))
  })
})

# test_that("Radius coordinates return correctly", {
#   skip_on_cran()
#   radius <- 15
#   center <- c(-102.0,32.7)
#   out <- swdi(dataset='nx3tvs', startdate='20060506', enddate='20060507',
#               radius=radius, center=center)
#   coordinates <- get_cordinates_df(out)
#   coordinates$distance <- meteo_spherical_distance(lat1=center[2], long1=center[1], lat2=coordinates[2][[1]], long2=coordinates[1][[1]])
#
#   expect_true(Reduce("&",coordinates$distance < radius * 1.609344))
# })
