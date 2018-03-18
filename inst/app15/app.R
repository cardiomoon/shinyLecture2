library(shiny)
require(moonBook)
require(ggplot2)

ui=fluidPage(
  titlePanel('Multiple Regression Analysis'),
  sidebarLayout(
    sidebarPanel(
      radioButtons("data","Select data",choices=c("mtcars","iris","acs","radial")),
      selectInput('y', 'Response variable',choices = c("")),
      selectInput('x', 'Explanatory variable(s)',choices = c(""),multiple=TRUE),
      actionButton('analysis',"Analysis")
    ),
    mainPanel(
      checkboxInput("showtable","show data.table",value=TRUE),
      conditionalPanel(condition="input.showtable==true",
                       DT::dataTableOutput("table")),
      verbatimTextOutput("regText"),
      uiOutput('regUI')
    )
  )
)
server=function(input,output,session){
     myeval=function(text){
         eval(parse(text=text))
     }
     
     data=reactive({
        myeval(input$data)
     })
     
     observeEvent(input$data,{
         updateSelectInput(session,"y",choices=colnames(data()))  
     })
     
     observeEvent(input$y,{
       choices=setdiff(colnames(data()),input$y)
       updateSelectInput(session,"x",choices=choices)  
     })
     
     output$table=DT::renderDataTable(data())
     
     regFormula=reactive({
         temp=""
         if(length(input$x)>0) {
            temp=paste0(input$y,"~",stringr::str_c(input$x,collapse="+"))
         }
         temp
     })
     
     output$regText=renderPrint({
         input$analysis
       
          isolate({
         if(regFormula()!=""){
              temp=paste0("lm(",regFormula(),",data=",input$data,")")
              result<-myeval(temp)
              summary(result)
         }
          })
     })
     
     output$regUI=renderUI({
          input$analysis
       
           isolate({
               for(i in seq_along(input$x)){
                 local({
                   j<-i
                   plotname=paste0("regPlot",j)
                   output[[plotname]]=renderPlot({
                        ggplot(data(),aes_string(x=input$x[j],input$y))+
                       geom_point()+geom_smooth(method="lm")
                   })
                 })
               }
               
               plotlist=lapply(1:length(input$x),function(i){
                  plotname=paste0("regPlot",i)
                  plotOutput(plotname)
               })
               
               do.call(tagList,plotlist)
           })
     })
}
shinyApp(ui,server)
