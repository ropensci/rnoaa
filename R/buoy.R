#' Get NOAA buoy data from the National Buoy Data Center
#'
#' @export
#'
#' @param dataset (character) Dataset name to query. See below for Details.
#' Required
#' @param buoyid Buoy ID, can be numeric/integer/character. Required
#' @param datatype (character) Data type, one of 'c', 'cc', 'p', 'o'. Optional
#' @param year (integer) Year of data collection. Optional. Note there is
#' a special value `9999` that, if found, contains the most up to date
#' data. 
#' @param refresh (logical) Whether to use cached data (`FALSE`) or get
#' new data (`FALSE`). Default: `FALSE`
#' @param ... Curl options passed on to [crul::verb-GET]
#' Optional. A number of different HTTP requests are made internally, but 
#' we only pass this on to the request to get the netcdf file in the internal 
#' function `get_ncdf_file()`
#' 
#' @return If netcdf data has lat/lon variables, then we'll parse into a 
#' tidy data.frame. If not, we'll give back the ncdf4 object for the user
#' to parse (in which case the data.frame will be empty).
#'
#' @details Functions:
#'
#' - buoy_stations - Get buoy stations. A cached version of the dataset
#'  is available in the package. Beware, takes a long time to run if you
#'  do `refresh = TRUE`
#' - buoys - Get available buoys given a dataset name
#' - buoy - Get data given some combination of dataset name, buoy ID,
#'  year, and datatype
#'
#' Options for the dataset parameter. One of:
#' 
#' - adcp - Acoustic Doppler Current Profiler data
#' - adcp2 - MMS Acoustic Doppler Current Profiler data
#' - cwind - Continuous Winds data
#' - dart - Deep-ocean Assessment and Reporting of Tsunamis data
#' - mmbcur - Marsh-McBirney Current Measurements data
#' - ocean - Oceanographic data
#' - pwind - Peak Winds data
#' - stdmet - Standard Meteorological data
#' - swden - Spectral Wave Density data with Spectral Wave Direction data
#' - wlevel - Water Level data
#' 
#' @references http://www.ndbc.noaa.gov/, http://dods.ndbc.noaa.gov/
#' @examples \dontrun{
#' if (crul::ok("https://dods.ndbc.noaa.gov/thredds", timeout_ms = 1000)) {
#' 
#' # Get buoy station information
#' x <- buoy_stations()
#' # refresh stations as needed, takes a while to run
#' # you shouldn't need to update very often
#' # x <- buoy_stations(refresh = TRUE)
#' if (interactive() && requireNamespace("leaflet")){
#' library("leaflet")
#' z <- leaflet(data = na.omit(x))
#' z <- leaflet::addTiles(z)
#' leaflet::addCircles(z, ~lon, ~lat, opacity = 0.5)
#' }
#' 
#' # year=9999 to get most current data - not always available
#' buoy(dataset = "swden", buoyid = 46012, year = 9999)
#'
#' # Get available buoys
#' buoys(dataset = 'cwind')
#'
#' # Get data for a buoy
#' ## if no year or datatype specified, we get the first file
#' buoy(dataset = 'cwind', buoyid = 46085)
#'
#' # Including specific year
#' buoy(dataset = 'cwind', buoyid = 41001, year = 1999)
#'
#' # Including specific year and datatype
#' buoy(dataset = 'cwind', buoyid = 45005, year = 2008, datatype = "c")
#' buoy(dataset = 'cwind', buoyid = 41001, year = 1997, datatype = "c")
#'
#' # Other datasets
#' buoy(dataset = 'ocean', buoyid = 41029)
#'
#' # curl debugging
#' buoy(dataset = 'cwind', buoyid = 46085, verbose = TRUE)
#'
#' # some buoy ids are character, case doesn't matter, we'll account for it
#' buoy(dataset = "stdmet", buoyid = "VCAF1")
#' buoy(dataset = "stdmet", buoyid = "wplf1")
#' buoy(dataset = "dart", buoyid = "dartu")
#' 
#' }
#' }
buoy <- function(dataset, buoyid, year = NULL, datatype = NULL, ...) {
  check4pkg("ncdf4")
  availbuoys <- buoys(dataset)
  buoyid <- tolower(buoyid)
  page <- availbuoys[grep(buoyid, availbuoys$id, ignore.case = TRUE), "url"]
  if (length(page) == 0) stop("No data files found, try a different search")
  files <- buoy_files(path = page, buoyid)
  if (length(files) == 0) stop("No data files found, try a different search")
  fileuse <- pick_year_type(files, year, datatype)
  if (length(fileuse) == 0) stop("No data files found, try a different search")
  toget <- buoy_single_file_url(dataset, buoyid, fileuse)
  output <- tempdir()
  ncfile <- get_ncdf_file(path = toget, buoyid, file = files[[1]], output, ...)
  buoy_collect_data(ncfile)
}

