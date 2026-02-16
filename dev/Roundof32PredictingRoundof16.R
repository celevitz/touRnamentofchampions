## Goal: how do results from Rounds of 32 predict Round of 16 winners?
## All the people in Rounds of 16 (Except seasons 1 and 2) won previous round.
## So, what can we learn from seasons 3, 4, and 5?
##    Do people who win by more in Round of 32 do better in Round of 16?
##    What about presentation order?
##    Will also look at game play: randomizer score as % of possible total
##      (since total changed by season)
## First thought is logistic regression predicting winner. But how to take into
##  account that half will always win?
## Can I use the logistic regression to predict whether Person A will win in
##  Round of 16 - and then compare it to their actual result.

rm(list=ls())

library(tidyverse)

directory <- "/Users/carlylevitz/Documents/Data/TOC/"

results <- read.csv(paste0(directory,"results.csv"),header=T)


## How do seasons compare in terms of total scores?
# overall standard devaiation
results %>%
  group_by(season) %>%
  summarise(standarddeviation = sd(total,na.rm=T))

# sd in round of 32
results %>%
  filter(round == "Round of 32") %>%
  group_by(season) %>%
  summarise(standarddeviation = sd(total,na.rm=T))

# st dev of average score differential
  results %>%
    filter(challenge != "Amanda/Madison") %>%
    group_by(season,episode,round,challenge) %>%
    summarise(min=min(total,na.rm=T)
              ,max=max(total,na.rm=T)
              ) %>%
    mutate(differential = max-min) %>%
    ungroup() %>%
    group_by(season) %>%
    summarise(averagediff = mean(differential)
              ,stdev = sd(differential))


## Average differential by round and season
  averagedifferential <- results %>%
    filter(challenge != "Amanda/Madison") %>%
    group_by(season,episode,round,challenge) %>%
    summarise(min=min(total,na.rm=T)
              ,max=max(total,na.rm=T)
    ) %>%
    mutate(differential = max-min) %>%
    ungroup() %>%
    group_by(season,round) %>%
    summarise(averagediff = mean(differential)) %>%
    pivot_wider(names_from= round,values_from = averagediff)

  averagedifferential <- averagedifferential[,c("season","Qualifier semi-final"
                                                ,"Qualifier final","Round of 32"
                                                ,"Round of 16","Quarter-final"
                                                ,"Semi-final","Final")]


  overallaveragedifferential <- results %>%
    filter(challenge != "Amanda/Madison") %>%
    group_by(season,episode,round,challenge) %>%
    summarise(min=min(total,na.rm=T)
              ,max=max(total,na.rm=T)
    ) %>%
    mutate(differential = max-min) %>%
    ungroup() %>%
    group_by(season) %>%
    summarise(averagediff = round(mean(differential),1))








