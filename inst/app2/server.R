shinyServer(function(input, output) {
  output$distPlot <- renderPlot({
    # Take a dependency on input$goButton
    # Use isolate() to avoid dependency on input$obs
    dist <- rnorm(input$obs)
  
    hist(dist,main=input$title)
  })
}) 