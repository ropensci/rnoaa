#' Historical Observing Metadata Repository (HOMR) station metadata
#'
#' @export
#'
#' @param qid One of COOP, FAA, GHCND, ICAO, NCDCSTNID, NWSLI, TRANS, WBAN, or
#' WMO, or any of those plus `a-z0-9`, or just `a-z0-9`. (qid = qualified ID)
#' @param qidMod  (character) One of: is, starts, ends, contains. Specifies
#' how the ID portion of the qid parameter should be applied within the search.
#' If a qid is passed but the qidMod parameter is not used, qidMod is
#' assumed to be IS.
#' @param station  (character) A station id.
#' @param state  (character) A two-letter state abbreviation. Two-letter code
#' for US states, Canadian provinces, and other Island areas.
#' @param county  (character) A two letter county code. US county names, best
#' used with a state identifier.
#' @param country  (character) A two letter country code. See here for a list
#' of valid country names.
#' @param name  (character) One of `0-9A-Z+`. Searches on any type of
#' name we have for the station.
#' @param nameMod  (character) `is|starts|ends|contains`. Specifies how the
#' name parameter should be applied within the search. If a name is passed but
#' the nameMod parameter is not used, nameMod is assumed to be IS.
#' @param platform  (character) (aka network) `ASOS|USCRN|USHCN|NEXRAD|AL
#' USRCRN|USRCRN|COOP`. Limit the search to stations of a certain
#' platform/network type.
#' @param date  (character) `YYYY-MM-DD|all` Limits values to only those that
#' occurred on a specific date. Alternatively, date=all will return all values
#' for matched stations. If this field is omitted, the search will return only
#' the most recent values for each field.
#' @param begindate,enddate `YYYY-MM-DD`. Limits values to only those that
#' occurred within a date range.
#' @param headersOnly (logical) Returns only minimal information for each
#' station found (NCDC Station ID, Preferred Name, Station Begin Date, and
#' Station End Date), but is much quicker than a full query. If you are
#' performing a search that returns a large number of stations and intend to
#' choose only one from that list to examine in detail, headersOnly may give
#' you enough information to find the NCDC Station ID for the station that
#' you actually want.
#' @param phrData (logical) The HOMR web service now includes PHR
#' (element-level) data when available, in an elements section. Because of
#' how this data is structured, it can substantially increase the size of any
#' result which includes it. If you don't need this data you can omit it
#' by including phrData=false. If the parameter is not set, it will default
#' to phrData=true.
#' @param combine (logical) Combine station metadata or not.
#' @param ... Curl options passed on to [crul::verb-GET] (optional)
#'
#' @details Since the definitions for variables are always the same, we don't
#' include the ability to get description data in this function. Use
#' [homr_definitions()] to get descriptions information.
#'
#' @return A list, with elements named by the station ids.
#'
#' @references https://www.ncdc.noaa.gov/homr/api
#'
#' @examples \dontrun{
#' homr(qid = 'COOP:046742')
#' homr(qid = ':046742')
#' homr(qidMod='starts', qid='COOP:0467')
#' homr(headersOnly=TRUE, state='DE')
#' homr(headersOnly=TRUE, country='GHANA')
#' homr(headersOnly=TRUE, state='NC', county='BUNCOMBE')
#' homr(name='CLAYTON')
#' res <- homr(state='NC', county='BUNCOMBE', combine=TRUE)
#' res$id
#' res$head
#' res$updates
#' homr(nameMod='starts', name='CLAY')
#' homr(headersOnly=TRUE, platform='ASOS')
#' homr(qid='COOP:046742', date='2011-01-01')
#' homr(qid='COOP:046742', begindate='2005-01-01', enddate='2011-01-01')
#' homr(state='DE', headersOnly=TRUE)
#' homr(station=20002078)
#' homr(station=20002078, date='all', phrData=FALSE)
#'
#' # Optionally pass in curl options
#' homr(headersOnly=TRUE, state='NC', county='BUNCOMBE', verbose = TRUE)
#' }

homr <- function(qid=NULL, qidMod=NULL, station=NULL, state=NULL, county=NULL,
  country=NULL, name=NULL, nameMod=NULL, platform=NULL, date=NULL,
  begindate=NULL, enddate=NULL, headersOnly=FALSE, phrData=NULL,
  combine=FALSE, ...) {

  args <- noaa_compact(
    list(
      qid=qid, qidMod=qidMod, state=state, county=county,
      country=country, name=name, nameMod=nameMod, platform=platform,
      date=date, begindate=begindate, enddate=enddate,
      headersOnly=tl(headersOnly), phrData=tl(phrData), definitions = 'false'
    )
  )

  if (length(args) == 0) args <- NULL
  url <- if (is.null(station)) paste0(homr_base(), "search") else
    paste0(homr_base(), station)
  cli <- crul::HttpClient$new(url = url, opts = list(...))
  res <- cli$get(query = args)
  res$raise_for_status()
  if (!grepl("json", res$response_headers$`content-type`)) {
    stop("an error occurred - expected JSON content type response")
  }
  out <- res$parse("UTF-8")
  json <- jsonlite::fromJSON(out, FALSE)
  sts <- lapply(json$stationCollection$stations, parse_stations,
                headersOnly = headersOnly)
  names(sts) <- sapply(sts, "[[", "id")
  if (!combine) {
    structure(sts, class = "homr", combined = FALSE)
  } else {
    structure(combine_stations(sts), class = "homr", combined = TRUE)
  }
}

