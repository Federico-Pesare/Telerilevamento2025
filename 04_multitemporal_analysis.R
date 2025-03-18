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

# EXPORTING DATA

#1 choose the folder (directory)
setwd()
# C:\Users\feder\Documents ,  remember to change backslash on Windows!!!
setwd("C:/Users/feder/Documents")

getwd()
plot(gr)

# create the file (png, pdf, jpeg, ...)
png("greenland_output.png")
plot(gr)
dev.off()

pdf("greendiff.pdf")
plot(grdif)
dev.off()

jpeg("greendiff.jpeg)
plot(grdif)
dev.off()





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
