#' Determine the "coverage" for a station data frame
#'
#' Call this function after pulling down observations for a set of stations
#' to retrieve the "coverage" (i.e. how complete each field is). If either
#' or both `obs_start_date` or `obs_end_date` are specified,
#' the coverage test will be limited to that date range.
#'
#' @param meteo_df a *meteo* \code{data.frame}
#' @param obs_start_date specify either or both (obs_start_date, obs_end_date)
#' to constrain coverate tests. These should be `Date` objects.
#' @param obs_end_date specify either or both (obs_start_date, obs_end_date)
#' to constrain coverate tests. These should be `Date` objects.
#' @param verbose if `TRUE` will display the coverage summary along
#' with returning the coverage data.frame
#' @return a `list` containing 2 `data.frame`s named 'summary' and 'detail'.
#' The 'summary' `data.frame` contains columns: \preformatted{
#' $ id         (chr)
#' $ start_date (time)
#' $ end_date   (time)
#' $ total_obs  (int)
#' }
#' with additional fields (and their coverage percent) depending on which
#' weather variables were queried and available for the weather station. The
#' `data.frame` named 'detail' contains the same columns as the `meteo_df` input
#' data, but expands the rows to contain `NA`s for days without data.
#' @export
#' @examples \dontrun{
#'
#' monitors <- c("ASN00095063", "ASN00024025", "ASN00040112", "ASN00041023",
#'              "ASN00009998", "ASN00066078", "ASN00003069", "ASN00090162",
#'              "ASN00040126", "ASN00058161")
#' obs <- meteo_pull_monitors(monitors)
#' obs_covr <- meteo_coverage(obs)
#'
#' }
meteo_coverage <- function(meteo_df,
                            obs_start_date=NULL,
                            obs_end_date=NULL,
                            verbose=FALSE) {

  if (!is.null(obs_start_date)) {
    meteo_df <- dplyr::filter(meteo_df, date >= obs_start_date)
  }

  if (!is.null(obs_end_date)) {
    meteo_df <- dplyr::filter(meteo_df, date <= obs_end_date)
  }

  dplyr::group_by(meteo_df, id) %>%
    dplyr::do({
      # calculate the date range for each station id
      rng <- range(.$date)
      # dataframe with only start & end dates
      dat <- data.frame(start_date = rng[1],
                        end_date = rng[2],
                        total_obs = nrow(.), stringsAsFactors=FALSE)

      if (verbose) message(sprintf("Station Id: %s\n", .$id[1]))
      if (verbose) message(sprintf("\n  Date range for observations: %s\n\n",
                               paste0(as.character(rng), sep="", collapse=" to ")))
      if (verbose) message(sprintf("  Total number of observations: %s\n\n",
                               scales::comma(nrow(.))))
      # get the names from meteo_df other than "date" and "id"
      meteo_cols <- dplyr::setdiff(colnames(.), c("id", "date"))

      col_cov <- lapply(meteo_cols,
                        function(x, n) {
                          if (verbose) message(sprintf("  Column %s completeness: %5s\n",
                                                   formatC(sprintf("'%s'", x),
                                                           width = (n+2)),
                                                   scales::percent(sum(!is.na(.[,x])) / nrow(.))))
                          sum(!is.na(.[,x])) / nrow(.)
                        },
                        n = max(vapply(colnames(.), # maximum width of any column name
                                       nchar,
                                       numeric(1),
                                       USE.NAMES=FALSE)))

      if (verbose) message("\n")
      # convert list into a data.frame
      col_cov <- stats::setNames(cbind.data.frame(col_cov, stringsAsFactors=FALSE), meteo_cols)

      dplyr::bind_cols(dat,
                       col_cov)
    }) -> out1


  dplyr::group_by(meteo_df, id) %>%
    dplyr::do({
      # calculate the date range for each station id
      rng <- range(.$date)

      # new dataframe has all dates from start to end date
      dates <- data.frame(date = as.Date(x = seq.Date(from = rng[1],
                                                        to = rng[2],
                                                        by = 'day')))
      # join the original data to all the unique dates
      dplyr::full_join(x = dates,
                             y = .,
                             by='date') %>%
        dplyr::mutate(id = stats::na.omit(unique(.$id)))
    }) -> out2

  # class(out1) <- c("meteo_coverage", class(out1))

  out <- list( summary = out1,
               detail = out2)

  class(out) <- c("meteo_coverage", class(out))
  out
}
