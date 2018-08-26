library(pacman)

#load packages
pacman::p_load(tidyverse,rgdal,rgeos,tmaptools,raster)

#install & load dev-version of tmap
devtools::install_github("mtennekes/tmap")
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
  tm_raster("TOT", palette = "Oranges", title = "Inhabitants per 100m2")
