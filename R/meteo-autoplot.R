#' autoplot method for meteo_coverage objects
#'
#' @export autoplot_meteo_coverage
#' @param meteo_object the object returned from [meteo_coverage()]
#' @param old_style (logical) create the old style of plots, which is faster, but
#' does not plot gaps to indicate missing data
#' @return A ggplot2 plot
#' @details see [meteo_coverage()] for examples.
autoplot_meteo_coverage <- function(meteo_object, old_style = FALSE) {

  mateo_coverage <- meteo_object

  if(old_style){
    # ungroup
    object <- dplyr::ungroup(mateo_coverage[['summary']])

    gg <- ggplot2::ggplot(object) +
      ggplot2::geom_segment(data = object,
                            ggplot2::aes_(x = ~ stats::reorder(id, start_date),
                                          xend = ~ stats::reorder(id, start_date),
                                          y = ~ start_date,
                                          yend = ~ end_date)) +
      ggplot2::scale_x_discrete(expand = c(0, 0.25)) +
      ggplot2::coord_flip()
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

      df_reduced <- dplyr::select(object, -start_date, -end_date, -total_obs, -dplyr::ends_with('_missing_dates'))
      df_long <- tidyr::gather_(df_reduced,
                                key_col = "observation", value_col = "value",
                                gather_cols = colnames(df_reduced[-1]))

      gg <- ggplot2::ggplot(df_long)
      gg <- gg + ggplot2::geom_segment(ggplot2::aes_(x = 0, xend = ~ value,
                                                     y = ~ observation, yend = ~ observation,
                                                     group = ~ id))
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
      gg <- gg + ggplot2::theme(panel.spacing.x = grid::unit(12, "pt"))
      gg <- gg + ggplot2::theme(panel.spacing.y = grid::unit(8, "pt"))
      gg <- gg + ggplot2::theme(plot.margin = ggplot2::margin(t = 30, b = 5, l = 20, r = 20))

      gridExtra::grid.arrange(ggtime, gg, ncol=1, heights=c(0.4, 0.6))
  } else {

    # this is just a work-around to prevent R CMD check from giving a NOTE about undefined global variables
    metric <- size <- NULL

    df <- dplyr::ungroup(mateo_coverage[['detail']])
    metrics <- df %>%
      dplyr::select(-date, -id, -grep(pattern = 'flag', x = names(df))) %>%
      names(.)
    nmetrics <- length(metrics)

    df_long <- df %>%
      tidyr::pivot_longer(data = .,
                          cols = tidyselect::all_of(metrics),
                          names_to = 'metric',
                          values_to = 'value') %>%
      dplyr::mutate(size = dplyr::if_else(is.na(value),
                                     NA_integer_,
                                     1L))

    nids = length(unique(df_long$id))

    ggplot2::ggplot(df_long,
                    ggplot2::aes(x = id,
                                 y = date,
                                 size = size,
                                 color = metric)) +
      ggplot2::theme_bw()+
      ggplot2::geom_line(position = ggplot2::position_dodge(width = 3/(25/(nids+1)))) +
      ggplot2::coord_flip()+
      ggplot2::scale_size(guide = 'none',
                          limits = c(0,1),
                          range = c((25-nids)/nmetrics,(25-nids)/nmetrics))
  }
}
