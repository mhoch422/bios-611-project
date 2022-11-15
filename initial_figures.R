library(tidyverse)
library(lubridate)
library(ggplot2)
library(plotly)
library(sf)
library(geojsonsf)
library(scales)

options(scipen=999)

cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#0072B2", "#D55E00", "#CC79A7")

neighbor_sf <- geojson_sf("/home/rstudio/project/source_data/Boston_Neighborhoods.geojson")
boston_demo <- read.csv("derived_data/boston_demo.csv")
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

pop_stops <- read.csv("derived_data/municipality_stops.csv")
pop_stops_nb <- read.csv("derived_data/municipality_stops_NoBoston.csv")
stop_info <- read.csv("derived_data/stop_info.csv")

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

g_inc <-ggplot(pop_stops_nb, aes(dor_income_per_capita_19, n)) +
  geom_point() +
  labs(title = "Per-Capita Income 2019 and # Stops", x = "Per-Capita Income", y= "# Stops")
ggsave("figures/income_stops_noBoston.png", width = 5, height = 3,  plot=g_inc)

g_eqv <-ggplot(pop_stops_nb, aes(eqv_per_capita_19, n)) +
  geom_point() +
  labs(title = "Per-Capita Property Value 2019 and # Stops", x = "Per-Capita EQV", y= "# Stops")
ggsave("figures/eqv_stops_noBoston.png", width = 5, height = 3,  plot=g_eqv)

reliability_bus <-read.csv("/home/rstudio/project/derived_data/reliability_bus.csv")
reliability_bus$date <- as_date(reliability_bus$date)
reliability_bus$gtfs_route_id <- as.factor(reliability_bus$gtfs_route_id)
bus_peak <- reliability_bus %>% filter(peak_offpeak_ind=="PEAK")
bus_op  <- reliability_bus %>% filter(peak_offpeak_ind=="OFF_PEAK")

g_bp<-ggplot(bus_peak, aes(x=date, y=mean, color=gtfs_route_id)) +
  geom_line() +
  geom_point() +
  (scale_x_date(labels=date_format("%b %y"))) +
  scale_colour_manual(values=cbbPalette)
ggsave("figures/bus_onpeak.png", width = 5, height = 3,  plot=g_bp)

g_bop <- ggplot(bus_op,aes(x=date, y=mean, color=gtfs_route_id)) +
  geom_line() +
  geom_point() +
  (scale_x_date(labels=date_format("%b %y"))) +
  scale_colour_manual(values=cbbPalette)
ggsave("figures/bus_offpeak.png", width = 5, height = 3,  plot=g_bop)

# gfg_plot <- ggplot(bus_op %>% filter(gtfs_route_id ==28), aes(x=date, color=gtfs_route_id)) +  
#   geom_line(aes(y = mean)) +
#   geom_ribbon(aes(ymin=minimum,ymax=maximum), alpha=0.5)
# gfg_plot

reliability_RT <-read.csv("/home/rstudio/project/derived_data/reliability_RT.csv")
reliability_RT$date <- as_date(reliability_RT$date)
reliability_RT$gtfs_route_id <- as.factor(reliability_RT$gtfs_route_id)
rt_peak <- reliability_RT %>% filter(peak_offpeak_ind=="PEAK")
rt_op <- reliability_RT %>% filter(peak_offpeak_ind=="OFF_PEAK")

g_rp<- ggplot(rt_peak %>% filter(gtfs_route_id %in% c("Blue", "Orange", "Red")), aes(x=date, y=mean, color=gtfs_route_id)) +
  geom_point() +
  geom_line() +
  (scale_x_date(labels=date_format("%b %y"))) +
  scale_color_manual(values = c("Blue" = "steelblue", "Orange" = "orange", "Red" = "red"))
ggsave("figures/rt_onpeak.png", width = 5, height = 3,  plot=g_rp)   

g_rpg<- ggplot(rt_peak %>% filter(gtfs_route_id %in% c("Green-B", "Green-C", "Green-D", "Green-E")), aes(x=date, y=mean, color=gtfs_route_id)) +
  geom_point() +
  geom_line() +
  (scale_x_date(labels=date_format("%b %y"))) +
  scale_color_manual(values = c("Green-B" = "#02231c", "Green-C" = "#004d25", "Green-D" = "#11823b", "Green-E" = "#48bf53"))
ggsave("figures/rtg_onpeak.png", width = 5, height = 3,  plot=g_rpg) 

g_rop<-ggplot(rt_op %>% filter(gtfs_route_id %in% c("Blue", "Orange", "Red")), aes(x=date, y=mean, color=gtfs_route_id)) +
  geom_point() +
  geom_line() +
  (scale_x_date(labels=date_format("%b %y"))) +
  scale_color_manual(values = c("Blue" = "steelblue", "Orange" = "orange", "Red" = "red"))

ggsave("figures/rt_offpeak.png", width = 5, height = 3,  plot=g_rop)

g_ropg<- ggplot(rt_peak %>% filter(gtfs_route_id %in% c("Green-B", "Green-C", "Green-D", "Green-E")), aes(x=date, y=mean, color=gtfs_route_id)) +
  geom_point() +
  geom_line() +
  (scale_x_date(labels=date_format("%b %y"))) +
  scale_color_manual(values = c("Green-B" = "#02231c", "Green-C" = "#004d25", "Green-D" = "#11823b", "Green-E" = "#48bf53"))
ggsave("figures/rtg_offpeak.png", width = 5, height = 3,  plot=g_ropg) 






