library(shinydashboard)
library(shiny)
library(leaflet)
library(rgdal)
library(ggplot2)
library(maptools)
library(tmap)
library(tmaptools)
library(raster)
library(osmdata)
library(sf)
# prepare data ------------------------------------------------------------

# options(encoding = "UTF-8")
# map0 <- spTransform(readOGR("./data/GEN_A4_GEMEINDEN_SEEN_2018_F.shp", encoding = "UTF-8", verbose=TRUE),
#                     CRS("+proj=longlat"))
# pop <- read.csv("population_raster_ha.csv")
# emp <- read.csv("empl_raster_ha.csv", sep = ";")
# save.image("data.RData")
# server ------------------------------------------------------------------
load("data.RData")
source("helpers.R")

# Define server logic required to draw a histogram
function(input, output, session) {
  output$visplot <- renderLeaflet({
    tm <- tm_shape(pop_layers) +
      tm_raster(input$var_pop, palette = "Spectral", title = "Inhabitants per 100m2", n = 10) + qtm(st_geometry(osmdata_sf(add_osm_feature(opq = opq(bbox = c(8.35768, 47.15944,8.984941,47.694472)), key = 'amenity', value = input$var_os))$osm_points))
    tmap_leaflet(tm) 
      
  })
  
  
  output$mymap <- renderLeaflet({
    tm <- tm_shape(pop_layers) +
      tm_raster("TOT", palette = "Greys", title = "Inhabitants per 100m2")
    tmap_leaflet(tm)
  })
  
}
