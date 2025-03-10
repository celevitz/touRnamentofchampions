## Carly Levitz
## March 9, 2025
## Purpose: Does the type of protein affect how high scores are?
## Want to take into account the round, season, and either seed or how many
##    times they've been in TOC.
## What I'm not sure about is how or whether to take into account that there
##    are two people in each battle and their scores are kinda related to
##    each other....maybe I could take into account winner status?

rm(list=ls())

library(tidyverse)
devtools::install_github("celevitz/touRnamentofchampions")

randomizer <- touRnamentofchampions::randomizerlongform
results <- touRnamentofchampions::results

## Keep just the protein information
## only seasons 1 to 5
  protein <- randomizer %>%
    filter(category %in% "protein" & season != 6) %>%
    # Need to flag when there are two proteins. The merge with the score data
    # won't work if there are 2. I may just keep the first instance of a
    # protein from the randomizer, but then I'll put a flag on it so I know
    group_by(season,episode,round,challenge,coast,region) %>%
    mutate(numberofproteins = n()
           ,twoproteins = ifelse(numberofproteins > 1
                                 ,"two proteins","one protein")) %>%
    ungroup() %>%
    # Keep just hte first protein
    filter(numberofproteins ==1 |
             (numberofproteins == 2 & randomizer=="randomizer1")) %>%
    # drop unneeded variables
    select(season,episode,round,challenge,value,subcategory,twoproteins)

    # Change the subcategory of protein to be a factor, so that in the reg.
    # the comparison is to Fish
    protein$subcategory <- relevel(as.factor(protein$subcategory),"Fish")

## Keep just the relevant score information
  scores <- results %>%
    select(!c(note,X8,X9,X10,x,y)) %>%
    filter(season != 6)

## Bring protein data onto the scores
  combined <- scores %>%
    left_join(protein)

## Looking at averages, do the scores differ by category of protein?
  combined %>%
    group_by(subcategory) %>%
    summarise(averagetotal = mean(total,na.rm=T)
              ,numberofscores=n()
              ,numberofbattles = numberofscores/2
              ,percentofbattles = numberofbattles/138
              ,difffromfish = round(averagetotal,1)-84.4) %>%
    arrange(desc(percentofbattles))

  ## how many battles total?
  table(touRnamentofchampions::randomizer$season)

## Regression for total score
  mainreg <- lm(combined$total ~ combined$season + combined$round +
                  #combined$seed +
                  combined$winner + combined$subcategory)
  summary(mainreg)

  # When comparing to Fish: Beef, Pork & other have significantly lower scores





