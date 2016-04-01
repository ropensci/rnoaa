library("shiny")
library("dplyr")
library("zoo")
library("lubridate")
library("xtable")
library("shinydashboard")
library("datasets")
library("DT")
library("ggiraph")
library("ammon")
options(RCHART_LIB = 'highcharts')
shinyUI(fluidPage(

  titlePanel("Exploring microPEM output"),

  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Choose file to explore',
                accept = c(
                  'text/csv',
                  'text/comma-separated-values',
                  'text/tab-separated-values',
                  'text/plain',
                  '.csv',
                  '.tsv'
                )),
      selectInput("version", "Version:",
                  c("CHAI" = "CHAI",
                    "Columbia1" = "Columbia1",
                    "Columbia2" = "Columbia2")),
      actionButton("go", "Go")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Summary",
                 DT::dataTableOutput("Summary")),
        tabPanel("Alarms",
                 DT::dataTableOutput("Alarms")),
        tabPanel("Plots",
                 fluidRow(

                   ggiraph::ggiraphOutput("plotPM")


                 )),


        tabPanel("Settings",
                 DT::dataTableOutput("Settings"))
      )
    )
  )

  )
)

