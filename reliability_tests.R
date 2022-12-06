library(tidyverse)
library(gridExtra)

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

peak_test <- t.test(onpeak$difference)
peak_test_df <- data.frame(" " = c("T-Statistic", "DoF", "p-value", "estimate", "95% Confidence Interval"),
                           " " = c(round(peak_test$statistic,2), 
                                   peak_test$parameter, 
                                   signif(peak_test$p.value,3), 
                                   round(peak_test$estimate,2), 
                                   paste0("(", round(peak_test$conf.int[1],2), ", ", round(peak_test$conf.int[2],2),")")))
names(peak_test_df) <- c("Label","Value")
peak_test_df %>% write_csv("/home/rstudio/project/derived_data/peaktest.csv")

offpeak_test <- t.test(offpeak$difference)
offpeak_test_df <- data.frame(" " = c("T-Statistic", "DoF", "p-value", "estimate", "95% Confidence Interval"),
                           " " = c(round(offpeak_test$statistic,2), 
                                   offpeak_test$parameter, 
                                   signif(offpeak_test$p.value,3), 
                                   round(offpeak_test$estimate,2), 
                                   paste0("(", round(offpeak_test$conf.int[1],2), ", ", round(offpeak_test$conf.int[2],2),")")))
names(offpeak_test_df) <- c("Label","Value")
offpeak_test_df %>% write_csv("/home/rstudio/project/derived_data/offpeaktest.csv")

reliability_RT <-  read.csv("/home/rstudio/project/derived_data/reliability_RT.csv", header=TRUE)

r2019_peak <- reliability_RT %>% 
  filter(month==9) %>% 
  filter(year == 2019) %>% 
  filter(peak_offpeak_ind=="PEAK")

r2020_peak <- reliability_RT %>% 
  filter(month==9) %>% 
  filter(year == 2020) %>% 
  filter(peak_offpeak_ind=="PEAK")

r2019_offpeak <- reliability_RT %>% 
  filter(month==9) %>% 
  filter(year == 2019) %>% 
  filter(peak_offpeak_ind=="OFF_PEAK")

r2020_offpeak <- reliability_RT %>% 
  filter(month==9) %>% 
  filter(year == 2020) %>% 
  filter(peak_offpeak_ind=="OFF_PEAK")

ronpeak <- r2019_peak %>%
  inner_join(r2020_peak, by = "gtfs_route_id") %>%
  select(gtfs_route_id, peak_offpeak_ind.x, mean.x, mean.y)

ronpeak$difference <- ronpeak$mean.y-ronpeak$mean.x

roffpeak <- r2019_offpeak %>%
  inner_join(r2020_offpeak, by = "gtfs_route_id") %>%
  select(gtfs_route_id, peak_offpeak_ind.x, mean.x, mean.y)

roffpeak$difference <- roffpeak$mean.y-roffpeak$mean.x

peak_rtest <- t.test(ronpeak$difference)
peak_rtest_df <- data.frame(" " = c("T-Statistic", "DoF", "p-value", "estimate", "95% Confidence Interval"),
                           " " = c(round(peak_rtest$statistic,2), 
                                   peak_rtest$parameter, 
                                   signif(peak_rtest$p.value,3), 
                                   round(peak_rtest$estimate,2), 
                                   paste0("(", round(peak_rtest$conf.int[1],2), ", ", round(peak_rtest$conf.int[2],2),")")))
names(peak_rtest_df) <- c("Label","Value")
peak_rtest_df %>% write_csv("/home/rstudio/project/derived_data/rpeaktest.csv")

offpeak_rtest <- t.test(roffpeak$difference)
offpeak_rtest_df <- data.frame(" " = c("T-Statistic", "DoF", "p-value", "estimate", "95% Confidence Interval"),
                              " " = c(round(offpeak_rtest$statistic,2), 
                                      offpeak_rtest$parameter, 
                                      signif(offpeak_rtest$p.value,3), 
                                      round(offpeak_rtest$estimate,2), 
                                      paste0("(", round(offpeak_rtest$conf.int[1],2), ", ", round(offpeak_rtest$conf.int[2],2),")")))
names(offpeak_rtest_df) <- c("Label","Value")
offpeak_rtest_df %>% write_csv("/home/rstudio/project/derived_data/roffpeaktest.csv")
