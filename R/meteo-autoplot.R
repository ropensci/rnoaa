#' autoplot method for meteo_coverage objects
#'
#' @export
#' @method autoplot meteo_coverage
#' @param object (data.frame) a data.frame
#' @return A ggplot2 plot
#' @details see \code{\link{meteo_coverage}} for examples
autoplot.meteo_coverage <- function(object) {

  gg <- ggplot2::ggplot(object)
  gg <- gg + ggplot2::geom_segment(data = object,
                                   ggplot2::aes_(x = ~ stats::reorder(id, start_date),
                                                 xend = ~ stats::reorder(id, start_date),
                                                 y = ~ start_date, yend = ~ end_date))
  gg <- gg + ggplot2::scale_x_discrete(expand = c(0, 0.25))
  # gg <- gg + ggplot2::scale_y_datetime(expand = c(0, 0))
  gg <- gg + ggplot2::coord_flip()
  gg <- gg + ggplot2::labs(x = NULL, y = NULL, title = "Time coverage by station")
  gg <- gg + ggplot2::theme_bw(base_family = "Arial Narrow")
  gg <- gg + ggplot2::theme(panel.grid = ggplot2::element_line(color="#b2b2b2", size=0.1))
  gg <- gg + ggplot2::theme(panel.grid.major.x = ggplot2::element_line(color = "#b2b2b2", size = 0.1))
  gg <- gg + ggplot2::theme(panel.grid.major.y = ggplot2::element_blank())
  gg <- gg + ggplot2::theme(panel.grid.minor = ggplot2::element_blank())
  gg <- gg + ggplot2::theme(panel.border = ggplot2::element_blank())
  gg <- gg + ggplot2::theme(axis.ticks = ggplot2::element_blank())
  gg <- gg + ggplot2::theme(plot.title = ggplot2::element_text(margin = ggplot2::margin(b = 12)))
  ggtime <- gg

  df_reduced <- dplyr::select_(object, .dots = c('-start_date', '-end_date',
                                             '-total_obs'))
  df_long <- tidyr::gather_(df_reduced,
                            key_col = "observation", value_col = "value",
                            gather_cols = colnames(df_reduced[-1]))

  gg <- ggplot2::ggplot(df_long)
  gg <- gg + ggplot2::geom_segment(ggplot2::aes_(x = 0, xend = ~ value,
                                                 y = ~ observation, yend = ~ observation,
                                                 group = ~ id))
  #gg <- gg + ggplot2::scale_x_continuous(labels = percent, limits = c(0, 1))
  gg <- gg + ggplot2::facet_wrap(~id, scales = "free_x")
  gg <- gg + ggplot2::labs(x = NULL, y = NULL, title = "Observation coverage by station")
  gg <- gg + ggplot2::theme_bw(base_family = "Arial Narrow")
  gg <- gg + ggplot2::theme(panel.grid = ggplot2::element_line(color = "#b2b2b2",
                                                               size = 0.1))
  gg <- gg + ggplot2::theme(panel.grid.major.x = ggplot2::element_line(color = "#b2b2b2",
                                                                       size = 0.1))
  gg <- gg + ggplot2::theme(panel.grid.major.y = ggplot2::element_blank())
  gg <- gg + ggplot2::theme(panel.grid.minor = ggplot2::element_blank())
  gg <- gg + ggplot2::theme(panel.border = ggplot2::element_blank())
  gg <- gg + ggplot2::theme(axis.ticks = ggplot2::element_blank())
  gg <- gg + ggplot2::theme(plot.title = ggplot2::element_text(margin =
                                                                 ggplot2::margin(b = 12)))
  gg <- gg + ggplot2::theme(strip.background = ggplot2::element_blank())
  gg <- gg + ggplot2::theme(strip.text = ggplot2::element_text(hjust = 0))
  gg <- gg + ggplot2::theme(panel.margin.x = grid::unit(12, "pt"))
  gg <- gg + ggplot2::theme(panel.margin.y = grid::unit(8, "pt"))
  gg <- gg + ggplot2::theme(plot.margin = ggplot2::margin(t = 30, b = 5, l = 20, r = 20))
  ggobs <- gg

  gridExtra::grid.arrange(ggtime, ggobs, ncol=1, heights=c(0.4, 0.6))

}
