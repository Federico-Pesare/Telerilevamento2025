# pacchetti impiegati per condurre l'analisi
library(terra)
library(imageRy)
library

# 1. LAND-COVER CLASSIFICATION

# 2017 DRY
> path="C:/Users/feder/Desktop/Tsiribihina/2017DRY/JPG/dry2017.jpg"
> dry2017=rast(path) 
> plot(dry2017)
> dry2017=flip(dry2017)
> plot(dry2017)

> dry2017c = im.classify(dry2017, num_clusters=3)

# calcolo area percentuale
pdry2017 = freq(dry2017c)*100 / ncell(dry2017c)
pdry2017
# class1 = vegetazione = 45.62%
# class2 = acqua = 16.84%
# class3 = suolo nudo = 37.54%
# composizione percentuale proporzionata alla terra emersa (100% - 16.84% = 83.16%)
# vegetazione:  x : 100 = 45.62 : 83.16  ->  54.86%
# suolo nudo:  x : 100 = 37.54 : 83.16  ->  45.14%
 

