#' Get ERDDAP tabledap data.
#'
#' @export
#'
#' @param x Anything coercable to an object of class erddap_info. So the output of a call to
#' \code{erddap_info}, or a datasetid, which will internally be passed through \code{erddap_info}.
#' @param ... Any number of key-value pairs in quotes as query constraints. See Details & examples
#' @param fields Columns to return, as a character vector
#' @param distinct If TRUE ERDDAP will sort all of the rows in the results table (starting with the
#' first requested variable, then using the second requested variable if the first variable has a
#' tie, ...), then remove all non-unique rows of data. In many situations, ERDDAP can return
#' distinct values quickly and efficiently. But in some cases, ERDDAP must look through all rows
#' of the source dataset.
#' @param orderby If used, ERDDAP will sort all of the rows in the results table (starting with the
#' first variable, then using the second variable if the first variable has a tie, ...). Normally,
#' the rows of data in the response table are in the order they arrived from the data source.
#' orderBy allows you to request that the results table be sorted in a specific way. For example,
#' use \code{orderby=c("stationID,time")} to get the results sorted by stationID, then time. The
#' orderby variables MUST be included in the list of requested variables in the fields parameter.
#' @param orderbymax Give a vector of one or more fields, that must be included in the fields
#' parameter as well. Gives back data given constraints. ERDDAP will sort all of the rows in the
#' results table (starting with the first variable, then using the second variable if the first
#' variable has a tie, ...) and then just keeps the rows where the value of the last sort variable
#' is highest (for each combination of other values).
#' @param orderbymin Same as \code{orderbymax} parameter, except returns minimum value.
#' @param orderbyminmax Same as \code{orderbymax} parameter, except returns two rows for every
#' combination of the n-1 variables: one row with the minimum value, and one row with the maximum
#' value.
#' @param units One of 'udunits' (units will be described via the UDUNITS standard (e.g.,degrees_C))
#' or 'ucum' (units will be described via the UCUM standard (e.g., Cel)).
#' @param store One of \code{disk} (default) or \code{memory}. You can pass options to \code{disk}
#' @param callopts Further args passed on to httr::GET (must be a named parameter)
#'
#' @details
#' For key-value pair query constraints, the valid operators are =, != (not equals), =~ (a regular
#' expression test), <, <=, >, and >= . For regular expressions you need to add a regular
#' expression. For others, nothing more is needed. Construct the entry like
#' \code{'time>=2001-07-07'} with the parameter on the left, value on the right, and the operator
#' in the middle, all within a set of quotes. Since ERDDAP accepts values other than \code{=}, we
#' can't simply do \code{time = '2001-07-07'} as we normally would.
#'
#' Server-side functionality: Some tasks are done server side. You don't have to worry about what
#' that means. They are provided via parameters in this function. See \code{distinct},
#' \code{orderby}, \code{orderbymax}, \code{orderbymin}, \code{orderbyminmax}, and \code{units}.
#' @references  \url{http://upwell.pfeg.noaa.gov/erddap/index.html}
#' @author Scott Chamberlain <myrmecocystus@@gmail.com>
#' @examples \dontrun{
#' # Just passing the datasetid without fields gives all columns back
#' erddap_table('erdCalCOFIfshsiz')
#'
#' # Pass time constraints
#' erddap_table('erdCalCOFIfshsiz', 'time>=2001-07-07', 'time<=2001-07-08')
#'
#' # Pass in fields (i.e., columns to retrieve) & time constraints
#' erddap_table('erdCalCOFIfshsiz',fields=c('longitude','latitude','fish_size','itis_tsn'),
#'    'time>=2001-07-07','time<=2001-07-10')
#' erddap_table('erdCinpKfmBT', fields=c('latitude','longitude',
#'    'Aplysia_californica_Mean_Density','Muricea_californica_Mean_Density'),
#'    'time>=2007-06-24','time<=2007-07-01')
#'
#' # Get info on a datasetid, then get data given information learned
#' erddap_info('erdCalCOFIlrvsiz')$variables
#' erddap_table('erdCalCOFIlrvsiz', fields=c('latitude','longitude','larvae_size',
#'    'itis_tsn'), 'time>=2011-10-25', 'time<=2011-10-31')
#'
#' # An example workflow
#' ## Search for data
#' (out <- erddap_search(query='fish', which = 'table'))
#' ## Using a datasetid, search for information on a datasetid
#' id <- out$info$dataset_id[7]
#' erddap_info(id)$variables
#' ## Get data from the dataset
#' erddap_table(id, fields = c('fish','landings','year'))
#'
#' # Time constraint
#' ## Limit by time with date only
#' (info <- erddap_info('erdCalCOFIfshsiz'))
#' erddap_table(info, fields = c('latitude','longitude','scientific_name'),
#'    'time>=2001-07-14')
#'
#' # Use distinct parameter
#' erddap_table('erdCalCOFIfshsiz',fields=c('longitude','latitude','fish_size','itis_tsn'),
#'    'time>=2001-07-07','time<=2001-07-10', distinct=TRUE)
#'
#' # Use units parameter
#' ## In this example, values are the same, but sometimes they can be different given the units
#' ## value passed
#' erddap_table('erdCinpKfmT', fields=c('longitude','latitude','time','temperature'),
#'    'time>=2007-09-19', 'time<=2007-09-21', units='udunits')
#' erddap_table('erdCinpKfmT', fields=c('longitude','latitude','time','temperature'),
#'    'time>=2007-09-19', 'time<=2007-09-21', units='ucum')
#'
#' # Use orderby parameter
#' erddap_table('erdCinpKfmT', fields=c('longitude','latitude','time','temperature'),
#'    'time>=2007-09-19', 'time<=2007-09-21', orderby='temperature')
#' # Use orderbymax parameter
#' erddap_table('erdCinpKfmT', fields=c('longitude','latitude','time','temperature'),
#'    'time>=2007-09-19', 'time<=2007-09-21', orderbymax='temperature')
#' # Use orderbymin parameter
#' erddap_table('erdCinpKfmT', fields=c('longitude','latitude','time','temperature'),
#'    'time>=2007-09-19', 'time<=2007-09-21', orderbymin='temperature')
#' # Use orderbyminmax parameter
#' erddap_table('erdCinpKfmT', fields=c('longitude','latitude','time','temperature'),
#'    'time>=2007-09-19', 'time<=2007-09-21', orderbyminmax='temperature')
#' # Use orderbymin parameter with multiple values
#' erddap_table('erdCinpKfmT', fields=c('longitude','latitude','time','depth','temperature'),
#'    'time>=2007-06-10', 'time<=2007-09-21', orderbymax=c('depth','temperature'))
#'
#' # Spatial delimitation
#' erddap_table('erdCalCOFIfshsiz', fields = c('latitude','longitude','scientific_name'),
#'  'latitude>=34.8', 'latitude<=35', 'longitude>=-125', 'longitude<=-124')
#'
#' # Integrate with taxize
#' out <- erddap_table('erdCalCOFIfshsiz',
#'    fields = c('latitude','longitude','scientific_name','itis_tsn'))
#' tsns <- unique(out$itis_tsn[1:100])
#' library("taxize")
#' classif <- classification(tsns, db = "itis")
#' head(rbind(classif)); tail(rbind(classif))
#' 
#' # Write to memory (within R), or to disk
#' (out <- erddap_info('erdCalCOFIfshsiz'))
#' ## disk, by default (to prevent bogging down system w/ large datasets)
#' ## you can also pass in path and overwrite options to disk()
#' erddap_table('erdCalCOFIfshsiz', store = disk())
#' ## the 2nd call is much faster as it's mostly just the time of reading in the table from disk
#' system.time( erddap_table('erdCalCOFIfshsiz', store = disk()) )
#' system.time( erddap_table('erdCalCOFIfshsiz', store = disk()) )
#' ## memory
#' erddap_table(x='erdCalCOFIfshsiz', store = memory())
#' }

