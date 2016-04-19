#' Determine the "coverage" for a station data frame
#'
#' Call this function after pulling down observations for a set of stations
#' to retrieve the "coverage" (i.e. how complete each field is). If either
#' or both \code{obs_start_date} or \code{obs_end_date} are specified,
#' the coverage test will be limited to that date range.
#'
#' There is an \code{autoplot} method for the output of this function.
#' @importFrom scales comma
#' @param meteo_df an \emph{meteo} \code{data.frame}
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
#' with additional fields (and their coverage percent) depending on what
#' was available for the weather station.
#' @export
#' @examples
#' monitors <- c("ASN00095063", "ASN00024025", "ASN00040112", "ASN00041023",
#'              "ASN00009998", "ASN00066078", "ASN00003069", "ASN00090162",
#'              "ASN00040126", "ASN00058161")
#' obs <- meteo_pull_monitors(monitors)
#' obs_covr <- meteo_coverage(obs)
#' ggplot2::autoplot(obs_covr)
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
      col_cov <- setNames(cbind.data.frame(col_cov, stringsAsFactors=FALSE), meteo_cols)
      dplyr::bind_cols(dat, col_cov)
    }) -> out
  class(out) <- c("meteo_coverage", class(out))
  if (verbose) return(invisible(out))
  out
}

autoplot.meteo_coverage <- function(df) {

  gg <- ggplot2::ggplot(df)
  gg <- gg + ggplot2::geom_segment(data = df, ggplot2::aes(x = reorder(id, start_date),
                                       xend = reorder(id, start_date),
                                       y = start_date, yend = end_date))
  gg <- gg + ggplot2::scale_x_discrete(expand = c(0, 0.25))
  gg <- gg + ggplot2::scale_y_datetime(expand = c(0, 0))
  gg <- gg + ggplot2::coord_flip()
  gg <- gg + ggplot2::labs(x = NULL, y = NULL, title = "Time coverage by station")
  gg <- gg + ggplot2::theme_bw(base_family = "Arial Narrow")
  gg <- gg + ggplot2::theme(panel.grid = element_line(color="#b2b2b2", size=0.1))
  gg <- gg + ggplot2::theme(panel.grid.major.x = element_line(color = "#b2b2b2", size = 0.1))
  gg <- gg + ggplot2::theme(panel.grid.major.y = element_blank())
  gg <- gg + ggplot2::theme(panel.grid.minor = element_blank())
  gg <- gg + ggplot2::theme(panel.border = element_blank())
  gg <- gg + ggplot2::theme(axis.ticks = element_blank())
  gg <- gg + ggplot2::theme(plot.title = element_text(margin = margin(b = 12)))
  ggtime <- gg

  df_long <- tidyr::gather(dplyr::select(df, -start_date, -end_date, -total_obs),
                           observation, value, -id)

  gg <- ggplot2::ggplot(df_long)
  gg <- gg + ggplot2::geom_segment(aes(x = 0, xend = value,
                              y = observation, yend = observation, group = id))
  gg <- gg + ggplot2::scale_x_continuous(labels = percent, limits = c(0, 1))
  gg <- gg + ggplot2::facet_wrap(~id, scales = "free_x")
  gg <- gg + ggplot2::labs(x = NULL, y = NULL, title = "Observation coverage by station")
  gg <- gg + ggplot2::theme_bw(base_family = "Arial Narrow")
  gg <- gg + ggplot2::theme(panel.grid = element_line(color = "#b2b2b2", size = 0.1))
  gg <- gg + ggplot2::theme(panel.grid.major.x = element_line(color = "#b2b2b2", size = 0.1))
  gg <- gg + ggplot2::theme(panel.grid.major.y = element_blank())
  gg <- gg + ggplot2::theme(panel.grid.minor = element_blank())
  gg <- gg + ggplot2::theme(panel.border = element_blank())
  gg <- gg + ggplot2::theme(axis.ticks = element_blank())
  gg <- gg + ggplot2::theme(plot.title = element_text(margin = margin(b = 12)))
  gg <- gg + ggplot2::theme(strip.background = element_blank())
  gg <- gg + ggplot2::theme(strip.text = element_text(hjust = 0))
  gg <- gg + ggplot2::theme(panel.margin.x = grid::unit(12, "pt"))
  gg <- gg + ggplot2::theme(panel.margin.y = grid::unit(8, "pt"))
  gg <- gg + ggplot2::theme(plot.margin = margin(t = 30, b = 5, l = 20, r = 20))
  ggobs <- gg

  gridExtra::grid.arrange(ggtime, ggobs, ncol=1, heights=c(0.4, 0.6))

}


