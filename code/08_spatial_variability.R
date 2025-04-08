# Code for calculating spatial variability

# Standard deviation
23, 22, 23, 49

m = (23 + 22 + 23 + 49) / 4
# m = 29.25

num = (23-29.5)^2 + (22-29.5)^2 + (23-29.5)^2 + (49-29.5)^2
den = 4
variance = num / den
stdev = sqrt(variance)

sd(c(22,23,22,49))

# 
library(terra)
library(imageRy)

im.list()
sent = im.import("sentinel.png")
# band 1 = NIR
# band 2 = red
# band 3 = green

# Plot the image in RGB with the NIR on top of the red component
im.plotRGB(sent, r=1, g=2, b=3)

# Make 3 plots with NIR on top of each component
im.multiframe(1,3)
im.plotRGB(sent, r=1, g=2, b=3)
im.plotRGB(sent, r=2, g=1, b=3)
im.plotRGB(sent, r=3, g=2, b=1)

# associate the nir to the first element
nir = sent[[1]]
plot(nir)
plot(nir, col=inferno(100))

# FOCAL function
sd3 = focal(nir, w=c(3,3), fun=sd)
plot(sd3)
# the standard deviation show us the most variable zones on the image

# Calculate standard deviation of the nir band with a moving window of 5x5 pixels (intervallo più ampio)
sd5 = focal(nir, w=c(5,5), fun=sd)
plot(ds5)

# Use ggplot to plot the standard deviation
im.ggplot(sd3)

# Use patchwork to plot one beside the other one
library(patchwork)
p1 = im.ggplot(sd3)
p2 = im.ggplot(sd5)
p1+p2

# Plot the original set in RGB (ggRGB) togheter with the standard deviationo with 3 and 5 pixels
library(RStoolbox)
p3 = ggRGB(sent, r=1, g=2, b=3)
p1 + p2 + p3


##############################################
# Code to measure spatial varibaility considering both (i) spectral distances and (ii) relative abundances

library(terra)
library(imageRy)
library(ggplot2)
library(viridis)
library(patchwork)
library(rasterdiv)

im.list()


sent <- im.import("sentinel.png")
sent <- c(sent[[1]], sent[[2]], sent[[3]])

# RGB space

# 1 NIR
# 2 red
# 3 green

im.plotRGB(sent, r=1, g=2, b=3, title="NIR on red component")
im.plotRGB(sent, 1, 2, 3, title="NIR on red component")
im.plotRGB(sent, r=3, g=2, b=1, title="NIR on red component")
im.plotRGB(sent, r=3, g=1, b=2, title="NIR on red component")

# standard deviation
# sqrt(sum((x - mean(x))^2) / n)
# variance: sd^2

nir <- sent[[1]]
focal(nir, matrix(1/9,3,3), fun=sd)

sd3 <- focal(nir, matrix(1/9, 3, 3), fun=sd)
plot(sd3)

im.ggplot(sd3)

var3 <- focal(nir, matrix(1/9, 3, 3), fun=var)
plot(var3)

par(mfrow=c(1,2))
plot(sd3)
plot(var3)

par(mfrow=c(1,2))
plot(sd3, col=plasma(100))
plot(var3, col=plasma(100))

par(mfrow=c(1,2))
plot(sd3, col=magma(100))
plot(var3, col=magma(100))

var3fromsd <- (sd3)^2

par(mfrow=c(1,3))
plot(sd3)
plot(var3)
plot(var3fromsd)

dif = var3 - var3fromsd
plot(dif)

# Other grains
sd5 <- focal(nir, matrix(1/25, 5, 5), fun=sd)
var5 <- focal(nir, matrix(1/25, 5, 5), fun=var)
plot(sd5)
plot(var5)

# Other grains
sd7 <- focal(nir, matrix(1/49, 7, 7), fun=sd)
var7 <- focal(nir, matrix(1/49, 7, 7), fun=var)
plot(sd7)
plot(var7)

p1 <- im.ggplot(sd3)
p2 <- im.ggplot(var3)
p3 <- im.ggplot(sd5)
p4 <- im.ggplot(var5)
p5 <- im.ggplot(sd7)
p6 <- im.ggplot(var7)

(p1 | p2 | p3) /
(p4 | p5 | p6)


(p1 | p2) /
(p3 | p4) /
(p5 | p6) 

# Shannon index: abundance based methods
shan3 <- Shannon(nir, window=3)

p7 <- im.ggplot(shan3)

p1 + p7

# Speeding up calculation
ext <- c(0, 100, 0, 100)
cropnir <- crop(nir, ext)
p8 <- im.ggplot(cropnir)
p9 <- im.ggplot(nir)
p9 + p8
shan3 <- Shannon(cropnir, window=3)

p10 <- im.ggplot(shan3)
p7 + p10

# Second way
# Example of resampling
r <- rast(nrows=3, ncols=3, xmin=0, xmax=10, ymin=0, ymax=10)
values(r) <- 1:ncell(r)
s <- rast(nrows=25, ncols=30, xmin=1, xmax=11, ymin=-1, ymax=11)
x <- resample(r, s, method="bilinear")

niragg <- aggregate(nir, fact=5)
plot(niragg)

pnir <- im.ggplot(nir)
pniragg <- im.ggplot(niragg)
pnir + pniragg

shanagg3 <- Shannon(niragg, window=3)
pshan <- im.ggplot(shanagg3)
p7 + pshan
pniragg + pshan

# Shannon is a point descriptor, hence: Renyi
ren3 <- Renyi(niragg, window=3, alpah=seq(0,12,4), na.tolerance=0.2, np=1)
renstack <- c(ren3[[1]], ren3[[2]], ren3[[3]], ren3[[4]])
plot(renstack)

ren3 <- Renyi(niragg, window=3, alpha=seq(0,12,4), na.tolerance=0.2, np=1)
renstack <- c(ren3[[1]], ren3[[2]], ren3[[3]], ren3[[4]])
plot(renstack)

names(renstack) <- c("alpha=0","alpha=4","alpha=8","alpha=12")
plot(renstack)
