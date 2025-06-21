# pacchetti impiegati per condurre l'analisi
library(terra)
library(imageRy)
library

# land-cover classification
# importo e classifico 2017 dry
> path="C:/Users/feder/Desktop/Tsiribihina/2017DRY/JPG/dry2017.jpg"
> dry2017=rast(path) 
> plot(dry2017)
> dry2017=flip(dry2017)
> plot(dry2017)

# creo maschera per eliminare i pixel neri
mask <- dry2017[[1]] == 0 & dry2017[[2]] == 0 & dry2017[[3]] == 0
# applicazione della maschera, nero = NA
dry2017_masked <- mask(dry2017, mask, maskvalue=1)
# plot, stretch="lin" ricalibra i pixel sulla scala RGB aumentando i contrasti
plotRGB(dry2017_masked, r=1, g=2, b=3, stretch="lin")
#classificazione
dry2017c=im.classify(dry2017_masked, num_clusters=3)
# class 1 = foresta decidua
# class 2 = suolo degradato

# calcolo area percentuale
pdry2017 = freq(dry2017c)*100 / ncell(dry2017c)
pdry2017
# class1 = 45.64
# class2 = 31.57


