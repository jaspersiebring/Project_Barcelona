#Team Monty (Jasper Siebring & Yingbao Sun)
#Project Pollution - Barcelona, Catalonia

#creates a DEM map for Barcelona, Catalonia

create_DEM = function(barcelona_bd){
  #Get all the source data in the directory
  TifFileList = list.files("Data/Data_YingBao",pattern = glob2rx('N*.tif'))
  TifFileList = paste('Data/Data_YingBao/',TifFileList,sep = '')
  
  #Create a empty list
  #Using for loop to convert all the .tif data into Rasters 
  raster_list = list()
  
  for(i in 1:length(TifFileList)){
  raster_list[i] = raster(TifFileList[i])
  }
  
  #Merge all the RasterLayer into 
  DEM = do.call(merge, raster_list)
  
  #Get elevation data witn Pa?s Vasco
  DEMmask = mask(DEM, barcelona_bd)
  #because after masking ,the relative area displayed is too small ,so we use the crop() to make it better
  DEMmaskfull = crop(DEMmask, barcelona_bd)
  
  #Create the contour from the DEM data
  contour = rasterToContour(DEMmaskfull, nlevels=8)
  
  #convert RasterLayer into shapefile in order to display them in the 
  writeOGR(contour, file.path("Output","contour.shp"),'contour', driver = 'ESRI Shapefile', overwrite_layer=TRUE)
  writeRaster(DEMmaskfull,filename = 'Output/Barcelona.tif',format='GTiff',overwrite=TRUE)
  plot(DEMmaskfull)
  plot(contour, add = TRUE)
  return (DEMmaskfull)
}

  