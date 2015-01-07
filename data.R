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

cgn <- read.csv("./dataset/Cologne.csv", header = TRUE, sep=";")

cologne <- ts(cgn[,2], start=1900, end=2013, frequency=1)

write.csv(cologne, "./dataset/data1.csv")

############################### ~~~~~~~~~~~~~~~~~ ##############################

ber <- read.csv("./dataset/Berlin.csv", header = TRUE, sep=";")

berlin <- ts(ber[,2], start=1900, end=2013, frequency=1)

write.csv(berlin, "./dataset/data2.csv")
