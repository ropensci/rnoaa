library(rnoaa)
library(rgdal)
library(maps)
library(ggplot2)
library(maptools)
library(plyr)
library(sp)
library(rgeos)
library(ggdendro)

# set working dir

setwd("/Users/ngood/Google Drive/Projects/R_Weather")

# get / load data

all_states <- map_data("state")

swdi(dataset = 'warn', format = 'shp', startdate = '20120821', enddate = '20120828', filepath = "tmp", limit = '10000000')

# read shape file

shape_file <-readOGR(".","swdi-warn-all-20160421-011714-919")

# convert shape file to ggplot format

shape_ggplot <- fortify(shape_file, region = "id")

shape_ggplot <- merge(shape_ggplot, shape_file@data, by = "id") # merge all fields by id

names(shape_ggplot)[names(shape_ggplot)=="warningtyp"] <- "Warning" # rename warnings column

# plot data

map_warnings <- ggplot() +
  geom_polygon( data=all_states, aes(x=long, y=lat, group = group), 
                colour="grey10", fill="white") +
  geom_polygon(data = shape_ggplot, aes(x = long, y = lat, group = group, fill = Warning),
               color = "red", size = 0.25) + theme_dendro()

# plot
  map_warnings
  
# Useful functions

summary(shape_2012) # Summarize shape file 

attributes(shape_2012@data) # list shape file attribute

shape_2012@data$warningtyp # access shape file attribute

plot_us_storm_warnings <- function(startdate = 20150101, enddate = 20150201){
  
  # get today's date
    today <- as.integer(as.character(format(Sys.Date(), format="%Y%m%d")))
  
  # check selected dates are ok
    if(startdate>=enddate | startdate < 20010101 | enddate < 20010101 | startdate > today | enddate > today ){
      stop("bad date format or selection")
    }
  
  # libraries
    require(rnoaa)
    require(rgdal)
    require(maps)
    require(ggplot2)
    require(maptools)
    require(plyr)
    require(sp)
    require(rgeos)
    require(ggdendro)

  # get working directory
    dir <- getwd()
  
  # prepare for data download
    fldr_name = paste0("tmp_swdi_warnings_", as.character(startdate),"_", as.character(enddate))
    fldr_exists <- grepl(fldr_name,list.dirs())
  # download data
    if('TRUE' %in% fldr_exists == 'FALSE'){
      print("downloading data")
      swdi(dataset = 'warn', format = 'shp', startdate = startdate, enddate = enddate, filepath = fldr_name, limit = '10000000')
      # unzip
      zip_file <- paste0(getwd(),"/",fldr_name, ".zip")
      print(paste0("unzipping ", zip_file))
      unzip(zip_file, exdir = fldr_name)
    }
    else{
      print("data already downloaded, continuing...")
    }
    
  # set dir to downloaded folder
    setwd(fldr_name)
  
  # get shape file prefix
    list.files()[1]
    shape_file_name <- gsub("\\.+.*", "", list.files()[1])
  
  # read shape file
    shape_file <-readOGR(".", shape_file_name)
    setwd("..")
    unlink(fldr_name, recursive = TRUE)
    unlink(zip_file, recursive = TRUE)
  # read map data
    all_states <- map_data("state")
  
  # convert shape file data to ggplot format
    shape_ggplot <- fortify(shape_file, region = "id")
    shape_ggplot <- merge(shape_ggplot, shape_file@data, by = "id") # merge all fields by id
    names(shape_ggplot)[names(shape_ggplot)=="warningtyp"] <- "Warning" # rename warnings column
  
  # build ggplot object
    map_warnings <- ggplot() +
    geom_polygon( data=all_states, aes(x=long, y=lat, group = group), 
                    colour="grey10", fill="white") +
    geom_polygon(data = shape_ggplot, aes(x = long, y = lat, group = group, fill = Warning),
                   color = "red", size = 0.25) + theme_dendro()
  # plot
    map_warnings
  
  # return ggplot object
    return(map_warnings)
}

