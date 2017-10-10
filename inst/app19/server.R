#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(moonBook)
library(ggplot2)
library(ggiraph)
library(ggiraphExtra)

# Define server logic required to draw a histogram
shinyServer(function(session,input, output) {
   
     mydata=reactive({
          df=eval(parse(text=input$data))
          df
     })
     
    output$table=DT::renderDataTable(
         mydata()
    )
    
    pasteplus=function(...){
         paste(...,sep="+")
    }
    
    # x=LETTERS[1:5]
    # x
    # Reduce(pasteplus,x)
    
    lmformula=reactive({
         result=NULL
         if(length(input$x)>0) result=paste0(input$y,"~",Reduce(pasteplus,input$x))
         result
    })
    
    observeEvent(input$data,{
         updateSelectInput(session,"y",choices=colnames(mydata()))
    })
    
    observeEvent(input$y,{
         updateSelectInput(session,"x",choices=setdiff(colnames(mydata()),input$y))
    })
    
    output$result=renderPrint({
         
         input$analysis
         
         isolate({
         if(length(input$x)>0){
         myformula=lmformula()
         temp=paste0("lm(",myformula,",data=",input$data,")")
         fit=eval(parse(text=temp))
         summary(fit)
         }
         })
    })
    
    myeval=function(...){
         eval(parse(text=paste0(...)))
    }
    
    output$plot.ui=renderUI({
         input$analysis
         
         isolate({
              plot_list=NULL
              if(length(input$x)>0){
                   df=mydata()
                   for (i in seq_along(input$x)){
                        local({
                        j=i
                        plotname=paste0("plot",j)
                        output[[plotname]]=renderggiraph({
                             fit=myeval("lm(",input$y,"~",input$x[j],",data=",input$data,")")
                             ggPredict(fit,se=input$se,interactive = TRUE)
                        })
                        })
                   }
              
         
         
         plot_list=lapply(seq_along(input$x),function(i){
              plotname=paste0("plot",i)
              ggiraphOutput(plotname)
         })
         
         
         
              }
              if(!is.null(plot_list)) do.call(tagList,plot_list)
         })
    })
   
    
   
  
})
