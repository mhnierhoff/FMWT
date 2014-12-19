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
                switch(input$page,
                       "cologne" = cologne,
                       "A" = A,
                       "B" = B)
                
        })
        
        getModel <- reactive({
                switch(input$model,
                       "ETS" = ets(getDataset()),
                       "ARIMA" = auto.arima(getDataset()),
                       "TBATS" = tbats(getDataset(), use.parallel=TRUE),
                       "StructTS" = StructTS(getDataset(), "level"),
                       "Holt-Winters" = HoltWinters(getDataset(), gamma=FALSE))
        })
        
        output$caption1 <- renderText({
                paste("The web traffic of", input$page, "with", input$model, "Forecasting")
        })
        
        output$caption2 <- renderText({
                paste("The web traffic of", input$page, 
                      "decomposed into seasonal, trend and irregular components using loess (acronym STL).")
        })
        
        output$caption3 <- renderText({
                paste("The web traffic of", input$page, "with", input$model, "Forecasting")
        })
        
        plotDcomp <- function() {
                ds_ts <- ts(getDataset(), frequency=12)
                f <- stl(ds_ts, s.window="periodic", robust=TRUE)
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
                        paste(input$page, input$model,"Traffic-Forecasting",Sys.Date(),sep="-", ".pdf") 
                        },
                content <- function(file) {
                        pdf(file)
                        plotInput()
                        plotDcomp()
                        plotDiac()
                dev.off()
                }
        )
})