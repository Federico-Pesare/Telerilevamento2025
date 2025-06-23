# pacchetti impiegati per condurre l'analisi
library(terra)
library(imageRy)
library(ggplot2)

# 1. LAND-COVER CLASSIFICATION
# importo immagini SCL (Sentinel-2 Scene Classification Layer) e ribaldo per visualizzarle correttamente: funzione flip()
# La classificazione delle classi è interpretata visivamente, sulla base della distribuzione dei colori/clusters nello spazio. 
# 4 classi individuate: Aree palustri, Vegetazione emersa, Acqua, Suolo arido   ->   Calcolo %
# Il codice è generico e può essere usato su qualsiasi immagine SCL o simile, previa interpretazione delle classi risultanti.

# 2019: baseline; ecosistema non perturbato

path="C:/Users/feder/Desktop/IBERA'/2019/2019c.jpg"
ibera19=rast(path)
plot(ibera19)
ibera19=flip(ibera19)
plot(ibera19)

ibera19c=im.classify(ibera19,num_clusters=4)

pibera19 = freq(ibera19c)*100 / ncell(ibera19c)
pibera19

# c1 = Aree palustri = 7.90 %
# c2 = Vegetazione emersa = 86.45 %
# c3 = Acqua permanente = 4.25 %
# c4 = Suoli aridi = 1,40 %

dev.off()

# 2020

path="C:/Users/feder/Desktop/IBERA'/2020/2020c.jpg"
ibera20=rast(path)
plot(ibera20)
ibera20=flip(ibera20)
plot(ibera20)

ibera20c=im.classify(ibera20,num_clusters=4)

pibera20 = freq(ibera20c)*100 / ncell(ibera20c)
pibera20

# Aree palustri = 5.05 %
# Vegetazione emersa = 87.51 %
# Acqua permanente = 3.73 %
# Suoli aridi = 3.71 %

dev.off()

# 2021

path="C:/Users/feder/Desktop/IBERA'/2021/2021c.jpg"
ibera21=rast(path)
plot(ibera21)
ibera21=flip(ibera21)
plot(ibera21)

ibera21c=im.classify(ibera21,num_clusters=4)

pibera21 = freq(ibera21c)*100 / ncell(ibera21c)
pibera21

# Aree palustri = 3.36 %
# Vegetazione emersa = 90.41 %
# Acqua permanente = 3.36 %
# Suoli aridi = 2.86 %

dev.off()

# 2022: Incendio

path="C:/Users/feder/Desktop/IBERA'/2022/27feb/2022c.jpg"
ibera22=rast(path)
plot(ibera22)
ibera22=flip(ibera22)
plot(ibera22)

ibera22c=im.classify(ibera22,num_clusters=4)

pibera22 = freq(ibera22c)*100 / ncell(ibera22c)
pibera22

# Aree palustri = 0 %
# Vegetazione emersa = 34.62 %
# Acqua permanente = 3.07 %
# Suoli aridi = 62.31 %

dev.off()

# 2023

path="C:/Users/feder/Desktop/IBERA'/2023/2023c.jpg"
ibera23=rast(path)
plot(ibera23)
ibera23=flip(ibera23)
plot(ibera23)

ibera23c=im.classify(ibera23,num_clusters=4)

pibera23 = freq(ibera23c)*100 / ncell(ibera23c)
pibera23

# Aree palustri = 0 %
# Vegetazione emersa = 51.18 %
# Acqua permanente = 2.93 %
# Suoli aridi = 45.89 %

dev.off()

# 2024

path="C:/Users/feder/Desktop/IBERA'/2024/2024c.jpg"
ibera24=rast(path)
plot(ibera24)
ibera24=flip(ibera24)
plot(ibera24)

ibera24c=im.classify(ibera24,num_clusters=4)

pibera24 = freq(ibera24c)*100 / ncell(ibera24c)
pibera24

# Aree palustri = 5.25 %
# Vegetazione emersa = 89.46 %
# Acqua permanente = 3.40 %
# Suoli aridi = 1.89 %

dev.off()

# 2025

path="C:/Users/feder/Desktop/IBERA'/2025/2025c.jpg"
ibera25=rast(path)
plot(ibera25)
ibera25=flip(ibera25)
plot(ibera25)

ibera25c=im.classify(ibera25,num_clusters=4)

pibera25 = freq(ibera25c)*100 / ncell(ibera25c)
pibera25

# Aree palustri = 6.03 %
# Vegetazione emersa = 72.51 %
# Acqua permanente = 2.99 %
# Suoli aridi = 18.47 %

dev.off()

# Grafico a barre delle variazioni annue nella percentuale di suolo arido
# creare dataframe
anno = c("2019","2020","2021","2022","2023","2024","2025")
perc = c(1.40, 3.71, 2.86, 62.31, 45.89, 1.89, 18.47)
SuoloArido = data.frame(anno,perc)
SuoloArido
# grafico a barre
ggplot(SuoloArido, aes(x=anno, y=perc)) + labs(x = "Anno", y = "Copertura %") + geom_bar(stat="identity",fill="sienna3") + theme_minimal()

# Confronto percentuali suolo arido / vegetazione nella serie temporale 2019 - 2025
# dataframe "lungo"
anno = rep(c("2019", "2020", "2021", "2022", "2023", "2024", "2025"), times = 2)
classe = c(rep("Suolo arido", 7),rep("Vegetazione emersa", 7))
perc = c(1.40, 3.71, 2.86, 62.31, 45.89, 1.89, 18.47, 86.45, 87.51, 90.41, 34.62, 51.18, 89.46, 72.51)
copertura = data.frame(anno, classe, perc)
copertura
# grafico a barre affiancato 
ggplot(copertura, aes(x=anno, y=perc, fill=classe)) + geom_bar(stat="identity", position="dodge") + scale_fill_manual(values = c("sienna3", "seagreen3"), name=NULL) + labs(x = "Anno",y = "Copertura%") + ylim(0,100) + theme_minimal() 
