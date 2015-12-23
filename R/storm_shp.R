#' @export
#' @rdname storms
storm_shp <- function(basin=NULL, storm=NULL, year=NULL, type="points", 
                      path="~/.rnoaa/storms", overwrite = TRUE) {
  
  shppath <- shp_local(basin, storm, year, path, type)
  if (!is_shpstorm(x = shppath)) {
    shppath <- shpstorm_GET(path, basin, storm, year, type, overwrite)
  }
  structure(list(path = spth(shppath)), class = "storm_shp", 
            basin = basin, storm = storm, year = year, type = type)
}

#' @export
#' @rdname storms
storm_shp_read <- function(x) {
  check4pkg("rgdal")
  readshp2(x$path, filepath2(attr(x, 'basin'), attr(x, 'storm'), attr(x, 'year'), attr(x, 'type')))
}

an <- function(x, y) { 
  tmp <- attr(x, y)
  if (is.null(tmp)) '<NA>' else tmp 
}

spth <- function(x) grep("\\.shp", x, value = TRUE)

#' @export
print.storm_shp <- function(x, ...) {
  cat("<NOAA Storm Shp Files>", sep = "\n")
  cat(sprintf("Path: %s", x$path), sep = "\n")
  cat(sprintf("Basin: %s", an(x, "basin")), sep = "\n")
  cat(sprintf("Storm: %s", an(x, "storm")), sep = "\n")
  cat(sprintf("Year: %s", an(x, "year")), sep = "\n")
  cat(sprintf("Type: %s", an(x, "type")), sep = "\n")
}

shpstorm_GET <- function(bp, basin, storm, year, type, overwrite) {
  dir.create(local_base(basin, storm, year, bp), showWarnings = FALSE, recursive = TRUE)
  fp <- shp_local(basin, storm, year, bp, type)
  paths <- Map(function(x, y) suppressWarnings(GET(x, write_disk(y, overwrite))), shp_remote(basin, storm, year, type), fp)  
  vapply(paths, function(z) z$request$output$path, "", USE.NAMES = FALSE)
}

shpfileext <- function(basin, storm, year, type) {
  tt <- filepath(basin, storm, year)
  if (grepl("Allstorms", tt)) {
    paste0(tt, '.ibtracs_all_', type, '.v03r06.', c('dbf','prj','shp','shx'), '.gz')
  } else {
    paste0(tt, '.ibtracs_all_', type, '.v03r06.', c('dbf','prj','shp','shx'))
  }
}

filepath2 <- function(basin, storm, year, type) {
  tmp <- filecheck(basin, storm, year)
  switch(names(tmp),
         all = 'Allstorms',
         basin = paste0('Basin.', tmp[[1]], '.ibtracs_all_', type, '.v03r06'),
         storm = paste0('Storm.', tmp[[1]], '.ibtracs_all_', type, '.v03r06'),
         year = paste0('Year.', tmp[[1]], '.ibtracs_all_', type, '.v03r06')
  )
}

shp_remote <- function(basin, storm, year, type) file.path(stormurl("shp"), shpfileext(basin, storm, year, type))
shp_local <- function(basin, storm, year, path, type) file.path(path, shpfileext(basin, storm, year, type))
is_shpstorm <- function(x) if (all(file.exists(x))) TRUE else FALSE
readshp2 <- function(x, layer) rgdal::readOGR(dsn = path.expand(x), layer = layer, stringsAsFactors = FALSE, verbose = FALSE)
