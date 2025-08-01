# *Esteros del Iberá*: dinamiche ambientali tra siccità ed incendi.

![Parque Iberà 2022](img/incendio2022.jpg)

*Fonte: Fundación Rewilding Argentina*

<br>
<br>
<br>

## Area di studio

Areale nord della Provincia di Corrientes, Argentina.

Eco-regione degli *Esteros del Iberá*.

Superficie analizzata: ~ 24.000 km²

<img src="img/PROVINCIA_DI_CORRIENTES.png" width=80% />

*Fonte: Municipalidad de Colonia Carlos Pellegrini*

<br>
<br>
<br>

## 1. Analisi multitemporale su indici spettrali

Periodo di riferimento: febbraio, dal 2019 al 2025.

Termine dell'estate australe:
- Picco biomassa
- Picco incendi
- Nuvolosità < 5%

Le immagini multispettrali Sentinel-2 sono state acquisite dal [Copernicus Browser](https://browser.dataspace.copernicus.eu/?zoom=5&lat=50.16282&lng=20.78613&themeId=DEFAULT-THEME&demSource3D=%22MAPZEN%22&cloudCoverage=30&dateMode=SINGLE) 

<br>

### :fire: NBR (Normalized Burn Ratio)
Indice impiegato per identificare aree colpite da incendi e valutarne la severità.

Bande utilizzate: Infrarosso vicino (NIR) e Infrarosso a onda corta 2 (SWIR2)

```r
NBR = (NIR - SWIR2) / (NIR + SWIR2)
```

<br>

### :sweat_drops: NDMI (Normalized Difference Moisture Index)
Indice impiegato per valutare il contenuto idrico della vegetazione e condizioni di siccità.

Bande utilizzate: Infrarosso vicino (NIR) e Infrarosso a onda corta 1 (SWIR1)

```r
NDMI = (NIR - SWIR1) / (NIR + SWIR1)
```

<br>

### :deciduous_tree: NDVI (Normalized Difference Vegetation Index)
Indice impiegato per valutare lo stato di salute e densità della vegetazione.

Bande utilizzate: Infrarosso vicino (NIR) e Rosso visibile (RED)

```r
NDVI = (NIR - RED) / (NIR + RED)
```

<br>
<br>

**Pacchetti** utilizzati in R per condurre l'analisi :
```r
library(terra)      # Analisi e manipolazione di raster e dati geospaziali
library(imageRy)    # Visualizzazione e gestione di immagini raster
library(viridis)    # Palette di colori per ottimizzare la leggibilità grafica
library(ggplot2)    # Creazione di grafici basata su grammatiche visive
library(ggridges)   # Creazione di ridgeline plots per analisi della distribuzione
library(patchwork)  # Combinazione di più grafici ggplot2 in un unico layout
```

<br>

**Ciclo *for***: ottimizzazione calcolo degli indici :
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

<br>
<br>

### :chart_with_downwards_trend: LINE PLOT

Andamento delle medie spaziali degli indici nella serie temporale 2019 - 2025.

Grafico delle medie annuali mediante la funzione ggplot() del pacchetto ggplot2:
```r
line_plot = ggplot(medie, aes(x = Anno, y = Valore, color = Indice)) + geom_line(size = 1.2) + geom_point(size = 1.4) + labs(x = "anni", y = "valore medio", color=NULL) + scale_x_continuous(breaks = 2019:2025) + scale_color_manual(values = c( "NDVI" = "forestgreen", "NDMI" = "cornflowerblue", "NBR"  = "firebrick")) + theme_minimal() + theme(panel.background = element_rect(fill = "white", colour = NA),plot.background = element_rect(fill = "white", colour = NA))
```

<br>

<img src="img/Lineplot.png" width=70% />

<br>
<br>

### :chart_with_upwards_trend: RIDGELINE PLOTS

Distribuzione e variabilità spaziale degli indici nel tempo.

Grafico della distribuzione di NBR, NDMI, NDVI mediante la funzione im.ridgeline() del pacchetto imageRy:
```r
Rnbr = im.ridgeline(nbr, scale=0.9, palette="rocket")
Rndvi = im.ridgeline(ndvi, scale=0.9, palette="viridis")   
Rndmi = im.ridgeline(ndmi, scale=0.9, palette="mako")
```
Distribuzione di NBR e NDMI a confronto, sfruttando il pacchetto patchwork:
```r
NBR_NDMI = Rnbr + Rndmi_mod
```

<br>

![NBR_NDMI](img/NBR_NDMI.png)

<br>
<br>
<br>

## 2. Analisi dell'impatto nel 2022

*Differenced NBR* (dNBR) fra dicembre 2021 e febbraio 2022.

-1 < dNBR < 1

```r
dnbr = nbr.dic21 - nbr.feb22                        
```

<br>

Confronto immagini *true color* di feb 2019 e feb 2022  :

![2019vs2022](img/2019_2022.png)

*Fonte: Copernicus Browser*

<br>
<br>

- **IMPATTO LIEVE:  0.1 < dNBR < 0.27**
  
  ```r
  i_low = dnbr > 0.1 & dnbr <= 0.27                               # imposto il range
  pixel_low = global(i_low, fun = "sum", na.rm = TRUE)            # calcolo i pixel nel range
  pixel_tot = global(!is.na(dnbr), fun = "sum")                   # calcolo i pixel totali
  perc_low = (pixel_low / pixel_tot) * 100                        # calcolo la percentuale
  ```

  = ***30 %*** della superficie analizzata*

  <br>
  
- **IMPATTO MODERATO:  0.27 < dNBR < 0.44**

  ```r
  i_med = dnbr > 0.27 & dnbr <= 0.44
  pixel_med = global(i_med, fun = "sum", na.rm = TRUE)
  perc_med = (pixel_med / pixel_tot) * 100
  ```

  = ***19 %*** *

  <br>
  
- **IMPATTO ELEVATO:  dNBR > 0.44** 

  ```r
  i_high = dnbr > 0.44
  pixel_high = global(i_high, fun = "sum", na.rm = TRUE)
  perc_high = (pixel_high / pixel_tot) * 100
  ```

  = ***24 %*** *

<br>
<br>

  **VEGETAZIONE ATTIVA (RESIDUA)**

  ```r
  veg_res = (ndvi.feb22 > 0.3) & (ndmi.feb22 > 0) & (dnbr < 0.1)
  pixel_vegres = global(veg_res, fun = "sum", na.rm = TRUE)
  perc_vegres = (pixel_vegres / pixel_tot) * 100
  ```

  = ***11 %*** *

<br>
<br>
<br>

## 3. Analisi della variabilità spaziale post disturbo

Area nord-ovest Riserva Iberá; superficie ~ 2.000 km²

<img src="img/IBERA'.png" width=60% />

*Fonte: Municipalidad de Colonia Carlos Pellegrini*

<br>

### *Δsd NDMI*:

Studio della variazione della deviazione standard associata al NDMI fra 2024 e 2019  (-1 < *Δsd* < 1)

Calcolo della sd locale mediante la funzione focal() del pacchetto terra, e successivamente del Δ sd:
```r 
sd_ndmi19 = focal(ndmi19, w=c(3,3), fun=sd, na.rm=TRUE)  
sd_ndmi24 = focal(ndmi24, w=c(3,3), fun=sd, na.rm=TRUE)

delta_sd_ndmi = sd_ndmi24 - sd_ndmi19
```

  <br>
  
  - % area più eterogenea: *Δsd NDMI* > 0.05

    ```r 
    area_fram = delta_sd_ndmi > 0.05
    pixel_fram = global(area_fram, fun = "sum", na.rm = TRUE)
    pixel_tot = global(!is.na(delta_sd_ndmi), fun = "sum")
    perc_fram = (pixel_fram / pixel_tot) * 100
    ```

    = *11 %*

    <br>
    
  - % area più omogenea: *Δsd NDMI* < 0.05
        
    ```r 
    area_omog = delta_sd_ndmi < 0.05
    pixel_omog = global(area_omog, fun = "sum", na.rm = TRUE)
    perc_omog = (pixel_omog / pixel_tot) * 100
    ```

    = *89 %*
<br>
<br>

Confronto fra superfici incendiate nel 2022 ed evoluzione del territorio nel 2024:

![incendio_vs_evoluzione](img/incendio_sdndmi.png)

<br>
<br>
<br>

## Conclusioni

Il confronto tra febbraio 2019 e febbraio 2024 mostra una marcata omogeneizzazione strutturale in corrispondenza della aree impattate nel 2022. Al contrario, le aree limitrofe mostrano un incremento dell’eterogeneità locale, verosimilmente legato a processi di ricolonizzazione e frammentazione.
Tali dinamiche risultano coerenti alle successioni secondarie post-incendio delle zone umide subtropicali. Tuttavia, l'entità dell'impatto associato alle forti pressioni antropiche e climatiche ha causato un'alterazione estesa negli Esteros del Iberá, ed il ritorno di condizioni avverse nel 2025 continua a comprometterne la resistenza e resilienza, con effetti potenzialmente duraturi sulla struttura funzionale di questi ecosistemi umidi.

<br>
<br>
<br>

## Bibliografia

- Key, C. H., & Benson, N. C. (2006). Landscape Assessment: Ground Measure of Severity, the Composite Burn Index; and Remote Sensing of Severity, the Normalized Burn Ratio.
- Gomez, L. F., Cardozo, O. D. (2024). Los incendios y su impacto sobre las coberturas de la tierra en la Reserva Natural Iberá, Corrientes.
- [U.S. Geological Survey](https://www.usgs.gov/)
- Fundación Rewilding Argentina - Planificación y gobernanza 2019 - 2029



