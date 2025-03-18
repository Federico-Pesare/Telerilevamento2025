## Reporting multitemporal analysis by Markdown

In order to perform multitemporal analysis, datasets in different times can be imported, by:

```r
im.list()
gr = im.import("greenland")
```

Once the set has been imported we can calculate the differences between different dates, as:

```r
grdif = gr[[1]] - gr[[4]]
```

The output will be something like:

<img src="../Pics/difgreen.jpeg" width=50% />

> Note: information about the Copernicus program can be found at the [Copernicus page](https://www.copernicus.eu/en)
