library(tidyverse)

reliability_full <-  read.csv("/home/rstudio/project/derived_data/reliability_bus_full.csv", header=TRUE)

s2019_peak <- reliability_full %>% 
  filter(month==9) %>% 
  filter(year == 2019) %>% 
  filter(peak_offpeak_ind=="PEAK")

s2020_peak <- reliability_full %>% 
  filter(month==9) %>% 
  filter(year == 2020) %>% 
  filter(peak_offpeak_ind=="PEAK")

s2019_offpeak <- reliability_full %>% 
  filter(month==9) %>% 
  filter(year == 2019) %>% 
  filter(peak_offpeak_ind=="OFF_PEAK")

s2020_offpeak <- reliability_full %>% 
  filter(month==9) %>% 
  filter(year == 2020) %>% 
  filter(peak_offpeak_ind=="OFF_PEAK")

onpeak <- s2019_peak %>%
  inner_join(s2020_peak, by = "gtfs_route_id") %>%
  select(gtfs_route_id, peak_offpeak_ind.x, mean.x, mean.y, ridership.x)

onpeak$difference <- onpeak$mean.y-onpeak$mean.x

offpeak <- s2019_offpeak %>%
  inner_join(s2020_offpeak, by = "gtfs_route_id") %>%
  select(gtfs_route_id, peak_offpeak_ind.x, mean.x, mean.y, ridership.x)

offpeak$difference <- offpeak$mean.y-offpeak$mean.x

t.test(onpeak$difference)
t.test(offpeak$difference)