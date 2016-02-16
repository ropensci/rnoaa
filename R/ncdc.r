#' Search for and get NOAA NCDC data.
#'
#' @export
#' @template rnoaa
#' @template noaa
#' @param stationid Accepts a valid station id or a vector or list of station ids
#' @param includemetadata Used to improve response time by preventing the calculation of
#' result metadata. Default: TRUE. This does not affect the return object, in that the named part
#' of the output list called "meta' is still returned, but is NULL. In practice, I haven't seen
#' response time's improve, but perhaps they will for you.
#'
#' @details
#' Note that NOAA NCDC API calls can take a long time depending on the call. The NOAA API doesn't
#' perform well with very long timespans, and will time out and make you angry - beware.
#'
#' Keep in mind that three parameters, datasetid, startdate, and enddate are required.
#'
#' Note that the default limit (no. records returned) is 25. Look at the metadata in \code{$meta}
#' to see how many records were found. If more were found than 25, you could set the parameter
#' \code{limit} to something higher than 25.
#'
#' The attributes, or "flags", for each row of the output for data may have a flag
#' with it. Each \code{datasetid} has it's own set of flags. The following are flag
#' columns, and what they stand for. \code{fl_} is the beginning of each flag
#' column name, then one or more characters to describe the flag, keeping it short
#' to maintain a compact data frame. Some of these fields are the same across
#' datasetids. See the vignette \code{vignette("rnoaa_attributes", "rnoaa")} for
#' description of possible values for each flag.
#'
#' \itemize{
#'  \item fl_c completeness
#'  \item fl_d day
#'  \item fl_m measurement
#'  \item fl_q quality
#'  \item fl_s source
#'  \item fl_t time
#'  \item fl_cmiss consecutive missing
#'  \item fl_miss missing
#'  \item fl_u units
#' }
#'
#' @return An S3 list of length two, a slot of metadata (meta), and a slot for data (data).
#' The meta slot is a list of metadata elements, and the data slot is a data.frame,
#' possibly of length zero if no data is found.
#'
#' @examples \dontrun{
#' # GHCN-Daily (or GHCND) data, for a specific station
#' ncdc(datasetid='GHCND', stationid='GHCND:USW00014895', startdate = '2013-10-01',
#'    enddate = '2013-12-01')
#'
#' # GHCND data, for a location by FIPS code
#' ncdc(datasetid='GHCND', locationid = 'FIPS:02', startdate = '2010-05-01',
#'    enddate = '2010-05-10')
#'
#' # GHCND data from October 1 2013 to December 1 2013
#' ncdc(datasetid='GHCND', startdate = '2013-10-01', enddate = '2013-10-05')
#'
#' # GHCN-Monthly (or GHCNDMS) data from October 1 2013 to December 1 2013
#' ncdc(datasetid='GHCNDMS', startdate = '2013-10-01', enddate = '2013-12-01')
#'
#' # Normals Daily (or NORMAL_DLY) GHCND:USW00014895 dly-tmax-normal data
#' ncdc(datasetid='NORMAL_DLY', stationid='GHCND:USW00014895', startdate = '2010-05-01',
#'    enddate = '2010-05-10')
#'
#' # Dataset, and location in Australia
#' ncdc(datasetid='GHCND', locationid='FIPS:AS', startdate = '2010-05-01', enddate = '2010-05-31')
#'
#' # Dataset, location and datatype for PRECIP_HLY data
#' ncdc(datasetid='PRECIP_HLY', locationid='ZIP:28801', datatypeid='HPCP',
#'    startdate = '2010-05-01', enddate = '2010-05-10')
#' 
#' # multiple datatypeid's
#' ncdc(datasetid='PRECIP_HLY', datatypeid=c('HPCP', 'ACMC'),
#'    startdate = '2010-05-01', enddate = '2010-05-10')   
#'    
#' # multiple locationid's
#' ncdc(datasetid='PRECIP_HLY', locationid=c("FIPS:30103", "FIPS:30091"),
#'    startdate = '2010-05-01', enddate = '2010-05-10')
#' 
#' # Dataset, location, station and datatype
#' ncdc(datasetid='PRECIP_HLY', locationid='ZIP:28801', stationid='COOP:310301', datatypeid='HPCP',
#'    startdate = '2010-05-01', enddate = '2010-05-10')
#'
#' # Dataset, location, and datatype for GHCND
#' ncdc(datasetid='GHCND', locationid='FIPS:BR', datatypeid='PRCP', startdate = '2010-05-01',
#'    enddate = '2010-05-10')
#'
#' # Normals Daily GHCND dly-tmax-normal data
#' ncdc(datasetid='NORMAL_DLY', datatypeid='dly-tmax-normal', startdate = '2010-05-01',
#'    enddate = '2010-05-10')
#'
#' # Normals Daily GHCND:USW00014895 dly-tmax-normal
#' ncdc(datasetid='NORMAL_DLY', stationid='GHCND:USW00014895', datatypeid='dly-tmax-normal',
#'    startdate = '2010-05-01', enddate = '2010-05-10')
#'
#' # Hourly Precipitation data for ZIP code 28801
#' ncdc(datasetid='PRECIP_HLY', locationid='ZIP:28801', datatypeid='HPCP',
#'    startdate = '2010-05-01', enddate = '2010-05-10')
#'
#' # 15 min Precipitation data for ZIP code 28801
#' ncdc(datasetid='PRECIP_15', datatypeid='QPCP', startdate = '2010-05-01', enddate = '2010-05-02')
#'
#' # Search the NORMAL_HLY dataset
#' ncdc(datasetid='NORMAL_HLY', stationid = 'GHCND:USW00003812', startdate = '2010-05-01',
#'    enddate = '2010-05-10')
#'
#' # Search the ANNUAL dataset
#' ncdc(datasetid='ANNUAL', locationid='ZIP:28801', startdate = '2010-05-01',
#'    enddate = '2010-05-10')
#'
#' # Search the NORMAL_ANN dataset
#' ncdc(datasetid='NORMAL_ANN', datatypeid='ANN-DUTR-NORMAL', startdate = '2010-01-01',
#'    enddate = '2010-01-01')
#'
#' # Include metadata or not
#' ncdc(datasetid='GHCND', stationid='GHCND:USW00014895', startdate = '2013-10-01',
#'    enddate = '2013-12-01')
#' ncdc(datasetid='GHCND', stationid='GHCND:USW00014895', startdate = '2013-10-01',
#'    enddate = '2013-12-01', includemetadata=FALSE)
#'    
#' # Many stationid's
#' stat <- ncdc_stations(startdate = "2000-01-01", enddate = "2016-01-01")
#' ## find out what datasets might be available for these stations
#' ncdc_datasets(stationid = stat$data$id[1])
#' ## get some data
#' ncdc(datasetid = "ANNUAL", stationid = stat$data$id[1:10], 
#'    startdate = "2010-01-01", enddate = "2011-01-01")
#' }
#'
#' \dontrun{
#' # NEXRAD2 data
#' ## doesn't work yet
#' ncdc(datasetid='NEXRAD2', startdate = '2013-10-01', enddate = '2013-12-01')
#' }

