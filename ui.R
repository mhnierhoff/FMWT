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
shinyUI(fluidPage(theme = "styles.css",
        
        # Application title
        titlePanel("Website Traffic Forecasting"),
        
        sidebarLayout(
        
        # Sidebar with controls to select the dataset and forecast ahead duration
        sidebarPanel(
                selectInput("variable", "Website:",
                            list("Köln" = "cologne", 
                                 "A" = "A",
                                 "B" = "B")),
                br(),
                radioButtons(inputId = "model",
                             label = "Select Forecasting Model:",
                             choices = c("ARIMA", "ETS", "TBATS", "STL"),
                             selected = "ARIMA"),
                br(),
                numericInput("ahead", "Months to Forecast Ahead:", 12),
                br(),
                br(),
                # Button to allow the user to save the image.
                
                downloadButton('report'),
                
                progressInit(),
                
        width = 3),
        
        
        # Show forecast plots
        mainPanel(
                #h4(textOutput("caption")),
                
                tabsetPanel(
                        tabPanel("Chosen Model", plotOutput("plot")),
                        tabPanel("Timeseries Decomposition", plotOutput("dcompPlot")),
                        tabPanel("Diagnostic Checking", plotOutput("diacPlot")),
                        tabPanel("Model Explanations", verbatimTextOutput("summary"))
                )
        
        )
        )
        
))
