library(tidyverse)
library(lubridate)
library(ggplot2)
library(plotly)
library(sf)
library(geojsonsf)
library(scales)

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

full_bus <-read.csv("/home/rstudio/project/derived_data/reliability_bus_full.csv")

ggplot(full_bus %>% filter(peak_offpeak_ind=="OFF_PEAK"), aes(x=ridership, y=mean, color=year)) +
  geom_point()

ggplot(full_bus %>% filter(peak_offpeak_ind=="OFF_PEAK"), aes(x=ridership, y=maximum, color=year)) +
  geom_point()