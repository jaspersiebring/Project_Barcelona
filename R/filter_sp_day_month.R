#Team Monty (Jasper Siebring & Yingbao Sun)

#Project Pollution - Barcelona, Catalonia
#1 for day, 0 for month

filter_sp_day_month = function(df, day_month_1_0, x){
  if (day_month_1_0 == 0){
    df = df[df[['month']] == x,]
    }
  if (day_month_1_0 == 1){
    df = df[df[['day']] == x,]
  }
return (df)
} 
