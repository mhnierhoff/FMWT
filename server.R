library(shiny)
library(shinyIncubator)
library(shinyapps)
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
                switch(input$variable,
                       "cologne" = cologne,
                       "A" = A,
                       "B" = B)
                
        })
        
        getModel <- reactive({
                switch(input$model,
                       "ETS" = ets(getDataset()),
                       "ARIMA" = auto.arima(getDataset()),
                       "TBATS" = tbats(getDataset(), use.parallel=TRUE),
                       "STL" = stl(log(getDataset(), s.window="periodic")))
        })
                
        #output$caption <- renderText({
        #        paste("Website: ", input$variable)
        #})
        
        plotDcomp <- function() {
                ds_ts <- ts(getDataset(), frequency=12)
                f <- decompose(ds_ts)
                plot(f)
        }
        
        output$dcompPlot <- renderPlot({
                plotDcomp()
        })
        
        plotDiac <- function() {
                dc_ts <- arima(getDataset(), order=c(1,0,1))
                tsdiag(dc_ts)
        }
        
        output$diacPlot <- renderPlot({
                plotDiac()
        })
        
        plotInput <- function() {
                plot(forecast(getModel(), h=input$ahead))
        }
        
        output$fmplot <- renderPlot({
                
                withProgress(session, {
                        setProgress(message = "Calculating, please wait",
                                    detail = "This may take a few moments...")
                        Sys.sleep(1)
                        setProgress(detail = "Still working...")
                        Sys.sleep(1)
                        setProgress(detail = "Almost there...")
                        Sys.sleep(1)
                        
                })
                
                plotInput()
                
        })
        
        output$downloadPlot <- downloadHandler(
                filename = function() { 
                        paste(input$variable, input$model,"Traffic-Forecasting",Sys.Date(),sep="-", ".pdf") 
                        },
                content <- function(file) {
                        pdf(file)
                        plotInput()
                        plotDiac()
                        plotDcomp()
                dev.off()
                }
        )
})