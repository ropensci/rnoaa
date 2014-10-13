trunc_mat <- function(x, n = NULL){
  rows <- nrow(x)
  if (!is.na(rows) && rows == 0)
    return()
  if (is.null(n)) {
    if (is.na(rows) || rows > 100) { n <- 10 }
    else { n <- rows }
  }
  df <- as.data.frame(head(x, n))
  if (nrow(df) == 0)
    return()
  #   is_list <- vapply(df, is.list, logical(1))
  #   df[is_list] <- lapply(df[is_list], function(x) vapply(x, obj_type, character(1)))
  mat <- format(df, justify = "left")
  width <- getOption("width")
  values <- c(format(rownames(mat))[[1]], unlist(mat[1, ]))
  names <- c("", colnames(mat))
  w <- pmax(nchar(values), nchar(names))
  cumw <- cumsum(w + 1)
  too_wide <- cumw[-1] > width
  if (all(too_wide)) {
    too_wide[1] <- FALSE
    df[[1]] <- substr(df[[1]], 1, width)
  }
  shrunk <- format(df[, !too_wide, drop = FALSE])
  needs_dots <- is.na(rows) || rows > n
  if (needs_dots) {
    dot_width <- pmin(w[-1][!too_wide], 3)
    dots <- vapply(dot_width, function(i) paste(rep(".", i), collapse = ""), FUN.VALUE = character(1))
    shrunk <- rbind(shrunk, .. = dots)
  }
  print(shrunk)
  if (any(too_wide)) {
    vars <- colnames(mat)[too_wide]
    types <- vapply(df[too_wide], type_sum, character(1))
    var_types <- paste0(vars, " (", types, ")", collapse = ", ")
    cat(noaa_wrap("Variables not shown: ", var_types), "\n", sep = "")
  }
}

noaa_wrap <- function (..., indent = 0, width = getOption("width")){
  x <- paste0(..., collapse = "")
  wrapped <- strwrap(x, indent = indent, exdent = indent + 5, width = width)
  paste0(wrapped, collapse = "\n")
}

#' Type summary
#' @export
#' @keywords internal
type_sum <- function (x) UseMethod("type_sum")

#' @method type_sum default
#' @export
#' @rdname type_sum
type_sum.default <- function (x) unname(abbreviate(class(x)[1], 4))

#' @method type_sum character
#' @export
#' @rdname type_sum
type_sum.character <- function (x) "chr"

#' @method type_sum Date
#' @export
#' @rdname type_sum
type_sum.Date <- function (x) "date"

#' @method type_sum factor
#' @export
#' @rdname type_sum
type_sum.factor <- function (x) "fctr"  

#' @method type_sum integer
#' @export
#' @rdname type_sum
type_sum.integer <- function (x) "int"

#' @method type_sum logical
#' @export
#' @rdname type_sum
type_sum.logical <- function (x) "lgl"

#' @method type_sum array
#' @export
#' @rdname type_sum
type_sum.array <- function (x){
  paste0(NextMethod(), "[", paste0(dim(x), collapse = ","), 
         "]")
}

#' @method type_sum matrix
#' @export
#' @rdname type_sum
type_sum.matrix <- function (x){
  paste0(NextMethod(), "[", paste0(dim(x), collapse = ","),
         "]")
}

#' @method type_sum numeric
#' @export
#' @rdname type_sum
type_sum.numeric <- function (x) "dbl"

#' @method type_sum POSIXt
#' @export
#' @rdname type_sum
type_sum.POSIXt <- function (x) "time"

obj_type <- function (x)
{
  if (!is.object(x)) {
    paste0("<", type_sum(x), if (!is.array(x))
      paste0("[", length(x), "]"), ">")
  }
  else if (!isS4(x)) {
    paste0("<S3:", paste0(class(x), collapse = ", "), ">")
  }
  else {
    paste0("<S4:", paste0(is(x), collapse = ", "), ">")
  }
}
