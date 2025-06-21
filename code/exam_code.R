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
# class1 = vegetazione = 45.18%
# class2 = acqua = 15.17%
# class3 = suolo nudo = 41.654165%
# composizione percentuale proporzionata alla terra emersa (100% - 15.17% = 84.83%)
# vegetazione:  x : 100 = 45.18 : 84.83  ->  53.26%
# suolo nudo:  y : 100 = 41.65 : 84.83  ->  49.09%


# 2020 DRY

path = "C:/Users/feder/Desktop/Tsiribihina/2020 DRY/JPG/dry2020.jpg"
dry2020=rast(path)
plot(dry2020)
dry2020=flip(dry2020)
plot(dry2020)

dry2020c = im.classify(dry2020, num_clusters=3)

pdry2020 = freq(dry2020c)*100 / ncell(dry2020c)
pdry2020
# class1 = vegetazione = 42.93%
# class2 = acqua = 16.68%
# class3 = suolo nudo = 40.38%
# composizione percentuale proporzionata alla terra emersa (100% - 16.68% = 83.32%)
# vegetazione: x : 100 = 42.93 : 83.32  ->  51.53%
# suolo nudo: y : 100 = 40.38 : 83.32  ->  48.47%

 # 2023 DRY

path = "C:/Users/feder/Desktop/Tsiribihina/2023 DRY/JPG/dry2023.jpg"
dry2023=rast(path)
plot(dry2023)
dry2023=flip(dry2023)
plot(dry2023)

dry2023c = im.classify(dry2023, num_clusters=3)

pdry2023 = freq(dry2023c)*100 / ncell(dry2023c)
pdry2023
