library(shiny)
require(moonBook)
require(ggplot2)

ui=fluidPage(
  uiOutput("titleUI"),
  radioButtons("lang","select language",
               choices=c("english"="en","한국어"="kor"),inline=TRUE),
  uiOutput("mainUI")
 
  
)
server=function(input,output,session){
     
     langchoice=function(en,kor){
       ifelse(input$lang=="en",en,kor)
     }
     
     output$titleUI=renderUI({
         titlePanel(langchoice('Multiple Regression Analysis',"다중회귀분석"))
     })
     
     myeval=function(text){
         eval(parse(text=text))
     }
     
     data=reactive({
       myeval(input$data)
     })
     
     output$mainUI=renderUI({
       tagList(
         sidebarLayout(
           sidebarPanel(
             radioButtons("data",langchoice("Select data","데이터선택"),choices=c("mtcars","iris","acs","radial")),
             selectInput('y', langchoice('Response variable','반응변수'),choices = c("")),
             selectInput('x', langchoice('Explanatory variable(s)','설명변수(들)'),choices = "",multiple=TRUE),
             actionButton('analysis',langchoice("Analysis","다중회귀분석"))
           ),
           mainPanel(
             checkboxInput("showtable",langchoice("show data.table","데이터 테이블 보기"),value=TRUE),
             conditionalPanel(condition="input.showtable==true",
                              DT::dataTableOutput("table")),
             verbatimTextOutput("regText"),
             uiOutput('regUI')
           )
         )

       )
     })
     observeEvent(input$data,{
       updateSelectInput(session,"y",choices=colnames(data()))  
     })
     
     observeEvent(input$lang,{
         if(!is.null(input$y)){
           updateSelectInput(session,"y",choices=colnames(data()))  
         }
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
             if(length(input$x)>0){
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
             }
           })
     })
}
shinyApp(ui,server)
