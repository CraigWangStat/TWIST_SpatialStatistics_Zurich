library(shinydashboard)
library(shiny)
library(leaflet)
library(ggplot2)

load("./data/Criteria_per_Cell.RData")
# Define UI for application that draws a histogram
dashboardPage(
  dashboardHeader(
    title = "Dive into Zurich",
    tags$li(a(h4("Thanks to:"),
              style = "padding-top:5px; padding-bottom:5px;"),
            class = "dropdown"),
    tags$li(a(href = "https://hack.twist2018.ch/project/2", img(src = 'logo.png',
                  title = "Data Source", height = "30px"),
              style = "padding-top:10px; padding-bottom:10px;"),
            class = "dropdown")
  ),
  
  dashboardSidebar(disable = TRUE),
  
  dashboardBody(
              h4("Where should you live in canton Zurich?"),
              h4("Do you want to live in an area where the inhabitants are similar (or maybe dissimilar) to you? With this app, you can find these areas!"),
              fluidRow(
                column(width = 4,
                       numericInput("var_age", "Age", min = 1, max = 100, value=40, step = 1),
                       checkboxInput("var_child", "Do you have children?", value = FALSE),
                       selectInput("var_gen", label = "Gender", choices = c("","Female","Male"), selected = ""),
                       selectInput("var_nat", label = "Nationality", 
                                   choices = c("","Swiss","Foreign"), selected = ""),
                       selectInput("var_work", label = "Working Sector", 
                                   choices = c("",colnames(dat)[15:25]), selected = ""),
                       checkboxInput("add_varos","Add points of interest", value = FALSE),
                       uiOutput("out_var_os"),
                       actionButton("contact"," Contact Us", icon = icon("address-card"), 
                                    class = "btn-primary",style = "color: white;",
                                    onclick ="window.open('https://hack.twist2018.ch/project/18', '_blank')"),
                       actionButton("help"," Help", icon = icon("info-circle"), 
                                    class = "btn-primary",style = "color: white;"),
                       div(style="display:inline-block;width:32%;text-align: center;",
                           actionButton("reset"," Reset", icon = icon("power-off"), 
                                        class = "btn-warning",style = "color: white;")),
                       br(),br(),
                       img(src = 'group.JPG',title = "Group Photo", height = "180px")
                ),
                column(width = 8,
                       leafletOutput("visplot", width = "80%", height = 600)
                )
              )
  )
)

