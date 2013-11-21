#' Check if object is of class noaa_data
#' @param x input
#' @export
is.noaa_data <- function(x) inherits(x, "noaa_data")

#' Theme for plotting NOAA data
#' @export
#' @keywords internal
noaa_theme <- function(){
  list(theme(panel.grid.major = element_blank(),
             panel.grid.minor = element_blank(),
             legend.position = c(0.7,0.6),
             legend.key = element_blank()),
       guides(col = guide_legend(nrow=1)))
}

#' Get NOAA data.
#' 
#' @param input Output from noaa function.
#' @param datatype One of df or list.
#' @return A data.frame or list.
#' @description datatype = data_df returns all data in a data.frame, while data_list
#'    returns data in a list.
#' @examples \dontrun{
#' out <- noaa(dataset='NORMAL_DLY', station='GHCND:USW00014895', datatype='dly-tmax-normal', year=2010, month=4)
#' noaa_data(input=out) # data.frame output by default
#' noaa_data(input=out, datatype="list") # list if you want it
#' }
#' @export
noaa_data <- function(input = NULL, datatype="df") UseMethod("noaa_data")

#' @method noaa_data noaa_data
#' @export
#' @rdname noaa_data
noaa_data.noaa_data <- function(input = NULL, datatype="df")
{
  if(!is.noaa_data(input))
    stop("Input is not of class noaa_data")
  
  if(datatype=="df"){
    return( data.frame(input$data) )
  } else
    if(datatype=="list"){ return( input ) }
}