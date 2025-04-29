# Code to solve colorblindness problems

# Packages
library(terra)

# Installing cblindplot
library(devtools)
install_github("ducciorocchini/cblindplot")
library(cblindplot)

# Importing data
setwd("C:/Users/feder/Desktop")
rast("vinicunca.jpg")
vinicunca = rast("vinicunca.jpg")

# Simulating colorblindness
im.multiframe(1,2)
im.plotRGB(vinicunca, r=1, g=2, b=3, title="Standard Vision")
im.plotRGB(vinicunca, r=2, g=1, b=3, title="Protanopia")

# Solving colorblindness
rast("rainbow.jpg")
rainbow = rast("rainbow.jpg")
plot(rainbow)
rainbow=flip(rainbow)
plot(rainbow)
cblind.plot(rainbow, cvd="protanopia")
cblind.plot(rainbow, cvd="deuteranopia")
cblind.plot(rainbow, cvd="tritanopia")
