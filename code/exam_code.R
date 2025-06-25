# pacchetti impiegati per condurre l'analisi
library(terra)
library(imageRy)
library(ggplot2)  # grafici
library(ggridges)  # ridgeline plots
library(dplyr)
library(patchwork)  # grafici affiancati
library(RStoolbox)  # FORSE, per sd

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


# Confronto percentuali suolo arido / vegetazione nella serie temporale 2019 - 2025

# creazione dataframe
anno <- rep(c("2019", "2020", "2021", "2022", "2023", "2024", "2025"), each = 3)
classe <- rep(c("Vegetazione emersa", "Aree palustri", "Suolo arido"), times = 7)
valori <- c(86.45, 7.90, 1.40, 87.51, 5.05, 3.71, 90.41, 3.36, 2.86, 34.62, 0.00, 62.31, 51.18, 0.00, 45.89, 89.46, 5.25, 1.89, 72.51, 6.03, 18.47)
copertura <- data.frame(anno, classe, valori)
 
# Aggiungi una colonna gruppo
copertura$gruppo <- ifelse(copertura$classe == "Suolo arido", "Suolo arido", "Vegetazione")

# Crea un asse fittizio con posizione personalizzata per barre affiancate
copertura$posizione <- as.numeric(as.factor(copertura$anno)) + ifelse(copertura$gruppo == "Vegetazione", -0.15, 0.15)

# Plot, aestethics con x posizione per la sequenza ordinata degli anni
lc_barplot = ggplot(copertura, aes(x = posizione, y = valori, fill = classe)) + geom_bar(data = filter(copertura, gruppo == "Vegetazione"), stat = "identity", position = "stack", width = 0.3) +
    geom_bar(data = filter(copertura, gruppo == "Suolo arido"), stat = "identity", width = 0.3) +
    scale_x_continuous(breaks = 1:7, labels = unique(copertura$anno)) +
    scale_fill_manual(values = c("Vegetazione emersa" = "seagreen3","Aree palustri" = "deepskyblue3","Suolo arido" = "sienna3"),breaks = c("Suolo arido", "Aree palustri", "Vegetazione emersa")) +
    labs(x = "Anno", y = "Copertura %", fill = NULL) +
    ylim(0, 100) + theme_minimal(base_size = 13) + theme(panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank())
lc_barplot

# esportare il grafico
ggsave("lc_barplot.jpg", plot = lc_barplot,width = 8, height = 5, dpi = 300)



# INDICI SPETTRALI

# Percorso della cartella contenente le sottocartelle per ogni anno della sequenza 2019 - 2025

# Anni da processare
anni <- c(2019, 2020, 2021, 2022, 2023, 2024, 2025)

# Tabella vuota per visualizzare il valore della media di ogni indice per anno
tab.indici <- data.frame(Anno = integer(), NDVI = numeric(), NDMI = numeric(), NBR = numeric())

# loop
for (anno in anni) {
  cat("Indici spettrali febbraio", anno, "\n")

# percorso alle cartelle contenenti le bande
path <- file.path("C:/Users/feder/Desktop/IBERA'", as.character(anno), "geoTiff")


# Carica le bande
  blue  <- rast(file.path(path, "B02.tiff"))
  red   <- rast(file.path(path, "B04.tiff"))
  nir   <- rast(file.path(path, "B08.tiff"))
  swir1 <- rast(file.path(path, "B11.tiff"))
  swir2 <- rast(file.path(path, "B12.tiff"))
  
# Calcolo indici
  ndvi <- (nir - red) / (nir + red)
  ndmi <- (nir - swir1) / (nir + swir1)
  nbr  <- (nir - swir2) / (nir + swir2)

# Calcolo medie degli indici, eliminando eventuali NA ed estraendo il solo valore numerico con [1] per il dataframe 
  ndvi_mean <- global(ndvi, fun = "mean", na.rm = TRUE)[1]
  ndmi_mean <- global(ndmi, fun = "mean", na.rm = TRUE)[1]
  nbr_mean  <- global(nbr,  fun = "mean", na.rm = TRUE)[1] 

# Aggiungi i risultati alla tabella
  tab.indici <- rbind(tab.indici, data.frame(Anno = anno, NDVI = as.numeric(ndvi_mean), NDMI = as.numeric(ndmi_mean), NBR  = as.numeric(nbr_mean)))
  rownames(tab.indici) <- NULL
                                             
# Cartella di output per raster indici
out_dir <- file.path("C:/Users/feder/Desktop", "indici", as.character(anno))
dir.create(out_dir, recursive = TRUE)
    
# Salvataggio raster indici
  writeRaster(ndvi, file.path(out_dir, "NDVI.tif"), overwrite = TRUE)
  writeRaster(ndmi, file.path(out_dir, "NDMI.tif"), overwrite = TRUE)
  writeRaster(nbr,  file.path(out_dir, "NBR.tif"),  overwrite = TRUE)
  
  cat("✓ Indici salvati in:", out_dir, "\n")
}

