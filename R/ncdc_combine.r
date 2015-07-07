#' Coerce multiple outputs to a single data.frame object.
#'
#' @export
#'
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

ncdc_combine <- function(...) {
  classes <- c("ncdc_data","ncdc_datasets","ncdc_datatypes","ncdc_datacats",
               "ncdc_locs","ncdc_locs_cats","ncdc_stations")
  input <- list(...)
  class <- class(input[[1]])
  if(!inherits(input[[1]], classes))
    stop(sprintf("Input must be of one of the following classes: %s", paste(classes,collapse=", ") ))

  if(class == 'ncdc_data'){
    out <- list(data = dplyr::bind_rows(lapply(input, "[[", "data")))
    class(out) <- "ncdc_data"
	} else {
    out <- dplyr::bind_rows(lapply(input, "[[", "data"))
	}

  return(out)
}
