.onAttach <- function(...) {
	packageStartupMessage("\n\n New to rnoaa? Tutorial at http://ropensci.org/tutorials/rnoaa_tutorial.html. \n A new NOAA API (v2) is out. Most functions have changed - some parameters are deprecated. \n Use suppressPackageStartupMessages() to suppress these startup messages in the future\n")
} 