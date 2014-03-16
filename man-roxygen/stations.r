#' @param datacategoryid (character, optional) Accepts a valid data category id or an array of data category ids. 
#'    Stations returned will be associated with the data category(ies) specified
#' @param extent (numeric, optional) The geographical extent for which you want to search. Give either a vecctor with
#' 	  two values: a latitude and a longitude. For example, \code{c(lat,long)}. Or give four values that defines a bounding box, lat and long for the 
#'    southwest corner, then lat and long for the northeast corner. For example: \code{c(minlat, 
#'    minlong, maxlat, maxlong)}.
#' @param radius (numeric) If a single latitude/longitude pair is given to the extent parameter, the radius to 
#' 	  create around the point. Ignored if a vector of appropriate structure is passed to the  extent parameter.
#' @param dataset THIS IS A DEPRECATED ARGUMENT. See datasetid.
#' @param station THIS IS A DEPRECATED ARGUMENT. See stationid.
#' @param location THIS IS A DEPRECATED ARGUMENT. See locationid.
#' @param locationtype THIS IS A DEPRECATED ARGUMENT. There is no equivalent argument in v2 
#'    of the NOAA API.
#' @param page THIS IS A DEPRECATED ARGUMENT. There is no equivalent argument in v2 
#'    of the NOAA API.