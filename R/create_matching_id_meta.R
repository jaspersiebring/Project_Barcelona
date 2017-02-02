#Team Monty (Jasper Siebring & Yingbao Sun)
#30th January, 2017

#Project Pollution
#first adds a zero to meta_data if under 8 digits

create_matching_id_meta = function(meta_df){
  for (i in seq_along(meta_df[['copy_id']])){
    if(nchar(meta_df[['copy_id']][i]) == 7){
      meta_df[['copy_id']][i] = paste0("0", as.character(meta_df[['copy_id']][i]))
    }
  }
  return (meta_df)
}
  
