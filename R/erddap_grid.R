#' Get ERDDAP griddap data.
#'
#' @export
#' @param x Anything coercable to an object of class erddap_info. So the output of a call to 
#' \code{erddap_info}, or a datasetid, which will internally be passed through \code{erddap_info}.
#' @param ... Dimension arguments.
#' @param fields Fields to return, a character vector.
#' @param stride (integer) How many values to get. 1 = get every value, 2 = get every other value,
#' etc. Default: 1 (i.e., get every value)
#' @param path Path to store files in. Default: ~/.rnoaa/upwell
#' @param overwrite (logical) Overwrite an existing file of the same name? Default: TRUE
#' @param callopts Pass on curl options to \code{\link[httr]{GET}}
#'
#' @details Some details:
#'
#' @section Dimensions and Variables:
#' ERDDAP grid dap data has this concept of dimenions vs. variables. So, dimensions are things
#' like time, latitude, longitude, and altitude. Whereas variables are the measured variables,
#' e.g., temperature, salinity, and air.
#'
#' You can't separately adjust values for dimensions for different variables. So, here's how it's
#' gonna work:
#'
#' Pass in lower and upper limits you want for each dimension as a vector (e.g., \code{c(1,2)}),
#' or leave to defaults (i.e., don't pass anything to a dimension). Then pick which variables
#' you want returned via the \code{fields} parameter. If you don't pass in options to the
#' \code{fields} parameter, you get all variables back.
#'
#' To get the dimensions and variables, along with other metadata for a dataset, run
#' \code{erddap_info}, and each will be shown, with their min and max values, and some
#' other metadata.
#'
#' @section Where does the data go?:
#' You can choose where data is stored. Be careful though. You can easily get a single file of
#' hundreds of MB's or GB's in size with a single request. To the store parameter, pass
#' \dQuote{memory} if you want to store the data in memory (saved as a data.frame), or
#' pass \dQuote{disk} if you want to store on disk in a file. Possibly will add other options,
#' like \dQuote{sql} for storing in a SQL database, though that option would need to be expanded
#' to various SQL DB options though.
#'
#' @examples \dontrun{
#' # single variable dataset
#' (out <- erddap_info('noaa_esrl_027d_0fb5_5d38'))
#' (res <- erddap_grid(out,
#'  time = c('2012-01-01','2012-06-12'),
#'  latitude = c(21, 18),
#'  longitude = c(-80, -75)
#' ))
#'
#' # multi-variable dataset
#' (out <- erddap_info('noaa_gfdl_5081_7d4a_7570'))
#' (res <- erddap_grid(out,
#'  time = c('2005-11-01','2006-01-01'),
#'  latitude = c(20, 21),
#'  longitude = c(10, 11)
#' ))
#' (res <- erddap_grid(out, time = c('2005-11-01','2006-01-01'), latitude = c(20, 21),
#' longitude = c(10, 11), fields = 'uo'))
#' (res <- erddap_grid(out, time = c('2005-11-01','2006-01-01'), latitude = c(20, 21),
#' longitude = c(10, 11), fields = 'uo', stride=c(1,2,1,2)))
#' (res <- erddap_grid(out, time = c('2005-11-01','2006-01-01'), latitude = c(20, 21),
#' longitude = c(10, 11), fields = c('uo','so')))
#' (res <- erddap_grid(out, time = c('2005-09-01','2006-01-01'), latitude = c(20, 21),
#' longitude = c(10, 11), fields = 'none'))
#'
#' # multi-variable dataset
#' ## this one also has a 0-360 longitude system, BLARGH!!!
#' (out <- erddap_info('noaa_gfdl_3c96_7879_a9d3'))
#' (res <- erddap_grid(out,
#'  time = c('2005-11-01','2006-01-01'),
#'  latitude = c(20, 22),
#'  longitude = c(-80, -75)
#' ))
#' (res <- erddap_grid(out,
#'  time = c('2005-11-01','2006-01-01'),
#'  latitude = c(20, 22),
#'  longitude = c(-80, -75),
#'  depth = c(5, 50)
#' ))
#'
#' # single variable dataset
#' (out <- erddap_info('noaa_pfeg_e9ae_3356_22f8'))
#' (res <- erddap_grid(out,
#'  time = c('2012-06-01','2012-06-12'),
#'  latitude = c(20, 21),
#'  longitude = c(-80, -75)
#' ))
#' }

