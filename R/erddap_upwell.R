#' Get ERDDAP UPWELL data.
#'
#' @export
#' @param time
#' @param altitude
#' @param latitude
#' @param longitude
#' @param stride (integer) How many values to get. 1 = get every value, 2 = get every other value,
#' etc. Default: 1 (i.e., get every value)
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
#' out <- erddap_info('noaa_esrl_027d_0fb5_5d38')
#' summary(out)
#' (res <- erddap_upwell_data(out,
#'  time = c('2012-01-01','2012-06-12'),
#'  latitude = c(21, 18),
#'  longitude = c(-80, -75)
#' ))
#'
#' # multi-variable dataset
#' out <- erddap_info('noaa_gfdl_5081_7d4a_7570')
#' summary(out)
#' (res <- erddap_upwell_data(out,
#'  time = c('2005-11-01','2006-01-01'),
#'  latitude = c(20, 21),
#'  longitude = c(10, 11)
#' ))
#' (res <- erddap_upwell_data(out, time = c('2005-11-01','2006-01-01'), latitude = c(20, 21),
#' longitude = c(10, 11), fields = 'uo'))
#' (res <- erddap_upwell_data(out, time = c('2005-11-01','2006-01-01'), latitude = c(20, 21),
#' longitude = c(10, 11), fields = 'uo', stride=c(1,2,1,2)))
#' (res <- erddap_upwell_data(out, time = c('2005-11-01','2006-01-01'), latitude = c(20, 21),
#' longitude = c(10, 11), fields = c('uo','so')))
#' (res <- erddap_upwell_data(out, time = c('2005-09-01','2006-01-01'), latitude = c(20, 21),
#' longitude = c(10, 11), fields = 'none'))
#'
#' # multi-variable dataset
#' ## this one also has a 0-360 longitude system, BLARGH!!!
#' out <- erddap_info('noaa_gfdl_3c96_7879_a9d3')
#' summary(out)
#' (res <- erddap_upwell_data(out,
#'  time = c('2005-11-01','2006-01-01'),
#'  latitude = c(20, 22),
#'  longitude = c(-80, -75)
#' ))
#' (res <- erddap_upwell_data(out,
#'  time = c('2005-11-01','2006-01-01'),
#'  latitude = c(20, 22),
#'  longitude = c(-80, -75),
#'  depth = c(5, 50)
#' ))
#'
#' # single variable dataset
#' out <- erddap_info('noaa_pfeg_e9ae_3356_22f8')
#' summary(out)
#' (res <- erddap_upwell_data(out,
#'  time = c('2012-06-01','2012-06-12'),
#'  latitude = c(20, 21),
#'  longitude = c(-80, -75)
#' ))
#'
#' dimargs <- list(time=c('2012-06-01','2012-06-12'), latitude=c(20, 21), longitude=c(-80, -75))
#' }

erddap_upwell_data <- function(.info, ..., fields = 'all', stride = 1, path = "~/.rnoaa/upwell",
  overwrite = TRUE, callopts = list())
{
  dimargs <- list(...)
  d <- attr(.info, "datasetid")
  url <- sprintf("http://upwell.pfeg.noaa.gov/erddap/griddap/%s.csv", d)
  var <- field_handler(fields, .info$variables$variable_name)
  dims <- dimvars(.info)
  if(all(var == "none")){
    args <- paste0(sapply(dims, function(x) parse_args(.info, x, stride, dimargs, wname = TRUE)), collapse = ",")
  } else {
    pargs <- sapply(dims, function(x) parse_args(.info, x, stride, dimargs))
    args <- paste0(lapply(var, function(x) paste0(x, paste0(pargs, collapse = ""))), collapse = ",")
  }
  csvpath <- erd_up_GET(url, dset=d, args, bp=path, overwrite, callopts)
  structure(list(data=read_upwell(csvpath)), class="upwell_data", datasetid=d, path=csvpath)
}

