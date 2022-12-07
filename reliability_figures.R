library(tidyverse)
library(lubridate)
library(ggplot2)
library(plotly)
library(sf)
library(geojsonsf)
library(scales)
pdf(NULL)

cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")


reliability_bus <-read.csv("/home/rstudio/project/derived_data/reliability_bus.csv")
reliability_bus$date <- as_date(reliability_bus$date)
reliability_bus$gtfs_route_id <- as.factor(reliability_bus$gtfs_route_id)
bus_peak <- reliability_bus %>% filter(peak_offpeak_ind=="PEAK")
bus_op  <- reliability_bus %>% filter(peak_offpeak_ind=="OFF_PEAK")

g_bp<-ggplot(bus_peak, aes(x=date, y=mean, color=gtfs_route_id)) +
  geom_line() +
  geom_point() +
  (scale_x_date(labels=date_format("%b %y"))) +
  scale_colour_manual(values=cbbPalette) +
  labs(title = "Peak Bus Reliability 2018-2022", x="Date", y="Mean Reliability")
ggsave("/home/rstudio/project/figures/bus_onpeak.png", width = 6, height = 3,  plot=g_bp)

g_bop <- ggplot(bus_op,aes(x=date, y=mean, color=gtfs_route_id)) +
  geom_line() +
  geom_point() +
  (scale_x_date(labels=date_format("%b %y"))) +
  scale_colour_manual(values=cbbPalette) +
  labs(title = "Off-Peak Bus Reliability 2018-2022", x="Date", y="Mean Reliability")
ggsave("figures/bus_offpeak.png", width = 6, height = 3,  plot=g_bop)

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
  scale_color_manual(values = c("Blue" = "steelblue", "Orange" = "orange", "Red" = "red")) +
  labs(title = "Peak RT Reliability 2018-2022", x="Date", y="Mean Reliability")
ggsave("figures/rt_onpeak.png", width = 6, height = 3,  plot=g_rp)   

g_rpg<- ggplot(rt_peak %>% filter(gtfs_route_id %in% c("Green-B", "Green-C", "Green-D", "Green-E")), aes(x=date, y=mean, color=gtfs_route_id)) +
  geom_point() +
  geom_line() +
  (scale_x_date(labels=date_format("%b %y"))) +
  scale_color_manual(values = c("Green-B" = "#02231c", "Green-C" = "#004d25", "Green-D" = "#11823b", "Green-E" = "#48bf53")) +
  labs(title = "Off-Peak RT Reliability 2018-2022", x="Date", y="Mean Reliability")
ggsave("figures/rtg_onpeak.png", width = 6, height = 3,  plot=g_rpg) 

g_rop<-ggplot(rt_op %>% filter(gtfs_route_id %in% c("Blue", "Orange", "Red")), aes(x=date, y=mean, color=gtfs_route_id)) +
  geom_point() +
  geom_line() +
  (scale_x_date(labels=date_format("%b %y"))) +
  scale_color_manual(values = c("Blue" = "steelblue", "Orange" = "orange", "Red" = "red")) +
  labs(title = "Off-Peak RT Reliability 2018-2022", x="Date", y="Mean Reliability")

ggsave("figures/rt_offpeak.png", width = 6, height = 3,  plot=g_rop)

g_ropg<- ggplot(rt_peak %>% filter(gtfs_route_id %in% c("Green-B", "Green-C", "Green-D", "Green-E")), aes(x=date, y=mean, color=gtfs_route_id)) +
  geom_point() +
  geom_line() +
  (scale_x_date(labels=date_format("%b %y"))) +
  scale_color_manual(values = c("Green-B" = "#02231c", "Green-C" = "#004d25", "Green-D" = "#11823b", "Green-E" = "#48bf53")) +
  labs(title = "Off-Peak RT Reliability 2018-2022", x="Date", y="Mean Reliability")
ggsave("figures/rtg_offpeak.png", width = 6, height = 3,  plot=g_ropg) 

full_bus <-read.csv("/home/rstudio/project/derived_data/reliability_bus_full.csv")

ggplot(full_bus %>% filter(peak_offpeak_ind=="OFF_PEAK"), aes(x=ridership, y=mean, color=year)) +
  geom_point()

ggplot(full_bus %>% filter(peak_offpeak_ind=="OFF_PEAK"), aes(x=ridership, y=maximum, color=year)) +
  geom_point()