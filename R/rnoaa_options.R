roenv <- new.env()
roenv$cache_messages <- TRUE

#' rnoaa options
#' @export
#' @param cache_messages (logical) whether to emit messages with information
#' on caching status for function calls that can cache data. default: `TRUE`
#' @details rnoaa package level options; stored in an internal
#' package environment `roenv`
#' @seealso [rnoaa_caching] for managing cached files
#' @examples \dontrun{
#' rnoaa_options(cache_messages = FALSE)
#' }
rnoaa_options <- function(cache_messages = TRUE) {
  roenv$cache_messages <- cache_messages
  return(NULL)
}

stract <- function(str, pattern) regmatches(str, regexpr(pattern, str))

cache_mssg <- function(file) {
  if (roenv$cache_messages) {
    fi <- file.info(file)
    if (NROW(fi) > 1) {
      message("in directory: ", dirname(file[1]))
      to_get <- min(c(3, length(file)))
      ss <- file[seq_len(to_get)]
      ss_str <- paste0(basename(ss), collapse = ", ")
      if (to_get < length(file)) ss_str <- paste0(ss_str, " ...")
      message("using cached files (first 3): ", ss_str)
      message(
        sprintf("[%s] date created: %s",
          basename(row.names(fi)[1]), fi[1,"ctime"]))
    } else {
      if (!fi$isdir) {
        size <- round(fi$size/1000000, 3)
        chaftdec <- nchar(stract(as.character(size), '^[0-9]+'))
        if (chaftdec > 1) size <- round(size, 1)
        message("using cached file: ", file)
        message(
          sprintf("date created (size, mb): %s (%s)", fi$ctime, size))
      } else {
        message("using cached directory: ", file)
        message(
          sprintf("date created: %s", fi$ctime))
      }
    }
  }
}
