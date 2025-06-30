install.packages("patchwork")     #package needed to couple graphs

library(terra)
library(imageRy)
library(ggplot2)
library(patchwork)

im.list()

mato1992 = im.import("matogrosso_l5_1992219_lrg.jpg")
mato1992 = flip(mato1992)
plot(mato1992)

mato2006 = im.import("matogrosso_ast_2006209_lrg.jpg")
mato2006 = flip(mato2006)
plot(mato2006)

# Classifing images, num_clusters per quante classi vogliamo associare, volendo si può aggiungere "seed" per decidere quale criterio di classificazione usare in modo da standardizzare 
mato1992c = im.classify(mato1992, num_clusters=2)
# class1 = forest
# class2 = human

mato2006c = im.classify(mato2006, num_clusters=2)
# class1 = forest
# class2 = human

# Calculating percentage: calcolare frequenze, il totale di pixel, proporzioni e percentuale. Anche in 1 solo comando!
f1992 = freq(mato1992c)
f1992
tot1992 = ncell(mato1992c)
tot1992
prop1992 = f1992 / tot1992
prop1992
perc1992 = prop1992 * 100
perc1992

# forest=83%  human=17%

perc2006 = freq(mato2006c)*100 / ncell(mato2006c)
perc2006

# forest=45%  human=54%

# ggplot2
# Creating dataframe

class = c("Forest","Human")
y1992 = c(83,17)
y2006 = c(45,55)
tabout = data.frame(class,y1992,y2006)

p1 = ggplot(tabout, aes(x=class, y=y1992, color=class)) + geom_bar(stat="identity", fill="white") + ylim(c(0,100))
p2 = ggplot(tabout, aes(x=class, y=y2006, color=class)) + geom_bar(stat="identity", fill="white") + ylim(c(0,100))
p1 + p2     # grafici uno di fianco all'altro
p1 / p2     # grafici uno sull'altro   

# per oottenere i grafici (barre) colorate internamente e non solo il contorno
p1 = ggplot(tabout, aes(x=class, y=y1992, fill=class, color=class)) + geom_bar(stat="identity") + ylim(c(0,100))

# accostiamo tutti i grafici
p0 = im.ggplot(mato1992)
p00 = im.ggplot(mato2006)
p0 + p00 + p1 + p2

# controllare sul file del prof il modo per accostare tutte e 4 le barre

# cont...

solar = im.import("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")

# classify the image in 3 classes
solarc = im.classify(solar, num_clusters=3)

# plot the original image beside the classified one
im.multiframe(1,2)
plot(solar)
plot(solarc)

# 3 = low
# 1 = medium
# 2 = high
# sostituire i 3 valori con la classe energetica alla quale corrispondono
solarcs = subst(solarc, c(3,1,2), c("low","medium","high"))
plot(solarcs)
# ordering using with other names 
solarcs = subst(solarc, c(3,1,2), c("c1_low","c2_medium","c3_high"))
plot(solarcs)

# Calculate the percentages of the sun energy with one line of code
solarperc = freq(solarc)*100 / ncell(solarc)
solarperc
# oppure, ma specificando l'argomento perchè senno non riesce a moltiplicare gli altri argomenti della tabellina
solarperc = freq(solarcs)$count *100 / ncell(solarcs)
solarperc
# 37.33349 41.44658 21.21993

# create dataframe
class = c("c1_low","c2_medium","c3_high")
perc = c(38,41,21)
tabsol = data.frame(class,perc)
tabsol

# final ggplot
ggplot(tabsol, aes(x=class, y=perc, fill=class, color=class)) + geom_bar(stat="identity")
ggplot(tabsol, aes(x=class, y=perc, fill=class, color=class)) + geom_bar(stat="identity") + coord_flip()   # to reverse
ggplot(tabsol, aes(x=class, y=perc, fill=class, color=class)) + geom_bar(stat="identity") + coord_flip() + scale_y_reverse()

       
