# R code for performing multitemporal analysis

library(imageRy)
library(terra)
library(viridis)

# list of data
im.list()
# we are interested in "EN" images, showing the concentration shift of NO2 during lockdown

EN_01 = im.import("EN_01.png")
EN_01 = flip(EN_01)
plot(EN_01)

EN_13 = im.import("EN_13.png")
EN_13 = flip(EN_13)
plot(EN_13)

im.multiframe(1,2)
plot(EN_01)
plot(EN_13)

# difference between the two images
ENdiff = EN_01[[1]] - EN_13[[1]]
plot(ENdiff)
plot(ENdiff, col=inferno(100))

# Using "greenland" images to analyse the ice melt
# we are going to import all the 4 images (greenland2000, g.2005, g.2010, g.2015) together using the common name of the images
gr = im.import("greenland")
plot(gr[[1]])
plot(gr[[4]])

im.multiframe(1,2)
plot(gr[[1]], col=rocket(100))
plot(gr[[4]], col=rocket(100))

dev.off()
grdif = gr[[1]] - gr[[4]]
plot(grdif)

# Ridgeline plots, creazione distribuzione delle frequenze in una serie temporale. Scale è un carattere obbligatorio ed è l'h del grafico
# prende tutti i pixel per anno e ne calcola la frequenza
# to create ridgelines plot ggridges is needed
install.packages("ggridges")
library(ggridges)
im.ridgeline(gr, scale=1)
im.ridgeline(gr, scale=1, palette="inferno") # to change colours

# import NDVI data from Sentinel2
ndvi = im.import("Sentinel2")
ndvi 
im.ridgeline(ndvi, scale=2) 
# the previous funtion provides 1 graphic!!! Because the name is the same for the 4 images
# Changing names
names(ndvi) = c("02_Feb", "05_May", "08_Aug", "11_Nov")
ndvi
im.ridgeline(ndvi, scale=2)

pairs(ndvi)

plot(ndvi[[1]], ndvi[[2]])

# x = y dunque la linea ipotetica dove i dati di Feb (x) sono uguali a May (y)
# y = a + bx
# a=0, b=1 because the two values are identical
# y = x (intercetta all'origine)

abline(0,1,col="red")

# assegnare lo stesso range al grafico in modo che la retta passi per l'origine
plot(ndvi[[1]], ndvi[[2]], xlim=c(-0.3,0.9), ylim=c(-0,3,0.9))

im.multiframe(1,2)
plot(ndvi[[1]])
plot(ndvi[[2]])
plot(ndvi[[1]], ndvi[[2]], xlim=c(-0.3,0.9), ylim=c(-0,3,0.9))
abline(0,1,col="red")



######
# time series analysis in R

library(terra)
library(imageRy)
library(ggridges) # for ridgeline plots
library(ggplot2) # for ridgeline plots
library(viridis) # for ridgeline plots

im.list()

# Importing data
EN01 <- im.import("EN_01.png")
EN13 <- im.import("EN_13.png")

difEN = EN01[[1]] - EN13[[1]]

# Example 2: ice melt in Greenland

gr <- im.import("greenland")
plot(gr[[1]])
plot(gr[[4]])

# Exercise: plot in a multiframe the first and last elements of gr
par(mfrow=c(1,2))
plot(gr[[1]])
plot(gr[[4]])

difgr = gr[[1]] - gr[[4]]
dev.off()
plot(difgr)

# Exercise: compose a RGB image with the years of Greenland temperature
im.plotRGB(gr, r=1, g=2, b=4)
# gr: 2000, 2005, 2010, 2015

# Ridgeline plots
# Example with NDVI data

# NDVI file
ndvi <- im.import("NDVI_2020")

plot(ndvi)

plot(ndvi[[2]],ndvi[[3]])
abline(0,1,col="red")
