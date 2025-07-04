# R code for visualizing satellite data

library(terra)
library(imageRy)

im.list()
 
# For the whole course we are going to make use of = instead of <-

b2 = im.import("sentinel.dolomites.b2.tif")
plot(b2, col=cl)

# colors change

cl = colorRampPalette(c("black", "dark grey", "light grey"))(100)
plot(b2, col=cl)

cl = colorRampPalette(c("black", "dark grey", "light grey"))(3)
plot(b2, col=cl)

# Make your own color ramp
# https://sites.stat.columbia.edu/tzheng/files/Rcolor.pdf

cl = colorRampPalette(c("royalblue3", "seagreen1", "red1"))(100)
plot(b2, col=cl)

# banda green
b3 = im.import("sentinel.dolomites.b3.tif")

# banda red
b4 = im.import("sentinel.dolomites.b4.tif")

# banda NIR (near infrared)
b8 = im.import("sentinel.dolomites.b8.tif")

# plottare più bande con funzione multiframe, prima era fatto con par
# in par ci va un multiframe: un grafico con più immagini
# in questo caso una sola riga e 4 colonne

par(mfrow=c(1,4))
plot(b2)
plot(b3)
plot(b4)
plot(b8)

# per rimuovere
dev.off()

# ora usiamo la funzione 
im.multiframe(1,4)
plot(b2)
plot(b3)
plot(b4)
plot(b8)

# plottare invertendo righe e colonne
im.multiframe(4,1)
plot(b2)
plot(b3)
plot(b4)
plot(b8)

# colors change
cl = colorRampPalette(c("black","light grey"))(100)
plot(b2, col=cl)
plot(b3, col=cl)
plot(b4, col=cl)
plot(b8, col=cl)

# sovrapporre le bande in un'unica immagine
sent = c(b2, b3, b4, b8)
sent
plot(sent, col=cl)

# cambiare i nomi
names(sent) = c("b2blue","b3green","b4red","b8NIR")
sent

plot(sent, col=cl)
plot(sent)

# ora voglio plottare solo una banda, es b8 NIR
plot(sent$b8NIR)
# stessa cosa ma selezionando il n dell'elemento
plot(sent[[4]])

# importing several bands together, importiamo tutti gli elementi visti fin ora con un solo comando
sentdol = im.import ("sentinel.dolomites")

# import several sets together, correlazioni (ogni punto nei grafici di correlazione rappresenta un pixel)u
pairs(sentdol)

# pacchetti SEMPRE in alto !!! VIRIDIS, un pacchetto contenente diverse palette
install.packages("viridis")
library(viridis)

plot(sentdol,col=viridis(100))

#NUOVA LEZIONE
library(terra)
library(imageRy)
library(viridis)
sentdol = im.import("sentinel.dolomites")

#RECAP
# 1 = blue (b2)
# 2 = green (b3)
# 3 = red (b4)
# 4 = NIR (b8)

#Ottenere l'immagine a colori naturali, le componenti RGB sono 3 quindi 3 bande alla volta
im.plotRGB(sentdol, r=3, g=2, b=1)

#False colours
im.plotRGB(sentdol, r=4, g=3, b=2)
#Abbiamo montato sulla componente red dello schema RGB l'infrarosso vicino, dove le piante rifletto tanto

#ora usare NIR sulla componente verde
im.plotRGB(sentdol, r=3, g=4, b=1)
#tutto ciò che è verde è vegetazione, ma basata sulla riflettanza del NIR!!!
#CIO' CHE FA VARIARE IL COLORE DELL'IMMAGINE E' L'INFRAROSSO






