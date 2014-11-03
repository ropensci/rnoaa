#' ERDDAP Information
#' 
#' NOAA's ERDDAP service holds many datasets of interest. It's built on top of 
#' OPenDAP \url{http://www.opendap.org/}. You can search for datasets via 
#' \code{\link{erddap_search}}, list datasets via \code{\link{erddap_datasets}}, 
#' get information on a single dataset via \code{\link{erddap_info}}, then get 
#' data you want for either tabledap type via \code{\link{erddap_table}}, or
#' for griddap type via \code{\link{erddap_grid}}.
#' 
#' tabledap and griddap have different interfaces to query for data, so 
#' \code{\link{erddap_table}} and \code{\link{erddap_grid}} are separated out as 
#' separate functions even though some of the internals are the same. In particular, 
#' with tabledap you can query on/subset all variables, whereas with gridddap, you can
#' only query on/subset the dimension varibles (e.g., latitude, longitude, altitude).
#' 
#' \bold{NOTE:} With griddap data vai \code{\link{erddap_grid}} you can get a lot of 
#' data quickly. Try small searches of a dataset to start to get a sense for the data, 
#' then you can increase the amount of data you get. See \code{\link{erddap_grid}}
#' for more details.
#' 
#' The following are the ERDDAP functions:
#'
#' \itemize{
#'  \item \code{\link{erddap_search}}
#'  \item \code{\link{erddap_datasets}}
#'  \item \code{\link{erddap_info}}
#'  \item \code{\link{erddap_table}}
#'  \item \code{\link{erddap_grid}}
#' }
#' 
#' @references  \url{http://upwell.pfeg.noaa.gov/erddap/index.html}
#' @author Scott Chamberlain <myrmecocystus@@gmail.com>
#' @name erddap
NULL
