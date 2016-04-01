#library(sp)
#library(rgeos)

library(leaflet)
library(dplyr)
#library(memoise)


# rnoaa::ghcnd_stations() returns a list containing a dataframe with  all of the 
# weather stations available
stations <- ghcnd_stations()$data
#> names(stations)
# [1] "id"         "latitude"   "longitude"  "elevation"  "name"      
# [6] "gsn_flag"   "wmo_id"     "element"    "first_year" "last_year" 

small_stations <- 
  stations %>% 
  distinct(latitude, longitude) %>% 
  dim()

  stations %>% 
  distinct(latitude, longitude, first_year, last_year) %>% 
  dim()

#-------------------------------------------------------------------------------
# Location of all weather stations
#-------------------------------------------------------------------------------

m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addCircles(data=stations %>% distinct(latitude, longitude), lat = ~latitude, lng = ~longitude)
m  # Print the map


#-------------------------------------------------------------------------------
# Example - display sites within 100 km from a site located at lat = -15, long = 145

list_oz_stations <- grep('^ASN', stations$id)
oz_stations <- stations[list_oz_stations, ]
data <- meteo_distance(data = oz_stations, lat = -15, long = 145, radius = 100)

m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addCircles(data=data, lat = ~latitude, lng = ~longitude) %>%
  addCircles(data = data, lat = ~-15, lng = ~145, color = 'red', radius = 80)
m  # Print the map