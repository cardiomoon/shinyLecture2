require(ggplot2)

function(input, output) {

  regEquation=reactive({
    options(digits = 2)
    fit <- eval(parse(text=paste0("lm( mpg ~",input$x,",data = mtcars)")))
    b   <- coef(fit)
    equation=paste0("mpg = ",round(b[2],2),input$x," + ",round(b[1],2))
    equation
  })
  output$regPlot <- renderPlot({
     input$analysis
    
     isolate({
       
     ggplot(data=mtcars,aes_string(req(input$x),"mpg"))+
         geom_point()+
         geom_smooth(method="lm")+
         ggtitle(regEquation())
     })
  })
  
  output$text=renderPrint({
    
    input$analysis
    
    isolate({
    options(digits = 2)
    fit <- eval(parse(text=paste0("lm(mpg ~",req(input$x),",data = mtcars)")))
    b   <- coef(fit)
    summary(fit)
    })
  })
  output$downloadReport <- downloadHandler(
    filename = function() {
      paste('my-report', sep = '.', switch(
        input$format, PDF = 'pdf', HTML = 'html', Word = 'docx'
      ))
    },

    content = function(file) {
      src <- normalizePath('report.Rmd')

      # temporarily switch to the temp dir, in case you do not have write
      # permission to the current working directory
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(src, 'report.Rmd', overwrite = TRUE)

      library(rmarkdown)
      out <- render('report.Rmd', switch(
        input$format,
        PDF = pdf_document(), HTML = html_document(), Word = word_document()
      ))
      file.rename(out, file)
    }
  )

}
