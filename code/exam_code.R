# pacchetti impiegati per condurre l'analisi
library(terra)
library(imageRy)
library

# land-cover classification
# importo e classifico 2017 dry
path = "C:/Users/feder/Desktop/Tsiribihina/2017DRY/JPG/set2017.jpg"
set2017 = rast(path)
set2017c = im.classify(set2017, num_clusters=3)
