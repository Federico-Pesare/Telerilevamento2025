# This code helps EXPORTING DATA

#1 choose the folder (directory)
setwd()
# C:\Users\feder\Documents ,  remember to change backslash on Windows!!!
setwd("C:/Users/feder/Documents")

getwd()
plot(gr)

# create the file (png, pdf, jpeg, ...)
png("greenland_output.png")
plot(gr)
dev.off()

pdf("greendiff.pdf")
plot(grdif)
dev.off()

jpeg("greendiff.jpeg)
plot(grdif)
dev.off()
