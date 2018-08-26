library(shinydashboard)
library(shiny)
library(leaflet)
library(ggplot2)

load("./data/Criteria_per_Cell.RData")
# Define UI for application that draws a histogram
dashboardPage(
  dashboardHeader(
    title = "Dive into Zurich",
    tags$li(a(h4("Thanks to data Source:"),
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
                       numericInput("var_age", "Age", min = 1, max = 100, value=30, step = 1),
                       checkboxInput("var_child", "Do you have children?", value = FALSE),
                       selectInput("var_gen", label = "Gender", choices = c("Female","Male"," "), selected = " "),
                       selectInput("var_nat", label = "Nationality", 
                                   choices = c("Swiss","Foreign"," "), selected = " "),
                       selectInput("var_work", label = "Working Section", 
                                   choices = c(colnames(dat)[15:25], " "), selected = " "),
                       checkboxInput("add_varos","Add points of interest", value = FALSE),
                       uiOutput("out_var_os"),
                       p("How to use the app:
Construct your profile by setting a value for one or several criteria of interest. We then compute a score and display it on a map of the canton of Zurich. A higher score indicates the areas in canton Zurich that most correspond to your profile."),
                       p("For instance, if you pick the factors 'Swiss' and 'Age 0-6', we will highlight on a map of canton Zurich the areas where the percentage of the inhabitants that are Swiss and are aged between 0 and 6 is higher than in the rest of the canton. Those are the areas where you might want to live!"),
                       p(" "),
                       actionButton("contact"," Contact Us", icon = icon("address-card"), 
                                    class = "btn-primary",style = "color: white;",
                                    onclick ="window.open('https://hack.twist2018.ch/project/18', '_blank')")
                ),
                column(width = 8,
                       leafletOutput("visplot", width = "80%", height = 600)
                )
              )
  )
)

