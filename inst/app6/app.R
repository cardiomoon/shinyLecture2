library(shiny)
library(shinyBS)
shinyApp(
  ui =
    fluidPage(
      sidebarLayout(
        sidebarPanel(
          sliderInput("bins",
                      "Move the slider to see its effect on the button below:",
                      min = 1,
                      max = 50,
                      value = 1),
          
          bsButton("actTwo", label = "Click me if you dare!", icon = icon("ban")),
          bsTooltip("actTwo", "You can show tooltip like this",
                    "right", options = list(container = "body")),
          tags$p("Clicking the first button below changes the disabled state of the second button."),
          bsButton("togOne", label = "Toggle 'Block Action Button' disabled status", block = TRUE, type = "toggle", value = TRUE),
          bsButton("actOne", label = "Block Action Button", block = TRUE)
          
        ),
        mainPanel(
          plotOutput("distPlot"),
          textOutput("exampleText")
        )
      )
    ),
  server =
    function(input, output, session) {
      observeEvent(input$togOne, ({
        updateButton(session, "actOne", disabled = !input$togOne)
      }))
      observeEvent(input$bins, ({
        
        b <- input$bins
        disabled = NULL
        style = "default"
        icon = ""
        
        if(b < 5) {
          disabled = TRUE
          icon <- icon("ban")
        } else {
          disabled = FALSE
        }
        
        if(b < 15 | b > 35) {
          style = "danger"
        } else if(b < 20 | b > 30) {
          style = "warning"
        } else {
          style = "default"
          icon = icon("check")
        }
        
        updateButton(session, "actTwo", disabled = disabled, style = style, icon = icon)
        
      }))
      
      output$exampleText <- renderText({
        input$actTwo
        b <- isolate(input$bins)
        txt = ""
        if((b > 5 & b < 15) | b > 35) {
          txt = "That was dangerous."
        } else if((b > 5 & b < 20) | b > 30) {
          txt = "I warned you about that."
        } else if(b >= 20 &  b <= 30) {
          txt = "You have choosen... wisely."
        }
        return(txt)
      })
      output$distPlot <- renderPlot({
        
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)
        
        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
        
      })
      addPopover(session, "distPlot", "Data", content = paste0("
                                                               Waiting time between ",
                                                               "eruptions and the duration of the eruption for the Old Faithful geyser ",
                                                               "in Yellowstone National Park, Wyoming, USA.
                                                               
                                                               Azzalini, A. and ",
                                                               "Bowman, A. W. (1990). A look at some data on the Old Faithful geyser. ",
                                                               "Applied Statistics 39, 357-365.
                                                               
                                                               "), trigger = 'click')
    }
)


