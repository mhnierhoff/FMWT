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

# Define UI 
shinyUI(fluidPage(
        
        tags$head(includeScript("ga-fmwt.js")),
        # Application title
        titlePanel("Forecasting App - Example Data"),
        
        sidebarLayout(

############################### ~~~~~~~~~~~~~~~~~ ##############################

## Sidebar with controls to select the dataset and forecast ahead duration
        
        sidebarPanel( 
                wellPanel(
                        radioButtons(inputId = "city", 
                                     label = "Select a city:", 
                                     choices = c("Cologne", "Berlin"), 
                                     selected = "Cologne")
                ),
                
                wellPanel(
                        selectInput(inputId = "model",
                                    label = "Select a forecasting model:",
                                    #br(),
                                    choices = c("ARIMA", "ETS", "TBATS", 
                                                "StructTS", "Holt-Winters", 
                                                "Theta", "Cubic Spline",
                                                "Random Walk", "Naive",
                                                "Mean"),
                                    selected = "ARIMA")
                ),

                wellPanel(
                        numericInput("ahead", "Years to forecast ahead:", 15)
                ),
                
############################### ~~~~~~~~~~~~~~~~~ ##############################                

## Option to download the Forecasting model plot & both decomposition plots
                
                        p("By clicking on the button a plot of the selected 
                          forecasting model and both decomposition plots can 
                          be downloaded."),
                tags$hr(),
                tags$div(downloadButton("downloadPlot", "Download Model Plot"),
                         align = "center"),
                
                width = 3),
        
        
############################### ~~~~~~~~~~~~~~~~~ ##############################        

## Show Forecasting Plots

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
                                 (textOutput("caption4"))),
                        
                        tabPanel("Info",
                                p("Author website:"),
                                tags$a(href="http://nierhoff.info", 
                                       "http://nierhoff.info"),
                                tags$hr(),
                                tags$br(),
                                p("Code of this app:"), 
                                tags$a(href="https://github.com/mhnierhoff/FMWT",
                                       "https://github.com/mhnierhoff/FMWT"),
                                tags$hr(),
                                tags$br(),
                                p("Data sources:"),
                                tags$a(
                                        href="http://de.wikipedia.org/wiki/Einwohnerentwicklung_von_K%C3%B6ln", 
                                        "Cologne"),
                                tags$br(),
                                tags$a(
                                        href="http://de.wikipedia.org/wiki/Einwohnerentwicklung_von_Berlin", 
                                       "Berlin"),
                                tags$hr(),
                                tags$br(),
                                p("This application is primarily a demo to show what is possible. 
                                In favor of the ease of use of this app, the individual models may 
                                not be maximally accurate. In case of any questions related to this 
                                application, feel free to write me a mail.")
                                )
                ),
        
        width = 6)
        )
        
))
