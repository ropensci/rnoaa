require(dplyr)
require(rnoaa)
require(ggplot2)
require(ggmap)

storm_path <- function(name, year, location, local = TRUE){
  # name: name of the storm
  # year: year of the storm
  # location: location of the storm
  # local: if true, plot the local map; else, plot the whole plot

  hurrs_year <- storm_data(year = year)
  storm <- hurrs_year$data[which(hurrs_year$data$name == name), ]
  if(sum(storm$latitude == -999)){
    storm <- storm[-c(which(storm$latitude == -999)),]
  }
  storm_loc <- select(storm, iso_time, latitude, longitude, wind.wmo.)

  if(local){
    map <- get_map(location = location, zoom = 5)
  }else{
    map <- get_map(location = location, zoom = 3, source='google')
  }
  ggmap(map) +
    geom_path(data = storm_loc, aes(x = longitude, y = latitude)) +
    geom_point(data = storm_loc, aes(x = longitude, y = latitude,
                                     color = wind.wmo.))
}

# Example:
storm_path(name = "BILIS", year = 2006, location = "Fuzhou", local = T)
