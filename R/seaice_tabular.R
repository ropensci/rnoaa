si_tab_pat <- "ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/%s/monthly/data/"

#' Sea ice tabular data
#'
#' Collects `.csv` files from NOAA, and binds them together into
#' a single data.frame. Data across years, with extent and area of ice.
#' 
#' An example file, for January, North pole:
#' `https://sidads.colorado.edu/DATASETS/NOAA/G02135/north/monthly/data/N_01_extent_v3.0.csv`
#'
#' @export
#' @param ... Curl options passed on to [crul::verb-GET] - beware
#' that curl options are passed to each http request, for each of
#' 24 requests.
#' @return A data.frame with columns:
#'
#' - year (integer)
#' - mo (integer)
#' - data.type (character)
#' - region (character)
#' - extent (numeric)
#' - area (numeric)
#'
#' @details a value in any cell of -9999 indicates missing data
#' @seealso [sea_ice()]
#' @examples \dontrun{
#' df <- sea_ice_tabular()
#' df
#' }
sea_ice_tabular <- function(...) {
  si_tab_n <- sprintf(si_tab_pat, "north")
  si_tab_s <- sprintf(si_tab_pat, "south")
  urls <- c(
    paste0(si_tab_n, sprintf("N_%02.f_extent_v3.0.csv", 1:12)),
    paste0(si_tab_s, sprintf("S_%02.f_extent_v3.0.csv", 1:12))
  )
  out <- lapply(urls, function(z) {
    res <- GET_retry(z, ...)
    read.csv(text = res$parse("UTF-8"), stringsAsFactors = FALSE,
      strip.white = TRUE)
  })
  tibble::as_tibble(dplyr::bind_rows(out))
}
