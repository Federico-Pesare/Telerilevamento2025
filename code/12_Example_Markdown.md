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

The image is the following:

![fires]![Wildfires](https://github.com/user-attachments/assets/d3760f57-2f62-48c2-99e0-36b845f58cfb)


## Data analysis

## Index visualisation by viridis

In order to visualize the index with another viridis palette we made use of the following code:

```r
plot(fireindex, col=inferno(100))
```
