library(shinydashboard)
library(shiny)
library(leaflet)
library(ggplot2)
library(maptools)
library(raster)
library(osmdata)
library(fmsb)
library(rgdal)
# server ------------------------------------------------------------------
load("./data/Criteria_per_Cell.RData")
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
  
  
  output$out_var_os <- renderUI({
    if (input$add_varos){
      selectInput("var_os", label = "Points of Interest",
                  choices = c("bar","kindergarten","pub","nightclub","cafe","restaurant","school","college",
                              "bus_station","parking","atm"), selected = "bars")} else {}
  })
  
  output$visplot <- renderLeaflet(leaflet() %>%
                                  addProviderTiles(providers$OpenStreetMap.CH) %>%
                                  setView(8.539685, 47.378030, zoom = 11))
                             
                             
  observe({
    user <- c(table(base::cut(input$var_age, breaks = c(-Inf, 6, 15, 19, 24, 44, 64, 79, Inf))), # age
              if(input$var_gen == "Male"){c(1,0)}else if(input$var_gen == "Female"){c(0,1)}else{c(0,0)}, # gender
              if(input$var_nat == "Swiss"){c(1,0)}else if(input$var_nat == "Foreign"){c(0,1)}else{c(0,0)}, # nat
              sapply(c("ht_per","widl_per","handel_per","finanz_per","freiedl_per",
                       "gewerbe_per","gesundheit_per","bau_per","sonstdl_per","inform_per",    
                       "unterricht_per","verkehr_per","uebrige_per"), function(x) x == input$var_work)) # work
    if(input$var_child){user[1:2] <- 0.5} 
    
    dat$score <- percentile(calc_score(dat[,3:27], as.vector(user)))
    
    coordinates(dat) <- ~ ha_x + ha_y
    # coerce to SpatialPixelsDataFrame
    gridded(dat) <- TRUE
    r <- raster(dat, layer=26)
    #define crs & projection, set to swiss projection
    crs(r) <- "+init=epsg:2056" 

    #transform to WGS84
    pop_layers2 <- projectRaster(r, crs="+init=epsg:4326 +proj=somerc +lat_0=46.95240555555556 +lon_0=7.439583333333333 +k_0=1 +x_0=2600000 +y_0=1200000 +ellps=bessel +units=m +no_defs")
    
    pal <-  colorNumeric("OrRd", pop_layers2@data@values, na.color = "transparent")
    
    leafletProxy("visplot") %>%
      clearShapes() %>%
      clearControls() %>%
      addRasterImage(pop_layers2, color = pal, layerId =  "score", opacity = 0.6) %>% 
      addLegend(pal = pal, values = pop_layers2@data@values,  title = "Score")
    
    if (input$add_varos){
      req(input$var_os)
      poi <- osmdata_sp(add_osm_feature(opq = opq(bbox = c(8.35768, 47.15944,8.984941,47.694472)), 
                                             key = 'amenity', value = input$var_os))$osm_points
      leafletProxy("visplot") %>%
        clearShapes() %>%
        clearControls() %>%
        addRasterImage(pop_layers2, color = pal, layerId =  "score", opacity = 0.6) %>% 
        addMarkers(lng = poi@coords[,1], lat = poi@coords[,2], icon = list(
          iconUrl = "https://image.flaticon.com/icons/svg/15/15520.svg", iconSize = c(20, 20))) %>%
        addLegend(pal = pal, values = pop_layers2@data@values,  title = "Score") 
    }
  })
}
