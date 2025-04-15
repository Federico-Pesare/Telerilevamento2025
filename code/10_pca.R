# R code for principal component analysis

library(imageRy)
library(terra)

im.list()
sent = im.import("sentinel.png")
sent = flip(sent)
plot(sent)

# deleting the 4th image (empty), we can do a subset
sent = c(sent[[1]],sent[[2]],sent[[3]])
plot(sent)
# band 1 = nir
# band 2 = red
# band 3 = green

?im.pca

sentpca = im.pca(sent)

tot = 72 + 59 + 6
# 137
# proportion for the percentage of the first image variability
72 : 137 = x : 100
72 * 100 / tot

sdpc1 = focal(sentpca[[1]], w=c(3,3), fun="sd")
plot(sdpc1)

