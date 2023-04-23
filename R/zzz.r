#' Check object class
#'
#' Check if an object is of class ncdc_data, ncdc_datasets,
#' ncdc_datatypes, ncdc_datacats, ncdc_locs, ncdc_locs_cats,
#' or ncdc_stations
#'
#' @param x input
#' @export
#' @keywords internal
is.ncdc_data <- function(x) inherits(x, "ncdc_data")

#' @rdname is.ncdc_data
#' @export
#' @keywords internal
is.ncdc_datasets <- function(x) inherits(x, "ncdc_datasets")

#' @rdname is.ncdc_data
#' @export
#' @keywords internal
is.ncdc_datatypes <- function(x) inherits(x, "ncdc_datatypes")

#' @rdname is.ncdc_data
#' @export
#' @keywords internal
is.ncdc_datacats <- function(x) inherits(x, "ncdc_datacats")

#' @rdname is.ncdc_data
#' @export
#' @keywords internal
is.ncdc_locs <- function(x) inherits(x, "ncdc_locs")

#' @rdname is.ncdc_data
#' @export
#' @keywords internal
is.ncdc_locs_cats <- function(x) inherits(x, "ncdc_locs_cats")

#' @rdname is.ncdc_data
#' @export
#' @keywords internal
is.ncdc_stations <- function(x) inherits(x, "ncdc_stations")

#' Theme for plotting NOAA data
#' @export
#' @keywords internal
ncdc_theme <- function(){
  list(theme(panel.grid.major = element_blank(),
             panel.grid.minor = element_blank(),
             legend.position = c(0.7,0.6),
             legend.key = element_blank()),
       guides(col = guide_legend(nrow=1)))
}

# Function to get UTM zone from a single longitude and latitude pair
# originally from David LeBauer I think
# @param lon Longitude, in decimal degree style
# @param lat Latitude, in decimal degree style
long2utm <- function(lon, lat) {
  if(56 <= lat & lat < 64){
    if(0 <= lon & lon < 3){ 31 } else
      if(3 <= lon & lon < 12) { 32 } else { NULL }
  } else
  if(72 <= lat) {
    if(0 <= lon & lon < 9){ 31 } else
      if(9 <= lon & lon < 21) { 33 } else
        if(21 <= lon & lon < 33) { 35 } else
          if(33 <= lon & lon < 42) { 37 } else { NULL }
  }
  (floor((lon + 180)/6) %% 60) + 1
}

#' Check response from NOAA, including status codes, server error messages, mime-type, etc.
#' @keywords internal
check_response <- function(x){
  if (!x$status_code == 200) {
    res <- tryCatch(jsonlite::fromJSON(x$parse("UTF-8"), FALSE),
      error = function(e) e)
    if (inherits(res, "error")) x$raise_for_status()
    stnames <- names(res)
    if (!is.null(stnames)) {
      if ('developerMessage' %in% stnames || 'message' %in% stnames) {
        warning(sprintf("Error: (%s) - %s", x$status_code,
            noaa_compact(list(jsonlite::fromJSON(x$parse("UTF-8"), FALSE)$developerMessage,
              jsonlite::fromJSON(x$parse("UTF-8"), FALSE)$message))),
            call. = FALSE)
      } else {
        warning(sprintf("Error: (%s)", x$status_code), call. = FALSE)
      }
    } else {
      z <- x$status_http()
      warning(z$status, ": ", z$message)
    }
  } else {
    # government shutdown check
    if (
      grepl("html", x$response_headers$`content-type`) &&
      grepl("shutdown", x$parse("UTF-8"))
    ) {
      stop("there's a government shutdown; check back later")
    }
    stopifnot("wrong response type, open an issue" =
      grepl("application/json", x$response_headers$`content-type`))
    res <- x$parse("UTF-8")
    out <- jsonlite::fromJSON(res, simplifyVector = FALSE)
    if (!'results' %in% names(out)) {
      if (length(out) == 0) {
        warning("Sorry, no data found", call. = FALSE)
      }
    } else {
      res <- try(out$results, silent = TRUE)
      if (
        inherits(res, "try-error") ||
        is.null(try(out$results, silent = TRUE))
      ) {
        warning("Sorry, no data found", call. = FALSE)
      }
    }
    return( out )
  }
}

