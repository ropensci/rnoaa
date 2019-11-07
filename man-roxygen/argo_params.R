#' @param func A function, one of n, np, nf, coord, fullcoord, list, ftplist, ticket, version
#' @param of of string
#' @param qwmo qwmo string
#' @param wmo wmo string. mandatory when using \code{argo_files}
#' @param box Bounding box, of the form: A) lon, lat for geographical coordinates of
#' the center of a box, or B) min lon, min lat, width, height, for geographical
#' coordinates of the center of the box and its width and height, and the longitude must
#' given between -180W and 180E. Width and height are in degrees of longitude and latitude.
#' @param area (integer/character), One of 0, 1, or 2, but can be in combination. e.g. 0, '0,2'
#' See Details.
#' @param around (character) Selects profiles located around a given center point. List of
#' 3 or 4 numerical values depending on how the center point need to be specified:
#' e.g., '-40,35,100', '6900678,2,200', '6900678,2,200,30'. See Details
#' @param cyc a cycle number
#' @param year restrict profiles sampled on a single, or a list of given years. One or a
#' comma separated list of numerical value(s) higher than 0 and lower than 9999.
#' @param yearmin,yearmax restrict profiles sampled before (yearmax) and/or after (yearmin)
#' a given year. A numerical value higher than 0 and lower than 9999. cannot be applied with
#' the other restriction parameter \code{year}
#' @param month restrict profiles sampled on a single, or a list of given month(s). One or a
#' comma separated list of numerical value(s) higher or equal to 1 and lower or equal to 12.
#' The month convention is a standard one: January is 1, February is 2, ... December is 12.
#' @param monthmin,monthmax restrict profiles sampled before (monthmax) and/or after (monthmin)
#' a given month. Higher or equal to 1 and lower or equal to 12. The month convention is a
#' standard one: January is 1, February is 2, ... December is 12. These restrictions cannot be
#' applied with the other restriction parameter month. At this time, these parameters are not
#' circular, so that the restriction chain: monthmin=12&monthmax=2 will through an error
#' and not select December to February profiles. To do so, you need to use a coma separated
#' list of months using the month restriction parameter.
#' @param lr restriction allows you to impose the last report (hence lr) date in days. A
#' numerical value in days between 1 (profiles sampled yesterday) and 60 (profiles sampled
#' over the last 60 days). This restriction allows a simple selection of the so-called
#' 'active' floats, ie those which reported a profiles over the last 30 days.
#' @param from,to select profiles sampled before (to) and/or after (from) an explicit date
#' (included). The date is specified following the format: YYYYMMDD, ie the year, month
#' and day numbers.
#' @param dmode (character) imposes a restriction on the Data Mode of profiles. A single value or
#' a coma separated list of characters defining the Data Mode to select. It can be: R for
#' "Real Time", A for "Real Time with Adjusted value" and D for "Delayed Mode". See Details.
#' @param pres_qc,temp_qc,psal_qc,doxy_qc Quality control. Imposes a restriction on the profile
#' data quality flag. For a given variable <PARAM> which can be: pres (pressure),
#' temp (temperature), psal (salinity) or doxy (oxygen), this restriction selects profiles
#' having one or a coma separated list of data quality flag. See Details.
#' @param ticket (numeric) select profiles with or without a ticket filled in the database. A
#' value: 0 (no ticket) or 1 (has a ticket). See
#' http://www.ifremer.fr/lpo/naarc/m/docs/api/database.html for more details.
#' @param dac (character) Data assembly center code
#' @param id (numeric) Buoy identifier
#' @param cycle (numeric) Cycle number
#' @param dtype (character) Data type, one of \code{D} for delayed, or \code{R} for real-time
#' @param limit (integer) number to return
#' @param ... Curl options passed on to \code{\link[crul]{HttpClient}}. Optional
#' @references \url{http://www.ifremer.fr/lpo/naarc/m/docs/api/howto.html}
#' @details
#' \code{area} parameter definitions:
#' \itemize{
#'  \item Value 0 selects profiles located in the North-Atlantic ocean north of 20S
#'  and not in areas 1 and 2.
#'  \item Value 1 selects profiles located in the Mediterranean Sea.
#'  \item Value 2 selects profiles located in the Nordic Seas.
#' }
#'
#' \code{around} parameter definitions:
#' \itemize{
#'  \item Specification 1: The location is specified with specific geographical
#'  coordinates in the following format: around=longitude,latitude,distance - The longitude
#'  must given between -180W and 180E and the distance is in kilometers.
#'  \item Specification 2: The location is the one of an existing profile in the database.
#'  It is thus specified with a float WMO and a cycle number: around=wmo,cyc,distance
#'  This specification can take an optional fourth value specifying the time range in days
#'  around the specified profile.
#' }
#'
#' \code{dmode} parameter definitions:
#' \itemize{
#'  \item Data from Argo floats are transmitted from the float, passed through processing and
#'  automatic quality control procedures. These profiles have a Data Mode called: real-time data.
#'  \item The data are also issued to the Principle Investigators who apply other procedures to
#'  check data quality returned to the global data centre within 6 to 12 months. These profiles
#'  have a Data Mode called: delayed mode data.
#'  \item The adjustments applied to delayed-data may also be applied to real-time data, to
#'  correct sensor drifts for real-time users. These profiles have a Data Mode called: real
#'  time data with adjusted values.
#' }
#'
#' \code{*_qc} parameter definitions:
#' This information was extracted from the netcdf profile variable PROFILE_<PARAM>_QC. Once
#' quality control procedures have been applied, a synthetic flag is assigned for each
#' parameter of each profile under this variable in netcdf files. It indicates the fraction
#' n of profile levels with good data. It can take one of the following values:
#' \itemize{
#'  \item A or F: All (n=100%) or none (n=0%) of the profile levels contain good data,
#'  \item B,C,D,E: n is in one of the intermediate range: 75-100, 50-75, 25-50 or 0-25
#'  \item empty: No QC was performed.
#' }
#'
#' @section File storage:
#' We use \pkg{rappdirs} to store files, see
#' \code{\link[rappdirs]{user_cache_dir}} for how we determine the directory on
#' your machine to save files to, and run
#' \code{rappdirs::user_cache_dir("rnoaa/argo")} to get that directory.
#'
#' The \code{path} parameter used to be used to set where files are stored
#' on your machine.
#' 
#' @section API Status:
#' The API is down as of 2019-11-07, and probably some time before that. The
#' following functions won't work anymore (future package versions may bring
#' them back if the API comes back):
#' 
#' \itemize{
#'  \item argo_search
#'  \item argo_files
#'  \item argo_qwmo
#'  \item argo_plan
#' }
#' 
#' The following functions still work as they are based off the FTP server
#' that still exists:
#' 
#' \itemize{
#'  \item argo_buoy_files
#'  \item argo
#' }

