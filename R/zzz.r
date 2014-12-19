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

#' Function to calculate bounding box for the extent parameter in ncdc_stations function.
#' @import rgeos
#' @export
#' @param lat Latitude, in decimal degree style
#' @param lon Longitude, in decimal degree style
#' @param radius Amount to create buffer by, in km
#' @keywords internal
#' @examples
#' latlong2bbox(lat=33.95, lon=-118.40) # radius of 10 km
#' latlong2bbox(lat=33.95, lon=-118.40, radius=2) # radius of 2 km
#' latlong2bbox(lat=33.95, lon=-118.40, radius=200) # radius of 200 km
#' latlong2bbox(lat=33.95, lon=-118.40, radius=0.02) # radius of 20 meters
latlong2bbox <- function(lat, lon, radius=10)
{
  stopifnot(is.numeric(lat), is.numeric(lon))
  stopifnot(abs(lat)<=90, abs(lon)<=180)

  # Make a spatialpoints obj, do settings, transform to UTM with zone
  d <- SpatialPoints(cbind(lon, lat), proj4string = CRS("+proj=longlat +datum=WGS84"))
  zone <- long2utm(lon=lon, lat=lat)
  dd <- spTransform(d, CRS(sprintf("+proj=utm +zone=%s +datum=WGS84 +units=m", zone)))

  # give buffer around point given radius
  inmeters <- radius*1000
  ee <- gBuffer(dd, width = inmeters)

  # transform back to decimal degree
  ff <- spTransform(ee, CRS("+proj=longlat +datum=WGS84"))

  # get bounding box, put in a vector of length 4, and return
  box <- ff@bbox
  geometry <- sprintf('%s,%s,%s,%s', box[2,1], box[1,1], box[2,2], box[1,2])
  return( geometry )
}

#' Check response from NOAA, including status codes, server error messages, mime-type, etc.
#' @keywords internal
check_response <- function(x){
  if(!x$status_code == 200){
    stnames <- names(content(x))
    if(!is.null(stnames)){
      if('developerMessage' %in% stnames|'message' %in% stnames){
        warning(sprintf("Error: (%s) - %s", x$status_code,
                        noaa_compact(list(content(x)$developerMessage, content(x)$message))))
      } else { warning(sprintf("Error: (%s)", x$status_code)) }
    } else { warn_for_status(x) }
  } else {
    stopifnot(x$headers$`content-type`=='application/json;charset=UTF-8')
    res <- content(x, as = 'text', encoding = "UTF-8")
    out <- jsonlite::fromJSON(res, simplifyVector = FALSE)
    if(!'results' %in% names(out)){
      if(length(out)==0){ warning("Sorry, no data found") }
    } else {
      if( class(try(out$results, silent=TRUE))=="try-error" | is.null(try(out$results, silent=TRUE)) )
        warning("Sorry, no data found")
    }
    return( out )
  }
}

#' Check response from NOAA, including status codes, server error messages, mime-type, etc.
#' @keywords internal
check_response_erddap <- function(x){
  if(!x$status_code == 200){
    html <- content(x)
    values <- xpathApply(html, "//u", xmlValue)
    error <- grep("Error|Resource", values, ignore.case = TRUE, value = TRUE)
    if(length(error) > 1) error <- error[1]
    #check specifically for no matching results error
    if(grepl("no matching results", error)) error <- 'Error: Your query produced no matching results.'

    if(!is.null(error)){
      if(grepl('Error|Resource not found', error, ignore.case = TRUE)){
        stop(sprintf("(%s) - %s", x$status_code, error), call. = FALSE)
      } else { stop(sprintf("Error: (%s)", x$status_code), call. = FALSE) }
    } else { stop_for_status(x) }
  } else {
    stopifnot(x$headers$`content-type`=='text/csv;charset=UTF-8')
    return( x )
  }
}

#' Check response from NOAA SWDI service, including status codes, server error messages,
#' mime-type, etc.
#' @keywords internal
check_response_swdi <- function(x, format){
  if(!x$status_code == 200){
    res <- content(x)
    err <- gsub("\n", "", xpathApply(res, "//error", xmlValue)[[1]])
    if(!is.null(err)){
      if(grepl('ERROR', err, ignore.case = TRUE)){
        warning(sprintf("(%s) - %s", x$status_code, err))
      } else { warn_for_status(x) }
    } else { warn_for_status(x) }
  } else {
    if(format=='csv'){
      stopifnot(x$headers$`content-type`=='text/plain; charset=UTF-8')
      uu <- content(x, as = 'text', encoding = "UTF-8")
      read.delim(text=uu, sep = ",")
    } else {
      stopifnot(x$headers$`content-type`=='text/xml')
      res <- content(x, as = 'text', encoding = "UTF-8")
      xmlParse(res)
    }
  }

#   if(!'results' %in% names(tt)){
#     if(length(out)==0){ warning("Sorry, no data found") }
#   } else {
#     if( class(try(out$results, silent=TRUE))=="try-error" | is.null(try(out$results, silent=TRUE)) )
#       warning("Sorry, no data found")
#   }
}

noaa_compact <- function (l) Filter(Negate(is.null), l)

read_csv <- function(x){
  tmp <- read.csv(x, header = FALSE, sep = ",", stringsAsFactors=FALSE, skip = 3)
  nmz <- names(read.csv(x, header = TRUE, sep = ",", stringsAsFactors=FALSE, skip = 1, nrows=1))
  names(tmp) <- tolower(nmz)
  tmp
}

read_upwell <- function(x){
  if(is(x, "response")) {
    x <- content(x, "text")
    tmp <- read.csv(text = x, header = FALSE, sep = ",", stringsAsFactors=FALSE, skip = 2)
    nmz <- names(read.csv(text = x, header = TRUE, sep = ",", stringsAsFactors=FALSE, nrows=1))
  } else {  
    tmp <- read.csv(x, header = FALSE, sep = ",", stringsAsFactors=FALSE, skip = 2)
    nmz <- names(read.csv(x, header = TRUE, sep = ",", stringsAsFactors=FALSE, nrows=1))
  }
  names(tmp) <- tolower(nmz)
  tmp
}

read_table <- function(x){
  if(is(x, "response")) {
    txt <- gsub('\n$', '', content(x, "text"))
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
