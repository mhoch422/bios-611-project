library(tidyverse)
library(xlsx)
library(sf)
library(geojsonsf)
library(spData)
library(ggplot2)
library(lubridate)
library(chron)

options(scipen=999)
simplify_strings <- function(s){
  s %>% 
    str_to_lower() %>%
    str_trim() %>%
    str_replace_all("[^a-z0-9.]+","_") %>%
    str_replace_all("^_+","") %>% 
    str_replace_all("_+$","");
}

rm_commas <- function(s){
  s %>%
    str_replace_all(",","")
}

dir.create("derived_data")

neigh <-read.xlsx('/home/rstudio/project/source_data/Boston_Neighborhoods_tables.xlsm', sheetIndex = 12)
neigh_table <- as_tibble(neigh)
names(neigh_table) <- c("Neighborhood", "Population", "Total_Income", "PerCapita", "Blank")
neigh_table <- neigh_table[6:27,1:4]
names(neigh_table) <- simplify_strings(names(neigh_table));

neighbor_sf <- geojson_sf("/home/rstudio/project/source_data/Boston_Neighborhoods.geojson")

bus_stops <- read.csv("/home/rstudio/project/source_data/Bus_Stops.csv")
bus_stops <- bus_stops %>% add_column(stop_type="Bus")
rapid_stops <- read.csv("/home/rstudio/project/source_data/RT_stops.csv")
rapid_stops <- rapid_stops %>% add_column(stop_type="Rapid_Transit")
rapid_stops[rapid_stops$stop_name=="Boston College",]$municipality <- "Newton"

transit_stops <- rbind(bus_stops, rapid_stops)
transit_stops %>% write_csv("derived_data/stop_info.csv")

boston_stops <- transit_stops %>% filter(municipality=="Boston")
## Convert points data.frame to an sf POINTS object
boston_stops$point <- st_as_sf(boston_stops[,1:2], coords = 1:2, crs = 4326)

## Transform spatial data to some planar coordinate system
## (e.g. Web Mercator) as required for geometric operations
t_neighbor <- st_transform(neighbor_sf, crs = 3857)
boston_stops$point <- st_transform(boston_stops$point, crs = 3857)

## Find names of state (if any) intersected by each point
hood_names <- t_neighbor[["Name"]]
ii <- as.integer(st_intersects(boston_stops$point, t_neighbor))
boston_stops$neighborhood<-hood_names[ii]

boston_stops[,c(1:35,37)] %>% write_csv("derived_data/boston_stop_info.csv")
names(t_neighbor) <- simplify_strings(names(t_neighbor))

boston_stops <- boston_stops %>% group_by(neighborhood) %>% tally()
boston_demo <- boston_stops %>% left_join(neigh_table, by="neighborhood")
boston_demo %>% write_csv("derived_data/boston_demo.csv")

names(transit_stops) <- simplify_strings(names(transit_stops));
stop_tally <- transit_stops %>% group_by(municipality) %>% tally()
metro_mun <- unique(transit_stops$municipality)

mass_pop <- read.csv("/home/rstudio/project/source_data/population.csv")
metro_pop <- mass_pop %>% filter(Municipality %in% metro_mun)
names(metro_pop) <- simplify_strings(names(metro_pop));
metro_pop <- metro_pop %>% select(municipality, county, x2020)
names(metro_pop) <- c("municipality", "county", "population")

mass_inc2019 <- read.csv("/home/rstudio/project/source_data/DOR_Income_EQV_Per_Capita_2019.csv")
names(mass_inc2019) <- simplify_strings(names(mass_inc2019))
mass_inc2019 <- mass_inc2019 %>% 
  mutate(across(everything(), rm_commas)) %>% 
  select(municipality, dor.income.per.capita, eqv.per.capita) %>% 
  filter(municipality %in% metro_mun) %>% 
  mutate_at(vars(dor.income.per.capita, eqv.per.capita), as.numeric)

mass_inc2020 <- read.csv("/home/rstudio/project/source_data/DOR_Income_EQV_Per_Capita_2020.csv")
names(mass_inc2020) <- simplify_strings(names(mass_inc2020))
mass_inc2020 <- mass_inc2020 %>% 
  mutate(across(everything(), rm_commas)) %>% 
  select(municipality, dor.income.per.capita, eqv.per.capita) %>% 
  filter(municipality %in% metro_mun) %>% 
  mutate_at(vars(dor.income.per.capita, eqv.per.capita), as.numeric)

mass_inc2021 <- read.csv("/home/rstudio/project/source_data/DOR_Income_EQV_Per_Capita_2021.csv")
names(mass_inc2021) <- simplify_strings(names(mass_inc2021))
mass_inc2021 <- mass_inc2021 %>% 
  mutate(across(everything(), rm_commas)) %>% 
  select(municipality, dor.income.per.capita, eqv.per.capita) %>% 
  filter(municipality %in% metro_mun) %>% 
  mutate_at(vars(dor.income.per.capita, eqv.per.capita), as.numeric)
names(mass_inc2021) <- c("municipality", "dor_income_per_capita_21", "eqv_per_capita_21")

mass_fin <- mass_inc2019 %>% 
  inner_join(mass_inc2020, by = "municipality", suffix = c("_19", "_20")) %>% 
  inner_join(mass_inc2021, by = "municipality")
mass_fin %>% write_csv("derived_data/fin_info.csv")

pop_stops <- stop_tally %>% 
  inner_join(metro_pop, by = "municipality") %>% 
  inner_join(mass_fin, by = "municipality")
pop_stops <- pop_stops %>% mutate(across(everything(), rm_commas)) %>% 
  mutate_at(vars(n, population), as.numeric)
pop_stops %>% write_csv("derived_data/municipality_stops.csv")


pop_stops_nb <- pop_stops %>% filter(municipality != "Boston")
pop_stops_nb %>% write_csv("derived_data/municipality_stops_NoBoston.csv")



