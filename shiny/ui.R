library(shinydashboard)
library(shiny)
library(leaflet)
library(rgdal)
library(ggplot2)
load("data.RData")
# Define UI for application that draws a histogram
dashboardPage(
  dashboardHeader(
    title = "Decision Tool"
  ),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Visualization", tabName = "vis", icon = icon("dashboard")),
      menuItem("Decision tool", icon = icon("th"), tabName = "widgets",
               badgeLabel = "click me!", badgeColor = "green")
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "vis",
              h2("Dashboard tab content"),
              fluidRow(
                column(width = 4,
                       selectInput("var_pop", label = "Variables", 
                                   choices = colnames(pop@data)[3:16],selected = "TOT"),
                       selectInput("var_os", label = "Points of Interest",
                                   choices = c("bar","kindergarten"), selected = "bars"),
                       sliderInput("cri", "Criteria1", min = 0, max = 10, value=5, step = 1, 
                                   sep = "", animate = FALSE),
                       sliderInput("cri", "Criteria1", min = 0, max = 10, value=5, step = 1, 
                                   sep = "", animate = FALSE),
                       actionButton("contact"," Contact Programmer", icon = icon("address-card"), 
                                    class = "btn-primary",style = "color: white;",
                                    onclick ="window.open('https://craigwanguzh.github.io', '_blank')")
                ),
                column(width = 8,
                       leafletOutput("visplot", width = "80%", height = 600)
                )
              )
      ),
      
      tabItem(tabName = "widgets",
              h2("Widgets tab content"),
              # Sidebar with a slider input for number of bins 
              fluidRow(
                column(width = 4,
                       sliderInput("cri", "Criteria1", min = 0, max = 10, value=5, step = 1, 
                                   sep = "", animate = FALSE),
                       sliderInput("cri", "Criteria1", min = 0, max = 10, value=5, step = 1, 
                                   sep = "", animate = FALSE),
                       sliderInput("cri", "Criteria1", min = 0, max = 10, value=5, step = 1, 
                                   sep = "", animate = FALSE),
                       actionButton("contact"," Contact Programmer", icon = icon("address-card"), 
                                    class = "btn-primary",style = "color: white;",
                                    onclick ="window.open('https://craigwanguzh.github.io', '_blank')")
                ),
                column(width = 8,
                       leafletOutput("mymap", width = "80%", height = 600)
                )
              )
              
      )
    )
  )
)

