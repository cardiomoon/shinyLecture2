function(input, output,session) {
  
  data=reactive({
       data=eval(parse(text=input$data))
       data
  })
  
  observeEvent(input$data,{
       df<-data()
       updateSelectInput(session,"y",choices=colnames(df))
  })
  
  observeEvent(input$y,{
      df<-data()
      updateSelectInput(session,"x",choices=setdiff(colnames(df),input$y))
  })
  
  output$table <- DT::renderDataTable(DT::datatable({
    
      df<-data()
      df
  }))
  
  pasteplus=function(...){
      paste(...,sep="+")
  }
  
  regFormula=reactive({
      result=NULL
      if(length(input$x)>0) {
           result=paste0(input$y,"~",Reduce(pasteplus,input$x))
      }
      result
  })
  
  myeval=function(...){
     eval(parse(text=paste0(...)))  
  }
  
  output$regText=renderPrint({
    
    input$analysis
    
    
    formula=isolate(req(regFormula()))
    
    fit=isolate(myeval("lm(",formula,",data=",input$data,")"))
    
    summary(fit)
  })
  
  
  output$regUI <- renderUI({
    
    input$analysis
    
    formula=isolate(req(regFormula()))
    
    df=data()
    

    for(i in 1:length(input$x)){
      local({
          j=i
          
          out=myeval("lm(",input$y,"~",input$x[j],",data=",input$data,")")
        
          plotname=paste0("plot",j)
          output[[plotname]]=renderPlot({
          #plot(df[[input$x[j]]],df[[input$y]])
            
            input$analysis
            
            isolate({
            myeval("plot(",input$data,"$",input$x[j],",",input$data,"$",input$y,")")
            abline(out,col="red")
            })
          })
          
      })
    }
    
    plot_list <- lapply(1:length(input$x), function(i) {
      plotname <- paste0("plot", i)
      plotOutput(plotname)
    })
    
    do.call(tagList,plot_list)

  })

}
