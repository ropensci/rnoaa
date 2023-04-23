#' Visualize missingness in a dataframe
#'
#' Gives you an at-a-glance ggplot of the missingness inside a dataframe,
#' colouring cells according to missingness, where black indicates a present
#' cell and grey indicates a missing cell. As it returns a `ggplot` object,
#' it is very easy to customize and change labels, and so on.
#'
#' @export
#' @param x a data.frame
#' @param cluster logical `TRUE`/`FALSE`. `TRUE` specifies that you want to use
#' hierarchical clustering (mcquitty method) to arrange rows according to
#' missingness. `FALSE` specifies that you want to leave it as is.
#' @param sort_miss logical `TRUE`/`FALSE`. `TRUE` arranges the columns in
#' order of missingness.
#' @details `vis_miss` visualises a data.frame to display missingness. This is
#' taken from the visdat package, currently only available on github:
#' https://github.com/tierneyn/visdat
#' @examples \dontrun{
#'   monitors <- c("ASN00003003", "ASM00094299")
#'   weather_df <- meteo_pull_monitors(monitors)
#'   vis_miss(weather_df)
#' }
vis_miss <- function(x, cluster = FALSE, sort_miss = FALSE) {
  # make a TRUE/FALSE matrix of the data.
  # This tells us whether it is missing (true) or not (false)
  x.na <- is.na(x)

  # switch for creating the missing clustering
  if (cluster) {
    # this retrieves a row order of the clustered missingness
    row_order_index <-
      stats::dist(x.na*1) %>%
      stats::hclust(method = "mcquitty") %>%
      stats::as.dendrogram %>%
      stats::order.dendrogram
  } else {
    row_order_index <- 1:nrow(x)
  }

  if (sort_miss) {
    # arrange by the columns with the highest missingness
    # code inspired from https://r-forge.r-project.org/scm/viewvc.php/pkg/R/missing.pattern.plot.R?view=markup&root=mi-dev
    # get the order of columns with highest missingness
    na_sort <- order(colSums(is.na(x)), decreasing = TRUE)

    # get the names of those columns
    col_order_index <- names(x)[na_sort]
  } else {
    col_order_index <- names(x)
  }

  # Arranged data by dendrogram order index
  d <- x.na[row_order_index , ] %>%
    as.data.frame %>%
    dplyr::mutate(rows = dplyr::row_number()) %>%
    tidyr::pivot_longer(cols = !rows,
                   names_to = "variables",
                   values_to = "valueType")

  d_value <- x[row_order_index , ] %>%
    as.data.frame %>%
    dplyr::mutate(rows = dplyr::row_number()) %>%
    tidyr::pivot_longer(cols = !rows,
                        names_to = "variables",
                        values_to = "value",
                        values_transform = as.character)

  d <- d |>
    dplyr::left_join(d_value, by = c("rows", "variables"))

  ggplot(data = d,
         ggplot2::aes_string(x = "variables",
                             y = "rows",
                             # text assists with plotly mouseover
                             text = "value")) +
    ggplot2::geom_raster(ggplot2::aes_string(fill = "valueType")) +
    # change the colour, so that missing is grey, present is black
    ggplot2::scale_fill_grey(name = "", labels = c("Present", "Missing")) +
    ggplot2::theme_minimal() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45,
                                                       vjust = 1,
                                                       hjust = 1)) +
    ggplot2::labs(x = "Variables in Data",
                  y = "Observations") +
    ggplot2::scale_x_discrete(limits = col_order_index)
}
