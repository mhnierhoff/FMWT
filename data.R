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

library(forecast)
library(lubridate)

dat <- read.csv("./dataset/Historical_Traffic.csv", 
                    header = TRUE,
                    sep=";")

aTR <- na.omit(dat) 

alexaTrafficRank <- ts(aTR, start=c(2014, yday("2014-06-27")), frequency=365.3)

write.csv(alexaTrafficRank, "data.csv")
