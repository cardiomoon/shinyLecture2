library(shiny)
library(moonBook)
library(ggplot2)


regressionInput=function(id){
    ns=NS(id)
    
    tagList(
    uiOutput(ns("regression"))
    )
}

regression=function(input,output,session,
                    lang=reactive("")){
  
     ns=session$ns
     
     langchoice=function(en,kor){
       ifelse(lang() == "en",en,kor)
     }
     output$regression=renderUI({
      
      tagList(
        fluidRow(
          column(4,
                 wellPanel(
                   radioButtons(ns("data"),langchoice("data","데이터선택"),choices=c("mtcars","iris","acs","radial")),
                   selectInput(ns("y"),langchoice("Response Variable","반응변수"),c("")),
                   selectInput(ns("x"),langchoice("Explanatory Variable(s)","설명변수"),c(""),multiple=TRUE),
                   
                   actionButton(ns("analysis"),langchoice("analysis","다중회귀분석"))
                 )
          ),
          column(8,
                 checkboxInput(ns("showtable"),langchoice("show data table","데이터테이블보기")),
                 conditionalPanel(sprintf("input['%s']==true",ns("showtable")),
                                  DT::dataTableOutput(ns("table"))),
                 verbatimTextOutput(ns("text")),
                 uiOutput(ns("plotUI"))
          )
        )
      )
       
     })
     
     
     
     
      myeval=function(temp){
        eval(parse(text=temp))
      }
      
      data=reactive({
           myeval(input$data)
      })
      
      output$table=DT::renderDataTable({
        data()
      })
      
      observeEvent(lang(),{
        if(!is.null(input$data)){
           updateRadioButtons(session,"data",selected=input$data)
        }
        if(!is.null(input$y)){
          updateSelectInput(session,"y",choices=colnames(data()))
          updateSelectInput(session,"x",choices=setdiff(colnames(data()),input$y),selected=input$x)
        }
      })
      
      observeEvent(input$data,{
        updateSelectInput(session,"y",choices=colnames(data()))
      })
      
      observeEvent(input$y,{
        updateSelectInput(session,"x",choices=setdiff(colnames(data()),input$y))
      })
      
      regFormula=reactive({
        temp=""
        if(length(input$x)>0){
          temp=paste0(input$y,"~",stringr::str_c(input$x,collapse="+"))
        }
        temp
      })
      
      output$text=renderPrint({
        input$analysis
        
        isolate({
          if(length(input$x)>0){
            result=myeval(paste0("lm(",regFormula(),",data=",input$data,")"))
            summary(result)
          }
        })
      })
      output$plotUI=renderUI({
        
        input$analysis
        
        isolate({
          for(i in seq_along(input$x)){
            local({
              j<-i
              plotname=paste0("plot",j)
              output[[plotname]]=renderPlot({
                ggplot(data(),aes_string(x=input$x[j],y=input$y))+
                  geom_point()+geom_smooth(method="lm")
              })
            })
          }
          
          plotlist=lapply(1:length(input$x),function(i){
            plotname=paste0("plot",i)
            plotOutput(ns(plotname))
          })
          
          do.call(tagList,plotlist)
        })
      })
}


ui=fluidPage(
   uiOutput("title"),
   radioButtons("language","Select Language",
                choices=c("English"="en","Korean"="kor"),inline=TRUE),
   regressionInput("reg")
 )
server=function(input,output,session){
    
     langchoice=function(en,kor){
         ifelse(input$language=="en",en,kor)
     }
     output$title=renderUI({
       titlePanel(langchoice("Multiple Regression Analysis using Shiny Module","shiny module을 사용한 다중회귀분석"))
     })
     
     observeEvent(input$language,{
         if(input$language=="en"){
            updateRadioButtons(session,"language","Select Language",
                        choices=c("English"="en","Korean"="kor"),inline=TRUE,selected=input$language)
         } else{
           updateRadioButtons(session,"language","언어선택",
                              choices=c("영어"="en","한국어"="kor"),inline=TRUE,selected=input$language)
         }
     })
     callModule(regression,"reg",lang=reactive(input$language))

}

shinyApp(ui,server)
