#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Multiple Regression Analysis"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       radioButtons("data","Select data",
                    choices=c("mtcars","iris","acs","radial")),
       selectInput("y","Reponse variable(종속변수)",choices=c()),
       selectInput("x","Explanatory variables(독립변수)",choices=c(),multiple=TRUE),
       actionButton("analysis","Analysis"),
       checkboxInput("se","show se")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
         checkboxInput("showDT","show datatable"),
         conditionalPanel(condition='input.showDT==true',
               DT::dataTableOutput("table")
         ),
         verbatimTextOutput("result"),
         uiOutput("plot.ui")

    )
  )
))
