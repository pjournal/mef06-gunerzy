#install.packages("cranlogs") # install package if not installed
#data_cranlogs <- cranlogs::cran_downloads(
 # packages=c("tidyverse","shiny","rmarkdown","reticulate"),
  # from="2022-11-01",to="2022-11-30")

#data_cranlogs %>% group_by(package) %>% summarise(sum(count))

#ggplot(data_cranlogs ,aes(x=date,y=count,color=package)) + geom_line()

library(readxl)
library(tidyverse)

saveRDS(read_excel("Airport_data.xlsx"), "C:/Users/zyagm/R/mef06-gunerzy/Airport_data.rds")
airport_data_org <- readRDS("Airport_data.rds")

airport_data <- airport_data_org %>% mutate (commercial_landing_takeoff = Landings_Takeoffs_Total - Other)
airport_data <- airport_data %>% mutate(airport_effc =ifelse(Passengers_Total > 0 | commercial_landing_takeoff > 0, Passengers_Total/commercial_landing_takeoff, 0))
#view(airport_data)

airport_data_ready <- airport_data %>% 
  group_by(IBBS_Detail) %>% 
    filter(IBBS_Detail!="Türkiye") %>% 
      mutate(count=n()) %>% 
        mutate(airport_total_effc = sum(airport_effc/count))



airport_data <- airport_data %>% 
  group_by(IBBS_Detail) %>% 
  filter(IBBS_Detail!="Türkiye") %>% 
  mutate(count=n()) %>% 
  summarise(airport_total_effc = sum(airport_effc/count))

airport_data_desc <- airport_data %>%  arrange(desc(airport_total_effc))


airport_data_desc<-airport_data_desc %>% slice(1:5)

airport_data_asc <- airport_data %>% arrange(airport_total_effc)


 airport_data_asc<- airport_data_asc %>% slice(1:6) #Since there are no commercial flights for Aydın, we consider the other airports.
airport_data_graph<-bind_rows(airport_data_desc,airport_data_asc)

airport_data_graph<-airport_data_graph%>%
  filter(airport_total_effc>0)

graph<-airport_data_graph%>%
  ggplot(aes(x=IBBS_Detail,y=airport_total_effc, fill=IBBS_Detail)) + 
  geom_bar(stat='identity', position='dodge') +
  xlab("Airport Name") +
  ylab("Efficiency")

graph



