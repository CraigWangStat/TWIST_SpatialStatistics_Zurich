# TWIST_SpatialStatistics_Zurich

A personalized dis-similarity measure with local residents in Kanton Zürich

## Data
For this project we combined two spacial data sets from the Canton of Zurich with raster tiles of resolution 100m x 100m. 

### The first data set contains population data

![Employment Visualization](https://raw.githubusercontent.com/CraigWangUZH/TWIST_SpatialStatistics_Zurich/master/Employees.png)

Available attributes are:

- total population
- population aged 0-6
- population aged 7-15
- population aged 16-19
- population aged 20-24
- population aged 25-44
- population aged 45-64
- population aged 65-79
- population aged 80 or over
- male population
- female population
- population with Swiss Citizenships
- population with Foreign Citizenships

### The second data set contains employment data

![Population Visualization](https://raw.githubusercontent.com/CraigWangUZH/TWIST_SpatialStatistics_Zurich/master/Population.png)

Available attributes are:

| Attribute name                        | Description | 
| -------------                         |-------------| 
| anz_vzae = Vollzeitäquivalente        | Total (fte) |
| anz_vzae_w = Vollzeitäquivalte Frauen | Total female (fte) |
| anz_besch = Anz. Beschäftigte	        | Nr. of people employed |
| anz_ast	= Anz. Betriebe               | Nr. of businesses  | 
| ht = High Tech                        | High Tech Industry (fte) |
| widl = wissensintensive Dienstl.      | Knowledge intensive services (fte) |
| handel                                | Trade and Commerce (fte) |
| finanz                                | Finance (fte) |
| freiedl = Freiberufl. Dienstl.        | Self-employed services (fte) |
| gewerbe                             	| Industry (fte) |
| gesundheit                            | Socaial and Healthcare (fte) |
| bau	                                  | Construction (fte) |
| sonstdl                               | Other Services (fte) |
| inform                                | Information technology (fte) |
| unterricht                            | Education (fte) |
| verkehr	                              | Traffic  and Logistics (fte) |
| uebrige                              	| Others (fte) |

fte = full time equivalent

## Idea
We want to help people who are moving to Zurich to find locations where people most similar to him/her live.

Second, the user might want to know what amenities there are in her/his future neighborhood. This is why, certain types of POI from Open Street Map can be displayed on the map.

## Method

### The R shiny UI
We created an R shiny interface where the user can input his profile.
Currently the following attributes are available:

- Age (enter number)
- Gender (choose m or f)
- Employment sector (chose from dropdown)

Further attributes that could be added in the future:

- Percentage working
- Number of children aged 0-6
- Number of children aged 7-15
- Number of children aged 16-19
- self-employed

![UI to inuput your profile](https://raw.githubusercontent.com/CraigWangUZH/TWIST_SpatialStatistics_Zurich/master/Preferences.png)

### Model
We first calculated the average numbers for the population (for age bands, gender and citizenship) and the average number of employments (per sector) in each cell. Then, we compared each cell to this average. For example, you then get to know that in a particular cell there are 151% more people aged 25-44 than in the average cell. Then, we took the percentile for this to get values from 0 to 100 for all the features.

To calculate the similarity of a profile to a cell's population and employment data, we multiply the percentile with the applicable profile features. With this we can calculate a score, how similar a person is to a certain cell's population and employees.

![Population Visualization](https://raw.githubusercontent.com/CraigWangUZH/TWIST_SpatialStatistics_Zurich/master/UI.png)

## Limitations
We are assuming that people work and live in the same location.


## Potential for further improvement
Add tickboxes that allow to show more POI on the map, e.g. restaurants, Kindergardens, parking lots. (At the moment only one type of POI can be displayed.)

Would be interesting to filter on you preferences for POI's around you, e.g. I'd like to have a Kindergarden in my Neighborhood.

Could be enriched with data form Mapnificientn (this app lets you find locations that can be reached within a specified time).









