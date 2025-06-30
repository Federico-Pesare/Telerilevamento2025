# Code for calculating spatial variability
library(terra)
library(imageRy)
library(ggplot2)
library(viridis)
library(patchwork)
library(rasterdiv)

# Standard deviation
23, 22, 23, 49

m = (23 + 22 + 23 + 49) / 4
# m = 29.25

num = (23-29.5)^2 + (22-29.5)^2 + (23-29.5)^2 + (49-29.5)^2
den = 4 - 1    # -1 is an adjustment for samples instead of populations
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


# NEW: What to do in case of huge images
sent = im.import("sentinel.png")
sent = flip(sent)
plot(sent)

# calculating the number of pixel
ncell(sent)                     #633612
ncell(sent) * nlyr(sent)        #2534448 final value of pixel number

senta = aggregate(sent, fact=2)
ncell(senta) * nlyr(senta)         #633612

senta5 = aggregate(sent, fact=5)
ncell(senta5) * nlyr(senta5)        #101760

# make a multiframe and plot in RGB the 3 images (or, 2, 5)
im.multiframe(1,3)
im.plotRGB(sent, 1, 2, 3)                  # we can use directly 1,2,3 instead of r=1, g=2, b=3
im.plotRGB(senta,1, 2, 3)
im.plotRGB(senta5, 1, 2, 3)
# HIGH RESOLUTION IS NOT NECESSARY EVERY TIME ! A LOWER ONE COULD BE BETTER IN SOME CASES


# calculating standard deviation
nir = sent[[1]]
sd3 = focal(nir, w=c(3,3), fun="sd")

nira = senta[[1]]
sd3a = focal(nira, w=c(3,3), fun="sd")

nira5 = senta5[[1]]
sd3a5 = focal(nira5, w=c(3,3), fun="sd")

nir5a5 = sent5a5[[1]]
sd5a5 = focal(nir5a5, w=c(5,5), fun="sd")

im.multiframe(2,2)
plot(sd3)
plot(sd3a)
plot(sd3a5)
plot(sd5a5)

#or
p1 = im.ggplot(sd3)
p2 = im.ggplot(sd3a)
p3 = im.ggplot(sd3a5)
p4 = im.ggplot(sd5a5)
p1+p2+p3+p4

# Variance
var3 = sd3^2

im.multiframe(1,2)
plot(sd3)
plot(var3)
# si perde tutta la variabilità intermedia, le mappe di varianza non sono molto impiegate come la deviazione standard (di fatti sul pacchetto terra la funzione focal non è implementata per la varianza).
# può essere ok per mostrare il confronto fra zone ad altissima variabilità e a bassissima variabilità


