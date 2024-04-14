library(tidyverse)
library(ggplot2)
library(devtools)
library(hrbrthemes)

devtools::install_github("celevitz/touRnamentofchampions")

rm(list=ls())

seeds <- touRnamentofchampions::seeds
results <- touRnamentofchampions::results
randomizerlong <- touRnamentofchampions::randomizerlongform

## number of chefs
results %>%
  left_join(seeds) %>%
  mutate(seed = case_when(season ==3 & chef %in% c("Brooke Williamson","Jet Tila")~ 1
                          ,season ==3 & chef %in% c("Tiffani Faison")~ 3
                          ,season ==3 & chef %in% c("Tobias Dorzon")~ 7
                          ,TRUE ~ seed)) %>%
  filter(!(round %in% c("Qualifier semi-final","Qualifier final"))) %>%
  select(season,seed,chef) %>%
  distinct() %>%
  group_by(season,seed) %>%
  summarise(n=n())

## Number of battles by seed & season
numbattles <- results %>%
  left_join(seeds) %>%
  mutate(seed = case_when(season ==3 & chef %in% c("Brooke Williamson","Jet Tila")~ 1
                          ,season ==3 & chef %in% c("Tiffani Faison")~ 3
                          ,season ==3 & chef %in% c("Tobias Dorzon")~ 7
                          ,TRUE ~ seed)) %>%
  filter(!(round %in% c("Qualifier semi-final","Qualifier final"))) %>%
  select(season,seed,episode,round,challenge) %>%
  distinct() %>%
  group_by(season,seed) %>%
  summarise(n=n())

numbattles %>%
  pivot_wider(names_from=seed,values_from=n)

# numbattles %>%
#   filter(season >= 3) %>%
#   ggplot(aes(x=season,y=seed,fill=n)) +
#   geom_tile() +
#   scale_fill_distiller(palette = "RdPu", direction=+1) +
#   theme_ipsum() +
#   ggtitle("Number of battles by seed for seasons 3 to 5\n(seasons 1 and 2 didn't have rounds of 32)")


## Average score
averagescore <- results %>%
  left_join(seeds) %>%
  mutate(seed = case_when(season ==3 & chef %in% c("Brooke Williamson","Jet Tila")~ 1
                          ,season ==3 & chef %in% c("Tiffani Faison")~ 3
                          ,season ==3 & chef %in% c("Tobias Dorzon")~ 7
                          ,TRUE ~ seed)) %>%
  filter(!(round %in% c("Qualifier semi-final","Qualifier final"))) %>%
  group_by(season,seed) %>%
  summarise(mean=mean(total,na.rm=T))

averagescore %>%
  pivot_wider(names_from=seed,values_from=mean)

## Win-loss percent






