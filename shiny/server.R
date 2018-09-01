library(shinydashboard)
library(leaflet)
library(rgdal)
library(fmsb)

# server ------------------------------------------------------------------
load("./data/Criteria_per_Cell.RData")
load("./data/score_layer.RData") # project raster layer
load("./data/osm_data.RData") # OSM data
source("helpers.R")

# Define server logic required to draw a histogram
function(input, output, session) {
  observeEvent(input$help, {
    showModal(modalDialog(
      title = "How to use the app:",
      p("Construct your profile by setting a value for one or several criteria of interest. We then compute a score and display it on a map of the canton of Zurich. A higher score indicates the areas in canton Zurich that most correspond to your profile."),
      p("For instance, if you pick the factors 'Swiss' and 'Age 0-6', we will highlight on a map of canton Zurich the areas where the percentage of the inhabitants that are Swiss and are aged between 0 and 6 is higher than in the rest of the canton. Those are the areas where you might want to live!"),
      easyClose = TRUE,
      footer = NULL
    ))
  })
  
  observeEvent(input$reset, {
    updateSelectInput(session, "var_gen", selected = "")
    updateSelectInput(session, "var_nat", selected = "")
    updateSelectInput(session, "var_work", selected = "")
    updateCheckboxInput(session, "add_varos", value = FALSE)
    updateCheckboxInput(session, "var_child", value = FALSE)
    updateNumericInput(session, "var_age", value = 40)
  })
  
  output$out_var_os <- renderUI({
    if (input$add_varos){
      selectInput("var_os", label = "Points of Interest",
                  choices = c("bar","kindergarten","nightclub","cafe","library","vending_machine",
                              "restaurant","theatre","car_sharing","atm"), selected = "bar")} else {}
  })
  
  output$visplot <- renderLeaflet(leaflet() %>%
                                  addProviderTiles(providers$OpenStreetMap.CH) %>%
                                  setView(8.597183, 47.424681, zoom = 11))
                             
  observe({
    user <- c(table(base::cut(input$var_age, breaks = c(-Inf, 6, 15, 19, 24, 44, 64, 79, Inf))), # age
              if(input$var_gen == "Male"){c(1,0)}else if(input$var_gen == "Female"){c(0,1)}else{c(0,0)}, # gender
              if(input$var_nat == "Swiss"){c(1,0)}else if(input$var_nat == "Foreign"){c(0,1)}else{c(0,0)}, # nat
              sapply(c("ht_per","widl_per","handel_per","finanz_per","freiedl_per",
                       "gewerbe_per","gesundheit_per","bau_per","sonstdl_per","inform_per",    
                       "unterricht_per","verkehr_per","uebrige_per"), function(x) x == input$var_work)) # work
    if(input$var_child){user[1:2] <- 0.5} # child
    
    score <- percentile(calc_score(dat[,3:27], as.vector(user))) # compute score
    score_layer@data@values <- score[score_layer@data@values] # assign scores to raster
    pal <-  colorNumeric("OrRd", score_layer@data@values, na.color = "transparent") # get colors
    
    if (input$add_varos == FALSE){
      leafletProxy("visplot") %>%
        clearShapes() %>% clearControls() %>% clearMarkers() %>%
        addRasterImage(score_layer, color = pal, layerId =  "score", opacity = 0.6) %>% 
        addLegend(pal = pal, values = score_layer@data@values,  title = "Score")
    } else {
      req(input$var_os)
     
      osm_idx <- which(sapply(c("bar","kindergarten","nightclub","cafe","library","vending_machine",
                                "restaurant","theatre","car_sharing","atm"), function(x) x == input$var_os))
      
      leafletProxy("visplot") %>%
        clearShapes() %>% clearControls() %>% clearMarkers() %>%
        addRasterImage(score_layer, color = pal, layerId =  "score", opacity = 0.6) %>% 
        addMarkers(lng = osm_lists[[osm_idx]]@coords[,1], lat = osm_lists[[osm_idx]]@coords[,2], icon = list(
          iconUrl = "https://image.flaticon.com/icons/svg/15/15520.svg", iconSize = c(15, 15))) %>%
        addLegend(pal = pal, values = score_layer@data@values,  title = "Score") 
    }
  })
}
