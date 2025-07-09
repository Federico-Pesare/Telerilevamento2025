# Analisi multi-temporale mediante indici spettrali (NDVI, NDMI, NBR) delle anomalie ambientali registrate negli Esteros del Iberà (Argentina) fra 2019 e 2025.


# Pacchetti impiegati in R per condurre l'analisi
library(terra)      # Analisi e manipolazione di raster e dati geospaziali
library(imageRy)    # Visualizzazione e gestione di immagini raster
library(viridis)    # Palette di colori per ottimizzare la leggibilità grafica
library(ggplot2)    # Creazione di grafici basata su grammatiche visive
library(ggridges)   # Creazione di ridgeline plots per analisi della distribuzione
library(patchwork)  # Combinazione di più grafici ggplot2 in un unico layout


# ANALISI INDICI SPETTRALI

# Anni da processare
anni = c(2019, 2020, 2021, 2022, 2023, 2024, 2025)

# Tabella vuota per visualizzare il valore della media di ogni indice per anno
tab.indici = data.frame(Anno = integer(), NDVI = numeric(), NDMI = numeric(), NBR = numeric())

# CICLO FOR per il calcolo degli indici
for (anno in anni) {
  cat("Indici spettrali febbraio", anno, "\n")

# Percorso alle cartelle contenenti le bande
path = file.path("C:/Users/feder/Desktop/IBERA'", as.character(anno), "geoTiff")

# Caricare le bande con la funzione rast() del pacchetto terra
  red = rast(file.path(path, "B04.tiff"))
  nir = rast(file.path(path, "B08.tiff"))
  swir1 = rast(file.path(path, "B11.tiff"))
  swir2 = rast(file.path(path, "B12.tiff"))
  
# Calcolo degli indici
  ndvi = (nir - red) / (nir + red)
  ndmi = (nir - swir1) / (nir + swir1)
  nbr = (nir - swir2) / (nir + swir2)

# Calcolo le medie degli indici, eliminando eventuali NA ed estraendo il solo valore numerico con [1] per il dataframe 
  ndvi_mean = global(ndvi, fun = "mean", na.rm = TRUE)[1]
  ndmi_mean = global(ndmi, fun = "mean", na.rm = TRUE)[1]
  nbr_mean = global(nbr,  fun = "mean", na.rm = TRUE)[1] 

# Aggiungo i risultati alla tabella
  tab.indici = rbind(tab.indici, data.frame(Anno = anno, NDVI = as.numeric(ndvi_mean), NDMI = as.numeric(ndmi_mean), NBR  = as.numeric(nbr_mean)))
                                             
# Inserisco il percorso per il salvataggio dei raster (all'interno della cartella "indici" che verrà creata appositamente)
out_dir = file.path("C:/Users/feder/Desktop", "indici", as.character(anno))
dir.create(out_dir, recursive = TRUE)
    
# Salvataggio raster indici
  writeRaster(ndvi, file.path(out_dir, "NDVI.tif"), overwrite = TRUE)
  writeRaster(ndmi, file.path(out_dir, "NDMI.tif"), overwrite = TRUE)
  writeRaster(nbr,  file.path(out_dir, "NBR.tif"),  overwrite = TRUE)
  
  cat("✓ Indici salvati in:", out_dir, "\n")
}

# Esporto la tabella degli indici
write.csv(tab.indici, file = "C:/Users/feder/Desktop/indici/valori_indici.csv", row.names = FALSE)

# Rimuovo i dati esportati per prevenire sovrascrizione in R
rm(list=ls())


# LINE PLOT: andamento (medie) NBR - NDVI - NDMI nella sequenza temporale 2019 - 2015

# Creo i dati per il dataframe
anno = rep(2019:2025, each = 3)
indice = rep(c("NDVI", "NDMI", "NBR"), times = 7)
valore = c(0.648,  0.190,  0.441, 0.619,  0.117,  0.372, 0.646,  0.160,  0.407, 0.361, -0.174, -0.002, 0.469, -0.057,  0.145, 0.665,  0.165,  0.423, 0.533, -0.014,  0.237)

# Creo il dataframe
medie = data.frame(Anno = anno, Indice = indice, Valore = valore)
 
# Visualizzo il line plot
line_plot = ggplot(medie, aes(x = Anno, y = Valore, color = Indice)) + geom_line(size = 1.2) + geom_point(size = 1.4) + labs(x = "anni", y = "valore medio", color=NULL) + scale_x_continuous(breaks = 2019:2025) + 
  scale_color_manual(values = c( "NDVI" = "forestgreen", "NDMI" = "cornflowerblue", "NBR"  = "firebrick")) + theme_minimal() + theme(panel.background = element_rect(fill = "white", colour = NA),plot.background = element_rect(fill = "white", colour = NA))
