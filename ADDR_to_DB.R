rm(list = ls())

# install.packages("RPostgreSQL")
library(RPostgreSQL)

# create a connection
# save the password that we can "hide" it as best as we can by collapsing it
pw <- {
  "zxcvbnm"
}

# loads the PostgreSQL driver
drv <- dbDriver("PostgreSQL")
# creates a connection to the postgres database
# note that "con" will be used later in each connection to the database
con <- dbConnect(drv, dbname = "postgres",
                 host = "localhost", port = 5432,
                 user = "sahil", password = pw)
rm(pw) # removes the password

# this file contains the location of each ADDR file which are in .RData format 
ADDR_file_list = read.csv("/home/sahil/Documents/code/masters_thesis/ADDR_locations.csv", 
                          header =T, stringsAsFactors = F)
# ADDR_file_list = as.list(ADDR_file_list)
head(ADDR_file_list)
nrow(ADDR_file_list) # 87 rows - pick last 2 year's rows only
# ADDR_file_list = ADDR_file_list[c(62:87), c(1,2)]
head(ADDR_file_list)
nrow(ADDR_file_list)

# open each file and convert it to csv
for (f in seq(1, nrow(ADDR_file_list))){
# for (f in seq(1, 2)){
  
  print(f)
  file_location = ADDR_file_list[f, 1]
  table_name = ADDR_file_list[f, 2]
  print(file_location)
  print(table_name)
  
  # load the .RData file  
  load(file_location)
  
  # save it as CSV
  save_csv_name = paste("/home/sahil/Documents/code/masters_thesis/Prescribing Data/ADDR_CSV/", table_name, ".csv", sep="")
  print(save_csv_name)
  
  
  df = ADDR
  
  # drop specific columns
  head(df)
  names(df) = c("period", "practice", "add1", "add2", "add3", "add4", "add5", "postcode")
  
  head(df)
  
  # convert column names to lower case
  old_col_names = names(df)
  old_col_names
  new_col_names = as.list(tolower(old_col_names))
  new_col_names

  
  print(names(df))
  
  write.csv(df, save_csv_name)
  # # 
  # # # save to database
  # # # query returns true if successful
  print(dbWriteTable(con, table_name, df, row.names=F, overwrite = TRUE))
  # 
  rm(df)
  rm(ADDR)
  
}





