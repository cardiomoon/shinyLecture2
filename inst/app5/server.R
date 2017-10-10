shinyServer(function(input, output) {
  
  data <- reactive({
      rnorm(input$obs)
  })
  output$distPlot <- renderPlot({
      hist(data())
  })
  
  output$text <-renderPrint({
     summary(data()) 
  })
}) 