parse_stations <- function(x, headersOnly) {
  id <- x$ncdcStnId
  head <- data.frame(x$header, stringsAsFactors = FALSE)
  if (headersOnly) {
    list(id = id, head = head)
  } else {
    namez <- rbf(todf(x$names))
    identifiers <- rbf(todf(x$identifiers))
    status <- x$statuses[[1]]$status
    platform <- x$platforms[[1]]$platform
    relocations <- todf(x$relocations)[[1]]
    remarks <- rbf(todf(x$remarks))
    updates <- todf(x$updates)[[1]]
    elements <- rbf(todf(x$elements))
    location <- parse_loc(x$location)
    list(id=id, head=head, namez=namez, identifiers=identifiers,
         status=status, platform=platform, relocations=relocations,
         remarks=remarks, updates=updates, elements=elements, location=location)
  }
}

parse_loc <- function(y){
  id <- y$ncdcstnId
  descriptions <- rbf(todf(y$descriptions))
  latlon <- todf(y$latLonPairs)[[1]]
  elev <- todf(y$elevations)[[1]]
  topography <- unlist(y$topography)
  obstructions <- rbf(todf(y$obstructions))
  geoinfo <- data.frame(ncdstnId=ifn_na(y$geoInfo$ncdcstnId),
             country=ifn_na(y$geoInfo$countries[[1]]$country),
             state=ifn_na(y$geoInfo$stateProvinces[[1]]$stateProvince),
             county=ifn_na(y$geoInfo$counties[[1]]$county),
             utcoffset=ifn_na(y$geoInfo$utcOffsets[[1]]$utcOffset),
             stringsAsFactors = FALSE)
  nwsinfo <- data.frame(ncdstnId=ifn_na(y$nwsInfo$ncdcstnId),
             climateDivisions=ifn_na(todf(y$nwsInfo$climateDivisions)[[1]]),
             nwsRegion=ifn_na(y$nwsInfo$nwsRegions[[1]]$nwsRegion),
             nwsWfos=ifn_na(todf(y$nwsInfo$nwsWfos)[[1]]),
             stringsAsFactors = FALSE)
  list(id=id, description=descriptions, latlon=latlon, elevation=elev,
       topography=topography, obstructions=obstructions,
       geoinfo=na2null(geoinfo), nwsinfo=na2null(nwsinfo))
}

combine_stations <- function(w){
  ids <- vapply(w, "[[", character(1), "id", USE.NAMES = FALSE)
  head <- rbf(x = lapply(w, "[[", "head"), TRUE)
  namez <- rbf(lapply(w, "[[", "namez"), TRUE)
  identifiers <- rbf(lapply(w, "[[", "identifiers"), TRUE)
  status <- sapply(w, "[[", "status", USE.NAMES = FALSE)
  platform <- unname(sapply(w, "[[", "platform", USE.NAMES = FALSE))
  relocations <- rbf(x = lapply(w, "[[", "relocations"), TRUE)
  remarks <- rbf(x = lapply(w, "[[", "remarks"), TRUE)
  updates <- rbf(x = lapply(w, "[[", "updates"), TRUE)
  elements <- rbf(x = lapply(w, "[[", "elements"), TRUE)
  location <- lapply(w, "[[", "location")
  list(id=ids, head=head, namez=namez, identifiers=identifiers,
       status=status, platform=platform, relocations=relocations,
       remarks=remarks, updates=updates, elements=elements, location=location)
}

tl <- function(x) if (is.null(x)) NULL else tolower(x)
todf <- function(x) ifn_null(x, lapply(x, data.frame, stringsAsFactors = FALSE))
rbf <- function(x, name = FALSE){
  if (!name) {
    ifn_null(x, dplyr::bind_rows(x))
  } else {
    x <- noaa_compact(x)
    nmz <- names(x)
    tmp <- Map(function(a, b) data.frame(id = b, a, stringsAsFactors = FALSE),
               x, nmz)
    ifn_null(tmp, dplyr::bind_rows(tmp))
  }
}
ifn_null <- function(x, y) if (is.null(x)) x else y
ifn_na <- function(x) if (is.null(x)) NA else x
na2null <- function(x) if (all(is.na(x))) NULL else x

homr_base <- function() 'https://www.ncei.noaa.gov/access/homr/services/station/'
