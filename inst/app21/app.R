library(shiny)

newApp=function(session){
  protocol<-session$clientData$url_protocol
  hostname<-session$clientData$url_hostname
  port<-session$clientData$url_port
  
  url<-paste0(protocol,"//",hostname,":",port)
  browseURL(url)
}

varA <- 1
varB <- 1

ui=fluidPage(
    radioButtons("select","select Data",choices=c("iris","mtcars","mpg")),
    verbatimTextOutput("text"), 
    actionButton("newApp","new App")
)
server=function(input,output,session){
  
  varA <- varA + 1
  
  varB <<- varB + 1
  
  output$text=renderPrint({
      cat("your choice=",input$select,"\n")
      varA <<- varA+1
      cat("varA=",varA,"\n")
      cat("varB=",varB,"\n")
      
  })
  
   observeEvent(input$newApp,{
       newApp(session)
   })
}

shinyApp(ui,server)
