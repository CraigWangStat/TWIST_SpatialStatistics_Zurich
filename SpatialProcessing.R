library(maptools)
library(raster)
library(leaflet)
library(rgdal)
load("./data/Criteria_per_Cell.RData")

# Preparing raster --------------------------------------------------------

dat$score <- 1:nrow(dat)
coordinates(dat) <- ~ ha_x + ha_y
crs(dat) <- "+init=epsg:2056"
# coerce to SpatialPixelsDataFrame
gridded(dat) <- TRUE
r <- raster(dat, layer=26)
#define crs & projection, set to swiss projection    
score_layer <- projectRaster(r, crs="+init=epsg:4326 +proj=somerc +lat_0=46.95240555555556 +lon_0=7.439583333333333 +k_0=1 +x_0=2600000 +y_0=1200000 +ellps=bessel +units=m +no_defs",
                             method = "ngb")
save(score_layer, file = "score_layer.RData")

# testing
score_layer@data@values <- dat@data$J_20_24_per[(score_layer@data@values)]
pal <-  colorNumeric("OrRd", score_layer@data@values, na.color = "transparent")

leaflet() %>%
  addProviderTiles(providers$OpenStreetMap.CH) %>%
  setView(8.539685, 47.378030, zoom = 11) %>%
addRasterImage(score_layer,  color = pal, layerId =  "score", opacity = 0.6) %>%
  addLegend(pal = pal, values = score_layer@data@values,  title = "Score") 


# Preparing OSM data ------------------------------------------------------

osm_category <- c("bar","kindergarten","nightclub","cafe","library","vending_machine",
                  "restaurant","theatre","car_sharing","atm")
osm_lists <- list()
for (i in 1:length(osm_category)){
  osm_lists[[i]] <-osmdata_sp(add_osm_feature(opq = opq(bbox = c(8.35768, 47.15944,8.984941,47.694472)),
                                              key = 'amenity', value = osm_category[i]))$osm_points
}

save(osm_lists, file = "osm_data.RData")

leaflet() %>%
  addProviderTiles(providers$OpenStreetMap.CH) %>%
  setView(8.539685, 47.378030, zoom = 11) %>%
  addMarkers(lng = osm_lists[[1]]@coords[,1], lat = osm_lists[[1]]@coords[,2]) 