pick_year_type <- function(x, y, z) {
  if (is.null(y) && is.null(z)) {
    message("Using ", x[[1]])
    return(x[[1]])
  } else if (is.null(z) && !is.null(y)) {
    tt <- pickme(y, x)
    message("Using ", tt)
    return(tt)
  } else if (is.null(y) && !is.null(z)) {
    tt <- pickme(z, x)
    message("Using ", tt)
    return(tt)
  } else {
    pickme(paste0(z, y), x)
  }
}

pickme <- function(findme, against) {
  tmp <- grep(findme, against, value = TRUE)
  if (length(tmp) > 1) tmp[1] else tmp
}

#' @export
#' @rdname buoy
buoys <- function(dataset) {
  url <- sprintf('https://dods.ndbc.noaa.gov/thredds/catalog/data/%s/catalog.html', dataset)
  res <- crul::HttpClient$new(url)$get()
  tt <- res$parse("UTF-8")
  html <- htmlParse(tt)
  folders <- xpathSApply(html, "//a//tt", xmlValue)
  folders <- grep("/", folders, value = TRUE)
  tmp <- paste0(sprintf('https://dods.ndbc.noaa.gov/thredds/catalog/data/%s/', dataset), folders, "catalog.html")
  data.frame(id = gsub("/", "", folders), url = tmp, stringsAsFactors = FALSE)
}

# Get NOAA buoy data from the National Buoy Data Center
buoy_files <- function(path, buoyid){
  res <- crul::HttpClient$new(path)$get()
  tt_sbf <- res$parse("UTF-8")
  html_sbf <- htmlParse(tt_sbf)
  files_sbf <- grep(".nc$", xpathSApply(html_sbf, "//a//tt", xmlValue), value = TRUE)
  gsub(tolower(buoyid), "", files_sbf)
}

# Make url for a single NOAA buoy data file
buoy_single_file_url <- function(dataset, buoyid, file){
  sprintf('https://dods.ndbc.noaa.gov/thredds/fileServer/data/%s/%s/%s%s',
          dataset, buoyid, buoyid, file)
}

# Download a single ncdf file
get_ncdf_file <- function(path, buoyid, file, output, ...){
  outpath <- sprintf("%s/%s%s", output, buoyid, file)
  res <- crul::HttpClient$new(path, opts = list(...))$get(disk = outpath)
  return(res$content)
}