line_plot

# Salvo come file png
ggsave("Line_Plot.png", line_plot)


# RIDGELINE PLOTS: analisi della distribuzione degli indici

# NDVI

# Imposto la directory alla cartella contenente i raster
setwd("C:/Users/feder/Desktop/indici/NDVI") 
 
# Importo tutti i raster NDVI in un'unica riga
ndvi = rast(list.files(pattern = "NDVI\\d{2}\\.tif$"))
 
# Rinomino i layer con gli anni corretti
names(ndvi) = c("2019", "2020", "2021", "2022", "2023", "2024", "2025")

# Rimuovo i valori=-1
ndvi[ndvi == -1] = NA

# Creo Ridgeline Plot mediante la funzione im.ridgeline() del pacchetto imageRy
Rndvi = im.ridgeline(ndvi, scale=0.9, palette="viridis")
Rndvi = Rndvi + labs(x = "NDVI", y = "anni") + theme_minimal() + theme(panel.background = element_rect(fill = "white", colour = NA),plot.background = element_rect(fill = "white", colour = NA))
Rndvi

# Salvataggio del Ridgeline Plot
ggsave("ndvi_ridgeline.png", Rndvi, width = 8, height = 6, dpi = 300)

# NDMI

setwd("C:/Users/feder/Desktop/indici/NDMI") 
 
ndmi = rast(list.files(pattern = "NDMI\\d{2}\\.tif$"))
 
names(ndmi) = c("2019", "2020", "2021", "2022", "2023", "2024", "2025")

ndmi[ndmi == -1] = NA

Rndmi = im.ridgeline(ndmi, scale=0.9, palette="mako")
Rndmi = Rndmi + labs(x = "NDMI", y = "anni") + theme_minimal() + theme(panel.background = element_rect(fill = "white", colour = NA),plot.background = element_rect(fill = "white", colour = NA))
Rndmi

ggsave("ndmi_ridgeline.png", Rndmi, width = 8, height = 6, dpi = 300)


#NBR

setwd("C:/Users/feder/Desktop/indici/NBR") 

nbr = rast(list.files(pattern = "NBR\\d{2}\\.tif$"))

names(nbr) = c("2019", "2020", "2021", "2022", "2023", "2024", "2025")

nbr[nbr == -1] = NA

Rnbr = im.ridgeline(nbr, scale=0.9, palette="rocket")
Rnbr = Rnbr + labs(x = "NBR", y = "anni") + theme_minimal() + theme(panel.background = element_rect(fill = "white", colour = NA),plot.background = element_rect(fill = "white", colour = NA))
Rnbr

ggsave("nbr_ridgeline.png", Rnbr, width = 8, height = 6, dpi = 300)


# CONFRONTO RIDGELINE NBR - NDMI

# Rimuovo l'etichetta asse Y da NDMI
Rndmi_mod = Rndmi + theme(axis.title.y = element_blank())

# Visualizzazione grafici affiancati grazie al pacchetto patchwork
NBR_NDMI = Rnbr + Rndmi_mod

# Salvo l'output grafico
ggsave("NBR_NDMI.png", NBR_NDMI, width = 12, height = 6, dpi = 300)




# ANALISI IMPATTO INCENDIO 2022 (DIC 2021 - FEB 2022)

# Calcolo degli indici spettrali per valutare le condizioni pre incendio (dicembre 2021)

# Percorso alla cartella contenete le bande di dicembre 2021
path_dic21 = "C:/Users/feder/Desktop/29dic2021/geoTiff"

# Carico le bande necessarie per il calcolo NBR
nir = rast(file.path(path_dic21, "B08.tiff"))
swir2 = rast(file.path(path_dic21, "B12.tiff"))

# Calcolo NBR per dicembre 2021
nbr.dic21  = (nir - swir2) / (nir + swir2)

# assegno la dicitura "nbr/ndvi/ndmi.feb22" ai raster di feb2022 precedentemente importati negli stack per la realizzazione dei ridgeline plots degli indici
nbr.feb22 = nbr[[4]]
ndvi.feb22 = ndvi[[4]]
ndmi.feb22 = ndmi[[4]]

# Calcolo Δ NBR: valori > 0.1 indicano danno da incendio
dnbr = nbr.dic21 - nbr.feb22


