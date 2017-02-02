#Team Monty (Jasper Siebring & Yingbao Sun)
#Project Pollution - Barcelona, Catalonia

#2nd of February, 2017 
#This script will produce two .gifs/.tifs which will illustrate the PM10/PM2.5 values in Barcelona, Catalonia throughout the year. 

#imports/sources the necessary libraries and sub-scripts
library(xlsx)
library(sp)
library(raster)
library(plyr)
library(maptools)
library(rgdal)
library(rgeos)
library(ggplot2)
library(rasterVis)
library(animation)
library(gstat)

source('R/create_mean_attribute.R')
source('R/create_matching_id_meta.R')
source('R/create_matching_id_pol.R')
source('R/filter_sp_day_month.R')
source('R/interpolation.R')
source('R/DEM.R')


#introducing some vectors that we'll use for formatting and some translation of the source_data 
en_station_names = c("year", "national_code", "station_code", "latitude", "longitude", "type_pollution", "name", "legit_value", "statistics", "value", "situation", "legend", "comments")
PM10_data_names = c("province", "municipality", "station", "magnitude", "point_id", "year", "month", "day_1", "day_2", "day_3", "day_4", "day_5", "day_6", "day_7", "day_8", "day_9", "day_10", "day_11", "day_12", "day_13", "day_14", "day_15", "day_16", "day_17", "day_18", "day_19", "day_20", "day_21", "day_22", "day_23", "day_24", "day_25", "day_26", "day_27", "day_28", "day_29", "day_30", "day_31") 
PM25_data_names = c("province", "municipality", "station", "magnitude", "point_id", "year", "month", "day_1", "val_1", "day_2", "val_2", "day_3", "val_3", "day_4", "val_4", "day_5", "val_5", "day_6", "val_6", "day_7", "val_7", "day_8", "val_8", "day_9", "val_9", "day_10", "val_10", "day_11", "val_11", "day_12", "val_12", "day_13", "val_13", "day_14", "val_14", "day_15", "val_15", "day_16", "val_16", "day_17", "val_17", "day_18", "val_18", "day_19", "val_19", "day_20", "val_20", "day_21", "val_21", "day_22", "val_22", "day_23", "val_23", "day_24", "val_24", "day_25", "val_25", "day_26", "val_26", "day_27", "val_27", "day_28", "val_28", "day_29", "val_29", "day_30", "val_30", "day_31", "val_31") 
keeps = c("type_pollution", "copy_id", "station_code", "national_code", "name")
months = c("jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec") 
PM10_titles = c("PM10 pollution over January 2014", "PM10 pollution over February 2014", "PM10 pollution over March 2014", "PM10 pollution over April 2014", "PM10 pollution over May 2014", "PM10 pollution over June 2014", "PM10 pollution over July 2014", "PM10 pollution over August 2014", "PM10 pollution over September 2014", "PM10 pollution over October 2014", "PM10 pollution over November 2014", "PM10 pollution over December 2014") 
PM25_titles = c("PM25 pollution over January 2014", "PM25 pollution over February 2014", "PM25 pollution over March 2014", "PM25 pollution over April 2014", "PM25 pollution over May 2014", "PM25 pollution over June 2014", "PM25 pollution over July 2014", "PM25 pollution over August 2014", "PM25 pollution over September 2014", "PM25 pollution over October 2014", "PM25 pollution over November 2014", "PM25 pollution over December 2014") 

#downloads the boundaries of Spain and subsets Barcelona from it (we're choosing Barcelona since there's a lot more avaiable data, see Images)
boundary = getData("GADM", country = 'ESP', level=2, path = 'Data') 
barcelona = boundary[boundary$NAME_2 == "Barcelona",]

#OPTIONAL, REMOVE THE COMMENTS TO CREATE A DEM MAP OF BARCELONA
#DEM = create_DEM(barcelona)
#plot(DEM)

#converts a .shp file containing meta data (and location) of measure stations to SpatialPointDataFrame (also reprojects, intersects, and drops some unnecessary columns
stations_df = readShapePoints('Data/ESTACIONES_2015', proj4string = CRS(proj4string(barcelona)))
names(stations_df) = en_station_names
stations_df = intersect(stations_df, barcelona)
stations_df = stations_df[stations_df$statistics == 'media',]
stations_df$copy_id = stations_df$national_code
stations_df = stations_df[keeps]

#seperates the station data into one PointDataFrame per Particle Matter type 
PM10_DF = stations_df[stations_df$type_pollution == 'PM10',]
PM25_DF = stations_df[stations_df$type_pollution == 'PM2.5',]

#reading the actual data (available per day/hour) which we're converting to (non-spatial) dataframes per pollution for Spain over 2014
PM10_2014_day = read.csv("data/2014/DAYS/PM10_2014_DD.csv", header = TRUE, sep=";", stringsAsFactors=FALSE) 
colnames(PM10_2014_day) = PM10_data_names 
PM10_2014_day$copy_id = PM10_2014_day$point_id  