ncdc <- function(datasetid=NULL, datatypeid=NULL, stationid=NULL, locationid=NULL,
  startdate=NULL, enddate=NULL, sortfield=NULL, sortorder=NULL, limit=25, offset=NULL,
  token=NULL, dataset=NULL, datatype=NULL, station=NULL, location=NULL,
  locationtype=NULL, page=NULL, year=NULL, month=NULL, day=NULL, includemetadata=TRUE,
  results=NULL, ...)
{
  calls <- names(sapply(match.call(), deparse))[-1]
  calls_vec <- c("dataset","datatype","station","location","locationtype","page","year","month","day","results") %in% calls
  if(any(calls_vec))
    stop("The parameters name, code, modifiedsince, startindex, and maxresults \n  have been removed, and were only relavant in the old NOAA API v1. \n\nPlease see documentation for ?noaa")

  token <- check_key(token)
  base = 'http://www.ncdc.noaa.gov/cdo-web/api/v2/data'
  args <- noaa_compact(list(datasetid=datasetid, startdate=startdate,
                         enddate=enddate, sortfield=sortfield, sortorder=sortorder,
                         limit=limit, offset=offset, includemetadata=includemetadata))
  if (!is.null(stationid)) {
    stationid <- lapply(stationid, function(x) list(stationid = x))
  }
  if (!is.null(datatypeid)) {
    datatypeid <- lapply(datatypeid, function(x) list(datatypeid = x))
  }
  if (!is.null(locationid)) {
    locationid <- lapply(locationid, function(x) list(locationid = x))
  }
  args <- c(args, stationid, datatypeid, locationid)
  args <- as.list(unlist(args))
  names(args) <- gsub("[0-9]+", "", names(args))
  if (length(args) == 0) args <- NULL
  temp <- GET(base, query=args, add_headers("token" = token), ...)
  tt <- check_response(temp)
  if(is(tt, "character")){
    all <- list(meta=NA, data=NA)
  } else {
    tt$results <- lapply(tt$results, split_atts, ds=datasetid)
    dat <- dplyr::bind_rows(lapply(tt$results, function(x) data.frame(x,stringsAsFactors=FALSE)))
    meta <- tt$metadata$resultset
    atts <- list(totalCount=meta$count, pageCount=meta$limit, offset=meta$offset)
    all <- list(meta=atts, data=dat)
  }

  structure(all, class="ncdc_data")
}

split_atts <- function(x, ds="GHCNDMS"){
  tmp <- x$attributes
  out <- switch(ds,
         ANNUAL = parse_ncdc(tmp,c('fl_m','fl_q','fl_d','fl_u')),
         GHCND = parse_ncdc(tmp,c('fl_m','fl_q','fl_so','fl_t')),
         GHCNDMS = parse_ncdc(tmp,c('fl_miss','fl_cmiss')),
         NEXRAD2 = parse_ncdc(tmp,c('x','x')), # no data returned, fix when data returned
         NEXRAD3 = parse_ncdc(tmp,c('x','x')), # no data returned, fix when data returned
         NORMAL_ANN = parse_ncdc(tmp,'fl_c'),
         NORMAL_DLY = parse_ncdc(tmp,'fl_c'),
         NORMAL_HLY = parse_ncdc(tmp,'fl_c'),
         NORMAL_MLY = parse_ncdc(tmp,'fl_c'),
         PRECIP_15 = parse_ncdc(tmp,c('fl_m','fl_q','fl_u')),
         PRECIP_HLY = parse_ncdc(tmp,c('fl_m','fl_q')))
  notatts <- x[!names(x)=="attributes"]
  c(notatts, out)
}

parse_ncdc <- function(y, headings){
  res <- strsplit(y, ',')[[1]]
  if(grepl(",$", y)){
    res <- c(res, "")
  }
  names(res) <- headings
  as.list(res)
}
