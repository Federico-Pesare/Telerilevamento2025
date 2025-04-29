# Exam project title: title

## Data gathering

Data were gathered from the [Earth Observatory site](https://earthobservatory.nasa.gov/).

Libraries used:

```r
library(terra)
library(imageRy)
library(viridis) # in order to plot images with different viridis color palettes
```

Setting the working directory and importing the data:

```r
setwd("C:/Users/feder/Desktop")
fires = rast("Wildfires.jpg")
plot(fires)
fires = flip(fires)
plot(fires)
```

The image is the following: *trascinare l'immagine*

![Wildfires](https://github.com/user-attachments/assets/d3760f57-2f62-48c2-99e0-36b845f58cfb)


## Data analysis

Based on the data gathered from the site we can caluclate an index, using the first two bands:

fireindex = fires[[1]] - fires[[2]]
plot(fireindex)

In order to export the index, we can use the png() function like:

png("fireindex.png")
plot(fireindex)
dev.off()

The index looks like:


## Index visualisation by viridis

In order to visualize the index with another viridis palette we made use of the following code:

```r
plot(fireindex, col=inferno(100))
```

The output is the following:

