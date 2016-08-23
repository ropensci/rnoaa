#' Determine the "coverage" for a station data frame
#'
#' Call this function after pulling down observations for a set of stations
#' to retrieve the "coverage" (i.e. how complete each field is). If either
#' or both \code{obs_start_date} or \code{obs_end_date} are specified,
#' the coverage test will be limited to that date range.
#'
#' There is an \code{autoplot} method for the output of this function.
#'
#' @param meteo_df a \emph{meteo} \code{data.frame}
#' @param obs_start_date specify either or both (obs_start_date, obs_end_date) to constrain
#'        coverate tests. These should be \code{Date} objects.
#' @param obs_end_date specify either or both (obs_start_date, obs_end_date) to constrain
#'        coverate tests. These should be \code{Date} objects.
#' @param verbose if \code{TRUE} will display the coverage summary along
#'        with returning the coverage data.frame
#' @return a \code{data.frame} with the coverage for each station, minimally
#' containing: \preformatted{
#' $ id         (chr)
#' $ start_date (time)
#' $ end_date   (time)
#' $ total_obs  (int)
#' }
#' with additional fields (and their coverage percent) depending on which
#' weather variables were queried and available for the weather station.
#' @export
#' @examples \dontrun{
#'
#' monitors <- c("ASN00095063", "ASN00024025", "ASN00040112", "ASN00041023",
#'              "ASN00009998", "ASN00066078", "ASN00003069", "ASN00090162",
#'              "ASN00040126", "ASN00058161")
#' obs <- meteo_pull_monitors(monitors)
#' obs_covr <- meteo_coverage(obs)
#'
#' library("ggplot2")
#' autoplot(obs_covr)
#'
#' }
meteo_coverage <- function(meteo_df,
                           obs_start_date=NULL,
                           obs_end_date=NULL,
                           verbose=FALSE) {

  if (!is.null(obs_start_date)) {
    dots <- list(~as.Date(date) >= obs_start_date)
    meteo_df <- dplyr::filter_(meteo_df, .dots = dots)
  }

  if (!is.null(obs_end_date)) {
    dots <- list(~as.Date(date) <= obs_end_date)
    meteo_df <- dplyr::filter_(meteo_df, .dots = dots)
  }

  dplyr::group_by_(meteo_df, ~id) %>%
    dplyr::do({
      rng <- range(.$date)
      dat <- data.frame(start_date = rng[1],
                        end_date = rng[2],
                        total_obs = nrow(.), stringsAsFactors=FALSE)
      if (verbose) cat(sprintf("Station Id: %s\n", .$id[1]))
      if (verbose) cat(sprintf("\n  Date range for observations: %s\n\n",
                  paste0(as.character(rng), sep="", collapse=" to ")))
      if (verbose) cat(sprintf("  Total number of observations: %s\n\n",
                               scales::comma(nrow(.))))
      meteo_cols <- dplyr::setdiff(colnames(.), c("id", "date"))
      col_cov <- lapply(meteo_cols, function(x, n) {
        if (verbose) cat(sprintf("  Column %s completeness: %5s\n",
                    formatC(sprintf("'%s'", x), width = (n+2)),
                    scales::percent(sum(!is.na(.[,x])) / nrow(.))))
        sum(!is.na(.[,x])) / nrow(.)
      }, max(vapply(colnames(.), nchar, numeric(1), USE.NAMES=FALSE)))
      if (verbose) cat("\n")
      col_cov <- stats::setNames(cbind.data.frame(col_cov, stringsAsFactors=FALSE), meteo_cols)
      dplyr::bind_cols(dat, col_cov)
    }) -> out
  class(out) <- c("meteo_coverage", class(out))
  if (verbose) return(invisible(out))
  out
}
