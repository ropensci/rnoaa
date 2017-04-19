#' NEXRAD II data
#'
#' @export
#' @param year xx
#' @param month xx
#' @param day xx
#' @param station xx
#' @param filename xx
#' @param path xx
#' @param ... curl options
#' @details
#' xx
#' @return data.frame
#' @examples \dontrun{
#' f <- tempfile(fileext = ".zip")
#' nexrad2(2017, 4, 1, 'KAMX', 'KAMX20170401_002500_V06', f)
#' }
nexrad2 <- function(year, month, day, station, filename, path, ...) {
  url <- file.path(nexs3base(), year, add0(month), add0(day), station, filename)
  res <- httr::GET(url, write_disk(path, TRUE), httr::verbose())
}

nexs3base <- function() 'https://noaa-nexrad-level2.s3.amazonaws.com'
# /<Year>/<Month>/<Day>/<NEXRAD Station>/<filename>
# filename format: GGGGYYYYMMDD_TTTTTT
# https://noaa-nexrad-level2.s3.amazonaws.com/2017/04/01/KAMX/KAMX20170401_002500_V06

add0 <- function(x) if (nchar(x) == 1) paste0("0", x) else x
