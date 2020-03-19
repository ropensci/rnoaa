test_that("safe_read_csv",{
  expect_is(safe_read_csv, "function")
  expect_error(safe_read_csv())
  expect_error(safe_read_csv(5), "class")
  
  # file doesn't exist, throws warning on read.csv
  file1 <- tempfile()
  expect_error(safe_read_csv(file1), "No such file")

  # file empty
  file2 <- tempfile()
  file.create(file2)
  expect_error(safe_read_csv(file2), "malformed")

  # file with a single newline
  file3 <- tempfile()
  cat("\n", file = file3)
  expect_error(safe_read_csv(file3), "malformed")

  # cleanup
  invisible(lapply(c(file1, file2, file3), unlink))
})
