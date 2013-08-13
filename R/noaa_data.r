#' Get NOAA data.
#' 
#' @import plyr
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

#' @S3method noaa_data noaa
#' @export
#' @keywords internal
noaa_data.noaa <- function(input = NULL, datatype="df")
{
  if(!is.noaa(input))
    stop("Input is not of class noaa")
  
  if(datatype=="df"){
    return( data.frame(input$data) )
  } else
    if(datatype=="list"){ return( input ) }
}