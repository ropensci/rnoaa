context("swdi")

valid_dataset <- function(dataset_name) {
  dataset <- swdi(dataset= dataset_name, startdate='20060505', enddate='20060506')
  expect_is(dataset$meta$totalCount, "numeric")
  expect_is(dataset$meta$totalTimeInSeconds, "numeric")
  expect_is(dataset$data, "data.frame")
  expect_is(dataset$shape, "data.frame")
}

test_that("each data set is accessible", {
  valid_dataset('nx3tvs')
  valid_dataset('nx3meso')
  valid_dataset('nx3hail')
  valid_dataset('nx3structure')
  valid_dataset('plsr')
  valid_dataset('warn')


})

test_that("correct data range is returned", {

})


test_that("Box co-ordinates return correctly", {

})

test_that("Radius co-ordinates return correctly", {

})
