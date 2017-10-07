shinyServer(function(input, output) {
  output$distPlot <- renderPlot({
    # Take a dependency on input$goButton
    input$goButton
    
    # Use isolate() to avoid dependency on input$obs
    dist <- isolate(rnorm(input$obs))
    hist(dist)
  })
}) 