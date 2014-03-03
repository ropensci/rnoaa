#' Coerce multiple outputs to a single data.frame object.
#' 
#' @importFrom plyr rbind.fill
#' @param ... Objects from another noaa_* function.
#' @return A data.frame
#' @examples \dontrun{
#' # data
#' out1 <- noaa(datasetid='GHCND', locationid = 'FIPS:02', startdate = '2010-05-01', 
#' enddate = '2010-05-31', limit=10)
#' out2 <- noaa(datasetid='GHCND', locationid = 'FIPS:02', startdate = '2010-07-01', 
#' enddate = '2010-07-31', limit=10)
#' noaa_combine(out1, out2)
#' 
#' # data sets
#' out1 <- noaa_datasets(datatypeid='TOBS')
#' out2 <- noaa_datasets(datatypeid='PRCP')
#' noaa_combine(out1, out2)
#' 
#' # data types
#' out1 <- noaa_datatypes(datatypeid="ACMH")
#' out2 <- noaa_datatypes(datatypeid='PRCP')
#' noaa_combine(out1, out2)
#' 
#' # data categories
#' out1 <- noaa_datacats(datacategoryid="ANNAGR")
#' out2 <- noaa_datacats(datacategoryid='PRCP')
#' noaa_combine(out1, out2)
#' 
#' # data locations
#' out1 <- noaa_locs(locationcategoryid='ST', limit=52)
#' out2 <- noaa_locs(locationcategoryid='CITY', sortfield='name', sortorder='desc')
#' noaa_combine(out1, out2)
#' 
#' # data locations
#' out1 <- noaa_locs_cats(startdate='1970-01-01')
#' out2 <- noaa_locs_cats(locationcategoryid='CLIM_REG')
#' noaa_combine(out1, out2)
#' 
#' # stations
#' out1 <- noaa_stations(datasetid='GHCND', locationid='FIPS:12017', 
#' stationid='GHCND:USC00084289')
#' out2 <- noaa_stations(stationid='COOP:010008')
#' out3 <- noaa_stations(datasetid='PRECIP_HLY', startdate='19900101', 
#' enddate='19901231')
#' out4 <- noaa_stations(datasetid='GHCND', locationid='FIPS:12017')
#' noaa_combine(out1, out2, out3, out4)
#' 
#' # try to combine two different classes
#' out1 <- noaa_locs_cats(startdate='1970-01-01')
#' out2 <- noaa_stations(stationid='COOP:010008')
#' out3 <- noaa_locs_cats(locationcategoryid='CLIM_REG')
#' noaa_combine(out1, out2)
#' }
#' @export
noaa_combine <- function(...)
{
  classes <- c("noaa_data","noaa_datasets","noaa_datatypes","noaa_datacats",
               "noaa_locs","noaa_locs_cats","noaa_stations")
  input <- list(...)
  class <- class(input[[1]])
  if(!inherits(input[[1]], classes))
    stop(sprintf("Input must be of one of the following classes: %s", paste(classes,collapse=", ") ))
  
  if(class == 'noaa_data'){
    out <- list(data = do.call(rbind.fill, lapply(input, "[[", "data")))
    class(out) <- "noaa_data"
	} else {
    out <- do.call(rbind.fill, lapply(input, "[[", "data"))
	}
  
  return(out)
}

# #' @method noaa_combine noaa_data
# #' @export
# #' @rdname noaa_combine
# noaa_combine.noaa_data <- function(...)
# {
#   input <- list(...)
#   if(!inherits(input[[1]], "noaa_data"))
#     stop("Input must be of class noaa_data")
#   
#   out <- do.call(rbind.fill, lapply(input, "[[", "data"))
#   class(out) <- "noaa_data_comb"
#   return(out)
# }

# #' @method noaa_combine noaa_datasets
# #' @export
# #' @rdname noaa_combine
# noaa_combine.noaa_datasets <- function(...) 
# {
#   input <- list(...)
#   if(!inherits(input[[1]], "noaa_datasets"))
#     stop("Input must be of class noaa_datasets")
#   
#   #   out <- data.frame(rbindlist(lapply(input, "[[", "data")))
#   out <- do.call(rbind.fill, lapply(input, "[[", "data"))
#   return(out)
# }
# 
# #' @method noaa_combine noaa_datatypes
# #' @export
# #' @rdname noaa_combine
# noaa_combine.noaa_datatypes <- function(...) 
# {
#   input <- list(...)
#   if(!inherits(input[[1]], "noaa_datatypes"))
#     stop("Input must be of class noaa_datatypes")
#   
#   #   out <- data.frame(rbindlist(lapply(input, "[[", "data")))
#   out <- do.call(rbind.fill, lapply(input, "[[", "data"))
#   return(out)
# }
# 
# #' @method noaa_combine noaa_datacats
# #' @export
# #' @rdname noaa_combine
# noaa_combine.noaa_datacats <- function(...) 
# {
#   input <- list(...)
#   if(!inherits(input[[1]], "noaa_datacats"))
#     stop("Input must be of class noaa_datacats")
#   
#   #   out <- data.frame(rbindlist(lapply(input, "[[", "data")))
#   out <- do.call(rbind.fill, lapply(input, "[[", "data"))
#   return(out)
# }
# 
# #' @method noaa_combine noaa_locs
# #' @export
# #' @rdname noaa_combine
# noaa_combine.noaa_locs <- function(...) 
# {
#   input <- list(...)
#   if(!inherits(input[[1]], "noaa_locs"))
#     stop("Input must be of class noaa_locs")
#   
#   #   out <- data.frame(rbindlist(lapply(input, "[[", "data")))
#   out <- do.call(rbind.fill, lapply(input, "[[", "data"))
#   return(out)
# }
# 
# #' @method noaa_combine noaa_locs_cats
# #' @export
# #' @rdname noaa_combine
# noaa_combine.noaa_locs_cats <- function(...) 
# {
#   input <- list(...)
#   if(!inherits(input[[1]], "noaa_locs_cats"))
#     stop("Input must be of class noaa_locs_cats")
#   
#   #   out <- data.frame(rbindlist(lapply(input, "[[", "data")))
#   out <- do.call(rbind.fill, lapply(input, "[[", "data"))
#   return(out)
# }
# 
# #' @method noaa_combine noaa_stations
# #' @export
# #' @rdname noaa_combine
# noaa_combine.noaa_stations <- function(...) 
# {
#   input <- list(...)
#   if(!inherits(input[[1]], "noaa_stations"))
#     stop("Input must be of class noaa_stations")
#   
#   #   out <- data.frame(rbindlist(lapply(input, "[[", "data")))
#   out <- do.call(rbind.fill, lapply(input, "[[", "data"))
#   return(out)
# }