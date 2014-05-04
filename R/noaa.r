#' Get NOAA data.
#'
#' @import httr
#' @importFrom plyr round_any rbind.fill
#' @importFrom RJSONIO fromJSON
#' @export
#' @template rnoaa
#' @template noaa
#'
#' @details
#' Note that NOAA API calls can take a long time depending on the call. The NOAA API doesn't
#' perform well with very long timespans, and will time out and make you angry - beware.
#'
#' Keep in mind that three parameters, datasetid, startdate, and enddate are required.
#'
#' Note that the default limit (no. records returned) is 25.
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
#'  \item fl_m measurement
#'  \item fl_q quality
#'  \item fl_s source
#'  \item fl_t time
#'  \item fl_cmiss consecutive missing
#'  \item fl_miss missing
#' }
#'
#' @return An S3 list of length two, a slot of metadata (meta), and a slot for data (data).
#' The meta slot is a list of metadata elements, and the data slot is a data.frame,
#' possibly of length zero if no data is found.
#'
#' @examples \dontrun{
#' # GHCN-Daily (or GHCND) data, for a specific station
#' noaa(datasetid='GHCND', stationid='GHCND:USW00014895', startdate = '2013-10-01',
#'    enddate = '2013-12-01')
#'
#' # GHCND data, for a location by FIPS code
#' noaa(datasetid='GHCND', locationid = 'FIPS:02', startdate = '2010-05-01',
#'    enddate = '2010-05-10')
#'
#' # GHCND data from October 1 2013 to December 1 2013
#' noaa(datasetid='GHCND', startdate = '2013-10-01', enddate = '2013-10-05')
#'
#' # GHCN-Monthly (or GHCNDMS) data from October 1 2013 to December 1 2013
#' noaa(datasetid='GHCNDMS', startdate = '2013-10-01', enddate = '2013-12-01')
#'
#' # Normals Daily (or NORMAL_DLY) GHCND:USW00014895 dly-tmax-normal data
#' noaa(datasetid='NORMAL_DLY', stationid='GHCND:USW00014895', startdate = '2010-05-01',
#'    enddate = '2010-05-10')
#'
#' # Dataset, and location in Australia
#' noaa(datasetid='GHCND', locationid='FIPS:AS', startdate = '2010-05-01', enddate = '2010-05-31')
#'
#' # Dataset, location and datatype for PRECIP_HLY data
#' noaa(datasetid='PRECIP_HLY', locationid='ZIP:28801', datatypeid='HPCP',
#'    startdate = '2010-05-01', enddate = '2010-05-10')
#'
#' # Dataset, location, station and datatype
#' noaa(datasetid='PRECIP_HLY', locationid='ZIP:28801', stationid='COOP:310301', datatypeid='HPCP',
#'    startdate = '2010-05-01', enddate = '2010-05-10')
#'
#' # Dataset, location, and datatype for GHCND
#' noaa(datasetid='GHCND', locationid='FIPS:BR', datatypeid='PRCP', startdate = '2010-05-01',
#'    enddate = '2010-05-10')
#'
#' # Normals Daily GHCND dly-tmax-normal data
#' noaa(datasetid='NORMAL_DLY', datatypeid='dly-tmax-normal', startdate = '2010-05-01',
#'    enddate = '2010-05-10')
#'
#' # Normals Daily GHCND:USW00014895 dly-tmax-normal
#' noaa(datasetid='NORMAL_DLY', stationid='GHCND:USW00014895', datatypeid='dly-tmax-normal',
#'    startdate = '2010-05-01', enddate = '2010-05-10')
#'
#' # Hourly Precipitation data for ZIP code 28801
#' noaa(datasetid='PRECIP_HLY', locationid='ZIP:28801', datatypeid='HPCP',
#'    startdate = '2010-05-01', enddate = '2010-05-10')
#'
#' # 15 min Precipitation data for ZIP code 28801
#' noaa(datasetid='PRECIP_15', datatypeid='QPCP', startdate = '2010-05-01', enddate = '2010-05-02')
#'
#' # Search the NORMAL_HLY dataset
#' noaa(datasetid='NORMAL_HLY', stationid = 'GHCND:USW00003812', startdate = '2010-05-01',
#'    enddate = '2010-05-10')
#'
#' # Search the ANNUAL dataset
#' noaa(datasetid='ANNUAL', locationid='ZIP:28801', startdate = '2010-05-01',
#'    enddate = '2010-05-10')
#'
#' # Search the NORMAL_ANN dataset
#' noaa(datasetid='NORMAL_ANN', datatypeid='ANN-DUTR-NORMAL', startdate = '2010-01-01',
#'    enddate = '2010-01-01')
#' }
#'
#' \donttest{
#' # NEXRAD2 data
#' ## doesn't work yet
#' noaa(datasetid='NEXRAD2', startdate = '2013-10-01', enddate = '2013-12-01')
#' }

