#' Historical Observing Metadata Repository (HOMR) station metadata
#'
#' @export
#'
#' @param qid One of COOP, FAA, GHCND, ICAO, NCDCSTNID, NWSLI, TRANS, WBAN, or WMO, or any
#' of those plus \code{[a-z0-9]}, or just \code{[a-z0-9]}.
#' @param qidMod One of is, starts, ends, contains. Specifies how the ID portion of the qid
#' parameter should be applied within the search. If a qid is passed but the qidMod parameter
#' is not used, qidMod is assumed to be IS.
#' @param state A two-letter state abbreviation. Two-letter code for US states, Canadian
#' provinces, and other Island areas.
#' @param county A two letter county code. US county names, best used with a state identifier.
#' @param country A two letter country code. See here for a list of valid country names.
#' @param name One of name=[0-9A-Z]+. Searches on any type of name we have for the station.
#' @param nameMod [is|starts|ends|contains]. Specifies how the name parameter should be applied
#' within the search. If a name is passed but the nameMod parameter is not used, nameMod is assumed
#' to be IS.
#' @param platform (aka network) [ASOS|USCRN|USHCN|NEXRAD|AL USRCRN|USRCRN|COOP]. Limit the
#' search to stations of a certain platform/network type.
#' @param date [YYYY-MM-DD|all] Limits values to only those that occurred on a specific date.
#' Alternatively, date=all will return all values for matched stations. If this field is omitted,
#' the search will return only the most recent values for each field.
#' @param begindate,enddate [YYYY-MM-DD]. Limits values to only those that occurred within a
#' date range.
#' @param headersOnly true Returns only minimal information for each station found (NCDC Station
#' ID, Preferred Name, Station Begin Date, and Station End Date), but is much quicker than a
#' full query. If you are performing a search that returns a large number of stations and intend
#' to choose only one from that list to examine in detail, headersOnly may give you enough
#' information to find the NCDC Station ID for the station that you actually want.
#' @param phrData false The HOMR web service now includes PHR (element-level) data when
#' available, in an elements section. Because of how this data is structured, it can substantially
#' increase the size of any result which includes it. If you don't need this data you can omit it
#' by including phrData=false. If the parameter is not set, it will default to phrData=true.
#' @param definitions false The HOMR web service includes a list of definitions with every result.
#' These are meant to serve as a reference for some of the more cryptic variable values, and are
#' identical for every request. You can omit these from your result by setting 
#' \code{definitions=FALSE}.
#' @param ... Further named parameters, such as \code{query}, \code{path}, etc, passed on to 
#' \code{\link[httr]{modify_url}}. Unnamed parameters will be combined with 
#' \code{\link[httr]{config}}. 
#'
#' @examples \donttest{
#' homr(qid = 'COOP:046742')
#' homr(headersOnly=TRUE, qid='TRANS:')
#' homr(qid = ':046742')
#' homr(qid = 'FAA:')
#' homr(qidMod='starts', qid='COOP:0467')
#' homr(headersOnly=TRUE, state='DE')
#' homr(headersOnly=TRUE, state='NC', county='BUNCOMBE')
#' homr(headersOnly=TRUE, country='GHANA')
#' homr(name='CLAYTON')
#' homr(nameMod='starts', name='CLAY')
#' homr(headersOnly=TRUE, platform='ASOS')
#' homr(qid='COOP:046742', date='2011-01-01')
#' homr(qid='COOP:046742', begindate='2005-01-01', enddate='2011-01-01')
#' homr(state='DE', headersOnly=TRUE)
#' homr(station=20002078, date='all', phrData=FALSE)
#' homr(station=20002078, date='all', definitions=FALSE)
#' }

homr <- function(qid=NULL, qidMod=NULL, state=NULL, county=NULL, country=NULL, name=NULL,
  nameMod=NULL, platform=NULL, date=NULL, begindate=NULL, enddate=NULL, headersOnly=NULL,
  phrData=NULL, definitions=NULL, ...)
{
  args <- noaa_compact(list(qid=qid, qidMod=qidMod, state=state, county=county, country=country,
      name=name, nameMod=nameMod, platform=platform, date=date, begindate=begindate,
      enddate=enddate, headersOnly=headersOnly, phrData=phrData, definitions=definitions))
  res <- GET(homr_base(), query=args, ...)
  out <- content(res, "text")
  json <- jsonlite::fromJSON(out, FALSE)
  defs <- parse_defs(json$stationCollection$definitions)
  sts <- 
    lapply(json$stationCollection$stations, parse_stations)
  structure(list(definition=defs, stations=sts), class="homr")
}

homr_base <- function() 'http://www.ncdc.noaa.gov/homr/services/station/search'

parse_defs <- function(x){
  do.call(rbind.fill, lapply(x, data.frame, stringsAsFactors = FALSE))
}

parse_stations <- function(x) {
  id <- x$ncdcStnId
  head <- data.frame(x$header, stringsAsFactors = FALSE)
  namez <- rbf(todf(x$names))
  identifiers <- rbf(todf(x$identifiers))
  location <- parse_loc(x$location)
  status <- x$statuses[[1]]$status
  platform <- x$platforms[[1]]$platform
  relocations <- todf(x$relocations)[[1]]
  remarks <- rbf(todf(x$remarks))
  updates <- todf(x$updates)[[1]]
  elements <- rbf(todf(x$elements))
  list(id=id, head=head, namez=namez, identifiers=identifiers, location=location, 
       status=status, platform=platform, relocations=relocations, 
       remarks=remarks, updates=updates, elements=elements)
}

todf <- function(x) ifn_null(x, lapply(x, data.frame, stringsAsFactors = FALSE))
rbf <- function(x) ifn_null(x, do.call(rbind.fill, x))
ifn_null <- function(x, y) if(is.null(x)) x else y
ifn_na <- function(x) if(is.null(x)) NA else x

parse_loc <- function(y){
  id <- y$ncdcstnId
  descriptions <- unlist(y$descriptions)
#   todf(y$latitudes)[[1]]
#   todf(y$longitudes)[[1]]
  latlon <- todf(y$latLonPairs)[[1]]
  elev <- todf(y$elevations)[[1]]
  topography <- unlist(y$topography)
  obstructions <- rbf(todf(y$obstructions))
  geoinfo <- data.frame(ncdstnId=y$geoInfo$ncdcstnId, 
             country=y$geoInfo$countries[[1]]$country,
             state=y$geoInfo$stateProvinces[[1]]$stateProvince,
             county=y$geoInfo$counties[[1]]$county,
             utcoffset=y$geoInfo$utcOffsets[[1]]$utcOffset, 
             stringsAsFactors = FALSE)
  nwsinfo <- data.frame(ncdstnId=ifn_na(y$nwsInfo$ncdcstnId),
             climateDivisions=ifn_na(todf(y$nwsInfo$climateDivisions)[[1]]),
             nwsRegion=ifn_na(y$nwsInfo$nwsRegions[[1]]$nwsRegion),
             nwsWfos=ifn_na(todf(y$nwsInfo$nwsWfos)[[1]]),
             stringsAsFactors = FALSE)
  list(id=id, description=descriptions, latlon=latlon, elevation=elev,
       topography=topography, obstructions=obstructions, 
       geoinfo=geoinfo, nwsinfo=nwsinfo)
}
