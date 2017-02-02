#Team Monty (Jasper Siebring & Yingbao Sun)
#Project Pollution - Barcelona, Catalonia

#Interpolates any Spatial.DataFrame file

interpolation_idw=function(SPdata,boundary){
  #dataframe = as.data.frame(SPdata)
  #coordinates(dataframe) = ~coords.x1 + coords.x2
  #SPdata = PM10_december_2014
  #boundary = barcelona
  x.range = range(boundary@bbox[1,])
  y.range = range(boundary@bbox[2,])
  grd = expand.grid(x=seq(from=x.range[1], to=x.range[2], by=0.01), y=seq(from=y.range[1], to=y.range[2], by=0.01))
  coordinates(grd) = ~ x+y
  gridded(grd) = TRUE
  proj4string(grd) = proj4string(SPdata)
  
  idw = idw(formula = mean ~ 1, locations=SPdata, newdata=grd)
  idw_raster=raster(idw)
  masked_Raster=mask(idw_raster,boundary)
  return(masked_Raster)
}
