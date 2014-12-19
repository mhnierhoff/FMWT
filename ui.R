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
                        choices = c("ARIMA", "ETS", "TBATS", "StructTS", "Holt-Winters"),
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
                        tabPanel("Selected Model", 
                                 plotOutput("fmplot"),
                                 tags$div(textOutput("caption1"), align = "center")),
                                 
                        tabPanel("STL Decomposition", 
                                 plotOutput("dcompPlot"),
                                 tags$div(textOutput("caption2"), align = "center")),
                        tabPanel("Diagnostic Checking", plotOutput("diacPlot")),
                        tabPanel("Explanations", includeMarkdown("models.md"))
                ),
        
        width = 6)
        )
        
))
