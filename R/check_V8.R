# check for V8
check4v8 <- function() {
  if (!requireNamespace("V8", quietly = TRUE)) {
    stop("Please install V8", call. = FALSE)
  } else {
    invisible(TRUE)
  }
}
