#' Get Argo buoy data
#'
#' @export
#' @name argo
#' @param limit (integer) number to return
#' @param ... Curl options passed on to \code{\link[httr]{GET}}. Optional
#' @references \url{http://www.ifremer.fr/lpo/naarc/m/docs/api/howto.html}
#' @examples \dontrun{
#' argo_search("n", limit = 3)
#' argo_search("np", limit = 3)
#' argo_search("nf", limit = 3)
#' argo_search("coord", limit = 3)
#' argo_search("fullcoord", limit = 5)
#' argo_search("list", "dac", limit = 5)
#' argo_search(qwmo = 49, limit = 3)
#' argo_search("n", box = c(-40, 35, 3, 2))
#' 
#' argo_files(wmo = 4900881)
#' }
argo_search <- function(gt = NULL, of = NULL, qwmo = NULL, 
                 wmo = NULL, box=NULL, limit = 10, ...) {
  args <- noaa_compact(list(get = gt, of = of, qwmo = qwmo, 
                            wmo = wmo, file = file, box = box, 
                            limit = limit))
  argo_GET(argo_base(), args, ...)
}

#' @export
#' @rdname argo
argo_files <- function(gt = NULL, of = NULL, qwmo = NULL, 
                       wmo = NULL, box=NULL, ...) {
  args <- noaa_compact(list(get = gt, of = of, qwmo = qwmo, 
                            wmo = wmo, file = "", box = box))
  argo_GET(argo_base(), args, ...)
}

# helpers -----------------------------------
argo_GET <- function(url, args, ...) {
  res <- GET(url, query = args, ...)
  stop_for_status(res)
  jsonlite::fromJSON(content(res, "text"))  
}

argo_base <- function() "http://www.ifremer.fr/lpo/naarc/api/v1"

# http://www.ifremer.fr/lpo/naarc/api/v1/?file&wmo=4900881
