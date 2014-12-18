library(shiny)
library(shinyIncubator)
library(zoo)
library(timeDate)
library(datasets)
library(forecast)
library(zoo)
library(knitr)
library(rmarkdown)

source("data.R")


shinyServer(function(input, output, session) {
        
        getDataset <- reactive({
                if (input$variable=="cologne")
                {
                        return(cologne)
                }
                else if (input$variable=="A")
                {
                        return(A)
                }
                else
                {
                        return(B)
                }
        })
        
        #output$caption <- renderText({
        #        paste("Website: ", input$variable)
        #})
        
        output$dcompPlot <- renderPlot({
                ds_ts <- ts(getDataset(), frequency=12)
                f <- decompose(ds_ts)
                plot(f)
        })
     
        
## new UI with Radio Buttons

        output$plot <- renderPlot({
                
                withProgress(session, {
                        setProgress(message = "Calculating, please wait",
                                    detail = "This may take a few moments...")
                        Sys.sleep(1)
                        setProgress(detail = "Still working...")
                        Sys.sleep(1)
                        setProgress(detail = "Almost there...")
                        Sys.sleep(1)
                        
                })
                
                                if(input$model=="ETS")
                                        fit <- ets(getDataset())
                                
                                if(input$model=="ARIMA")
                                        fit <- auto.arima(getDataset())
                                
                                if(input$model=="TBATS")
                                        fit <- tbats(getDataset(), use.parallel=TRUE)
                                
                                if(input$model=="STL")
                                        fit <- stl(getDataset(), s.window="periodic")
                
                plot(forecast(fit, h=input$ahead))
                
                ## Generating pdf report
                output$report = downloadHandler(
                        filename = "myreport.pdf",
                        
                        content = function(file) {
                                out = knit2pdf("input.Rnw", clean = TRUE)
                                file.rename(out, file) # move pdf to file for downloading
                        },
                        
                        contentType = "application/pdf"
                )
        })

})