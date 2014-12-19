#' Clear cached files
#' 
#' @export
#' @param path Path to location of cached files. Defaults to \code{disk()$path}
#' @details BEWARE: this will clear all cached files. 
erddap_clear_cache <- function(path = disk()){
  files <- list.files(path$path, full.names = TRUE)
  unlink(files, recursive = TRUE, )
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

write_path <- function(path, url, args=list())
{
  url <- if(!identical(args, list())) make_key(url, args) else url
  hash <- digest::digest(url)
  file.path(path, paste0(hash, ".csv", sep=""))
}

make_key <- function(url, args)
{
  tmp <- httr::parse_url(url)
  tmp$query <- args
  httr::build_url(tmp)
}
