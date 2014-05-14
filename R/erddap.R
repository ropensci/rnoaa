#' Get ERDDAP data.
#'
#' @export
#' @import httr assertthat
#' @param datasetid Dataset id
#' @param fields Columns to return, as a character vector
#' @param ... Any numbe rof key-value pairs in quotes as query constraints. See Details and examples
#' @param callopts Further args passed on to httr::GET (must be a named parameter)
#' @details
#' For key-value pair query constraints, the valid operators are =, != (not equals), =~ (a regular 
#' expression test), <, <=, >, and >= . 
#' 
#' 
#' @examples \dontrun{
#' erddap_data(datasetid='erdCalCOFIfshsiz', fields=c('longitude','latitude','fish_size','itis_tsn'),
#'    'time>=' = '2001-07-07','time<=' = '2001-07-10')
#' erddap_data(datasetid='erdCinpKfmBT', fields=c('latitude','longitude',
#'    'Aplysia_californica_Mean_Density','Muricea_californica_Mean_Density'),
#'    'time>=' = '2007-06-24','time<=' = '2007-07-01')
#'
#' # An example workflow
#' (out <- erddap_search(query='fish size'))
#' id <- out$info$dataset_id[1]
#' erddap_info(datasetid=id)$variables
#' erddap_data(datasetid = id, fields = c('latitude','longitude','scientific_name'),
#'    'time>=' = '2001-07-14')
#' erddap_data(datasetid='ndbcSosWTemp', fields=c('latitude','longitude','sea_water_temperature'),
#'    'time>=' = '2014-05-12', 'sea_water_temperature!=' = 'NaN')
#' }

erddap_data <- function(datasetid, fields=NULL, ..., callopts=list()){
  fields <- paste(fields, collapse = ",")
  url <- "http://coastwatch.pfeg.noaa.gov/erddap/tabledap/%s.csv?%s"
  url <- sprintf(url, datasetid, fields)
  args <- list(...)
  args <- collapse_args(args)
  if(!nchar(args[[1]]) == 0){
    url <- paste0(url, '&', args)
  }
  tt <- GET(url, list(), callopts)
  warn_for_status(tt)
  assert_that(tt$headers$`content-type` == 'text/csv;charset=UTF-8')
  out <- content(tt, as = "text")
  df <- read.delim(text=out, sep=",")[-1,]
  return( df )
}

collapse_args <- function(x){
  outout <- list()
  for(i in seq_along(x)){
    tmp <- paste(names(x[i]), x[i], sep="")
    outout[[i]] <- tmp
  }
  paste0(outout, collapse = "&")
}

#' Get information on an ERDDAP dataset.
#'
#' @export
#' @import httr assertthat
#' @importFrom jsonlite fromJSON
#' @param datasetid Dataset id
#' @param callopts Further args passed on to httr::GET (must be a named parameter)
#' @examples \dontrun{
#' erddap_info(datasetid='erdCalCOFIfshsiz')
#' out <- erddap_info(datasetid='erdCinpKfmBT')
#' }

erddap_info <- function(datasetid, callopts=list()){
  url <- 'http://coastwatch.pfeg.noaa.gov/erddap/info/%s/index.json'
  url <- sprintf(url, datasetid)
  tt <- GET(url, list(), callopts)
  warn_for_status(tt)
  assert_that(tt$headers$`content-type` == 'application/json;charset=UTF-8')
  out <- content(tt, as = "text")
  json <- jsonlite::fromJSON(out, simplifyVector = FALSE)
  colnames <- sapply(tolower(json$table$columnNames), function(z) gsub("\\s", "_", z))
  dfs <- lapply(json$table$rows, function(x){
    tmp <- data.frame(x, stringsAsFactors = FALSE)
    names(tmp) <- colnames
    tmp
  })
  lists <- lapply(json$table$rows, function(x){
    names(x) <- colnames
    x
  })
  df <- data.frame(rbindlist(dfs))
  vars <- df[ df$row_type == 'variable', names(df) %in% c('row_type','variable_name','data_type')]
  res <- list(variables=vars, alldata=lists)
  class(res) <- "erddap_info"
  return( res )
}

# print.erddap_info <- function(x, ...){
#   x <- x[ x$row_type == 'variable', names(x) %in% c('row_type','variable_name','data_type')]
#   print(x)
# }
#   cutlength <- vapply(x[apply(x, c(1,2), nchar) > 25], substr, "", start=1, stop=25, USE.NAMES = FALSE)
#   cutlength <- paste0(cutlength, "...")
#   x[apply(x, c(1,2), nchar) > 25] <- cutlength
#   x <- data.frame(x, stringsAsFactors = FALSE)

#' Search for ERDDAP datasets.
#'
#' @export
#' @import httr assertthat
#' @param query Search terms
#' @param page Page number
#' @param page_size Results per page
#' @param callopts Further args passed on to httr::GET (must be a named parameter)
#' @param x Input to print method for class erddap_search
#' @param ... Further args to print, ignored.
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

#' @method print erddap_search
#' @export
#' @rdname erddap_search
print.erddap_search <- function(x, ...){
  cat(sprintf("%s results, showing first 20", nrow(x$info)), "\n")
  print(head(x$info, n = 20))
}
