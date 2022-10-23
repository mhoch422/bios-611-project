library(tidyverse)

options(scipen=999)
simplify_strings <- function(s){
  s %>% 
    str_to_lower() %>%
    str_trim() %>%
    str_replace_all("[^a-z0-9]+","_") %>%
    str_replace_all("^_+","") %>% 
    str_replace_all("_+$","");
}

rm_commas <- function(s){
  s %>%
    str_replace_all(",","")
}

dir.create("derived_data")

bus_stops <- read.csv("/home/rstudio/project/source_data/Bus_Stops.csv")
rapid_stops <- read.csv("/home/rstudio/project/source_data/RT_stops.csv")

transit_stops <- rbind(bus_stops, rapid_stops)
transit_stops %>% write_csv("derived_data/stop_info.csv")

names(transit_stops) <- simplify_strings(names(transit_stops));
stop_tally <- transit_stops %>% group_by(municipality) %>% tally()
metro_mun <- unique(transit_stops$municipality)

mass_pop <- read.csv("/home/rstudio/project/source_data/population.csv")
metro_pop <- mass_pop %>% filter(Municipality %in% metro_mun)
names(metro_pop) <- simplify_strings(names(metro_pop));

pop_stops <- stop_tally %>% inner_join(metro_pop, by = "municipality")
pop_stops <- pop_stops %>% mutate(across(everything(), rm_commas)) 
pop_stops %>% write_csv("derived_data/municipality_stops.csv")


pop_stops_nb <- pop_stops %>% filter(municipality != "Boston")
pop_stops_nb %>% write_csv("derived_data/municipality_stops_NoBoston.csv")