erddap_table <- function(x, ..., fields=NULL, distinct=FALSE, orderby=NULL,
  orderbymax=NULL, orderbymin=NULL, orderbyminmax=NULL, units=NULL, 
  store = disk(), callopts=list())
{
  x <- as.erddap_info(x)
  fields <- paste(fields, collapse = ",")
  url <- sprintf(paste0(eurl(), "tabledap/%s.csv?%s"), attr(x, "datasetid"), fields)
  args <- list(...)
  distinct <- if(distinct) 'distinct()' else NULL
  units <- if(!is.null(units)) makevar(toupper(units), 'units("%s")') else units
  orderby <- makevar(orderby, 'orderBy("%s")')
  orderbymax <- makevar(orderbymax, 'orderByMax("%s")')
  orderbymin <- makevar(orderbymin, 'orderByMin("%s")')
  orderbyminmax <- makevar(orderbyminmax, 'orderByMinMax("%s")')
  moreargs <- noaa_compact(list(distinct, orderby, orderbymax, orderbymin, orderbyminmax, units))
  args <- c(args, moreargs)
  args <- lapply(args, function(x) RCurl::curlEscape(x))
  args <- paste0(args, collapse = "&")
  if(!nchar(args[[1]]) == 0){
    url <- paste0(url, '&', args)
  }
  resp <- erd_tab_GET(url, dset=attr(x, "datasetid"), store, callopts)
  loc <- if(store$store == "disk") resp else "memory"
  structure(read_table(resp), class=c("erddap_table","data.frame"), datasetid=attr(x, "datasetid"), path=loc)
}

#' @export
print.erddap_table <- function(x, ..., n = 10){
  finfo <- file_info(attr(x, "path"))
  cat(sprintf("<NOAA ERDDAP tabledap> %s", attr(x, "datasetid")), sep = "\n")
  cat(sprintf("   Path: [%s]", attr(x, "path")), sep = "\n")
  if(attr(x, "path") != "memory"){
    cat(sprintf("   Last updated: [%s]", finfo$mtime), sep = "\n")
    cat(sprintf("   File size:    [%s mb]", finfo$size), sep = "\n")
  }
  cat(sprintf("   Dimensions:   [%s X %s]\n", NROW(x), NCOL(x)), sep = "\n")
  trunc_mat(x, n = n)
}

erd_tab_GET <- function(url, dset, store, ...){
  if(store$store == "disk"){
    fpath <- path.expand(file.path(store$path, paste0(dset, ".csv")))
    if( file.exists( fpath ) & store$overwrite == FALSE){ fpath } else {
      dir.create(store$path, showWarnings = FALSE, recursive = TRUE)
      res <- GET(url, write_disk(writepath(store$path, dset), store$overwrite), ...)
      out <- check_response_erddap(res)
      if(grepl("Error", out)) NA else res$request$writer[[1]]
    }
  } else {
    res <- GET(url, ...)
    out <- check_response_erddap(res)
    if(grepl("Error", out)) NA else res
  }
}

makevar <- function(x, y){
  if(!is.null(x)){
    x <- paste0(x, collapse = ",")
    sprintf(y, x)
  } else {
    NULL
  }
}

eurl <- function() "http://upwell.pfeg.noaa.gov/erddap/"
