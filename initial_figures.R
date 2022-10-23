library(tidyverse)
library(ggplot2)
library(plotly)

pop_stops <- read.csv("derived_data/municipality_stops.csv")

g <- ggplot(pop_stops, aes(as.numeric(x2020), as.numeric(n))) +
  geom_point(alpha = 0.5) +
  labs(title = "Municipality Population and # Stops", x= "Population", y = "# Stops") +
  scale_y_continuous(limits = c(0, 2000), breaks = seq(0,2000, 200)) 
ggsave("figures/population_stops.png", plot=g)


pop_stops_nb <- read.csv("derived_data/municipality_stops_NoBoston.csv")

g_nb <-ggplot(pop_stops_nb, aes(as.numeric(x2020), as.numeric(n))) +
  geom_point(alpha = 0.5) +
  labs(title = "Municipality Population and # Stops (Boston Removed)", x= "Population", y = "# Stops") +
  scale_y_continuous(limits = c(0, 600), breaks = seq(0,600, 50)) 

ggsave("figures/population_stops_noBoston.png", plot=g_nb)
