require(shiny)
require(moonBook)

fluidPage(
  titlePanel('Multiple Regression Analysis'),
  sidebarLayout(
    sidebarPanel(
      radioButtons("data","Select data",choices=c("mtcars","iris","acs","radial")),
      selectInput('y', 'Response variable(종속변수)',choices = c("")),
      selectInput('x', 'Explanatory variable(s)(독립변수)',choices = c(""),multiple=TRUE),
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