tab.indici

# esporto la tabella degli indici
write.csv(tab.indici, file = "C:/Users/feder/Desktop/indici/valori_indici.csv", row.names = FALSE)


# RIDGELINE PLOTS

#NBR

# Imposta la cartella dove sono i raster
setwd("C:/Users/feder/Desktop/indici/NBR") 
 
# Importa tutti i raster NBR in un'unica riga
nbr <- rast(list.files(pattern = "NBR\\d{2}\\.tif$"))
 
# 3. Rinomina i layer con gli anni corretti
names(nbr) <- c("2019", "2020", "2021", "2022", "2023", "2024", "2025")

# rimuovo i valori=-1
nbr[nbr == -1] <- NA

# Ridgeline plot, forzare lo sfondo bianco per la palette usata (rocket)
Rnbr = im.ridgeline(nbr, scale=0.9, palette="rocket")
Rnbr = Rnbr + labs(x = "NBR", y = "anni") + theme_minimal() + theme(panel.background = element_rect(fill = "white", colour = NA),plot.background = element_rect(fill = "white", colour = NA))
Rnbr

# salvataggio
ggsave("nbr_ridgeline.png", Rnbr, width = 8, height = 6, dpi = 300)


#NDVI

# Imposta la cartella dove sono i raster
setwd("C:/Users/feder/Desktop/indici/NDVI") 
 
# Importa tutti i raster NDVI in un'unica riga
ndvi <- rast(list.files(pattern = "NDVI\\d{2}\\.tif$"))
 
# 3. Rinomina i layer con gli anni corretti
names(ndvi) <- c("2019", "2020", "2021", "2022", "2023", "2024", "2025")

# rimuovo i valori=-1
ndvi[ndvi == -1] <- NA

# Ridgeline plot
Rndvi = im.ridgeline(ndvi, scale=0.9, palette="viridis")
Rndvi = Rndvi + labs(x = "NDVI", y = "anni") + theme_minimal() + theme(panel.background = element_rect(fill = "white", colour = NA),plot.background = element_rect(fill = "white", colour = NA))
Rndvi

# salvataggio
ggsave("ndvi_ridgeline.png", Rndvi, width = 8, height = 6, dpi = 300)


#NDMI

# Imposta la cartella dove sono i raster
setwd("C:/Users/feder/Desktop/indici/NDMI") 
 
# Importa tutti i raster NDMI in un'unica riga
ndmi <- rast(list.files(pattern = "NDMI\\d{2}\\.tif$"))
 
# 3. Rinomina i layer con gli anni corretti
names(ndmi) <- c("2019", "2020", "2021", "2022", "2023", "2024", "2025")

# rimuovo i valori=-1
ndmi[ndmi == -1] <- NA

# Ridgeline plot
Rndmi = im.ridgeline(ndmi, scale=0.9, palette="mako")
Rndmi = Rndmi + labs(x = "NDMI", y = "anni") + theme_minimal() + theme(panel.background = element_rect(fill = "white", colour = NA),plot.background = element_rect(fill = "white", colour = NA))
Rndmi

# salvataggio
ggsave("ndmi_ridgeline.png", Rndmi, width = 8, height = 6, dpi = 300)


# CONFRONTO grafici NBR - NDMI
library(patchwork)

# Rimuovo l'etichetta asse Y da NDMI
Rndmi_mod <- Rndmi + theme(axis.title.y = element_blank())

# Composizione pulita
NBR_NDMI = Rnbr + Rndmi_mod

# Salva
ggsave("NBR_NDMI.png", NBR_NDMI, width = 12, height = 6, dpi = 300)
