library(shiny)
library(zoo)
library(timeDate)
library(datasets)
library(forecast)
library(zoo)
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
        })

## Downloadable file

        downloadFileType <- reactive({
        input$downloadFileType  
        })

        # Include a downloadable file of the plot in the output list.
        output$downloadPlot <- downloadHandler(
        filename = function() {
                paste("Website: ", input$variable, "with" , input$model, "Forecasting", downloadFileType(), sep="-")   
        },
        # The argument content below takes filename as a function
        # and returns what"s printed to it.
        content = function(con) {
                # Gets the name of the function to use from the 
                # downloadFileType reactive element. Example:
                # returns function pdf() if downloadFileType == "pdf".
                plotFunction <- match.fun(downloadFileType())
                plotFunction(con)
                        print(plot(fit))
                dev.off(which=dev.cur())
        }
        )
})