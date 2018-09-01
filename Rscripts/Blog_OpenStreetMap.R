library(pacman)

#load packages
pacman::p_load(tidyverse,rgdal,rgeos,tmaptools,raster)

#install & load dev-version of tmap
#devtools::install_github("mtennekes/tmap")
library(tmap)

# population data - values for raster-cells with population totals < 10 have been excluded
pop <- read.csv("https://www.web.statistik.zh.ch/twist/population_raster_ha.csv")

# employment data - values for raster-cells with a number of enterprises <= 3 have been excluded
empl <- read.csv("https://www.web.statistik.zh.ch/twist/empl_raster_ha.csv", sep=";")

# Population raster ---------

# create spatial points data frame
coordinates(pop) <- ~ GKODE_HEKTARMP + GKODN_HEKTARMP
# coerce to SpatialPixelsDataFrame
gridded(pop) <- TRUE

# plot(pop)

# Generate RasterBrick object containing all the layers
pop_layers <- brick(pop)

#define crs & projection, set to swiss projection
crs(pop_layers) <- "+init=epsg:2056" 

#transform to WGS84
pop_layers2 <- projectRaster(pop_layers, crs="+init=epsg:4326 +proj=somerc +lat_0=46.95240555555556 +lon_0=7.439583333333333 +k_0=1 +x_0=2600000 +y_0=1200000 +ellps=bessel +units=m +no_defs")

#plot the Layer "Population Totals"
# plot(pop_layers[["TOT"]])

#visualize raster

#configure tmap to display data as interactive leaflet map
tmap::tmap_mode("view")

#visualize population raster
tm_shape(pop_layers) +
  tm_raster("TOT", palette = "Greys", title = "Inhabitants per 100m2")

# Employment raster --------

coordinates(empl) <- ~ ha_x + ha_y

gridded(empl) <- TRUE

empl_layers <- raster(empl)

crs(empl_layers) <- "+init=epsg:2056" 

empl_layers <- projectRaster(empl_layers, crs="+init=epsg:4326 +proj=somerc +lat_0=46.95240555555556 +lon_0=7.439583333333333 +k_0=1 +x_0=2600000 +y_0=1200000 +ellps=bessel +units=m +no_defs")

tm_shape(empl_layers) +
  tm_raster(palette = "Oranges", title = "Employees per 100m2")

pacman::p_load(units,sf,osmdata)

# -----------------------------------------------------

#install tmap for visualization purpouses
#devtools::install_github("mtennekes/tmap")

#get BoundingBox of the canton of Zurich
#getbb("Kanton Zürich")

q0 <- opq(bbox = c(8.35768, 47.15944,8.984941,47.694472))

# extract   boundaries of the Canton of Zurich via wikidati URI
q1 <- add_osm_feature(opq = q0, key = 'wikidata', value = "Q11943")
# retrieve the data
res1 <- osmdata_sf(q1)
#get geometry
zh <- st_geometry(res1$osm_multipolygons)

# extract Bars & Pubs
q6 <- add_osm_feature(opq = q0, key = 'amenity', value = "bar")
bars <- osmdata_sf(q6)
bars_zh<- st_geometry(bars$osm_points)

# plot the bars in the canton of Zurich
tmap::tmap_mode("view")
tmap::qtm(bars_zh)

# -----------------------------------------------------

