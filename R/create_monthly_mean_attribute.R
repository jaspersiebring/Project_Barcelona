#Team Monty (Jasper Siebring & Yingbao Sun)

#Project Pollution

a = PM25_2014_day
b = a

for (i in order(unique(b$month))){
  month_string = paste0("mean_", as.character(i))
  b[[month_string]] = 0
}

x = b[,71:82]
list_mean = names(x)

b$mean_test = rowMeans(subset(temp_df, select = c('day_1', 'day_2', 'day_3', 'day_4', 'day_5', 'day_6', 'day_7', 'day_8', 'day_9', 'day_10', 'day_11', 'day_12', 'day_13', 'day_14', 'day_15', 'day_16', 'day_17', 'day_18', 'day_19', 'day_20', 'day_21', 'day_22', 'day_23', 'day_24', 'day_25', 'day_26', 'day_27', 'day_28', 'day_29', 'day_30', 'day_31')), na.rm = TRUE) = subset(b, copy_id = '03065007' & month = 1)  
dataFrame$newColumn <- dataFrame$oldColumn1 +



for (i in order(unique(sp_dataframe[['copy_id']]))){
  #starts with lowest copy_id and works its way up
  #i = 03065007 for example
  #with a differnt month
  #temp_df = sp_dataframe[sp_dataframe[['copy_id']] == i,]
  
  for (j in order(list_mean)){
    
    
    temp_df = subset(sp_dataframe, copy_id = i & month = j) 
    temp_df[[month_string]] = rowMeans(subset(temp_df, select = c('day_1', 'day_2', 'day_3', 'day_4', 'day_5', 'day_6', 'day_7', 'day_8', 'day_9', 'day_10', 'day_11', 'day_12', 'day_13', 'day_14', 'day_15', 'day_16', 'day_17', 'day_18', 'day_19', 'day_20', 'day_21', 'day_22', 'day_23', 'day_24', 'day_25', 'day_26', 'day_27', 'day_28', 'day_29', 'day_30', 'day_31')), na.rm = TRUE)
    
    sp_dataframe[[month_string]] = mean_month
    
    sp_dataframe[sp_dataframe[['copy_id']] == i,] 
  }
  
  temp_df = subset(sp_dataframe, copy_id = i)
  
  temp_df = sp_dataframe[sp_dataframe[['copy_id']] == i,]
  temp_df = subset(sp_dataframe, select = )
  temp_df$
    #maybe two arguments? both month and id
    


    
    
    





sp_dataframe = b
for (i in order(sp_dataframe[['month']])){
  month_string = paste0("mean_", as.character(i))
  sp_dataframe[[month_string]] = 0
}

sp_dataframe$mean_monthly = 0

#calculates and creates a mean_1, mean_2 (mean_x per month) for the mean pollution per 
create_monthly_mean_attribute = function(sp_dataframe){
#for each point there are 12 months
#dont make a selection
#first make the attribute, then fill them in them nested loop
  
  
  PM25_2014_day[PM25_2014_day$copy_id == '03065007',]  
  
  sp_dataframe = b
  
                  
  
                  
                  

  
    
    
    sp_dataframe[[temp]] = round(mean_month*10000)
  }
  return (sp_dataframe)
}


#PM25_2014_day has 1215 rows
#sp_dataframe has 100 (1 = january)
# maybe no selection of the sp_dataframe?