# Download a single ncdf file
buoy_collect_data <- function(path) {
  nc <- ncdf4::nc_open(path)
  dims <- names(nc$dim)

  # check if likely on a lat/lon grid, or not; if not, throw message
  if (
    !any(c('lat', 'latitude') %in% dims) && 
    !any(c('lon', 'longitude') %in% dims)
  ) {
    warning("data not on lat/lon grid - not reading in data; see help")
    res <- structure(list(meta = nc, data = data.frame(NULL)),
      class = "buoy")
    return(res)
  }

  out <- list()
  for (i in seq_along(dims)) {
    out[[dims[i]]] <- ncdf4::ncvar_get(nc, nc$dim[[dims[i]]])
  }
  out$time <- sapply(out$time, convert_time)

  vars <- names(nc$var)
  outvars <- list()
  for (i in seq_along(vars)) {
    outvars[[ vars[i] ]] <- as.vector(ncdf4::ncvar_get(nc, vars[i]))
  }
  df <- do.call("cbind.data.frame", outvars)

  rows <- length(outvars[[1]])
  time <- rep(out$time, each = rows/length(out$time))
  lat <- rep(rep(out$latitude, each = length(out$longitude)), length(out$time))
  lon <- rep(rep(out$longitude, times = length(out$latitude)), times = length(out$time))
  meta <- data.frame(time, lat, lon, stringsAsFactors = FALSE)
  alldf <- cbind(meta, df)

  nms <- c('name','prec','units','longname','missval','hasAddOffset','hasScaleFact')
  meta <- lapply(vars, function(x) nc$var[[x]][names(nc$var[[x]]) %in% nms])
  names(meta) <- vars

  on.exit(ncdf4::nc_close(nc))
  structure(list(meta = meta, data = tibble::as_tibble(alldf)), class = "buoy")
}

#' @export
print.buoy <- function(x, ...) {
  vars <- names(x$meta)
  dims <- dim(x$data)
  cat(sprintf('Dimensions (rows/cols): [%s X %s]', dims[1], dims[2]), "\n")
  cat(sprintf('%s variables: [%s]', length(vars), paste0(vars, collapse = ", ")),
    "\n\n")
  if (NROW(x$data) > 0) {
    print(x$data)
  } else if (inherits(x$meta, "ncdf4")) {
    cat("Data not on lat/lon grid; see x$meta for ncdf4 object",
      sep = "\n")
  }
}

convert_time <- function(n = NULL, isoTime = NULL) {
  format(as.POSIXct(noaa_compact(list(n, isoTime))[[1]], origin = "1970-01-01T00:00:00Z", tz = "UTC"),
         format = "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
}

#' @export
#' @rdname buoy
buoy_stations <- function(refresh = FALSE, ...) {
  if (refresh) {
    # get station urls
    cli <- crul::HttpClient$new('https://www.ndbc.noaa.gov/to_station.shtml', 
      opts = list(...))
    res <- cli$get()
    html <- read_html(res$parse("UTF-8"))

    sta_urls <- file.path(
      'https://www.ndbc.noaa.gov',
      xml_attr(
        xml_find_all(
          html,
          "//a[contains(@href,'station_page.php?station')]"),
        "href"
      )
    )

    # async it
    sta_urls_cli <- crul::Async$new(urls = sta_urls)
    sta_out <- sta_urls_cli$get()
    # FIXME: just remove failures for now. 
    #   probably should do some error catching here ....
    sta_out <- Filter(function(x) x$status_code < 300, sta_out)

    # get station IDs
    stations <- vapply(sta_out, function(z) {
      strsplit(str_extract_(z$url, "station=.+"), "=")[[1]][[2]]
    }, "")

    # get individual station metadata
    tt <- Map(function(w, sttt) {
      html <- read_html(w$parse("UTF-8"))
      dc <- sapply(xml_find_all(html, "//meta[@name]"), function(z) {
        as.list(stats::setNames(xml_attr(z, "content"), xml_attr(z, "name")))
      })
      as_tibble(c(
        station = sttt,
        lat = {
          val <- str_extract_(dc$DC.description, "[0-9]+\\.[0-9]+[NS]")
          num <- as.numeric(str_extract_(val, "[0-9]+\\.[0-9]+"))
          if (length(num) == 0) {
            NA
          } else {
            if (grepl("S", val)) num * -1 else num
          }
        },
        lon = {
          val <- str_extract_(dc$DC.description, "[0-9]+\\.[0-9]+[EW]")
          num <- as.numeric(str_extract_(val, "[0-9]+\\.[0-9]+"))
          if (length(num) == 0) {
            NA
          } else {
            if (grepl("W", val)) num * -1 else num
          }
        },
        dc
      ))
    }, sta_out, stations)
    dplyr::bind_rows(tt)
  } else {
    readRDS(system.file("extdata", "buoy_station_data.rds", package = "rnoaa"))
  }
}
