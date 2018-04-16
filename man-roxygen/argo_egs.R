#' @examples \dontrun{
#' # Search Argo metadata
#' ## Number of profiles
#' argo_search("np", limit = 3)
#' ## Number of floats
#' argo_search("nf", limit = 3)
#' ## Number of both profiles and floats
#' argo_search("n", limit = 3)
#' ## return the coordinates in time and space of profiles
#' argo_search("coord", limit = 3)
#' ## return the coordinates in time and space of profiles, plus other metadata
#' argo_search("fullcoord", limit = 3)
#'
#' ## List various things, e.g,...
#' ### data assembly centers
#' argo_search("list", "dac")
#' ### data modes
#' argo_search("list", "dmode", limit = 5)
#' ### World Meteorological Organization unique float ID's
#' argo_search("list", "wmo", limit = 5)
#' ### Profile years
#' argo_search("list", "year", limit = 5)
#'
#' ## coord or fullcoord with specific buoy id
#' argo_search("coord", wmo = 4900881, limit = 3)
#' argo_search("fullcoord", wmo = 4900881, limit = 3)
#'
#' # Spatial search
#' ### search by bounding box (see param def above)
#' argo_search("coord", box = c(-40, 35, 3, 2))
#' ### search by area
#' argo_search("coord", area = 0)
#' ### search by around
#' argo_search("coord", around = '-40,35,100')
#'
#' # Time based search
#' ### search by year
#' argo_search("coord", year = 2006)
#' ### search by yearmin and yearmax
#' argo_search("coord", yearmin = 2007)
#' argo_search("coord", yearmin = 2007, yearmax = 2009)
#' ### search by month
#' argo_search("coord", month = '12,1,2')
#' ### search by lr
#' argo_search("coord", lr = 7)
#' ### search by from or to
#' argo_search("coord", from = 20090212)
#' argo_search("coord", to = 20051129)
#'
#' # Data mode search
#' argo_search("coord", dmode = "R")
#' argo_search("coord", dmode = "R,A")
#'
#' # Data quality based search
#' argo_search("coord", pres_qc = "A,B")
#' argo_search("coord", temp_qc = "A")
#' argo_search("coord", pres_qc = "A", temp_qc = "A")
#'
#' # Ticket search
#' argo_search("coord", ticket = 1)
#'
#' ## Search on partial float id number
#' argo_qwmo(qwmo = 49)
#' argo_qwmo(qwmo = 49, limit = 2)
#'
#' ## Get files
#' argo_files(wmo = 6900087)
#' argo_files(wmo = 6900087, cyc = 12)
#' argo_files(wmo = 6900087, cyc = 45)
#'
#' ## Get planned buoys data, accepts no parameters
#' argo_plan()
#'
#' # Get files for a buoy, must specify data assembly center (dac)
#' argo_buoy_files(dac = "bodc", id = 1901309)
#' argo_buoy_files(dac = "kma", id = 2900308)
#'
#' # Get data
#' x <- argo_buoy_files(dac = "meds", id = 4900881)
#' argo(dac = "meds", id = 4900881, cycle = 127, dtype = "D")
#' }
