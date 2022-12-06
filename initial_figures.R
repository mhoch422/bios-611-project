library(tidyverse)
library(lubridate)
library(ggplot2)
library(plotly)
library(sf)
library(geojsonsf)
library(scales)

options(scipen=999)

cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

neighbor_sf <- geojson_sf("/home/rstudio/project/source_data/Boston_Neighborhoods.geojson")
boston_demo <- read.csv("/home/rstudio/project/derived_data/boston_demo.csv")
neighbor_sf <- left_join(neighbor_sf, boston_demo, by = c("Name" = "neighborhood"))

boston_map_1 <- ggplot(neighbor_sf) +
  geom_sf(aes(fill=n))
ggsave("figures/boston_map_numstops.png", width = 6, height = 4, plot= boston_map_1)

boston_map_2 <- ggplot(neighbor_sf) + 
  geom_sf(aes(fill=percapita))
ggsave("figures/boston_map_income.png", width = 6, height = 4,  plot= boston_map_2)

boston_map_3 <- ggplot(neighbor_sf) + 
  geom_sf(aes(fill=population))
ggsave("figures/boston_map_pop.png", width = 6, height = 4,  plot= boston_map_3)

g_bp <- ggplot(boston_demo, aes(population, n)) +
  geom_point(alpha = 0.5) +
  labs(title = "Neighborhood Population and # Stops", x= "Population", y = "# Stops") +
  scale_y_continuous(limits = c(0, 400), breaks = seq(0,600, 50)) 
ggsave("figures/boston_population_stops.png", width = 5, height = 3,  plot=g_bp)

g_bi <- ggplot(boston_demo, aes(percapita, n)) +
  geom_point(alpha = 0.5) +
  labs(title = "Neighborhood Income and # Stops", x= "Per-Capita Income", y = "# Stops") +
  scale_y_continuous(limits = c(0, 400), breaks = seq(0,400, 50)) 
ggsave("figures/boston_income_stops.png", width = 5, height = 3,  plot=g_bi)

pop_stops <- read.csv("/home/rstudio/project/derived_data/municipality_stops.csv")
pop_stops_nb <- read.csv("/home/rstudio/project/derived_data/municipality_stops_NoBoston.csv")
stop_info <- read.csv("/home/rstudio/project/derived_data/stop_info.csv")

g <- ggplot(pop_stops, aes(population, n)) +
  geom_point(alpha = 0.5) +
  labs(title = "Municipality Population and # Stops", x= "Population", y = "# Stops") +
  scale_y_continuous(limits = c(0, 2000), breaks = seq(0,2000, 200)) 
ggsave("figures/population_stops.png", width = 5, height = 3,  plot=g)


g_nb <-ggplot(pop_stops_nb, aes(population, n)) +
  geom_point(alpha = 0.5) +
  labs(title = "Municipality Population and # Stops", x= "Population", y = "# Stops") +
  scale_y_continuous(limits = c(0, 600), breaks = seq(0,600, 50)) 
ggsave("figures/population_stops_noBoston.png", width = 5, height = 3,  plot=g_nb)

g_inc <-ggplot(pop_stops_nb, aes(dor.income.per.capita_19, n)) +
  geom_point() +
  labs(title = "Per-Capita Income 2019 and # Stops", x = "Per-Capita Income", y= "# Stops")
ggsave("figures/income_stops_noBoston.png", width = 5, height = 3,  plot=g_inc)

g_eqv <-ggplot(pop_stops_nb, aes(eqv.per.capita_19, n)) +
  geom_point() +
  labs(title = "Per-Capita Property Value 2019 and # Stops", x = "Per-Capita EQV", y= "# Stops")
ggsave("figures/eqv_stops_noBoston.png", width = 5, height = 3,  plot=g_eqv)








