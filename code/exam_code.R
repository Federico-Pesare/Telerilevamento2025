# pacchetti impiegati per condurre l'analisi
library(terra)
library(imageRy)
library(ggplot2)  # grafici
library(ggridges)  # ridgeline plots
library(dplyr)
library(patchwork)  # grafici affiancati
library(RStoolbox)  # FORSE, per sd



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

################
rm(list=ls())
###################

# LINE PLOT: andamento (medie) NBR - NDVI - NDMI nella sequenza temporale 2019 - 2015

# creo i dati per il dataframe
anno = rep(2019:2025, each = 3)
indice = rep(c("NDVI", "NDMI", "NBR"), times = 7)
valore <- c(0.648,  0.190,  0.441, 0.619,  0.117,  0.372, 0.646,  0.160,  0.407, 0.361, -0.174, -0.002, 0.469, -0.057,  0.145, 0.665,  0.165,  0.423, 0.533, -0.014,  0.237)

medie <- data.frame(Anno = anno, Indice = indice, Valore = valore)
 
# Visualizza il line plot
line_plot = ggplot(medie, aes(x = Anno, y = Valore, color = Indice)) + geom_line(size = 1.2) + geom_point(size = 1.4) + labs(x = "anni", y = "valore medio", color=NULL) + scale_x_continuous(breaks = 2019:2025) + 
  scale_color_manual(values = c( "NDVI" = "forestgreen", "NDMI" = "cornflowerblue", "NBR"  = "firebrick")) + theme_minimal() + theme(panel.background = element_rect(fill = "white", colour = NA),plot.background = element_rect(fill = "white", colour = NA))
line_plot

# Salva
ggsave("Line_Plot.png", line_plot)



# RIDGELINE PLOTS: analisi della distribuzione degli indici




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



# CONFRONTO grafici NBR - NDMI
library(patchwork)

# Rimuovo l'etichetta asse Y da NDMI
Rndmi_mod <- Rndmi + theme(axis.title.y = element_blank())

# Visualizzazione grafici affiancati
NBR_NDMI = Rnbr + Rndmi_mod

# Salva
ggsave("NBR_NDMI.png", NBR_NDMI, width = 12, height = 6, dpi = 300)











# INCENDIO (DIC 2021 - FEB 2022)

# Calcolo indici per le condizioni pre incendio
path_dic21 <- "C:/Users/feder/Desktop/29dic2021/geoTiff"

red   <- rast(file.path(path_dic21, "B04.tiff"))
nir   <- rast(file.path(path_dic21, "B08.tiff"))
swir1 <- rast(file.path(path_dic21, "B11.tiff"))
swir2 <- rast(file.path(path_dic21, "B12.tiff"))

ndvi.dic21 <- (nir - red) / (nir + red)
ndmi.dic21 <- (nir - swir1) / (nir + swir1)
nbr.dic21  <- (nir - swir2) / (nir + swir2)

# assegno la dicitura "nbr/ndvi/ndmi.feb22" ai raster di feb2022 precedentemente importati negli stack per la realizzazione dei ridgeline plots degli indici
nbr.feb22 = nbr[[4]]
ndvi.feb22 = ndvi[[4]]
ndmi.feb22 = ndmi[[4]]

# PERC AREA INCENDIATA. Basata sul delta NBR: valori > 0.1 indicano danno da incendio
dnbr = nbr.dic21 - nbr.feb22

# % AREE AD IMPATTO LIEVE
i_low = dnbr > 0.1 & dnbr <= 0.27

#pixel bruciati
pixel_low <- global(i_low, fun = "sum", na.rm = TRUE)

# Numero totale di pixel validi (non NA)
pixel_tot <- global(!is.na(dnbr), fun = "sum", na.rm = TRUE)

perc_low <- (pixel_low / pixel_tot) * 100
perc_low
# 30 %

# % AREE AD IMPATTO MODERATO
i_med = dnbr > 0.27 & dnbr <= 0.44
pixel_med = global(i_med, fun = "sum", na.rm = TRUE)
perc_med = (pixel_med / pixel_tot) * 100
perc_med
# 19 %

# % AREE AD IMPATTO ELEVATO
i_high = dnbr > 0.44
pixel_high = global(i_high, fun = "sum", na.rm = TRUE)
perc_high = (pixel_high / pixel_tot) * 100
perc_high
# 24 %


# VEGETAZIONE RESIDUA %
veg_res = (ndvi.feb22 > 0.3) & (ndmi.feb22 > 0) & (dnbr < 0.1)
pixel_vegres = global(veg_res, fun = "sum", na.rm = TRUE)
perc_vegres = (pixel_vegres / pixel_tot) * 100
perc_vegres
# 11 %


