## test data
cgn <- read.csv("./dataset/Cologne.csv", 
                    header = TRUE,
                    sep=";")

cologne <- ts(cgn[,2], start=1900, end=2013, frequency=1)

write.csv(cologne, 'data.csv')