field_handler <- function(x, y){
  x <- match.arg(x, c(y, "none", "all"), TRUE)
  if(length(x) == 1 && x == "all"){
    y
  } else if(all(x %in% y)) {
    x
  } else if(x == "none") {
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

#' Get information on an ERDDAP dataset.
#'
#' @export
#' @import httr assertthat
#' @importFrom jsonlite fromJSON
#' @param datasetid Dataset id
#' @param ... Further args passed on to \code{\link[httr]{GET}} (must be a named parameter)
#' @return Prints a summary of the data on return, but you can index to various information. 
#' 
#' The data is a list of length two with:
#' \itemize{
#'  \item variables - Data.frame of variables and their types
#'  \item alldata - List of data variables and their full attributes
#' }
#' Where \code{alldata} element has many data.frame's, one for each variable, with metadata 
#' for that variable. E.g., for griddap dataset \code{noaa_pfeg_696e_ec99_6fa6}, \code{alldata}
#' has:
#' \itemize{
#'  \item NC_GLOBAL
#'  \item time
#'  \item latitude
#'  \item longitude
#'  \item sss
#' }
#' @examples \dontrun{
#' # grid dap datasets
#' erddap_info('noaa_pfeg_696e_ec99_6fa6')
#' erddap_info('noaa_ngdc_34bf_a95c_7e28')
#'
#' (out <- erddap_search(query='temperature'))
#' erddap_info(out$info$dataset_id[5])
#' erddap_info(out$info$dataset_id[15])
#' erddap_info(out$info$dataset_id[25])
#' erddap_info(out$info$dataset_id[33])
#' erddap_info(out$info$dataset_id[65])
#' erddap_info(out$info$dataset_id[150])
#' erddap_info(out$info$dataset_id[400])
#' erddap_info(out$info$dataset_id[678])
#'
#' out <- erddap_info(datasetid='noaa_ngdc_34bf_a95c_7e28')
#' ## See brief overview of the variables and range of possible values, if given
#' out$variables
#' ## all information on longitude
#' out$alldata$longitude
#' ## all information on Climatological_Temperature
#' out$alldata$Climatological_Temperature
#'
#' # table dap datasets
#' (out <- erddap_search(query='temperature', which = "table"))
#' erddap_info(out$info$dataset_id[1])
#' erddap_info(out$info$dataset_id[2])
#' erddap_info(out$info$dataset_id[3])
#' erddap_info(out$info$dataset_id[4])
#' erddap_info(out$info$dataset_id[54])
#' 
#' erddap_info(datasetid='erdCalCOFIfshsiz')
#' out <- erddap_info(datasetid='erdCinpKfmBT')
#' ## See brief overview of the variables and range of possible values, if given
#' out$variables
#' ## all information on longitude
#' out$alldata$longitude
#' ## all information on Haliotis_corrugata_Mean_Density
#' out$alldata$Haliotis_corrugata_Mean_Density
#' }

erddap_info <- function(datasetid, ...){
  url <- 'http://upwell.pfeg.noaa.gov/erddap/info/%s/index.json'
  json <- erdddap_GET(sprintf(url, datasetid), list(), ...)
  colnames <- vapply(tolower(json$table$columnNames), function(z) gsub("\\s", "_", z), "", USE.NAMES = FALSE)
  dfs <- lapply(json$table$rows, function(x){
    tmp <- data.frame(x, stringsAsFactors = FALSE)
    names(tmp) <- colnames
    tmp
  })
  lists <- lapply(json$table$rows, setNames, nm=colnames)
  names(lists) <- vapply(lists, function(b) b$variable_name, "", USE.NAMES = FALSE)
  outout <- list()
  for(i in seq_along(lists)){
    outout[[names(lists[i])]] <- unname(lists[ names(lists) %in% names(lists)[i] ])
  }

  df <- data.frame(rbindlist(dfs))
  vars <- df[ df$row_type == 'variable', names(df) %in% c('variable_name','data_type')]
  actual <- vapply(split(df, df$variable_name), function(z){
    tmp <- z[ z$attribute_name %in% 'actual_range' , "value"]
    if(length(tmp)==0) "" else tmp
  }, "")
  actualdf <- data.frame(variable_name=names(actual), actual_range=unname(actual))
  vars <- merge(vars, actualdf, by="variable_name")
  oo <- lapply(outout, function(x) data.frame(rbindlist(x)))
  structure(list(variables=vars, alldata=oo),
            class="erddap_info",
            datasetid=datasetid,
            type=table_or_grid(datasetid))
}

#' @export
print.erddap_info <- function(x, ...){
  global <- x$alldata$NC_GLOBAL
  tt <- global[ global$attribute_name %in% c('time_coverage_end','time_coverage_start'), "value", ]
  dims <- x$alldata[dimvars(x)]
  vars <- x$alldata[x$variables$variable_name]
  cat(sprintf("<ERDDAP Dataset> %s", attr(x, "datasetid")), "\n")
  if(attr(x, "type") == "griddap") cat(" Dimensions (range): ", "\n")
  for(i in seq_along(dims)){
    if(names(dims[i]) == "time"){
      cat(sprintf("     time: (%s, %s)", tt[2], tt[1]), "\n")
    } else {
      cat(sprintf("     %s: (%s)", names(dims[i]), foo(dims[[i]], "actual_range")), "\n")
    }
  }
  cat(" Variables: ", "\n")
  for(i in seq_along(vars)){
    cat(sprintf("     %s:", names(vars[i])), "\n")
    ar <- foo(vars[[i]], "actual_range")
    if(!length(ar) == 0) cat("         Range:", foo(vars[[i]], "actual_range"), "\n")
    un <- foo(vars[[i]], "units")
    if(!length(un) == 0) cat("         Units:", foo(vars[[i]], "units"), "\n")
  }
}

foo <- function(x, y){
  x[ x$attribute_name == y, "value"]
}

#' Search for ERDDAP tabledep or griddap datasets.
#'
#' @export
#'
#' @param query (character) Search terms
#' @param page (integer) Page number
#' @param page_size (integer) Results per page
#' @param which (character) One of tabledep or griddap.
#' @param ... Further args passed on to \code{\link[httr]{GET}} (must be a named parameter)
#' @examples \dontrun{
#' (out <- erddap_search(query='temperature'))
#' out$alldata[[1]]
#' (out <- erddap_search(query='size'))
#' out$info
#'
#' # List datasets
#' head( erddap_datasets('table') )
#' head( erddap_datasets('grid') )
#' }

erddap_search <- function(query, page=NULL, page_size=NULL, which='griddap', ...){
  which <- match.arg(which, c("tabledap","griddap"), FALSE)
  url <- 'http://upwell.pfeg.noaa.gov/erddap/search/index.json'
  args <- noaa_compact(list(searchFor=query, page=page, itemsPerPage=page_size))
  json <- erdddap_GET(url, args, ...)
  colnames <- vapply(tolower(json$table$columnNames), function(z) gsub("\\s", "_", z), "", USE.NAMES = FALSE)
  dfs <- lapply(json$table$rows, function(x){
    names(x) <- colnames
    x <- x[c('title','dataset_id')]
    data.frame(x, stringsAsFactors = FALSE)
  })
  df <- data.frame(rbindlist(dfs))
  lists <- lapply(json$table$rows, setNames, nm=colnames)
  df$gd <- vapply(lists, function(x) if(x$griddap == "") "tabledap" else "griddap", character(1))
  df <- df[ df$gd == which, -3 ]
  res <- list(info=df, alldata=lists)
  structure(res, class="erddap_search")
}

#' @export
print.erddap_search <- function(x, ...){
  cat(sprintf("%s results, showing first 20", nrow(x$info)), "\n")
  print(head(x$info, n = 20))
}

erdddap_GET <- function(url, args, ...){
  tt <- GET(url, query=args, ...)
  warn_for_status(tt)
  assert_that(tt$headers$`content-type` == 'application/json;charset=UTF-8')
  out <- content(tt, as = "text")
  jsonlite::fromJSON(out, FALSE)
}

table_or_grid <- function(datasetid){
  table_url <- 'http://upwell.pfeg.noaa.gov/erddap/tabledap/index.json'
  grid_url <- 'http://upwell.pfeg.noaa.gov/erddap/griddap/index.json'
  tab <- toghelper(table_url)
#   grd <- toghelper(grid_url)
  if(datasetid %in% tab) "tabledap" else "griddap"
#   if(datasetid %in% grd) "griddap"
}

toghelper <- function(url){
  out <- erdddap_GET(url, list(page=1, itemsPerPage=10000L))
  nms <- out$table$columnNames
  lists <- lapply(out$table$rows, setNames, nm=nms)
  vapply(lists, "[[", "", "Dataset ID")
}


#' List datasets for either tabledap or griddap
#' @export
#' @param which One of tabledap or griddap
#' @rdname  erddap_search
erddap_datasets <- function(which = 'tabledap'){
  which <- match.arg(which, c("tabledap","griddap"), FALSE)
  url <- sprintf('http://upwell.pfeg.noaa.gov/erddap/%s/index.json', which)
  out <- erdddap_GET(url, list(page=1, itemsPerPage=10000L))
  nms <- out$table$columnNames
  lists <- lapply(out$table$rows, setNames, nm=nms)
  data.frame(rbindlist(lapply(lists, data.frame)), stringsAsFactors = FALSE)
}
