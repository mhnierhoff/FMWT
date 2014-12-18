library(shiny)
library(shinyIncubator)
library(zoo)
library(timeDate)
library(datasets)
library(forecast)
library(zoo)
library(rmarkdown)

# Define UI 
shinyUI(fluidPage(theme = "styles.css",
        
        # Application title
        headerPanel("Portfolio Traffic Forecasting"),
        
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
                selectInput(
                        inputId = "downloadFileType",
                        label   = "Select Download File Type",
                        choices = list(
                                "JPEG" = "jpeg",
                                "PDF" = "pdf",
                                "PNG" = "png",
                                "BMP" = "bmp")),
                br(),
                downloadButton(
                        outputId = "downloadPlot", 
                        label    = "Download Plot"),
                
                progressInit()
        ),
        
        
        
        # Show the caption and forecast plots
        mainPanel(
                #h4(textOutput("caption")),
                
                tabsetPanel(
                        tabPanel("Chosen Model", plotOutput("plot")),
                        tabPanel("Timeseries Decomposition", plotOutput("dcompPlot")),
                        tabPanel("Model Explanations", verbatimTextOutput("summary"))
                )
        
        )
))