# Calcolo % AREE AD IMPATTO LIEVE
# Genero un range per filtrare i valori
i_low = dnbr > 0.1 & dnbr <= 0.27

#pixel bruciati
pixel_low = global(i_low, fun = "sum", na.rm = TRUE)

# Numero totale di pixel validi (non NA)
pixel_tot = global(!is.na(dnbr), fun = "sum", na.rm = TRUE)

# Calcolo della percentule impattata lievemente
perc_low = (pixel_low / pixel_tot) * 100
perc_low
# 30 %


# Calcolo % AREE AD IMPATTO MODERATO
i_med = dnbr > 0.27 & dnbr <= 0.44
pixel_med = global(i_med, fun = "sum", na.rm = TRUE)
perc_med = (pixel_med / pixel_tot) * 100
perc_med
# 19 %


# Calcolo % AREE AD IMPATTO ELEVATO
i_high = dnbr > 0.44
pixel_high = global(i_high, fun = "sum", na.rm = TRUE)
perc_high = (pixel_high / pixel_tot) * 100
perc_high
# 24 %


# Calcolo % VEGETAZIONE ATTIVA (RESIDUA)
veg_res = (ndvi.feb22 > 0.3) & (ndmi.feb22 > 0) & (dnbr < 0.1)
pixel_vegres = global(veg_res, fun = "sum", na.rm = TRUE)
perc_vegres = (pixel_vegres / pixel_tot) * 100
perc_vegres
# 11 %




# Δ ETEROGENEITA' LOCALE SU BASE NDMI FRA 2019 E 2024 A NORD-OVEST DEL PARQUE NACIONAL IBERA' 

# Percorsi alle cartelle contenenti le bande
path19 = "C:/Users/feder/Desktop/Ibera_19/geoTiff"
path24 = "C:/Users/feder/Desktop/Ibera_24/geoTiff"

# Carico le bande necessarie per il calcolo NDMI 2019 e 2024
nir19 = rast(file.path(path19, "B08.tiff"))
swir19 = rast(file.path(path19, "B11.tiff"))
nir24 = rast(file.path(path24, "B08.tiff"))
swir24 = rast(file.path(path24, "B11.tiff"))

# Calcolo NDMI
ndmi19 = (nir19 - swir19) / (nir19 + swir19)
ndmi24 = (nir24 - swir24) / (nir24 + swir24)

# SD locale su finestra mobile (3x3) per 2019 e 2024 
sd_ndmi19 = focal(ndmi19, w=c(3,3), fun=sd, na.rm=TRUE)
sd_ndmi24 = focal(ndmi24, w=c(3,3), fun=sd, na.rm=TRUE)

# Δ SD
delta_sd_ndmi = sd_ndmi24 - sd_ndmi19

# Visualizzo le aree che hanno subito frammentazione, sono rimaste invariate o sono diventate più omogenee
plot(delta_sd_ndmi, main="Δ SD NDMI 2024 - 2019", col=cividis(11))

# Esporto il file png, sfruttando la pallette "cividis"
png("delta_sd_ndmi.png", width = 1600, height = 1200, res = 150)
plot(delta_sd_ndmi, main="Δ SD NDMI 2024 - 2019", col=cividis(11))
dev.off()


# % Area con > frammentazione nel 2024. Imposto il range > 0.5
area_fram = delta_sd_ndmi > 0.05
pixel_fram = global(area_fram, fun = "sum", na.rm = TRUE)
pixel_tot = global(!is.na(delta_sd_ndmi), fun = "sum", na.rm = TRUE)
perc_fram = (pixel_fram / pixel_tot) * 100
perc_fram
# 11 %


# % Area con > omogeneità nel 2024
area_omog = delta_sd_ndmi < 0.05
pixel_omog = global(area_omog, fun = "sum", na.rm = TRUE)
perc_omog = (pixel_omog / pixel_tot) * 100
perc_omog
# 89 %


# Visualizzazione dell'area bruciata a N-O del Parco nel 2022

# Importo la banda 8 che permette una buona visualizzazione delle superfici bruciate
incendio22 = rast("C:/Users/feder/Desktop/Ibera_22/B08.tiff")
plot (incendio22, col=cividis(100))

# Salvo il file png sfruttando la palette "cividis" 
png("incendio2022.png", width = 1600, height = 1200, res = 150)
plot(incendio22, legend= FALSE, main ="Incendio 2022", col=cividis(100))
dev.off()
