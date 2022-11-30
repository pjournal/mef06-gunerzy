#Data preprocessing for shiny app assignment
library(tidyverse)
library(readxl)

#Read excel
data_foreign_st <- read_excel("foreign_students_by_nationality_2021_2022.xlsx")

#Rename columns
column_names <- data_foreign_st %>% colnames() %>% gsub(" ","_", .)
colnames(data_foreign_st) <- chartr("Ü ü ı İ","U u i I",column_names)

#Last line is the total values of the columns, exclude that
#data_foreign_st %>% slice_tail(n=5)
data_foreign_st <- data_foreign_st %>% head(-1)

#Find and drop NA values, in this case there is no NA value
#colSums(is.na(data_foreign_st))

#Convert the numeric values to integer format
data_foreign_st <- type.convert(data_foreign_st, as.is=TRUE)

#data_foreign_st %>% glimpse

#Convert to rds format
saveRDS(data_foreign_st, "Shiny app assignment/foreign_students_shiny_app/data_foreign_students.rds")
