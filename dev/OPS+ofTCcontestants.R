## Carly Levitz
## 2/15/2026
## What is the OPS+ from Top Chef of the competitors on TOC?
## How does it change by season? (I'll do that later)


rm(list=ls())

library(tidyverse)
library(openxlsx)

directory <- "/Users/carlylevitz/Documents/Data/TOC/"

toc <- read.xlsx(paste(directory,"TOC.xlsx",sep=""),sheet=2)

ops <- read.csv("/Users/carlylevitz/Documents/Data/topChef/NPTplus.csv")
ops <- ops %>%
  # Different names between the two datasets need to be aligned
  mutate(chef = gsub("Claudette Zepeda Wilkins","Claudette Zepeda",chef)
         ,chef= gsub("Kelsey Barnard Clark","Kelsey Barnard-Clark",chef))

## Bring the data together
combined <- ops %>%
  full_join(toc %>%
              select(chef,season,seed) %>%
              # make each chef one row; this will ensure an accurate merge
              # if they were in a season but I don't know their seed, they
              #   will have an X in that column
              mutate(season=gsub(".0","",paste0("S",season))) %>%
              pivot_wider(names_from=season,values_from=seed)) %>%
  # Keep just the TOp Chef main series chefs
  # Will first pivot the data so that I can keep the chef as long as they
  #   have an X in a season...doing this so I don't have to have a long OR
  #   statement. Additionally, it will allow me to use season as a grouping var
  pivot_longer(
    cols = c("S1","S2","S3","S4","S5","S6","S7","SAll Star Christmas"),
    names_to = "tocseason",
    names_prefix = "S",
    values_to = "seed",
    values_drop_na = FALSE
  ) %>%
  filter(!(is.na(seasonNumber)) & !(is.na(seed))) %>%
  # create distinction between 8 seeds and those in the qualifiers
  mutate(status = ifelse(seed %in% c("8.0","8.2","8.3","8.4","QF"),"Qualifiers"
                         ,"Main competition"))


## Stats by season
## Exclude Lee Anne in S15; she only competed in 1 challenge
##  otherwise, some of the numbers aren't as meaningful
## Actually, include her; just use the median
seasonstats <- combined %>%
  #filter(C >=2) %>%
  group_by(tocseason) %>%
  summarise(uniquechefs=n_distinct(chef)
            ,chef_seasons=n()
            ,min=min(NPTplus)
            ,median=median(NPTplus)
            ,mean=mean(NPTplus)
            ,max=max(NPTplus))

seasonstats[,c(1,2,3,5)]
combined %>% filter(NPTplus < 0) %>% select(chef,seasonNumber,tocseason,NPTplus)

## Stats of those in Qualifiers or 8 seed
qualifierstats <- combined %>%
  group_by(tocseason,status) %>%
  summarise(median=median(NPTplus)) %>%
  pivot_wider(names_from = "status",values_from = "median")

## across all seasons
combined %>%
  summarise(uniquechefs=n_distinct(chef)
            ,chef_seasons=n()
            ,min=min(NPTplus)
            ,median=median(NPTplus)
            ,mean=mean(NPTplus)
            ,max=max(NPTplus))



