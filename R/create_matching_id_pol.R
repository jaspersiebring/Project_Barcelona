#Team Monty (Jasper Siebring & Yingbao Sun)
#30th January, 2017

#Project Pollution

#removes every value after the '_' character
create_matching_id_pol = function(pol_df){
  for (i in seq_along(pol_df[['copy_id']])){
    pol_df[['copy_id']][i] = unlist(strsplit(pol_df[['copy_id']][i], split='_', fixed = TRUE))[1]
    }
  return (pol_df)
}
