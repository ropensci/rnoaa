#' Search for ERDDAP tabledep or griddap datasets.
#'
#' @export
#'
#' @param query (character) Search terms
#' @param page (integer) Page number
#' @param page_size (integer) Results per page
#' @param which (character) One of tabledep or griddap.
#' @param ... Further args passed on to \code{\link[httr]{GET}} (must be a named parameter)
#' @references  \url{http://upwell.pfeg.noaa.gov/erddap/index.html}
#' @author Scott Chamberlain <myrmecocystus@@gmail.com>
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
  args <- noaa_compact(list(searchFor=query, page=page, itemsPerPage=page_size))
  json <- erdddap_GET(paste0(eurl(), 'search/index.json'), args, ...)
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
  stopifnot(tt$headers$`content-type` == 'application/json;charset=UTF-8')
  out <- content(tt, as = "text")
  jsonlite::fromJSON(out, FALSE)
}

table_or_grid <- function(datasetid){
  table_url <- paste0(eurl(), 'tabledap/index.json')
  tab <- toghelper(table_url)
  if(datasetid %in% tab) "tabledap" else "griddap"
}

toghelper <- function(url){
  out <- erdddap_GET(url, list(page=1, itemsPerPage=10000L))
  nms <- out$table$columnNames
  lists <- lapply(out$table$rows, setNames, nm=nms)
  vapply(lists, "[[", "", "Dataset ID")
}

#' @export
#' @rdname erddap_search
erddap_datasets <- function(which = 'tabledap'){
  which <- match.arg(which, c("tabledap","griddap"), FALSE)
  url <- sprintf('%s%s/index.json', eurl(), which)
  out <- erdddap_GET(url, list(page=1, itemsPerPage=10000L))
  nms <- out$table$columnNames
  lists <- lapply(out$table$rows, setNames, nm=nms)
  data.frame(rbindlist(lapply(lists, data.frame)), stringsAsFactors = FALSE)
}
