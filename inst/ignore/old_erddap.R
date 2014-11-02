#' Search for ERDDAP datasets.
#'
#' @export
#' @import httr assertthat
#' @param query Search terms
#' @param page Page number
#' @param page_size Results per page
#' @param callopts Further args passed on to httr::GET (must be a named parameter)
#' @examples \dontrun{
#' (out <- erddap_search(query='fish size'))
#' out$alldata
#' (out <- erddap_search(query='size'))
#' out$info
#' }

erddap_search <- function(query, page=NULL, page_size=NULL, callopts=list()){
  url <- 'http://coastwatch.pfeg.noaa.gov/erddap/search/index.json'
  args <- noaa_compact(list(searchFor=query, page=page, itemsPerPage=page_size))
  tt <- GET(url, query=args, callopts)
  warn_for_status(tt)
  assert_that(tt$headers$`content-type` == 'application/json;charset=UTF-8')
  out <- content(tt, as = "text")
  json <- jsonlite::fromJSON(out, simplifyVector = FALSE)
  colnames <- vapply(tolower(json$table$columnNames), function(z) gsub("\\s", "_", z), "", USE.NAMES = FALSE)
  dfs <- lapply(json$table$rows, function(x){
    names(x) <- colnames
    x <- x[c('title','dataset_id')]
    data.frame(x, stringsAsFactors = FALSE)
  })
  df <- data.frame(rbindlist(dfs))
  lists <- lapply(json$table$rows, function(x){
    names(x) <- colnames
    x
  })
  res <- list(info=df, alldata=lists)
  class(res) <- "erddap_search"
  return( res )
}

#' @export
print.erddap_search <- function(x, ...){
  cat(sprintf("%s results, showing first 20", nrow(x$info)), "\n")
  print(head(x$info, n = 20))
}


#' Get information on an ERDDAP dataset.
#' 
#' Gives back a brief data.frame for quick inspection and a list of more complete
#' metadata on the dataset.
#'
#' @export
#' @import httr assertthat
#' @importFrom jsonlite fromJSON
#' @param datasetid Dataset id
#' @param callopts Further args passed on to httr::GET (must be a named parameter)
#' @return A list of length two
#' \itemize{
#'  \item variables Data.frame of variables and their types
#'  \item alldata List of data variables and their full attributes
#' }
#' @examples \dontrun{
#' erddap_info(datasetid='erdCalCOFIfshsiz')
#' out <- erddap_info(datasetid='erdCinpKfmBT')
#' ## See brief overview of the variables and range of possible values, if given
#' out$variables
#' ## all information on longitude
#' out$alldata$longitude
#' ## all information on Haliotis_corrugata_Mean_Density
#' out$alldata$Haliotis_corrugata_Mean_Density
#' }

erddap_info <- function(datasetid, callopts=list()){
  url <- 'http://coastwatch.pfeg.noaa.gov/erddap/info/%s/index.json'
  url <- sprintf(url, datasetid)
  tt <- GET(url, list(), callopts)
  warn_for_status(tt)
  assert_that(tt$headers$`content-type` == 'application/json;charset=UTF-8')
  out <- content(tt, as = "text")
  json <- jsonlite::fromJSON(out, simplifyVector = FALSE)
  colnames <- vapply(tolower(json$table$columnNames), function(z) gsub("\\s", "_", z), "", USE.NAMES = FALSE)
  dfs <- lapply(json$table$rows, function(x){
    tmp <- data.frame(x, stringsAsFactors = FALSE)
    names(tmp) <- colnames
    tmp
  })
  lists <- lapply(json$table$rows, function(x){
    names(x) <- colnames
    x
  })
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
  res <- list(variables=vars, alldata=outout)
  class(res) <- "erddap_info"
  return( res )
}
