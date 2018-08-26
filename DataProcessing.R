
# Load and shape the data. 
# Output is a dataframe to be used in the shiny app

library(tidyverse) 


pop <- read.csv("data/population_raster_ha.csv")
empl <- read.csv("data/empl_raster_ha.csv", sep=";")

pop <- pop %>% mutate(ha_x = GKODE_HEKTARMP, ha_y = GKODN_HEKTARMP)
data <- full_join(pop, empl)

# We first compute the avarages over the whole population
tot_sum <- sum(data$TOT, na.rm = TRUE) # total population in ZH
empl_sum <- sum(data$anz_vzae, na.rm = TRUE) # total of the VollZeitAequivalent over ZH 


J_0_6_mean   <- sum(data$J_0_6, na.rm = TRUE)   / tot_sum # avg persons in this age class
J_7_15_mean  <- sum(data$J_7_15, na.rm = TRUE)  / tot_sum
J_16_19_mean <- sum(data$J_16_19, na.rm = TRUE) / tot_sum
J_20_24_mean <- sum(data$J_20_24, na.rm = TRUE) / tot_sum
J_25_44_mean <- sum(data$J_25_44, na.rm = TRUE) / tot_sum
J_45_64_mean <- sum(data$J_45_64, na.rm = TRUE) / tot_sum
J_65_79_mean <- sum(data$J_65_79, na.rm = TRUE) / tot_sum
J_80P_mean   <- sum(data$J_80P, na.rm = TRUE)   / tot_sum
# other columns:

MANN_mean   <- sum(data$MANN, na.rm = TRUE)   / tot_sum # avg persons in this age class
FRAU_mean   <- sum(data$FRAU, na.rm = TRUE)   / tot_sum # avg persons in this age class

SCHWEIZ_mean   <- sum(data$SCHWEIZ, na.rm = TRUE)   / tot_sum # avg persons in this age class
AUSLAND_mean   <- sum(data$AUSLAND, na.rm = TRUE)   / tot_sum # avg persons in this age class

ht_mean <- sum(data$ht, na.rm = TRUE) / empl_sum
widl_mean <- sum(data$widl, na.rm = TRUE) / empl_sum
handel_mean <- sum(data$handel, na.rm = TRUE) / empl_sum
finanz_mean <- sum(data$finanz, na.rm = TRUE) / empl_sum
freiedl_mean <- sum(data$freiedl, na.rm = TRUE) / empl_sum
gewerbe_mean <- sum(data$gewerbe, na.rm = TRUE) / empl_sum
gesundheit_mean <- sum(data$gesundheit, na.rm = TRUE) / empl_sum
bau_mean <- sum(data$bau, na.rm = TRUE) / empl_sum
sonstdl_mean <- sum(data$sonstdl, na.rm = TRUE) / empl_sum
inform_mean <- sum(data$inform, na.rm = TRUE) / empl_sum
unterricht_mean <- sum(data$unterricht, na.rm = TRUE) / empl_sum
verkehr_mean <- sum(data$verkehr, na.rm = TRUE) / empl_sum
uebrige_mean <- sum(data$uebrige, na.rm = TRUE) / empl_sum

data <- data %>%
  mutate(
    J_0_6_per = (J_0_6 / (TOT * J_0_6_mean) * 100) - 100, # vector of percentage of persons of this age class
    J_7_15_per = (J_7_15 / (TOT * J_7_15_mean) * 100) - 100, # vector of percentage of persons of this age class
    J_16_19_per = (J_16_19 / (TOT * J_16_19_mean) * 100) - 100, # vector of percentage of persons of this age class
    J_20_24_per = (J_20_24 / (TOT * J_20_24_mean) * 100) - 100, # vector of percentage of persons of this age class
    J_25_44_per = (J_25_44 / (TOT * J_25_44_mean) * 100) - 100, # vector of percentage of persons of this age class
    J_45_64_per = (J_45_64 / (TOT * J_45_64_mean) * 100) - 100, # vector of percentage of persons of this age class
    J_65_79_per = (J_65_79 / (TOT * J_65_79_mean) * 100) - 100, # vector of percentage of persons of this age class
    J_80P_per = (J_80P / (TOT * J_80P_mean) * 100) - 100, # vector of percentage of persons of this age class

    MANN_per = (MANN / (TOT * MANN_mean) * 100) - 100, # vector of percentage of persons of this age class
    FRAU_per = (FRAU / (TOT * FRAU_mean) * 100) - 100, # vector of percentage of persons of this age class

    SCHWEIZ_per = (SCHWEIZ / (TOT * SCHWEIZ_mean) * 100) - 100, # vector of percentage of persons of this age class
    AUSLAND_per = (AUSLAND / (TOT * AUSLAND_mean) * 100) - 100, # vector of percentage of persons of this age class

    ht_per = ( ht / (anz_vzae * ht_mean) * 100) - 100,
    widl_per = ( widl / (anz_vzae * widl_mean) * 100) - 100,
    handel_per = ( handel / (anz_vzae * handel_mean) * 100) - 100,
    finanz_per = ( finanz / (anz_vzae * finanz_mean) * 100) - 100,
    freiedl_per = ( freiedl / (anz_vzae * freiedl_mean) * 100) - 100,
    gewerbe_per = ( gewerbe / (anz_vzae * gewerbe_mean) * 100) - 100,
    gesundheit_per = ( gesundheit / (anz_vzae * gesundheit_mean) * 100) - 100,
    bau_per = ( bau / (anz_vzae * bau_mean) * 100) - 100,
    sonstdl_per = ( sonstdl / (anz_vzae * sonstdl_mean) * 100) - 100,
    inform_per = ( inform / (anz_vzae * inform_mean) * 100) - 100,
    unterricht_per = ( unterricht / (anz_vzae * unterricht_mean) * 100) - 100,
    verkehr_per = ( verkehr / (anz_vzae * verkehr_mean) * 100) - 100,
    uebrige_per = ( uebrige / (anz_vzae * uebrige_mean) * 100) - 100

  ) 


# select
output %>% data %>%
  select(
    ha_x,  ha_y,
    J_0_6_per, J_7_15_per, J_16_19_per, J_20_24_per, J_25_44_per, J_45_64_per, J_65_79_per, J_80P_per, 
    MANN_per, FRAU_per, SCHWEIZ_per, AUSLAND_per, 
    ht_per, widl_per, handel_per, finanz_per, freiedl_per, gewerbe_per, gesundheit_per, 
    bau_per, sonstdl_per, inform_per, unterricht_per, verkehr_per, uebrige_per
  )

save(output, file = "Criteria_per_Cell.RData")

