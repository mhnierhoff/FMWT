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
library(knitr)
library(rmarkdown)

source("data.R")

shinyServer(function(input, output, session) {

############################### ~~~~~~~~~~~~~~~~~ ##############################
        
## Getting the data for the websites         

        getDataset <- reactive({
                switch(input$page,
                       "spotted.de" = alexaTrafficRank[,2],
                       "meckr.net" = alexaTrafficRank[,3],
                       "womenweb.de" = alexaTrafficRank[,4],
                       "kochrezepte.de" = alexaTrafficRank[,5],
                       "spontacts.com" = alexaTrafficRank[,6],
                       "autoinfo.de" = alexaTrafficRank[,7],
                       "hoccer.com" = alexaTrafficRank[,8],
                       "einfachlotto.de" = alexaTrafficRank[,9],
                       "yasni.de" = alexaTrafficRank[,10],
                       "tape.tv" = alexaTrafficRank[,11],
                       "merkando.de" = alexaTrafficRank[,12],
                       "make.tv" = alexaTrafficRank[,13],
                       "ferien-touristik.de" = alexaTrafficRank[,14],
                       "dailyme.de" = alexaTrafficRank[,15])
                
        })


############################### ~~~~~~~~~~~~~~~~~ ##############################

## Creation of the forecasting models        

        getModel <- reactive({
                switch(input$model,
                       "ETS" = ets(getDataset()),
                       "ARIMA" = auto.arima(getDataset()),
                       "TBATS" = tbats(getDataset(), use.parallel=TRUE),
                       "StructTS" = StructTS(getDataset(), "level"),
                       "Holt-Winters" = HoltWinters(getDataset(), gamma=FALSE),
                       "Theta" = thetaf(getDataset()),
                       "Random Walk" = rwf(getDataset()),
                       "Naive" = naive(getDataset()),
                       "Mean" = meanf(getDataset()),
                       "Cubic Spline" = splinef(getDataset()))
        })


############################### ~~~~~~~~~~~~~~~~~ ##############################
        
## Caption creation for tabpanels          
        

        output$caption1 <- renderText({
                paste("The web traffic of", input$page, "with", 
                      input$model, "forecasting model.")
        })
        
        output$caption2 <- renderText({
                paste("The data of the forecasted next", input$ahead, 
                      "days of the website", input$page, "with the", 
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

        
############################### ~~~~~~~~~~~~~~~~~ ##############################
        
## STL Timeseries Decomposition Plot         

        plotSTLdcomp <- function() {
                ds_ts <- ts(getDataset(), frequency=12)
                STLdcomp <- stl(ds_ts, s.window="periodic", robust=TRUE)
                plot(STLdcomp)
        }
        
        output$STLdcomp <- renderPlot({
                plotSTLdcomp()
        })

############################### ~~~~~~~~~~~~~~~~~ ##############################
        
## Normal Timeseries Decomposition Plot    

        plotNdcomp <- function() {
                ds_ts <- ts(getDataset(), frequency=12)
                Ndcomp <- decompose(ds_ts)
                plot(Ndcomp)
        }

        output$Ndcomp <- renderPlot({
                plotNdcomp()
        })



############################### ~~~~~~~~~~~~~~~~~ ##############################
                                                        
## Forecasting model plot creation                       
           
        plotInput <- function() {
                x <- forecast(getModel(), h=input$ahead)
                plot(x, flty = 3, axes = FALSE)
                a <- seq(as.Date(aTR$Date, format = "%d.%m.%y")[1] + 1, 
                         by = "months", length = length(date) + 11)
                axis(1, at = as.numeric(a)/365.3 + 1970, 
                     labels = format(a, format = "%d/%m/%Y"), cex.axis = 0.9)
                axis(2, cex.axis = 0.9, las = 2)
        }
        
        output$fmplot <- renderPlot({
                
                ##########    Adding a progress bar  ##########
                
                ## Create a Progress object
                
                progress <- shiny::Progress$new()
                
                on.exit(progress$close())
                
                progress$set(message = "Creating Plot", value = 0)
                
                n <- 10
                
                for (i in 1:n) {
                        # Each time through the loop, add another row of data. This is
                        # a stand-in for a long-running computation.
                        
                        # Increment the progress bar, and update the detail text.
                        progress$inc(1/n, detail = paste("Doing part", i))
                        
                        plotInput()
                        
                        # Pause for 0.1 seconds to simulate a long computation.
                        Sys.sleep(0.1)
                }
                
                
                #plotInput()
                
        })

############################### ~~~~~~~~~~~~~~~~~ ##############################

## Forecasting model table creation         

        tableInput <- function() {
                forecast(getModel(), h=input$ahead)
        }

        output$fmtable <- renderPrint({
        
                ##########    Adding a progress bar  ##########
                # Create a Progress object
                progress <- shiny::Progress$new()
                
                on.exit(progress$close())
                
                progress$set(message = "Creating Table", value = 0)
                
                n <- 10
                
                for (i in 1:n) {
                        # Each time through the loop, add another row of data. This is
                        # a stand-in for a long-running computation.
                        
                        # Increment the progress bar, and update the detail text.
                        progress$inc(1/n, detail = paste("Doing part", i))
                        
                        # Pause for 0.1 seconds to simulate a long computation.
                        Sys.sleep(0.1)
                }
        
                tableInput()
        
        })


############################### ~~~~~~~~~~~~~~~~~ ##############################

## PDF Download Handler             

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