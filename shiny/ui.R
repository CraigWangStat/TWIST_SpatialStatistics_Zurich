library(shinydashboard)
library(shiny)
library(leaflet)
library(ggplot2)
load("./data/Criteria_per_Cell.RData")
# Define UI for application that draws a histogram
dashboardPage(
  dashboardHeader(
    title = "Dive into Kanton Zurich",
    tags$li(a(h4("Thanks to data Source:"),
              style = "padding-top:5px; padding-bottom:5px;"),
            class = "dropdown"),
    tags$li(a(href = "https://hack.twist2018.ch/project/2", img(src = 'logo.png',
                  title = "Data Source", height = "30px"),
              style = "padding-top:10px; padding-bottom:10px;"),
            class = "dropdown")
  ),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Application", tabName = "vis", icon = icon("dashboard")),
      menuItem("Future", icon = icon("th"), tabName = "widgets",
               badgeLabel = "Don't hit me", badgeColor = "green")
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "vis",
              h2("Input your preference/profile"),
              fluidRow(
                column(width = 4,
                       numericInput("var_age", "Age", min = 1, max = 100, value=30, step = 1),
                       selectInput("var_gen", label = "Gender", choices = c("Female","Male"," "), selected = " "),
                       selectInput("var_nat", label = "Nationality", 
                                   choices = c("Swiss","Foreign"," "), selected = " "),
                       selectInput("var_work", label = "Working Section", 
                                   choices = c(colnames(dat)[15:25], " "), selected = " "),
                       checkboxInput("add_varos","Add points of interest", value = FALSE),
                       uiOutput("out_var_os"),
                       actionButton("contact"," Contact Us", icon = icon("address-card"), 
                                    class = "btn-primary",style = "color: white;",
                                    onclick ="window.open('https://hack.twist2018.ch/project/18', '_blank')")
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

