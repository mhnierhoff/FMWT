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

# Define UI 
shinyUI(fluidPage(
        
        # Application title
        titlePanel("Website Traffic Forecasting"),
        
        sidebarLayout(
        
        # Sidebar with controls to select the dataset and forecast ahead duration
        sidebarPanel(
                
                wellPanel(
                        selectInput("page", "Website:",
                        list("Köln" = "cologne", 
                                "A" = "A",
                                "B" = "B"))
                ),
                
                wellPanel(
                        radioButtons(inputId = "model",
                        label = "Select Forecasting Model:",
                        choices = c("ARIMA", "ETS", "TBATS", 
                                    "StructTS", "Holt-Winters", 
                                    "Theta", "Neural Network"),
                        selected = "ARIMA")
                ),

                wellPanel(
                        numericInput("ahead", "Months to Forecast Ahead:", 12)
                ),
                
                # Button to allow the user to save the image.
                
               
                        p("By clicking on the button a plot of the selected 
                          forecasting model and both decomposition plots can 
                          be downloaded."),
                tags$div(downloadButton("downloadPlot", "Download Model Plot"),
                         align = "center"),
                
                
                progressInit(),
        
                width = 3),
        
        
        # Show forecast plots
        mainPanel(
                
                tabsetPanel(
                        tabPanel("Model Plot", 
                                 plotOutput("fmplot"),
                                 tags$strong(textOutput("caption1"), 
                                          align = "center")),
                        
                        tabPanel("Forecasting Data",
                                 tags$div(textOutput("caption2"), 
                                          align = "left"),
                                 tags$br(),
                                 verbatimTextOutput("fmtable")),
                        
                        tabPanel("Decomposition Plots",
                                 tags$div(strong("STL Decomposition"), 
                                          align ="center"),
                                 plotOutput("STLdcomp"),
                                 textOutput("caption3"),
                                 tags$hr(),
                                 plotOutput("Ndcomp"),
                                 (textOutput("caption4")),
                                 tags$hr()),
                        
                        tabPanel("Explanations", includeMarkdown("models.md"))
                ),
        
        width = 6)
        )
        
))
