#' ERDDAP searches and data retrieval
#' 
#' @export
#' @import httr assertthat
#' @param datasetid Dataset id
#' @param fields Columns to return, as a character vector
#' @param ... 
#' @param callopts Further args passed on to httr::GET (must be a named parameter)
#' @examples \dontrun{
#' erddap(datasetid='erdCalCOFIfshsiz', fields=c('longitude','latitude','fish_size','itis_tsn'),
#'    'time>=' = '2001-07-07','time<=' = '2001-07-10')
#' erddap(datasetid='erdCinpKfmBT', fields=c('latitude','longitude','Aplysia_californica_Mean_Density','Muricea_californica_Mean_Density'),
#'    'time>=' = '2007-06-24','time<=' = '2007-07-01')
#' }

erddap <- function(datasetid, fields=NULL, ..., callopts=list()){  
  fields <- paste(fields, collapse = ",")
  url <- "http://coastwatch.pfeg.noaa.gov/erddap/tabledap/%s.csv?%s"
  url <- sprintf(url, datasetid, fields)
  args <- list(...)
  args <- collapse_args(args)
  if(!nchar(args[[1]]) == 0){
    url <- paste0(url, '&', args)
  }
  tt <- GET(url, list(), callopts)
  stop_for_status(tt)
  assert_that(tt$headers$`content-type` == 'text/csv;charset=UTF-8')
  out <- content(tt, as = "text")
  df <- read.delim(text=out, sep=",")[-1,]
  return( df )
}

# 'http://coastwatch.pfeg.noaa.gov/erddap/tabledap/erdCalCOFIfshsiz.htmlTable?cruise,ship,ship_code,order_occupied,tow_type,net_type,tow_number,net_location,standard_haul_factor,volume_sampled,percent_sorted,sample_quality,latitude,longitude,line,station,time,scientific_name,common_name,itis_tsn,calcofi_species_code,fish_size,fish_count,fish_1000m3&time>=2001-07-07&time<=2001-07-14T10:17:00Z'
# index
# 'http://coastwatch.pfeg.noaa.gov/erddap/info/erdCalCOFIfshsiz/index.json'

# http://coastwatch.pfeg.noaa.gov/erddap/tabledap/erdCalCOFIfshsiz.htmlTable?cruise,ship,ship_code,order_occupied,tow_type,net_type,tow_number,net_location,standard_haul_factor,volume_sampled,percent_sorted,sample_quality,latitude,longitude,line,station,time,scientific_name,common_name,itis_tsn,calcofi_species_code,fish_size,fish_count,fish_1000m3&time>=2001-07-07&time<=2001-07-14T10:17:00Z

collapse_args <- function(x){
  outout <- list()
  for(i in seq_along(x)){
    tmp <- paste(names(x[i]), x[i], sep="")
    outout[[i]] <- tmp
  }
  paste0(outout, collapse = "&")
}