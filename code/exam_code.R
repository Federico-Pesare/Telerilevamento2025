# pacchetti impiegati per condurre l'analisi
library(terra)
library(imageRy)
library

# land-cover classification
# importo e classifico 2017 dry
> path = "C:/Users/feder/Desktop/Tsiribihina/2017DRY/JPG/2017dry.jpg"
> dry2017 = rast(path)
> plot(dry2017)
> dry2017=flip(dry2017)
> plot(dry2017)
> dry2017c = im.classify(dry2017, num_clusters=3)
