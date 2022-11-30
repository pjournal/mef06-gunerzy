#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(ggplot2)
foreign_students_data <- readRDS(file='data_foreign_students.rds')
#foreign_students_data %>% glimpse

uni_name <- foreign_students_data %>% 
  distinct(Universite_Adi)
#uni_name %>% print(n=Inf)

uni_type <- foreign_students_data %>% 
  distinct(Universite_Turu)
#uni_type %>% print(n=Inf)

province <- foreign_students_data %>% 
  arrange(Il_Adi) %>%
  distinct(Il_Adi)
#province %>% print(n=Inf)


# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Foreign Students by Nationality"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("Il_Adi","Province",choices = c("All",province),multiple=TRUE),
      
      selectInput("Universite_Turu","University Type",choices = c("All", uni_type) ,multiple=TRUE)
      
      
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("foreign_st_chart")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output,session) {
  
  output$foreign_st_chart <- renderPlot({
    chart_data <- foreign_students_data %>% group_by(Uyruk) %>% 
      summarise(T=sum(T)) %>% 
      slice_max(T,n=5)
    
    if(!("All" %in% input$Il_Adi)&!("All" %in% input$Universite_Turu) ){
    chart_data <- foreign_students_data %>% 
     filter(Il_Adi %in% input$Il_Adi) %>% 
     filter(Universite_Turu %in% input$Universite_Turu) %>% 
      group_by(Uyruk) %>% 
      summarise(T=sum(T)) %>% 
      slice_max(T,n=5)}
    
    if(!("All" %in% input$Il_Adi)){
      chart_data <- foreign_students_data %>% 
        filter(Il_Adi %in% input$Il_Adi) %>% 
        group_by(Uyruk) %>% 
        summarise(T=sum(T)) %>% 
        slice_max(T,n=5)}
    
    if(!("All" %in% input$Universite_Turu)){
      chart_data <- foreign_students_data %>% 
        filter(Universite_Turu %in% input$Universite_Turu) %>%  
        group_by(Uyruk) %>% 
        summarise(T=sum(T)) %>%
        slice_max(T,n=5)}
    
    chart_data <- chart_data %>% rename(total_student=T) %>%
      rename(nationality=Uyruk)

    ggplot(chart_data,aes(x=nationality,y=total_student, color=nationality, fill=nationality)) + geom_bar(stat = "identity")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)