erddap_grid <- function(x, ..., fields = 'all', stride = 1, path = "~/.rnoaa/upwell",
  overwrite = TRUE, callopts = list())
{
  x <- as.erddap(x)
  dimargs <- list(...)
  d <- attr(x, "datasetid")
  url <- sprintf("http://upwell.pfeg.noaa.gov/erddap/griddap/%s.csv", d)
  var <- field_handler(fields, x$variables$variable_name)
  dims <- dimvars(x)
  if(all(var == "none")){
    args <- paste0(sapply(dims, function(y) parse_args(x, y, stride, dimargs, wname = TRUE)), collapse = ",")
  } else {
    pargs <- sapply(dims, function(y) parse_args(x, y, stride, dimargs))
    args <- paste0(lapply(var, function(y) paste0(y, paste0(pargs, collapse = ""))), collapse = ",")
  }
  csvpath <- erd_up_GET(url, dset=d, args, bp=path, overwrite, callopts)
  structure(list(data=read_upwell(csvpath)), class="upwell_data", datasetid=d, path=csvpath)
}

field_handler <- function(x, y){
  x <- match.arg(x, c(y, "none", "all"), TRUE)
  if(length(x) == 1 && x == "all"){
    y
  } else if(all(x %in% y) || x == "none") {
    x
  }
}

parse_args <- function(.info, dim, s, dimargs, wname=FALSE){
  tmp <- if(dim %in% names(dimargs)){
    dimargs[[dim]]
  } else {
    if(dim == "time"){
      times <- c(getvar(.info, "time_coverage_start"), getvar(.info, "time_coverage_end"))
      sprintf('[(%s):%s:(%s)]', times[1], s, times[2])
    } else {
      actrange <- foo(.info$alldata[[dim]], "actual_range")
      gsub("\\s+", "", strsplit(actrange, ",")[[1]])
    }
  }
  if(length(s) > 1){
    if(!length(s) == length(dimvars(.info))) stop("Your stride vector must equal length of dimension variables", call. = FALSE)
    names(s) <- dimvars(.info)
    if(!wname)
      sprintf('[(%s):%s:(%s)]', tmp[1], s[[dim]], tmp[2])
    else
      sprintf('%s[(%s):%s:(%s)]', dim, tmp[1], s[[dim]], tmp[2])
  } else {
    if(!wname)
      sprintf('[(%s):%s:(%s)]', tmp[1], s, tmp[2])
    else
      sprintf('%s[(%s):%s:(%s)]', dim, tmp[1], s, tmp[2])
  }
}

getallvars <- function(x){
  vars <- names(x$alldata)
  vars[ !vars %in% "NC_GLOBAL" ]
}

getvars <- function(x){
  vars <- names(x$alldata)
  vars[ !vars %in% c("NC_GLOBAL","time", x$variables$variable_name) ]
}

dimvars <- function(x){
  vars <- names(x$alldata)
  vars[ !vars %in% c("NC_GLOBAL", x$variables$variable_name) ]
}

erd_up_GET <- function(url, dset, args, bp, overwrite, ...){
  dir.create(bp, showWarnings = FALSE, recursive = TRUE)
  res <- GET(url, query=args, write_disk(writepath(bp, dset), overwrite), ...)
  res$request$writer[[1]]
}

#' @export
print.upwell_data <- function(x, ..., n = 10){
  finfo <- file_info(attr(x, "path"))
  cat(sprintf("<NOAA ERDDAP Data> %s", attr(x, "datasetid")), sep = "\n")
  cat(sprintf("   Path: [%s]", attr(x, "path")), sep = "\n")
  cat(sprintf("   Last updated: [%s]", finfo$mtime), sep = "\n")
  cat(sprintf("   File size:    [%s mb]", finfo$size), sep = "\n")
  cat(sprintf("   Dimensions:   [%s X %s]\n", NROW(x$data), NCOL(x$data)), sep = "\n")
  trunc_mat(x$data, n = n)
}

file_info <- function(x){
  tmp <- file.info(x)
  row.names(tmp) <- NULL
  tmp2 <- tmp[,c('mtime','size')]
  tmp2$size <- round(tmp2$size/1000000L, 2)
  tmp2
}

writepath <- function(path, d) file.path(path, paste0(d, ".csv"))

getvar <- function(x, y){
  x$alldata$NC_GLOBAL[ x$alldata$NC_GLOBAL$attribute_name == y, "value"]
}
