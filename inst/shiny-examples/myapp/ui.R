library("shiny")
library("dplyr")
library("leaflet")

library("rnoaa")
library("httr")

library("geosphere")
library("purrr")




options(RCHART_LIB = 'highcharts')
shinyUI(fluidPage(

  titlePanel("Exploring microPEM output"),

  sidebarLayout(
    sidebarPanel(
      numericInput("latitude", "latitude", value = 37.779199),
      numericInput("longitude", "longitude", value = -122.404294),
      numericInput("radius", "radius", value = 10),
      actionButton("go", "Go")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Summary",
                 leafletOutput("mymap"))
      )
    )
  )

  )
)

