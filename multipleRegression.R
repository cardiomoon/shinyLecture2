library(shiny)
library(ggplot2)

ui=fluidPage(
  selectInput("x","x",choices=setdiff(colnames(mtcars),"mpg"),multiple=TRUE,
              selected=NULL),
  verbatimTextOutput("text"),
  uiOutput("plotUI")
)

server=function(input,output){
  
  model=reactive({
    fit<-NULL
    if(!is.null(input$x)){
    tempvar=stringr::str_c(input$x,collapse="+")
    temp=paste0("lm(mpg~",tempvar,",data=mtcars)")
    fit<-eval(parse(text=temp))
    }
    fit
  })
  
   output$text=renderPrint({
       result=model()
       if(is.null(result)){
          cat("Please select independent variable(s)")
       } else{
          summary(result)
       }
   })
   
   output$plotUI=renderUI({
     if(!is.null(input$x)){
        for(i in 1:length(input$x)){
          local({
            j<-i
             output[[paste0("plot",j)]]=renderPlot({
                  ggplot(data=mtcars,aes_string(input$x[j],"mpg"))+
                 geom_point()+geom_smooth(method="lm")
             })
          })
        }
        
        plotlist=lapply(1:length(input$x),
                        function(i) {plotOutput(paste0("plot",i))})
        
        do.call(tagList,plotlist)
     }
     
   })
   
}

shinyApp(ui=ui,server=server)
