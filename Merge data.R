
library(ggplot2)
library(dplyr)

race = readRDS("counties(1).rds")

counties_map = map_data("county")

counties_map = counties_map %>%
  mutate(name = paste(region, subregion, sep = ","))

counties = left_join(counties_map, race, by = "name")

ggplot(counties, aes(x = long, y = lat, group = group, fill = white)) +
  geom_polygon() +
  scale_fill_gradient(low = "white", high = "darkred") +
  theme_void()
