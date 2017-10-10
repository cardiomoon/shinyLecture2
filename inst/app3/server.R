shinyServer(function(input, output) {
  output$distPlot <- renderPlot({
   
    input$update
    
    isolate({
    dist <- rnorm(input$obs)
  
    hist(dist,main=input$title)
    })
  })
}) 