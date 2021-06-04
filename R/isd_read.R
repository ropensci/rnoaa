#' Read NOAA ISD/ISH local file
#'
#' @export
#' @param path (character) path to the file. required.
#' @param additional (logical) include additional and remarks data sections
#' in output. Default: `TRUE`. Passed on to
#' [isdparser::isd_parse()]
#' @param parallel (logical) do processing in parallel. Default: `FALSE`
#' @param cores (integer) number of cores to use: Default: 2. We look in
#' your option "cl.cores", but use default value if not found.
#' @param progress (logical) print progress - ignored if `parallel=TRUE`.
#' The default is `FALSE` because printing progress adds a small bit of
#' time, so if processing time is important, then keep as `FALSE`
#' @references https://ftp.ncdc.noaa.gov/pub/data/noaa/
#' @seealso [isd()], [isd_stations()], [isd_stations_search()]
#' @details `isd_read` - read a `.gz` file as downloaded
#' from NOAA's website
#' @return A tibble (data.frame)
#' @family isd
#' @examples \dontrun{
#' file <- system.file("examples", "011490-99999-1986.gz", package = "rnoaa")
#' isd_read(file)
#' isd_read(file, additional = FALSE)
#' }
isd_read <- function(path, additional = TRUE, parallel = FALSE,
                     cores = getOption("cl.cores", 2), progress = FALSE) {

  isdparser::isd_parse(
    path = path,
    additional = additional,
    parallel = parallel,
    cores = cores,
    progress = progress
  )
}
