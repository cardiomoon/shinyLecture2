library(shiny)

testInput=function(id){
      ns<-NS(id)
      
      uiOutput(ns("test"))
}

test=function(input,output,session){
     
     ns<-session$ns
     output$test=renderUI({
          tagList(
               sliderInput(ns("obs"),"Select number",min=0,max=1000,value=500),
               plotOutput(ns("distPlot")),
               verbatimTextOutput(ns("text"))
          )
     })
     output$distPlot=renderPlot({
          hist(rnorm(input$obs))
     })
     
     output$text=renderPrint({
          ns("text")
     })
}

ui <- fluidPage(
     
     testInput("test1")
     
)
server <- function(input,output){
     
     callModule(test,"test1")
}
shinyApp(ui=ui,server=server)




