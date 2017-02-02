#Team Monty (Jasper Siebring & Yingbao Sun)
#Project Pollution - Barcelona, Catalonia

library(xlsx)
library(sp)
library(raster)
library(plyr)
library(maptools)
library(rgdal)
library(rgeos)
library(ipdw)
library(gstat)
library(ggplot2)
library(rasterVis)
library(spatstat)
library(geoR)


create_DEM = function(...){}
#Get all the source data in the directory
TifFileList = list.files("Data/Data_YingBao",pattern = glob2rx('N*.tif'))
TifFileList = paste('Data/Data_YingBao/',TifFileList,sep = '')

#Create a empty list
#Using for loop to convert .tif data into Rasterayer in a created 
raster_list = list()
for(i in 1:length(TifFileList)){
  raster_list[i] = raster(TifFileList[i])
}

#Merge all the RasterLayer
DEM = do.call(merge, raster_list)
plot(DEM)

#Get the municipality boundary of Spain
boundary = raster::getData('GADM',country='ESP',level=2,path = 'Data/Data_YingBao')

#Select Barcelona region
Barcelona = boundary[boundary$NAME_2=="Barcelona",]

#Get elevation data witn Pa?s Vasco
DEMmask = mask(DEM,Barcelona)

#because after masking ,the relative area displayed is too small ,so we use the crop() to make it better
DEMmaskfull = crop(DEMmask,Barcelona)
plot(DEMmaskfull,axes=FALSE)

#Create the contour from the DEM data
contour = rasterToContour(DEMmaskfull,nlevels=8)
plot(contour,add=TRUE)

#convert RasterLayer into shapefile in order to display them in the 
writeOGR(contour, file.path("Output","contour.shp"),'contour', driver = 'ESRI Shapefile', overwrite_layer=TRUE)
writeRaster(DEMmaskfull,filename = 'Output/Barcelona.tif',format='GTiff',overwrite=TRUE)

levelplot(DEMmaskfull)
