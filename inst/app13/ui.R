fluidPage(
  titlePanel('Download a Report'),
  sidebarLayout(
    sidebarPanel(
      helpText(),
      selectInput('x', 'Build a regression model of mpg against:',
                  choices = c("",names(mtcars)[-1])),
      actionButton("analysis"," Analysis "),
      hr(),
      radioButtons('format', 'Document format', c('PDF', 'HTML', 'Word'),
                   inline = TRUE),
      downloadButton('downloadReport')
    ),
    mainPanel(
      verbatimTextOutput("text"),
      plotOutput('regPlot')
    )
  )
)
