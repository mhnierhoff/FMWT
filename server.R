################# ~~~~~~~~~~~~~~~~~ ######## ~~~~~~~~~~~~~~~~~ #################
##                                                                            ##
##                   Forecasting Models for Website Traffic                   ##
##                                                                            ##            
##                    App & Code by Maximilian H. Nierhoff                    ##
##                                                                            ##
##                           http://nierhoff.info                             ##
##                                                                            ##                     
##         Live version of this app: https://nierhoff.shinyapps.io/FMWT       ##
##                                                                            ##
##         Github Repo for this app: https://github.com/mhnierhoff/FMWT       ##
##                                                                            ##
################# ~~~~~~~~~~~~~~~~~ ######## ~~~~~~~~~~~~~~~~~ #################


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

        ################# ~~~~~~~~~~~~~~~~~ #################
        
##########       Getting the data for the websites         ##
        
        ################# ~~~~~~~~~~~~~~~~~ #################        

        getDataset <- reactive({
                switch(input$page,
                       "cologne" = cologne,
                       "A" = A,
                       "B" = B)
                
        })


        ################# ~~~~~~~~~~~~~~~~~ #################

##########       Creation of the forecasting models        ##

        ################# ~~~~~~~~~~~~~~~~~ ################# 

        getModel <- reactive({
                switch(input$model,
                       "ETS" = ets(getDataset()),
                       "ARIMA" = auto.arima(getDataset()),
                       "TBATS" = tbats(getDataset(), use.parallel=TRUE),
                       "StructTS" = StructTS(getDataset(), "level"),
                       "Holt-Winters" = HoltWinters(getDataset(), gamma=FALSE),
                       "Theta" = thetaf(getDataset()),
                       "Neural Network" = nnetar(getDataset()))
        })


        ################# ~~~~~~~~~~~~~~~~~ #################
        ##
##########         Caption creation for tabpanels          ##
        ##
        ################# ~~~~~~~~~~~~~~~~~ #################
        

        output$caption1 <- renderText({
                paste("The web traffic of", input$page, "with", 
                      input$model, "forecasting model.")
        })
        
        output$caption2 <- renderText({
                paste("The data of the forecasted next", input$ahead, 
                      "months of the website", input$page, "with the", 
                      input$model, "forecasting model.")
        })

        output$caption3 <- renderText({
                paste("The web traffic of", input$page, 
                      "decomposed into seasonal, trend and irregular components 
                      using loess (acronym STL).")
        })

        output$caption4 <- renderText({
                paste("The web traffic of", input$page, 
                      "into seasonal, trend and irregular components using 
                      moving averages.The additive model uses the following 
                      formula: Y[t] = T[t] + S[t] + e[t]")
        })

        
        ################# ~~~~~~~~~~~~~~~~~ #################
        ##
##########       STL Timeseries Decomposition Plot         ##
        ##
        ################# ~~~~~~~~~~~~~~~~~ #################

        plotSTLdcomp <- function() {
                ds_ts <- ts(getDataset(), frequency=12)
                STLdcomp <- stl(ds_ts, s.window="periodic", robust=TRUE)
                plot(STLdcomp)
        }
        
        output$STLdcomp <- renderPlot({
                plotSTLdcomp()
        })

        ################# ~~~~~~~~~~~~~~~~~ #################
        ##
##########       Normal Timeseries Decomposition Plot      ##
        ##
        ################# ~~~~~~~~~~~~~~~~~ #################

        plotNdcomp <- function() {
                ds_ts <- ts(getDataset(), frequency=12)
                Ndcomp <- decompose(ds_ts)
                plot(Ndcomp)
        }

        output$Ndcomp <- renderPlot({
                plotNdcomp()
        })



        ################# ~~~~~~~~~~~~~~~~~ #################
        ##
##########         Forecasting model plot creation         ##
        ##
        ################# ~~~~~~~~~~~~~~~~~ #################
           
        plotInput <- function() {
                plot(forecast(getModel(), h=input$ahead))
        }
        
        output$fmplot <- renderPlot({
                
                ##########    Adding a progress bar  ##########
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


        ################# ~~~~~~~~~~~~~~~~~ #################

##########        Forecasting model table creation         ##

        ################# ~~~~~~~~~~~~~~~~~ #################

        tableInput <- function() {
                forecast(getModel(), h=input$ahead)
        }

        output$fmtable <- renderPrint({
        
                ##########    Adding a progress bar  ##########
                withProgress(session, {
                        setProgress(message = "Calculating, please wait",
                                    detail = "This may take a few moments...")
                        Sys.sleep(1)
                        setProgress(detail = "Still working...")
                        Sys.sleep(1)
                        setProgress(detail = "Almost there...")
                        Sys.sleep(1)
                
                })
        
                tableInput()
        
        })


        ################# ~~~~~~~~~~~~~~~~~ #################

##########              PDF Download Handler               ##

        ################# ~~~~~~~~~~~~~~~~~ #################

        output$downloadPlot <- downloadHandler(
                filename = function() { 
                        paste(input$page, input$model,"Traffic-Forecasting",
                              Sys.Date(),sep="-", ".pdf") 
                        },
                content <- function(file) {
                        pdf(file)
                        plotInput()
                        plotSTLdcomp()
                        plotNdcomp()
                        tableInput()
                dev.off()
                }
        )
})