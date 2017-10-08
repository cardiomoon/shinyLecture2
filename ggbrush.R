library(shiny)
library(miniUI)
library(ggplot2)

ggbrush <- function(data, xvar, yvar) {
  
  ui <- miniPage(
    gadgetTitleBar("Drag to select points"),
    miniContentPanel(
      plotOutput("plot", height = "100%", brush = "brush")
    )
  )
  
  server <- function(input, output, session) {
    
    output$plot <- renderPlot({
      ggplot(data, aes_string(xvar, yvar)) + geom_point()
    })
    
    observeEvent(input$done, {
      stopApp(brushedPoints(data, input$brush))
    })
  }
  
  runGadget(ui, server)
}