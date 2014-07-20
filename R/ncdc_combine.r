#' Coerce multiple outputs to a single data.frame object.
#'
#' @importFrom plyr rbind.fill
#' @param ... Objects from another ncdc_* function.
#' @return A data.frame
#' @examples \dontrun{
#' # data
#' out1 <- ncdc(datasetid='GHCND', locationid = 'FIPS:02', startdate = '2010-05-01',
#' enddate = '2010-05-31', limit=10)
#' out2 <- ncdc(datasetid='GHCND', locationid = 'FIPS:02', startdate = '2010-07-01',
#' enddate = '2010-07-31', limit=10)
#' ncdc_combine(out1, out2)
#'
#' # data sets
#' out1 <- ncdc_datasets(datatypeid='TOBS')
#' out2 <- ncdc_datasets(datatypeid='PRCP')
#' ncdc_combine(out1, out2)
#'
#' # data types
#' out1 <- ncdc_datatypes(datatypeid="ACMH")
#' out2 <- ncdc_datatypes(datatypeid='PRCP')
#' ncdc_combine(out1, out2)
#'
#' # data categories
#' out1 <- ncdc_datacats(datacategoryid="ANNAGR")
#' out2 <- ncdc_datacats(datacategoryid='PRCP')
#' ncdc_combine(out1, out2)
#'
#' # data locations
#' out1 <- ncdc_locs(locationcategoryid='ST', limit=52)
#' out2 <- ncdc_locs(locationcategoryid='CITY', sortfield='name', sortorder='desc')
#' ncdc_combine(out1, out2)
#'
#' # data locations
#' out1 <- ncdc_locs_cats(startdate='1970-01-01')
#' out2 <- ncdc_locs_cats(locationcategoryid='CLIM_REG')
#' ncdc_combine(out1, out2)
#'
#' # stations
#' out1 <- ncdc_stations(datasetid='GHCND', locationid='FIPS:12017',
#' stationid='GHCND:USC00084289')
#' out2 <- ncdc_stations(stationid='COOP:010008')
#' out3 <- ncdc_stations(datasetid='PRECIP_HLY', startdate='19900101',
#' enddate='19901231')
#' out4 <- ncdc_stations(datasetid='GHCND', locationid='FIPS:12017')
#' ncdc_combine(out1, out2, out3, out4)
#'
#' # try to combine two different classes
#' out1 <- ncdc_locs_cats(startdate='1970-01-01')
#' out2 <- ncdc_stations(stationid='COOP:010008')
#' out3 <- ncdc_locs_cats(locationcategoryid='CLIM_REG')
#' ncdc_combine(out1, out2, out3)
#' }
#' @export
ncdc_combine <- function(...)
{
  classes <- c("ncdc_data","ncdc_datasets","ncdc_datatypes","ncdc_datacats",
               "ncdc_locs","ncdc_locs_cats","ncdc_stations")
  input <- list(...)
  class <- class(input[[1]])
  if(!inherits(input[[1]], classes))
    stop(sprintf("Input must be of one of the following classes: %s", paste(classes,collapse=", ") ))

  if(class == 'ncdc_data'){
    out <- list(data = do.call(rbind.fill, lapply(input, "[[", "data")))
    class(out) <- "ncdc_data"
	} else {
    out <- do.call(rbind.fill, lapply(input, "[[", "data"))
	}

  return(out)
}

# #' @method ncdc_combine ncdc_data
# #' @export
# #' @rdname ncdc_combine
# ncdc_combine.ncdc_data <- function(...)
# {
#   input <- list(...)
#   if(!inherits(input[[1]], "ncdc_data"))
#     stop("Input must be of class ncdc_data")
#
#   out <- do.call(rbind.fill, lapply(input, "[[", "data"))
#   class(out) <- "ncdc_data_comb"
#   return(out)
# }

# #' @method ncdc_combine ncdc_datasets
# #' @export
# #' @rdname ncdc_combine
# ncdc_combine.ncdc_datasets <- function(...)
# {
#   input <- list(...)
#   if(!inherits(input[[1]], "ncdc_datasets"))
#     stop("Input must be of class ncdc_datasets")
#
#   #   out <- data.frame(rbindlist(lapply(input, "[[", "data")))
#   out <- do.call(rbind.fill, lapply(input, "[[", "data"))
#   return(out)
# }
#
# #' @method ncdc_combine ncdc_datatypes
# #' @export
# #' @rdname ncdc_combine
# ncdc_combine.ncdc_datatypes <- function(...)
# {
#   input <- list(...)
#   if(!inherits(input[[1]], "ncdc_datatypes"))
#     stop("Input must be of class ncdc_datatypes")
#
#   #   out <- data.frame(rbindlist(lapply(input, "[[", "data")))
#   out <- do.call(rbind.fill, lapply(input, "[[", "data"))
#   return(out)
# }
#
# #' @method ncdc_combine ncdc_datacats
# #' @export
# #' @rdname ncdc_combine
# ncdc_combine.ncdc_datacats <- function(...)
# {
#   input <- list(...)
#   if(!inherits(input[[1]], "ncdc_datacats"))
#     stop("Input must be of class ncdc_datacats")
#
#   #   out <- data.frame(rbindlist(lapply(input, "[[", "data")))
#   out <- do.call(rbind.fill, lapply(input, "[[", "data"))
#   return(out)
# }
#
# #' @method ncdc_combine ncdc_locs
# #' @export
# #' @rdname ncdc_combine
# ncdc_combine.ncdc_locs <- function(...)
# {
#   input <- list(...)
#   if(!inherits(input[[1]], "ncdc_locs"))
#     stop("Input must be of class ncdc_locs")
#
#   #   out <- data.frame(rbindlist(lapply(input, "[[", "data")))
#   out <- do.call(rbind.fill, lapply(input, "[[", "data"))
#   return(out)
# }
#
# #' @method ncdc_combine ncdc_locs_cats
# #' @export
# #' @rdname ncdc_combine
# ncdc_combine.ncdc_locs_cats <- function(...)
# {
#   input <- list(...)
#   if(!inherits(input[[1]], "ncdc_locs_cats"))
#     stop("Input must be of class ncdc_locs_cats")
#
#   #   out <- data.frame(rbindlist(lapply(input, "[[", "data")))
#   out <- do.call(rbind.fill, lapply(input, "[[", "data"))
#   return(out)
# }
#
# #' @method ncdc_combine ncdc_stations
# #' @export
# #' @rdname ncdc_combine
# ncdc_combine.ncdc_stations <- function(...)
# {
#   input <- list(...)
#   if(!inherits(input[[1]], "ncdc_stations"))
#     stop("Input must be of class ncdc_stations")
#
#   #   out <- data.frame(rbindlist(lapply(input, "[[", "data")))
#   out <- do.call(rbind.fill, lapply(input, "[[", "data"))
#   return(out)
# }
