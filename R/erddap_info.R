#' Get information on an ERDDAP dataset.
#'
#' @export
#' @importFrom jsonlite fromJSON
#' 
#' @param datasetid Dataset id
#' @param ... Further args passed on to \code{\link[httr]{GET}} (must be a named parameter)
#' @param x A datasetid or the output of \code{erddap_info}
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
#' @references  \url{http://upwell.pfeg.noaa.gov/erddap/index.html}
#' @author Scott Chamberlain <myrmecocystus@@gmail.com>
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
  json <- erdddap_GET(sprintf(paste0(eurl(), 'info/%s/index.json'), datasetid), list(), ...)
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

#' @export
#' @rdname erddap_info
as.erddap_info <- function(x) UseMethod("as.erddap_info")

#' @export
as.erddap_info.erddap_info <- function(x) x

#' @export
as.erddap_info.character <- function(x) erddap_info(x)