PM25_2014_day = read.csv("data/2014/DAYS/PM25_2014_DD.csv", header = TRUE, sep=";", stringsAsFactors=FALSE) 
colnames(PM25_2014_day) = PM25_data_names 
PM25_2014_day$copy_id = PM25_2014_day$point_id  

#creating matching ID's which we're going to use to join the non-spatial.dataframes to the SpatialPointDataFrames  
PM10_DF = create_matching_id_meta(PM10_DF)
PM10_2014_day = create_matching_id_pol(PM10_2014_day) 

PM25_DF = create_matching_id_meta(PM25_DF)  
PM25_2014_day = create_matching_id_pol(PM25_2014_day) 

#creating 24 PM10_x/PM25_x data.frames where x stands for the number of each month, this will be used to store the mean pollution over an entire month
for (i in order(unique(PM10_2014_day$month))){
  PM10_string = paste0("PM10_", months[i]) #or as.character[i]
  assign(PM10_string, filter_sp_day_month(PM10_2014_day, 0, i))
  PM25_string = paste0("PM25_", months[i])
  assign(PM25_string, filter_sp_day_month(PM25_2014_day, 0, i))
}

#listing the variables containing all the pollution data per month, we're using these lists for further computations
PM10_list = list(PM10_jan, PM10_feb, PM10_mar, PM10_apr, PM10_may, PM10_jun, PM10_jul, PM10_aug, PM10_sep, PM10_oct, PM10_nov, PM10_dec)
PM25_list = list(PM25_jan, PM25_feb, PM25_mar, PM25_apr, PM25_may, PM25_jun, PM25_jul, PM25_aug, PM25_sep, PM25_oct, PM25_nov, PM25_dec)
                 
#creates a mean attribute based on the pollution data in the 'days_x' columns
for (i in order(unique(PM10_2014_day$month))){
  PM10_list[[i]] = create_mean_attribute(PM10_list[[i]])
  PM25_list[[i]] = create_mean_attribute(PM25_list[[i]])
}

#merges the SpatialPointDataFrames (with the coordinates of the stations) with the pollution data
for (i in order(unique(PM10_2014_day$month))){
  PM10_list[[i]] = merge(PM10_DF, PM10_list[[i]][,c("mean", "copy_id")], by = 'copy_id',  incomparables = NULL, duplicateGeoms = TRUE)
  PM25_list[[i]] = merge(PM25_DF, PM25_list[[i]][,c("mean", "copy_id")], by = 'copy_id',  incomparables = NULL, duplicateGeoms = TRUE)
}

#removing the NA and NaN values which cannot be used for interpolation
for (i in order(unique(PM10_2014_day$month))){
  PM10_list[[i]] = subset(PM10_list[[i]], !is.na(PM10_list[[i]]$mean) & !is.nan(PM10_list[[i]]$mean))
  PM25_list[[i]] = subset(PM25_list[[i]], !is.na(PM25_list[[i]]$mean) & !is.nan(PM25_list[[i]]$mean))
}

#interpolating the pollution data with the locations of the stations in the form of a raster
for (i in order(unique(PM10_2014_day$month))){
  PM10_list[[i]] = interpolation_idw(PM10_list[[i]], barcelona)
  PM25_list[[i]] = interpolation_idw(PM25_list[[i]], barcelona)
}

#turning the previously made list (which now contains all the interpolated_rasters) into two RasterBricks
PM10_brick = brick(PM10_list)
PM25_brick = brick(PM25_list)

#saving these RasterBricks to two .tif files
writeRaster(PM10_brick,"Output/PM10_brick.tif", format="GTiff", overwrite = TRUE)
writeRaster(PM25_brick,"Output/PM25_brick.tif", format="GTiff", overwrite = TRUE)

#animating the RasterBricks so you can see the evolution of pollution in Barcelona, Catalonia
animate(PM10_brick, main = PM10_titles, col = rev(heat.colors(length(seq(0, 30, by = 1)))))
animate(PM25_brick, main = PM25_titles, col = rev(heat.colors(length(seq(0, 30, by = 1)))))

#saves these animations in two seperate .gifs (THIS WILL REQUIRE THE INSTALLATION OF 'ImageMagick', they'll also be provided in the output folder beforehand)
saveGIF(animate(PM10_brick, main = PM10_titles, col = rev(heat.colors(30))),movie.name = 'Output/pollution_PM10.gif',convert='convert',ani.width = 600,ani.height = 600)
saveGIF(animate(PM25_brick, main = PM25_titles, col = rev(heat.colors(30))),movie.name = 'Output/pollution_PM25.gif',convert='convert',ani.width = 600,ani.height = 600)
