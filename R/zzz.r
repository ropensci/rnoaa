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
    stnames <- names(jsonlite::fromJSON(utcf8(x), FALSE))
    if (!is.null(stnames)) {
      if ('developerMessage' %in% stnames || 'message' %in% stnames) {
        warning(sprintf("Error: (%s) - %s", x$status_code,
            noaa_compact(list(jsonlite::fromJSON(utcf8(x), FALSE)$developerMessage, jsonlite::fromJSON(utcf8(x), FALSE)$message))),
            call. = FALSE)
      } else {
        warning(sprintf("Error: (%s)", x$status_code), call. = FALSE)
      }
    } else {
      warn_for_status(x)
    }
  } else {
    stopifnot(x$headers$`content-type` == 'application/json;charset=UTF-8')
    res <- utcf8(x)
    out <- jsonlite::fromJSON(res, simplifyVector = FALSE)
    if (!'results' %in% names(out)) {
      if (length(out) == 0) {
        warning("Sorry, no data found", call. = FALSE)
      }
    } else {
      if ( class(try(out$results, silent = TRUE)) == "try-error" || is.null(try(out$results, silent = TRUE)) ) {
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
    res <- utcf8(x)
    if (length(res) == 0) {
      stop(http_status(x)$message, call. = FALSE)
    }
    err <- gsub("\n", "", xpathApply(res, "//error", xmlValue)[[1]])
    if (!is.null(err)) {
      if (grepl('ERROR', err, ignore.case = TRUE)) {
        warning(sprintf("(%s) - %s", x$status_code, err))
      } else {
        warn_for_status(x)
      }
    } else {
      warn_for_status(x)
    }
  } else {
    if (format == 'csv') {
      stopifnot(grepl('text/plain', x$headers$`content-type`))
      read.delim(text = utcf8(x), sep = ",")
    } else {
      stopifnot(grepl('text/xml', x$headers$`content-type`))
      xmlParse(utcf8(x))
    }
  }
}

noaa_compact <- function(l) Filter(Negate(is.null), l)

read_csv <- function(x){
  tmp <- read.csv(x, header = FALSE, sep = ",", stringsAsFactors=FALSE, skip = 3)
  nmz <- names(read.csv(x, header = TRUE, sep = ",", stringsAsFactors=FALSE, skip = 1, nrows=1))
  names(tmp) <- tolower(nmz)
  tmp
}

read_table <- function(x){
  if(inherits(x, "response")) {
    txt <- gsub('\n$', '', utcf8(x))
    read.csv(text = txt, sep = ",", stringsAsFactors=FALSE,
             blank.lines.skip=FALSE)[-1, , drop=FALSE]
  } else {
    read.delim(x, sep=",", stringsAsFactors=FALSE,
               blank.lines.skip=FALSE)[-1, , drop=FALSE]
  }
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

#Check operating system is windows
is_windows <- function() {
      .Platform$OS.type == "windows"
}

utcf8 <- function(x) httr::content(x, "text", encoding = "UTF-8")

rnoaa_cache_dir <- function() rappdirs::user_cache_dir("rnoaa")

assert_range <- function(x, y) {
  if (!x %in% y) {
    stop(sprintf("%s must be between %s and %s",
                 deparse(substitute(x)), min(y), max(y)), call. = FALSE)
  }
}

assert <- function(x, y) {
  if (!is.null(x)) {
    if (!class(x) %in% y) {
      stop(deparse(substitute(x)), " must be of class ",
           paste0(y, collapse = ", "), call. = FALSE)
    }
  }
}
