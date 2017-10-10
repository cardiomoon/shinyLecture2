shinyUI(pageWithSidebar(
  headerPanel("Click the button"),
  sidebarPanel(
    sliderInput("obs", "Number of observations:",
                min = 0, max = 1000, value = 500),
    textInput("title","title",value="Histogram")
  ),
  mainPanel(
    plotOutput("distPlot")
  )
))