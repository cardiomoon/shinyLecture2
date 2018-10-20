library(shiny)
library(editData)


ui <- fluidPage(
  textInput("mydata","Enter data name",value="mtcars"),
  editableDTUI("table1"),
  verbatimTextOutput("test")
)
server <- function(input, output) {
  df=callModule(editableDT,"table1",dataname=reactive(input$mydata))
  
  output$test=renderPrint({
    head(df())
  })
}
shinyApp(ui, server)
