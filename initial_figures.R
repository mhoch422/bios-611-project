library(tidyverse)
library(ggplot2)
library(plotly)

pop_stops <- read.csv("derived_data/municipality_stops.csv")
pop_stops_nb <- read.csv("derived_data/municipality_stops_NoBoston.csv")
stop_info <- read.csv("derived_data/stop_info.csv")

g <- ggplot(pop_stops, aes(population, n)) +
  geom_point(alpha = 0.5) +
  labs(title = "Municipality Population and # Stops", x= "Population", y = "# Stops") +
  scale_y_continuous(limits = c(0, 2000), breaks = seq(0,2000, 200)) 
ggsave("figures/population_stops.png", plot=g)


g_nb <-ggplot(pop_stops_nb, aes(population, n)) +
  geom_point(alpha = 0.5) +
  labs(title = "Municipality Population and # Stops (Boston Removed)", x= "Population", y = "# Stops") +
  scale_y_continuous(limits = c(0, 600), breaks = seq(0,600, 50)) 
ggsave("figures/population_stops_noBoston.png", plot=g_nb)

g_inc <-ggplot(pop_stops_nb, aes(dor_income_per_capita_19, n)) +
  geom_point() +
  labs(title = "Per-Capita Income 2019 and # Stops (Boston Removed)", x = "Per-Capita Income", y= "# Stops")
ggsave("figures/income_stops_noBoston.png", plot=g_inc)

g_eqv <-ggplot(pop_stops_nb, aes(eqv_per_capita_19, n)) +
  geom_point() +
  labs(title = "Per-Capita Property Value 2019 and # Stops (Boston Removed)", x = "Per-Capita EQV", y= "# Stops")
ggsave("figures/eqv_stops_noBoston.png", plot=g_eqv)



