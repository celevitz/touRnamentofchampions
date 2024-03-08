library(tidyverse)

results %>%
  filter(round == "Round of 32") %>%
  group_by(season,commentator) %>%
  summarise(total=mean(total,na.rm=T))

results %>%
  left_join(seeds) %>%
  filter(round == "Round of 32") %>%
  group_by(season,commentator) %>%
  summarise(total=mean(total,na.rm=T)
            ,seed=mean(seed,na.rm=T))
