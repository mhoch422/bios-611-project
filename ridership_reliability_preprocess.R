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

bus_stops <- read.csv("/home/rstudio/project/source_data/Bus_Stops.csv")

ridership <- read.csv("/home/rstudio/project/source_data/ridership.csv")

#ridership$trip_start_time2 <- times(ridership$trip_start_time)
ridership_group <- ridership %>% 
  filter(season=="Fall 2019") %>% 
  filter(day_type_name == "weekday") %>%
  group_by(route_id) %>%
  tally(boardings) %>%
  arrange(desc(n))

names(ridership_group) <- c("gtfs_route_id", "ridership")

ridership_group2 <- ridership %>% 
  filter(season=="Fall 2019") %>% 
  filter(day_type_name == "weekday") %>%
  group_by(route_id, stop_id) %>%
  tally(boardings) %>%
  arrange(desc(n))

ridership_group2$stop_id <- as.character(ridership_group2$stop_id)

ridership_top <- ridership_group %>%
  filter(ridership > 10000)

rm(ridership)

reliability <- read.csv("/home/rstudio/project/source_data/reliability.csv")
reliability$service_date <- as_date(reliability$service_date)
reliability$month <- month(reliability$service_date)
reliability$year <- year(reliability$service_date)
reliability <- reliability %>% filter(year > 2017)
reliability$rel_m <- reliability$otp_numerator/reliability$otp_denominator

reliability_bus_full <- reliability %>%
  filter(mode_type=="Bus") %>%
  #filter(month == 1) %>%
  group_by(gtfs_route_id, year, month,peak_offpeak_ind) %>%
  summarise(mean=mean(rel_m), minimum = min(rel_m), maximum=max(rel_m)) %>%
  inner_join(ridership_group, by = "gtfs_route_id")
reliability_bus_full$date <- as_date(paste0(reliability_bus_full$year,"-",reliability_bus_full$month,"-01"))

reliability_bus <- reliability %>% 
  inner_join(ridership_top, by = "gtfs_route_id") %>%
  group_by(gtfs_route_id, year, month,peak_offpeak_ind) %>%
  summarise(mean=mean(rel_m), minimum = min(rel_m), maximum=max(rel_m)) 
reliability_bus$date <- as_date(paste0(reliability_bus$year,"-",reliability_bus$month,"-01"))

reliability_RT <- reliability %>% 
  filter(mode_type == "Rail") %>%
  group_by(gtfs_route_id, year, month,peak_offpeak_ind) %>%
  summarise(mean=mean(rel_m), minimum = min(rel_m), maximum=max(rel_m))
reliability_RT$date <- as_date(paste0(reliability_RT$year,"-",reliability_RT$month,"-01"))

reliability_bus_full %>% write.csv("/home/rstudio/project/derived_data/reliability_bus_full.csv", row.names=FALSE)
reliability_bus %>% write.csv("/home/rstudio/project/derived_data/reliability_bus.csv", row.names=FALSE)
reliability_RT %>% write.csv("/home/rstudio/project/derived_data/reliability_RT.csv", row.names=FALSE)

stops_and_routes <- bus_stops %>% left_join(ridership_group2, by="stop_id")
names(stops_and_routes) <- simplify_strings(names(stops_and_routes))
sandr_trimmed <- stops_and_routes %>% select(stop_id, stop_lat, stop_lon, zone_id, 
                                             level_id, wheelchair_boarding, municipality,
                                             vehicle_type, sidewalk_width_ft, accessibility_score,
                                             sidewalk_condition, sidewalk_material, current_shelter,
                                             n)

sandr_trimmed$sidewalk_width_ft <- round(as.numeric(sandr_trimmed$sidewalk_width_ft), 1)

sandr_trimmed <- sandr_trimmed %>% mutate(across(everything(), simplify_strings))

sandr_trimmed %>% write.csv("/home/rstudio/project/derived_data/stop_ridership.csv", row.names= FALSE)

stop_ridership_mun <- sandr_trimmed %>% 
  group_by(municipality, stop_id) %>% 
  summarise(mean=mean(n, na.rm=TRUE)) %>%
  group_by(municipality) %>%
  summarise(avg = mean(mean, na.rm=TRUE), 
            min = min(mean, na.rm=TRUE),
            max = max(mean, na.rm=TRUE),
            tot_stops=n()) %>%
  filter(is.na(mean)==FALSE)

stop_ridership_mun %>% write.csv("/home/rstudio/project/derived_data/stop_ridership_mun.csv", row.names= FALSE)


