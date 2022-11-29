library(tidyverse)
library(lubridate)
library(ggplot2)
library(plotly)
library(sf)
library(geojsonsf)
library(scales)
library(matlab)
library(gbm)


stop_ridership <- read.csv("/home/rstudio/project/derived_data/stop_ridership.csv")

#pca_results <- prcomp(stop_ridership %>% select(-character, -universe) %>% as.matrix())

ggplot(stop_ridership, aes(zone_id)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle=90, vjust=.5, hjust=1))

ggplot(stop_ridership, aes(level_id)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle=90, vjust=.5, hjust=1))

ggplot(stop_ridership, aes(wheelchair_boarding)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle=90, vjust=.5, hjust=1))

ggplot(stop_ridership, aes(sidewalk_width_ft)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle=90, vjust=.5, hjust=1))

ggplot(stop_ridership, aes(sidewalk_condition)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle=90, vjust=.5, hjust=1))

ggplot(stop_ridership, aes(sidewalk_material)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle=90, vjust=.5, hjust=1))

ggplot(stop_ridership, aes(accessibility_score)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle=90, vjust=.5, hjust=1))

ggplot(stop_ridership, aes(current_shelter)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle=90, vjust=.5, hjust=1))
