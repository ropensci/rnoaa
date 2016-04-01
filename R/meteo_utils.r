#' Determine the "coverage" for a station data frame
#'
#' Call this function after pulling down observations for a set of stations
#' to retrieve the "coverage" (i.e. how complete each field is). If either
#' or both \code{obs_start_date} or \code{obs_end_date} are specified,
#' the coverage test will be limited to that date range.
#'
#' @param meteo_df an \emph{meteo} \code{data.frame}
#' @param obs_end_date,obs_end_date specify either or both to constrain
#'        coverate tests. These should be \code{Date} objects.
#' @param verbose if \code{TRUE} will display the coverage summary along
#'        with returning the coverage data.frame
#' @return a \code{data.frame} with the coverage for each station, minimally
#' containing: \preformatted{
#' $ id         (fctr)
#' $ station    (fctr)
#' $ start_date (time)
#' $ end_date   (time)
#' $ total_obs  (int)
#' }
#' with additional fields (and their coverage percent) depending on what
#' was available for the weather station.
#' @export
meteo_coverage <- function(meteo_df,
                           obs_start_date=NULL,
                           obs_end_date=NULL,
                           verbose=TRUE) {

  if (!is.null(obs_start_date)) {
    meteo_df <- dplyr::filter(meteo_df, as.Date(date) >= obs_start_date)
  }

  if (!is.null(obs_end_date)) {
    meteo_df <- dplyr::filter(meteo_df, as.Date(date) <= obs_end_date)
  }

  dplyr::group_by(meteo_df, id) %>%
    do({
      rng <- range(.$date)
      dat <- data.frame(station = .$id[1],
                        start_date = rng[1],
                        end_date = rng[2],
                        total_obs = nrow(.))
      if (verbose) cat(sprintf("Station Id: %s\n", .$id[1]))
      if (verbose) cat(sprintf("\n  Date range for observations: %s\n\n",
                  paste0(as.character(rng), sep="", collapse=" to ")))
      if (verbose) cat(sprintf("  Total number of observations: %s\n\n", comma(nrow(.))))
      meteo_cols <- setdiff(colnames(.), c("id", "date"))
      col_cov <- lapply(meteo_cols, function(x, n) {
        if (verbose) cat(sprintf("  Column %s completeness: %5s\n",
                    formatC(sprintf("'%s'", x), width = (n+2)),
                    percent(sum(!is.na(.[,x])) / nrow(.))))
        sum(!is.na(.[,x])) / nrow(.)
      }, max(vapply(colnames(.), nchar, numeric(1), USE.NAMES=FALSE)))
      if (verbose) cat("\n")
      col_cov <- setNames(cbind.data.frame(col_cov), meteo_cols)
      dplyr::bind_cols(dat, col_cov)
    }) -> out
  if (verbose) return(invisible(out))
  out
}
