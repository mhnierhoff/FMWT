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
        titlePanel("Website Traffic Forecasting"),
        
        sidebarLayout(

############################### ~~~~~~~~~~~~~~~~~ ##############################
## Sidebar with controls to select the dataset and forecast ahead duration
        sidebarPanel(
                
                wellPanel(
                        selectInput(inputId = "page", 
                                    label = "Select a website:",
                                    #br(),
                                    choices= c("spotted.de","meckr.net",
                                               "womenweb.de","kochrezepte.de",
                                               "spontacts.com","autoinfo.de",
                                               "hoccer.com","einfachlotto.de",
                                               "yasni.de","tape.tv", 
                                               "merkando.de", "make.tv",
                                               "ferien-touristik.de","dailyme.de"),
                                    selected = "spotted.de")
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
                        numericInput("ahead", "Months to forecast ahead:", 12)
                ),
                
############################### ~~~~~~~~~~~~~~~~~ ##############################                
## Option to download the Forecasting model plot & both decomposition plots
                
                        p("By clicking on the button a plot of the selected 
                          forecasting model and both decomposition plots can 
                          be downloaded."),
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
                                          align = "center"),
                                 tags$div("Historical Data: Alexa.com | Metric: 
                                 Alexa Traffic Rank - Global", align="center")),
                        
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
