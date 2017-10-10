library(shiny)

ui <- fluidPage(
   column(6,
    sliderInput("obs", "Number of observations:",
                min = 0, max = 1000, value = 500)),
  column(6,
  plotOutput("distPlot"))
)

server <- function(input,output){
  
  output$distPlot <- renderPlot({
    hist(rnorm(input$obs))
  })
}

shinyApp(ui=ui,server=server)
