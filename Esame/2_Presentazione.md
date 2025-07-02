# Gli *Esteros del Iberá* tra siccità e incendi: analisi multitemporale delle dinamiche ambientali tra 2019 e 2025.

![Parque Iberà 2022](img/incendio2022.jpg)
*Fonte: Fundación Rewilding Argentina*


## Area di studio

Areale nord della Provincia di Corrientes, Argentina.

Eco-regione degli *Esteros del Iberá*.

Superficie analizzata: ~ 24.000 km²

<img src="img/PROVINCIA_DI_CORRIENTES.png" width=80% />
*Fonte: Municipalidad de Colonia Carlos Pellegrini*


## Analisi multitemporale su indici spettrali

Periodo di riferimento dal 2019 al 2025: 
Febbraio (termine estate australe)
- Bassa nuvolosità: < 5%
- Picco biomassa
- Picco incendi

Le immagini multispettrali Sentinel-2 sono state acquisite dal [Copernicus Browser](https://browser.dataspace.copernicus.eu/?zoom=5&lat=50.16282&lng=20.78613&themeId=DEFAULT-THEME&demSource3D=%22MAPZEN%22&cloudCoverage=30&dateMode=SINGLE) 

### - NBR (Normalized Burn Ratio)
Indice impiegato per identificare aree colpite da incendi e valutarne la severità.

Bande utilizzate: Infrarosso vicino (NIR) e Infrarosso a onda corta 2 (SWIR2)

```r
NBR = (NIR - SWIR2) / (NIR + SWIR2)
```

### - NDMI (Normalized Difference Moisture Index)
Indice impiegato per valutare il contenuto idrico della vegetazione e condizioni di siccità.

Bande utilizzate: Infrarosso vicino (NIR) e Infrarosso a onda corta 1 (SWIR1)

```r
NDMI = (NIR - SWIR1) / (NIR + SWIR1)
```

### - NDVI (Normalized Difference Vegetation Index)
Indice impiegato per valutare lo stato di salute e densità della vegetazione.

Bande utilizzate: Infrarosso vicino (NIR) e Rosso visibile (RED)

```r
NDVI = (NIR - RED) / (NIR + RED)
```


**Pacchetti** utilizzati in R per condurre l'analisi:
```r
library(terra)  # Analisi e manipolazione di raster e dati geospaziali
library(imageRy)  # Visualizzazione e gestione di immagini raster
library(viridis)  # Palette di colori per ottimizzare la leggibilità grafica
library(ggplot2)  # Creazione di grafici basata su grammatiche visive
library(ggridges)  # Creazione di ridgeline plots per analisi della distribuzione
library(patchwork)  # Combinazione di più grafici ggplot2 in un unico layout
```


**Ciclo *for***: ottimizzazione calcolo degli indici 
```r
# Anni da processare
anni = c(2019, 2020, 2021, 2022, 2023, 2024, 2025)

for (anno in anni) {
  cat("Indici spettrali febbraio", anno, "\n")

# Percorso alle cartelle contenenti le bande
 path = file.path("C:/Users/feder/Desktop/IBERA'", as.character(anno), "geoTiff")

# Carico le bande con la funzione rast() del pacchetto terra
  red = rast(file.path(path, "B04.tiff"))
  nir = rast(file.path(path, "B08.tiff"))
  swir1 = rast(file.path(path, "B11.tiff"))
  swir2 = rast(file.path(path, "B12.tiff"))
  
# Calcolo degli indici
  ndvi = (nir - red) / (nir + red)
  ndmi = (nir - swir1) / (nir + swir1)
  nbr = (nir - swir2) / (nir + swir2)

# Calcolo le medie degli indici, eliminando eventuali NA 
  ndvi_mean = global(ndvi, fun = "mean", na.rm = TRUE)[1]
  ndmi_mean = global(ndmi, fun = "mean", na.rm = TRUE)[1]
  nbr_mean = global(nbr,  fun = "mean", na.rm = TRUE)[1]

 cat("✓ Indici salvati in:", out_dir, "\n")
}
```

### LINE PLOT

Andamento delle medie spaziali dei tre indici analizzati nella serie temporale 2019 - 2025

Mediante la funzione ggplot() del pacchetto ggplot2:
```r
line_plot = ggplot(medie, aes(x = Anno, y = Valore, color = Indice)) + geom_line(size = 1.2) + geom_point(size = 1.4) + labs(x = "anni", y = "valore medio", color=NULL) + scale_x_continuous(breaks = 2019:2025) + scale_color_manual(values = c( "NDVI" = "forestgreen", "NDMI" = "cornflowerblue", "NBR"  = "firebrick")) + theme_minimal() + theme(panel.background = element_rect(fill = "white", colour = NA),plot.background = element_rect(fill = "white", colour = NA))
```

<img src="img/Lineplot.png" width=70% />


### RIDGELINE PLOTS
