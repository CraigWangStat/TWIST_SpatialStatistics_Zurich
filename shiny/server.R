library(shinydashboard)
library(shiny)
library(leaflet)
library(ggplot2)
library(maptools)
library(tmap)
library(tmaptools)
library(raster)
library(osmdata)
library(sf)
library(fmsb)
# server ------------------------------------------------------------------
load("./data/Criteria_per_Cell.RData")
source("helpers.R")

# Define server logic required to draw a histogram
function(input, output, session) {
  
  output$out_var_os <- renderUI({
    if (input$add_varos){
      selectInput("var_os", label = "Points of Interest",
                  choices = c("bar","kindergarten","pub","nightclub","cafe","restaurant","school","college",
                              "bus_station","parking","atm"), selected = "bars")} else {}
  })
    output$visplot <- renderLeaflet({
    user <- c(table(base::cut(input$var_age, breaks = c(-Inf, 6, 15, 19, 24, 44, 64, 79, Inf))), # age
              if(input$var_gen == "Male"){c(1,0)}else if(input$var_gen == "Female"){c(0,1)}else{c(0,0)}, # gender
              if(input$var_nat == "Swiss"){c(1,0)}else if(input$var_nat == "Foreign"){c(0,1)}else{c(0,0)}, # nat
              sapply(c("ht_per","widl_per","handel_per","finanz_per","freiedl_per",
                       "gewerbe_per","gesundheit_per","bau_per","sonstdl_per","inform_per",    
                       "unterricht_per","verkehr_per","uebrige_per"), function(x) x == input$var_work)) # work
    
    dat$score <- percentile(calc_score(dat[,3:27], as.vector(user)))
    coordinates(dat) <- ~ ha_x + ha_y
    # coerce to SpatialPixelsDataFrame
    gridded(dat) <- TRUE
    
    # plot(pop)
    # Generate RasterBrick object containing all the layers
    pop_layers <- brick(dat)
    
    #define crs & projection, set to swiss projection
    crs(pop_layers) <- "+init=epsg:2056" 
    
    #transform to WGS84
    pop_layers2 <- projectRaster(pop_layers, crs="+init=epsg:4326 +proj=somerc +lat_0=46.95240555555556 +lon_0=7.439583333333333 +k_0=1 +x_0=2600000 +y_0=1200000 +ellps=bessel +units=m +no_defs")
    
    tm <- tm_shape(pop_layers2) +
      tm_raster("score", palette = "Oranges", title = "Score", style = "fixed", breaks = seq(0,100,by = 10), alpha = 0.6) 
    if (input$add_varos){
      req(input$var_os)
      tm <- tm + qtm(st_geometry(osmdata_sf(add_osm_feature(opq = opq(bbox = c(8.35768, 47.15944,8.984941,47.694472)), key = 'amenity', value = input$var_os))$osm_points),
                     symbols.size = 0.025)
    } 
      tmap_leaflet(tm) 
      
  })
  
  
  output$mymap <- renderLeaflet({
    tm <- tm_shape(pop_layers) +
      tm_raster("TOT", palette = "Greys", title = "Inhabitants per 100m2")
    tmap_leaflet(tm)
  })
  
}
