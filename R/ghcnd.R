#' Get GHCND daily data from NOAA FTP server
#'
#' @export
#'
#' @param stationid Stationid to get
#' @param path (character) A path to store the files, Default: \code{~/.rnoaa/isd}
#' @param overwrite (logical) To overwrite the path to store files in or not, Default: TRUE.
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#'
#' @examples \dontrun{
#' # Get metadata
#' ghcnd_states()
#' ghcnd_countries()
#' ghcnd_version()
#' 
#' # Get stations, ghcnd-stations and ghcnd-inventory merged
#' (stations <- ghcnd_stations())
#'
#' # Get data
#' ghcnd(stationid="AGE00147704")
#' ghcnd(stations$id[40])
#' ghcnd(stations$id[4000])
#' ghcnd(stations$id[10000])
#' ghcnd(stations$id[80000])
#'
#' library("dplyr")
#' dat <- ghcnd(stations$id[10000])
#' dat$data %>%
#'    filter(element == "PRCP", year == 1884)
#' }

ghcnd <- function(stationid, path = "~/.rnoaa/ghcnd", overwrite = TRUE, ...)
{
  csvpath <- ghcnd_local(stationid, path)
  if(!is_ghcnd(x = csvpath)){
    structure(list(data=ghcnd_GET(path, stationid, overwrite, ...)), class="ghcnd")
  } else {
    structure(list(data=read.csv(csvpath, stringsAsFactors = FALSE)), class="ghcnd")
  }
}

#' @export
print.ghcnd <- function(x, ..., n = 10){
  cat("<GHCND Data>", sep = "\n")
  cat(sprintf("Size: %s X %s\n", NROW(x$data), NCOL(x$data)), sep = "\n")
  trunc_mat_(x$data, n = n)
}

#' @export
#' @rdname ghcnd
ghcnd_stations <- function(..., n = 10){
  sta <- get_stations(...)
  inv <- get_inventory(...)
  structure(list(data=merge(sta, inv[,-c(2,3)], by = "id")), class = "ghcnd_stations")
}

#' @export
print.ghcnd_stations <- function(x, ..., n = 10){
  cat("<GHCND Station Data>", sep = "\n")
  cat(sprintf("Size: %s X %s\n", NROW(x$data), NCOL(x$data)), sep = "\n")
  trunc_mat_(x$data, n = n)
}

get_stations <- function(...){
  res <- suppressWarnings(GET("ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-stations.txt", ...))
  df <- read.fwf(textConnection(content(res, "text")), widths = c(11, 9, 11, 7, 33, 5, 10), header = FALSE, strip.white=TRUE, comment.char="", stringsAsFactors=FALSE)
  nms <- c("id","latitude", "longitude", "elevation", "name", "gsn_flag", "wmo_id")
  setNames(df, nms)
}

get_inventory <- function(...){
  res <- suppressWarnings(GET("ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-inventory.txt", ...))
  df <- read.fwf(textConnection(content(res, "text")), widths = c(11, 9, 10, 5, 5, 5), header = FALSE, strip.white=TRUE, comment.char="", stringsAsFactors=FALSE)
  nms <- c("id","latitude", "longitude", "element", "first_year", "last_year")
  setNames(df, nms)
}

#' @export
#' @rdname ghcnd
ghcnd_states <- function(...){
  res <- suppressWarnings(GET("ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-states.txt", ...))
  df <- read.fwf(textConnection(content(res, "text")), widths = c(2, 27), header = FALSE, strip.white=TRUE, comment.char="", stringsAsFactors=FALSE, col.names = c("code","name"))
  df[ -NROW(df) ,]
}

#' @export
#' @rdname ghcnd
ghcnd_countries <- function(...){
  res <- suppressWarnings(GET("ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-countries.txt", ...))
  df <- read.fwf(textConnection(content(res, "text")), widths = c(2, 47), header = FALSE, strip.white=TRUE, comment.char="", stringsAsFactors=FALSE, col.names = c("code","name"))
  df[ -NROW(df) ,]
}

#' @export
#' @rdname ghcnd
ghcnd_version <- function(...){
  res <- suppressWarnings(GET("ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-version.txt", ...))
  content(res, "text")
}

ghcnd_GET <- function(bp, stationid, overwrite, ...){
  dir.create(bp, showWarnings = FALSE, recursive = TRUE)
  fp <- ghcnd_local(stationid, bp)
  res <- suppressWarnings(GET(ghcnd_remote(stationid), ...))
  tt <- content(res, "text")
  vars <- c("id","year","month","element",do.call("c", lapply(1:31, function(x) paste0(c("VALUE","MFLAG","QFLAG","SFLAG"), x))))
  df <- read.fwf(textConnection(tt), c(11,4,2,4,rep(c(5,1,1,1), 31)))
  dat <- setNames(df, vars)
  write.csv(dat, fp, row.names = FALSE)
  return(dat)
  # res$request$writer[[1]]
}

ghcnd_remote <- function(stationid) file.path(ghcndbase(), paste0(stationid, ".dly"))
ghcnd_local <- function(stationid, path) file.path(path, paste0(stationid, ".dly"))
is_ghcnd <- function(x) if(file.exists(x)) TRUE else FALSE
ghcndbase <- function() "ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/all"
