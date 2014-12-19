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
shinyUI(fluidPage(#theme = "styles.css",
        
        # Application title
        titlePanel("Website Traffic Forecasting"),
        
        sidebarLayout(
        
        # Sidebar with controls to select the dataset and forecast ahead duration
        sidebarPanel(
                
                wellPanel(
                        selectInput("variable", "Website:",
                        list("Köln" = "cologne", 
                                "A" = "A",
                                "B" = "B"))
                ),
                wellPanel(
                        radioButtons(inputId = "model",
                        label = "Select Forecasting Model:",
                        choices = c("ARIMA", "ETS", "TBATS", "STL"),
                        selected = "ARIMA")
                ),
                
                wellPanel(
                        numericInput("ahead", "Months to Forecast Ahead:", 12)
                ),
                
                # Button to allow the user to save the image.
                
                
                tags$div(
                        downloadButton("downloadPlot", "Download Model Plot"),
                        align = "center"
                        ),
                
                progressInit(),
                
                
                width = 3),
        
        
        # Show forecast plots
        mainPanel(
                
                tabsetPanel(
                        tabPanel("Chosen Model", plotOutput("fmplot")),
                        tabPanel("Timeseries Decomposition", plotOutput("dcompPlot")),
                        tabPanel("Diagnostic Checking", plotOutput("diacPlot")),
                        tabPanel("Explanations", includeMarkdown("models.md"))
                ),
        
        width = 6)
        )
        
))
