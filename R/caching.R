#' Clear cached files
#' 
#' @name caching
#' @param path Path to location of cached files. Defaults to \code{disk()$path}
#' @param force (logical) Should we force removal of files if permissions say otherwise?
#' @details BEWARE: this will clear all cached files. 

#' @export
#' @rdname caching
erddap_clear_cache <- function(path = disk(), force = FALSE) {
  files <- list.files(path$path, full.names = TRUE)
  unlink(files, recursive = TRUE, force = force)
}

#' @export 
#' @rdname caching
ghcnd_clear_cache <- function(path = "~/.rnoaa/ghcnd", force = FALSE) {
  files <- list.files(path, full.names = TRUE)
  unlink(files, recursive = TRUE, force = force)
}

cache_get <- function(cache, url, args=list(), path="~/")
{
  if(cache){
    key <- if(!identical(args, list())) make_key(url, args) else url
    hash <- digest::digest(key)
    stored_hashes <- list.files(path, full.names=TRUE, pattern=".csv")
    getname <- function(x) strsplit(x, "/")[[1]][length(strsplit(x, "/")[[1]])]
    stored_hashes_match <- gsub("\\.csv", "", sapply(stored_hashes, getname, USE.NAMES=FALSE))
    if(length(stored_hashes) == 0){
      NULL 
    } else {  
      tt <- stored_hashes[stored_hashes_match %in% hash]
      if(identical(tt, character(0))) NULL else tt
    }
  } else { NULL }
}

write_path <- function(path, url, args=list(), fmt="csv")
{
  url <- if(!identical(args, list())) make_key(url, args) else url
  hash <- digest::digest(url)
  file.path(path, paste0(hash, paste0(".", fmt), sep=""))
}

make_key <- function(url, args)
{
  tmp <- httr::parse_url(url)
  tmp$query <- args
  httr::build_url(tmp)
}