#' Check response from NOAA SWDI service, including status codes, server error messages,
#' mime-type, etc.
#' @keywords internal
check_response_swdi <- function(x, format){
  if (!x$status_code == 200) {
    res <- x$parse("UTF-8")
    if (length(res) == 0) {
      stop(x$status_http()$message)
    }
    err <- gsub("\n", "", xpathApply(res, "//error", xmlValue)[[1]])
    if (!is.null(err)) {
      if (grepl('ERROR', err, ignore.case = TRUE)) {
        warning(sprintf("(%s) - %s", x$status_code, err))
      } else {
        warning(x$status_http()$message)
      }
    } else {
      warning(x$status_http()$message)
    }
  } else {
    # government shutdown check
    if (
      grepl("html", x$response_headers$`content-type`) &&
      grepl("shutdown", x$parse("UTF-8"))
    ) {
      stop("there's a government shutdown; check back later")
    }
    if (format == 'csv') {
      stopifnot(grepl('text/plain', x$response_headers$`content-type`))
      read.delim(text = x$parse("UTF-8"), sep = ",")
    } else {
      stopifnot(grepl('text/xml', x$response_headers$`content-type`))
      txt <- x$parse("UTF-8")
      # check for no results first
      if (grepl("<count>0</count>", txt)) stop("no results found")
      # read xml
      xml2::read_xml(txt)
    }
  }
}

noaa_compact <- function(l) Filter(Negate(is.null), l)

storms_read_csv <- function(x){
  tmp <- read.csv(x, header = FALSE, sep = ",",
    stringsAsFactors=FALSE, skip = 3)
  nmz <- names(read.csv(x, header = TRUE, sep = ",",
    stringsAsFactors=FALSE, skip = 1, nrows=1))
  names(tmp) <- tolower(nmz)
  tmp
}

# This function is only used in lcd(), see R/lcd.R
safe_read_csv <- function(x, header = TRUE, stringsAsFactors = FALSE, sep = ",", col_types) {
  assert(x, "character")

  tmp <- tryCatch(
    data.table::fread(x, header = header, sep = sep,
      stringsAsFactors = stringsAsFactors, data.table = FALSE,
      colClasses = col_types),
    error = function(e) e
    # warning = function(w) w
  )
  # if (inherits(tmp, "warning"))
    # warning(tmp$message)
  if (inherits(tmp, "error"))
    stop("file ", x, " malformed; delete file and try again")
  return(tmp)
}

# This function is only used by lcd() and lcd_columns(), see R/lcd.R
check_lcd_columns <- function(x) {
  # check that col_types is a named vector
  if(is.null(names(x))) {
    message <- "col_types must be a named vector, see lcd_columns() for an example and expected names"
  } else {
    # check that user input values are proper R classes
    allowable_types <- c("character", "integer", "numeric", "factor", "integer64", "POSIXct")
    allowed <- x %in% allowable_types
    if(FALSE %in% allowed) {
      message <- paste0(names(x[which(!(allowed))]),
                        " must equal a valid R class ('character', 'integer', 'numeric', 'factor', 'integer64', 'POSIXct')",
                        collapse = "\n")} else {
                  message <- NULL }
  }
  return(message)

}


check_key <- function(x){
  tmp <- if(is.null(x)) Sys.getenv("NOAA_KEY", "") else x
  if(tmp == "") getOption("noaakey", stop("need an API key for NOAA data")) else tmp
}

# check for a package
check4pkg <- function(x) {
  if (!requireNamespace(x, quietly = TRUE)) {
    stop(sprintf("Please install '%s'", x), call. = FALSE)
  } else {
    invisible(TRUE)
  }
}

# Check operating system is windows
is_windows <- function() {
  .Platform$OS.type == "windows"
}

rnoaa_cache_dir <- function() tools::R_user_dir("rnoaa", which = "cache")

assert_range <- function(x, y) {
  if (!x %in% y) {
    stop(sprintf("%s must be between %s and %s",
                 deparse(substitute(x)), min(y), max(y)), call. = FALSE)
  }
}

assert <- function(x, y) {
  if (!is.null(x)) {
    if (!inherits(x, y)) {
      stop(deparse(substitute(x)), " must be of class ",
           paste0(y, collapse = ", "), call. = FALSE)
    }
  }
}

GET_retry <- function(url, ..., times = 3) {
  cliret <- crul::HttpClient$new(url)
  res <- suppressWarnings(cliret$get(...))
  if (res$status_code > 226) {
    message("Request failed - Retrying")
    stat <- 500
    i <- 0
    while (stat > 226 && i <= times) {
      i <- i + 1
      res <- suppressWarnings(cliret$get(...))
      stat <- res$status_code
    }
    if (res$status_code > 226) stop("Request failed, try again", call. = FALSE)
  }
  return(res)
}
