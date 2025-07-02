# Gli *Esteros del Iberá* tra siccità e incendi: analisi multitemporale delle dinamiche ambientali tra 2019 e 2025.

![Parque Iberà 2022](img/incendio2022.jpg)
*Fonte: Fundación Rewilding Argentina*


## Area di studio

Areale nord della Provincia di Corrientes, Argentina.

Eco-regione degli *Esteros del Iberá*.

Superficie analizzata: ~ 24.000 km²

![Esteros del Iberá](img/PROVINCIA_DI_CORRIENTES.png)
*Fonte: Municipalidad de Colonia Carlos Pellegrini*


## Analisi multitemporale su indici spettrali

Periodo di riferimento dal 2019 al 2025: 
Febbraio (termine estate australe)
- Bassa nuvolosità: < 5%
- Picco biomassa
- Picco incendi


### NBR (Normalized Burn Ratio)
Indice impiegato per identificare aree colpite da incendi e valutarne la severità.

Bande utilizzate: Infrarosso vicino (NIR) e Infrarosso a onda corta 2 (SWIR2)

```r
NBR = (NIR - SWIR2) / (NIR + SWIR2)
```

### NDMI (Normalized Difference Moisture Index)
Indice impiegato per valutare il contenuto idrico della vegetazione e condizioni di siccità.

Bande utilizzate: Infrarosso vicino (NIR) e Infrarosso a onda corta 1 (SWIR1)

```r
NDMI = (NIR - SWIR1) / (NIR + SWIR1)
```

### NDVI (Normalized Difference Vegetation Index)
Indice impiegato per valutare lo stato di salute e densità della vegetazione.

Bande utilizzate: Infrarosso vicino (NIR) e Rosso visibile (RED)

```r
NDVI = (NIR - RED) / (NIR + RED)
```


Pacchetti impiegati in R per condurre l'analisi:
```r
library(terra)  # Analisi e manipolazione di raster e dati geospaziali
library(imageRy)  # Visualizzazione e gestione di immagini raster
library(viridis)  # Palette di colori per ottimizzare la legibilità grafica
library(ggplot2)  # Creazione di grafici basata su grammatiche visive
library(ggridges)  # Creazione di ridgeline plots per analisi della distribuzione
library(patchwork)  # Combinazione di più grafici ggplot2 in un unico layout
```
