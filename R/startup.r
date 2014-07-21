.onAttach <- function(...) {
	packageStartupMessage("\n\n New to rnoaa? See package vignettes, and see the tutorial at http://ropensci.org/tutorials/rnoaa_tutorial.html. \n A new NOAA API (v2) is out. Most functions have changed. \n Use suppressPackageStartupMessages() to suppress these startup messages in the future\n")
} 