library("shiny")
library("dplyr")
library("leaflet")
library("rnoaa")
library("httr")
library("geosphere")
library("purrr")



station_data <- rnoaa::ghcnd_stations()[[1]]



shinyServer(function(input, output) {
  points <- eventReactive(input$go, {
  closest <- rnoaa::meteo_nearby_stations(data.frame(latitude = input$latitude,
                                 longitude = input$longitude,
                                 id = factor("here")),
                                 station_data = station_data,
                      "latitude",
                      "longitude",
                      input$radius)

  rbind_all(closest)%>%
    filter(!is.na(latitude))
})

  now <- eventReactive(input$go, {
    #stations <- ghcnd()
    data.frame(latitude = input$latitude,
               longitude = input$longitude)
  })

  radius <- eventReactive(input$go, {
    #stations <- ghcnd()
    as.numeric(input$radius)
  })

  output$mymap <- renderLeaflet({
    input$go

    lat2 <- destPoint(p = c(now()$longitude,
                              now()$latitude),
                        b = 0,
                        d = radius()*1000)[1,2]
    lat1 <- destPoint(p = c(now()$longitude,
                            now()$latitude),
                      b = 180,
                      d = radius()*1000)[1,2]
    lon2 <- destPoint(p = c(now()$longitude,
                            now()$latitude),
                      b = 90,
                      d = radius()*1000)[1,1]
    lon1 <- destPoint(p = c(now()$longitude,
                            now()$latitude),
                      b = 270,
                      d = radius()*1000)[1,1]

    leaflet() %>%
      addTiles() %>%  # Add default OpenStreetMap map tiles
      addCircles(data=now(), lat = ~latitude, lng = ~longitude,
                radius = radius()*1000,
              fillColor = "green", color = "green", fillOpacity=0.2)%>%  # Add default OpenStreetMap map tiles
      addCircleMarkers(data=now(), lat = ~latitude, lng = ~longitude,
                       popup = "Your location", fillColor = "red") %>%
      addMarkers(data=points(), lat = ~latitude, lng = ~longitude,
                 popup = ~id) %>%
      fitBounds(lng1 = as.numeric(lon1),
                lat1 = as.numeric(lat1),
                lng2 = as.numeric(lon2),
                lat2 = as.numeric(lat2))

  })

})

