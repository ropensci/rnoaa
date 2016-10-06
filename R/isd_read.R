#' Read NOAA ISD/ISH local file
#'
#' @export
#' @param path (character) path to the file. required.
#' @references ftp://ftp.ncdc.noaa.gov/pub/data/noaa/
#' @seealso \code{\link{isd}}, \code{\link{isd_stations}},
#' \code{\link{isd_stations_search}}
#' @details \code{isd_read} - read a \code{.gz} file as downloaded
#' from NOAA's website
#' @return A tibble (data.frame)
#' @family isd
#' @examples \dontrun{
#' file <- system.file("examples", "011490-99999-1986.gz", package = "rnoaa")
#' isd_read(file)
#' }
isd_read <- function(path) {
  if (!file.exists(as.character(path))) {
    stop("file does not exist / can not be found", call. = FALSE)
  }
  lns <- readLines(path)
  linesproc <- lapply(lns, each_line, sections = sections)
  df <- bind_rows(linesproc)
  trans_vars(df)
}
