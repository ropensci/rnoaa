buff <- NULL
extent <- NULL
.onLoad <- function(libname, pkgname){
  buff <<- V8::new_context();
  buff$source(system.file("js/turf-buffer.js", package = pkgname))
  
  extent <<- V8::new_context();
  extent$source(system.file("js/turf-extent.js", package = pkgname))
}