noaa <- function(datasetid=NULL, datatypeid=NULL, stationid=NULL, locationid=NULL,
  startdate=NULL, enddate=NULL, sortfield=NULL, sortorder=NULL, limit=25, offset=NULL,
  callopts=list(), token=NULL, dataset=NULL, datatype=NULL, station=NULL, location=NULL,
  locationtype=NULL, page=NULL, year=NULL, month=NULL, day=NULL, results=NULL)
{
  calls <- names(sapply(match.call(), deparse))[-1]
  calls_vec <- c("dataset","datatype","station","location","locationtype","page","year","month","day","results") %in% calls
  if(any(calls_vec))
    stop("The parameters name, code, modifiedsince, startindex, and maxresults \n  have been removed, and were only relavant in the old NOAA API v1. \n\nPlease see documentation for ?noaa")

  if(is.null(token))
    token <- getOption("noaakey", stop("you need an API key NOAA data"))

  base = 'http://www.ncdc.noaa.gov/cdo-web/api/v2/data'
  args <- noaa_compact(list(datasetid=datasetid, datatypeid=datatypeid,
                         locationid=locationid, stationid=stationid, startdate=startdate,
                         enddate=enddate, sortfield=sortfield, sortorder=sortorder,
                         limit=limit, offset=offset))
  args <- as.list(unlist(args))
  names(args) <- gsub("[0-9]+", "", names(args))

  if(limit > 1000){
    startat <- seq(1, limit, 1000)-1
    repto <- rep(1000, length(startat))
    repto[length(repto)] <- limit-round_any(limit, 1000, floor)

    out <- list()
    for(i in seq_along(startat)){
      args$limit <- repto[i]
      args$offset <- startat[i]
      callopts <- c(add_headers("token" = token), callopts)
      temp <- GET(base, query=args, config = callopts)
      tt <- check_response(temp)
      out[[i]] <- do.call(rbind.fill, lapply(tt$results, function(x) data.frame(x,stringsAsFactors=FALSE)))
    }
    dat <- do.call(rbind.data.frame, out)
    meta <- tt$metadata$resultset
    atts <- list(totalCount=meta$count, pageCount="none", offset="none")
  } else
  {
    callopts <- c(add_headers("token" = token), callopts)
    temp <- GET(base, query=args, config = callopts)
    tt <- check_response(temp)
    tt$results <- lapply(tt$results, split_atts, ds=datasetid)
    dat <- do.call(rbind.fill, lapply(tt$results, function(x) data.frame(x,stringsAsFactors=FALSE)))
    meta <- tt$metadata$resultset
    atts <- list(totalCount=meta$count, pageCount=meta$limit, offset=meta$offset)
  }

  all <- list(meta=atts, data=dat)
  class(all) <- "noaa_data"
  return( all )
}

split_atts <- function(x, ds="GHCNDMS"){
  tmp <- x$attributes
  out <- switch(ds,
         ANNUAL = parse_noaa(tmp,c('fl_m','fl_q','fl_d','fl_u')),
         GHCND = parse_noaa(tmp,c('fl_m','fl_q','fl_so','fl_t')),
         GHCNDMS = parse_noaa(tmp,c('fl_miss','fl_cmiss')),
         NEXRAD2 = parse_noaa(tmp,c('x','x')), # no data returned, fix when data returned
         NEXRAD3 = parse_noaa(tmp,c('x','x')), # no data returned, fix when data returned
         NORMAL_ANN = parse_noaa(tmp,'fl_c'),
         NORMAL_DLY = parse_noaa(tmp,'fl_c'),
         NORMAL_HLY = parse_noaa(tmp,'fl_c'),
         NORMAL_MLY = parse_noaa(tmp,'fl_c'),
         PRECIP_15 = parse_noaa(tmp,c('fl_m','fl_q','fl_u')),
         PRECIP_HLY = parse_noaa(tmp,c('fl_m','fl_q')))
  notatts <- x[!names(x)=="attributes"]
  c(notatts, out)
}

parse_noaa <- function(y, headings){
  res <- strsplit(y, ',')[[1]]
  if(grepl(",$", y)){
    res <- c(res, "")
  }
  names(res) <- headings
  as.list(res)
}
  