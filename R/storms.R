#' Get NOAA wind storm data from International Best Track Archive for Climate Stewardship (IBTrACS)
#' 
#' @export
#' 
#' @param basin (character) A basin name, one of EP, NA, NI, SA, SI, SP, or WP.
#' @param storm (character) A storm serial number of the form YYYYJJJHTTNNN. See Details.
#' @param year (numeric) One of the years from 1842 to 2014
#' @param path (character) A path to store the files, Default: \code{~/.rnoaa/storms}
#' @param overwrite (logical) To overwrite the path to store files in or not, Default: TRUE.
#' @param what (character) One of storm_columns or storm_names.
#' 
#' @details Details for storm serial numbers:
#' \itemize{
#'  \item YYYY is the corresponding year of the first recorded observation of the storm
#'  \item JJJ is the day of year of the first recorded observation of the storm
#'  \item H is the hemisphere of the storm: N=Northern, S=Southern
#'  \item TT is the absolute value of the rounded latitude of the first recorded observation of the 
#'  storm (range 0-90, if basin=SA or SH, then TT in reality is negative)
#'  \item NNN is the rounded longitude of the first recorded observation of the storm (range 0-359)
#' } 
#' 
#' For example: \code{1970143N19091} is a storm in the North Atlantic which started on 
#' May 23, 1970 near 19°N 91°E
#' 
#' See \url{http://www.ncdc.noaa.gov/ibtracs/index.php?name=numbering} for more.
#' 
#' @references \url{http://www.ncdc.noaa.gov/ibtracs/index.php?name=wmo-data}
#' @rdname storms
#' @examples \donttest{
#' # Metadata
#' head( storm_meta() )
#' head( storm_meta("storm_columns") )
#' head( storm_meta("storm_names") )
#' 
#' # Tabular data
#' storm_data(basin='WP')
#' storm_data(storm='1970143N19091')
#' storm_data(year=1940)
#' storm_data(year=1941)
#' storm_data(year=2010)
#' 
#' # Or get all data, simply don't specify a value for basin, storm, or year
#' res <- storm_data(read=FALSE) # just get path
#' head()
#' }

storm_data <- function(basin=NULL, storm=NULL, year=NULL, path="~/.rnoaa/storms", 
                       overwrite = TRUE){
  
  csvpath <- csv_local(basin, storm, year, path)
  if(!is_storm(x = csvpath)){
    csvpath <- storm_GET(path, basin, storm, year, overwrite)
  }
  message(sprintf("<path>%s", csvpath), "\n")
  structure(list(data=read_csv(csvpath)), class="storm_data")
}

#' @export 
print.storm_data <- function(x, ..., n = 10){
  cat("<NOAA Storm Data>", sep = "\n")
  cat(sprintf("Size: %s X %s\n", NROW(x$data), NCOL(x$data)), sep = "\n")
  trunc_mat(x$data, n = n)
}

storm_GET <- function(bp, basin, storm, year, overwrite){
  dir.create(local_base(basin, storm, year, bp), showWarnings = FALSE, recursive = TRUE)
  fp <- csv_local(basin, storm, year, bp)
  res <- suppressWarnings(GET(csv_remote(basin, storm, year), write_disk(fp, overwrite)))
  res$request$writer[[1]]
}

filecheck <- function(basin, storm, year){
  tmp <- noaa_compact(list(basin=basin, storm=storm, year=year))
  if(length(tmp) > 1) stop("You can only supply one or more of basin, storm, or year")
  if(length(tmp) == 0) list(all="Allstorms") else tmp
}

filepath <- function(basin, storm, year){
  tmp <- filecheck(basin, storm, year)
  switch(names(tmp),
         all = 'Allstorms',
         basin = sprintf('basin/Basin.%s', tmp[[1]]),
         storm = sprintf('storm/Storm.%s', tmp[[1]]),
         year = sprintf('year/Year.%s', tmp[[1]])
  )
}

fileext <- function(basin, storm, year){
  tt <- filepath(basin, storm, year)
  if(grepl("Allstorms", tt)) paste0(tt, '.ibtracs_all.v03r06.csv.gz') else paste0(tt, '.ibtracs_all.v03r06.csv')  
}

csv_remote <- function(basin, storm, year) file.path(stormurl(), fileext(basin, storm, year))
csv_local <- function(basin, storm, year, path) file.path(path, fileext(basin, storm, year))

local_base <- function(basin, storm, year, path){
  tt <- filecheck(basin, storm, year)
  if(names(tt)=="all") path else file.path(path, names(tt))
}

is_storm <- function(x) if(file.exists(x)) TRUE else FALSE

stormurl <- function(x = "csv") sprintf('ftp://eclipse.ncdc.noaa.gov/pub/ibtracs/v03r06/all/%s', x)
