shinyServer(function(input, output) {
  
 
  output$distPlot <- renderPlot({
      hist(rnorm(input$obs))
  })
  
  output$text <-renderPrint({
     summary(rnorm(input$obs)) 
  })
}) 