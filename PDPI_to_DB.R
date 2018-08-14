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

# this file contains the location of each PDPI file which are in .RData format 
PDPI_file_list = read.csv("/home/sahil/Documents/code/masters_thesis/PDPI_locations.csv", 
                          header =T, stringsAsFactors = F)
# PDPI_file_list = as.list(PDPI_file_list)
head(PDPI_file_list)
nrow(PDPI_file_list) # 87 rows - pick last 2 year's rows only
PDPI_file_list = PDPI_file_list[c(63:87), c(1,2)]
head(PDPI_file_list)
nrow(PDPI_file_list)

# open each file and convert it to csv
for (f in seq(1, nrow(PDPI_file_list))){
# for (f in seq(1, 3)){
  
  print(f)
  file_location = PDPI_file_list[f, 1]
  table_name = PDPI_file_list[f, 2]
  print(file_location)
  print(table_name)
  
  # load the .RData file  
  load(file_location)
  
  # save it as CSV
  save_csv_name = paste("/home/sahil/Documents/code/masters_thesis/Prescribing Data/PDPI_CSV/", table_name, ".csv", sep="")
  print(save_csv_name)
  
  
  df = PDPI
  
  # drop specific columns
  head(df)
  names(df)
  drops <- c("", "X.1", "X") # these column names to drop
  df = df[ , !(names(df) %in% drops)]
  head(df)
  
  # convert column names to lower case
  old_col_names = names(df)
  old_col_names
  new_col_names = as.list(tolower(old_col_names))
  new_col_names
  
  # replace "." in column names with _
  new_col_names = gsub("[.]", "_", new_col_names)
  new_col_names
  names(df) = new_col_names
  
  print(names(df))
  
  write.csv(df, save_csv_name)
  # 
  # # save to database
  # # query returns true if successful
  print(dbWriteTable(con, table_name, df, row.names=F, overwrite = TRUE))
  
  rm(df)
  rm(PDPI)
  
}





