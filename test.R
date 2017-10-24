library(shiny)
ui <- fluidPage(
     sliderInput("obs","Select number",min=0,max=1000,value=500),
     plotOutput("distPlot")
)
server <- function(input,output){
     output$distPlot=renderPlot({
          hist(rnorm(input$obs))
     })
}
shinyApp(ui=ui,server=server)



sliderInput("obs","Select number",min=0,max=1000,value=500)
