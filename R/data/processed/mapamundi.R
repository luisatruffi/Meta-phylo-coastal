setwd("~/Documents/Labtrop/Mestrado Luisa Truffi/Meta analise/Analise/analises sem gimno git/Meta-phylo-coastal")
library(ggplot2)

data <- read.csv("R/data/processed/tab.dist.filo.22.08.2023.csv")
data$dd_lat
data$dd_long


data$dd_lat <- gsub(",", ".", data$dd_lat)
data$dd_long <-  gsub(",", ".", data$dd_long)

coordenadas <- cbind(data$dd_lat, data$dd_long)
coordenadas <- as.data.frame(coordenadas)
coordenadas[ ,1] <- as.numeric(coordenadas[ ,1])
coordenadas[ ,2]<- as.numeric(coordenadas[ ,2])



##brincando com o degrade dos pontos
mp <- NULL
mapWorld <- borders("world", colour="gray50", fill="gray50") # create a layer of borders
mp <- ggplot() +   mapWorld
mp <- mp+ geom_point(aes(x=c(coordenadas[,2]), y=c(coordenadas[ ,1])), col = rgb(0,0,0) , size=2.5) 
mp

