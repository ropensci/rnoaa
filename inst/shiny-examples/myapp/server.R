library("shiny")
library("dplyr")
library("zoo")
library("lubridate")
library("xtable")
library("shinydashboard")
library("ammon")
library("DT")
library("ggiraph")

shinyServer(function(input, output) {


  microPEMObject <- eventReactive(input$go, {

    file <- reactive({input$file1})
    if (is.null(input$file1))
    return(NULL)

    else {
      convertOutput(file()$datapath, version=input$version)
    }
       })

  output$Settings<- DT::renderDataTable({
    file <- reactive({input$file1})
    if (is.null(input$file1))
      return(NULL)

    else {
      data.frame(value = t(microPEMObject()$control)[,1])

    }
  }, options = list(pageLength = 41))




    output$Summary <- DT::renderDataTable({
      microPEMObject()$summary()
    })

    output$Alarms <- DT::renderDataTable({
      alarmCHAI(microPEMObject())
    })

    gg_plot <- eventReactive(input$go, {

      file <- reactive({input$file1})
      if (is.null(input$file1))
        return(NULL)

      else {
        microPEMObject()$plot(type="interactive")
      }
    })

    output$plotPM <-  renderggiraph({
      ggiraph(code = print(gg_plot()), width = 12, height = 10,
              hover_css = "fill:orange;stroke-width:1px;stroke:wheat;cursor:pointer;")
    })


})

