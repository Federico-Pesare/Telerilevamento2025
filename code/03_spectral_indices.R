# Code to calculate spectral indices from satellite images

library(terra)
library(imageRy)
library(viridis)

#quali immagini ho a disposizione?
im.list()

# importare l'immagine satellitare del matogrosso del 1992
mato1992 = im.import("matogrosso_l5_1992219_lrg.jpg")
# se serve invertire l'immagine usare la f flip
mato1992 = flip(mato1992) 

# 1 = NIR
# 2 = red
# 3 = green

im.plotRGB(mato1992, r=1, g=2, b=3)
# oppure 
plot(mato1992)

# NIR su green
im.plotRGB(mato1992, r=2, g=1, b=3)
# NIR su blue
im.plotRGB(mato1992, r=2, g=3, b=1)

# importare l'immagine satellitare del matogrosso del 2006
mato2006 = im.import("matogrosso_ast_2006209_lrg.jpg")
mato2006 = flip(mato2006)
plot(mato2006)

# visualizzare le due immagini (1992 e 2006) affiancate
im.multiframe(1,2)
im.plotRGB(mato1992, r=2, g=3, b=1)
im.plotRGB(mato2006, r=2, g=3, b=1)

# Radiometric resolution
plot(mato1992[[1]], col=inferno(100))
plot(mato2006[[1]], col=inferno(100))

# Range da 0 a 250 indica immagini a 8 bit

# Difference Vegetation Index (DVI), informazioni sullo stato di salute delle piante
# Plant: NIR=255, red=0, DVI=NIR-red = 255 
# Stressed plant: NIR=100, red=20, DVI=100-20 = 80

# Calculating DVI
# 1 = NIR
# 2 = red

# NIR - red
dvi1992 = mato1992[[1]] - mato1992[[2]] 
plot(dvi1992)

# range DVI (da -255 a 255)
# maximum: NIR - red = 255 - 0 = 255
# minimum: NIR - red = 0 - 255 = -255

#con un'altra variazione di colore (aver scaricato viridis permette di evitare l'impiego del comando colorramppalette
plot(dvi1992, col=magma(100))

# DVI per mato2006
dvi2006 = mato2006[[1]] - mato2006[[2]]
plot(dvi2006)

# uno accanto all'altro
im.multiframe(1,2)
plot(dvi1992)
plot(dvi2006)

# Different radiometric resolution, quando abbiamo risoluzioni diverse occorre normalizzare, es 8 e 4 bit

# DVI 8 bit: range (0-255)
# maximum: NIR - red = 255 - 0 = 255
# minimum: NIR - red = 0 - 255 = -255

# DVI 4 bit: range (0-15)
# maximum: NIR - red = 15 - 0 = 15
# minimum: NIR - red = 0 - 15 = -15

# NORMALIZZATO (rapporto)

# NDVI 8 bit: range (0-255)
# maximum: (NIR - red) / (NIR + red) = (255 - 0) / (255 + 0) = 1
# minimum: (NIR - red) / (NIR + red) = (0 - 255) / (0 + 255) = -1

# NDVI 4 bit: range (0-15)
# maximum: (NIR - red) / (NIR + red) = (15 - 0) / (15 + 0) = 1
# minimum: (NIR - red) / (NIR + red) = (0 - 15) / (0 + 15) = -1

ndvi1992 = (mato1992[[1]] - mato1992[[2]]) / (mato1992[[1]] + mato1992[[2]])
plot(ndvi1992)

ndvi2006 = (mato2006[[1]] - mato2006[[2]]) / (mato2006[[1]] + mato2006[[2]])
plot(ndvi2006)

# oppure tramite una f di imageRy
dvi1992auto = im.dvi(mato1992,1,2)
plot(dvi1992auto)

dvi2006auto = im.dvi(mato2006,1,2)
plot(dvi2006auto)

ndvi1992auto = im.ndvi(mato1992,1,2)
plot(ndvi1992auto)

ndvi2006auto = im.ndvi(mato2006,1,2)
plot(ndvi2006auto)

im.multiframe(1,2)


