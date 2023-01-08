library(scales)
library(tidyverse)

sector_data_org <- read_rds("Group_Project_Data/sector_information.rds")
head(sector_data)

sector_data <- sector_data_org %>%
  filter(number == 'Number_of_employees') %>%
    filter(size != 'Total') %>%
      group_by(size, year) %>%
        summarise(value=sum(value))


ggplot(sector_data ,aes(x=year,y=value,color=size, group=size)) + geom_line() + scale_y_continuous(labels = comma)


sector_data_2 <- sector_data_org %>%
  filter(number == 'Number_of_companies') %>%
  filter(size != 'Total') %>%
  group_by(size, year) %>%
  summarise(value=sum(value))


ggplot(sector_data_2 ,aes(x=year,y=value,color=size, group=size)) + geom_line() + scale_y_continuous(labels = comma)


