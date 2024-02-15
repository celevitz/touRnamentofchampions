# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#     Other checks:             rhub::check_for_cran()
#                               devtools::check()
#   Test Package:              'Cmd + Shift + T'
#   Knit                       'Cmd + Shift + K'
#   Load the data              'Cmd + Shift + L'

# Check for things that don't yet have documentation library(tools); undoc(touRnamentofchampions)

rm(list=ls())

library(tidyverse); library(openxlsx); library(usethis); library(rmarkdown)

directory <- "/Users/carlylevitz/Documents/Data/TOC/"

seeds <- as_tibble(read.xlsx(paste(directory,"TOC.xlsx",sep=""),sheet=2))
chefs <- as_tibble(read.xlsx(paste(directory,"TOC.xlsx",sep=""),sheet=3))
randomizer <- as_tibble(read.xlsx(paste(directory,"TOC.xlsx",sep=""),sheet=4))
resultsraw <- as_tibble(read.xlsx(paste(directory,"TOC.xlsx",sep=""),sheet=5))
judges <- as_tibble(read.xlsx(paste(directory,"TOC.xlsx",sep=""),sheet=6))



## Add variable to results for the winner
results <- resultsraw %>%
  group_by(season,episode,round,challenge) %>%
  mutate(highesttotal = max(total,na.rm=T)
         ,highesttaste = max(score_taste,na.rm=T)
         ,highestpresentation=max(score_presentation,na.rm=T)
         ,highestrandomizer=max(score_randomizer,na.rm=T)
         ,winner = case_when(total == highesttotal &
                               score_taste == highesttaste &
                               score_randomizer == highestrandomizer &
                               score_presentation == highestpresentation ~ "Winner"
                             # Amanda/Madison challenge where Madison gets disqualified
                             ,order == "Auto-win" ~ "Winner"
                             ,TRUE ~ "Loser")
        ) %>%
  ungroup() %>%
  group_by(season,episode,round,challenge,winner) %>%
  mutate(
    # check for ties
    id = row_number()
    ,multipleresults=max(id)
    ,multipleresults=ifelse(winner == "Loser",NA,multipleresults)
    ,winner=case_when(multipleresults > 1~"Tie"
                      ,TRUE ~ winner)
    ) %>%
  select(!c(highesttotal,highesttaste,highestpresentation,highestrandomizer,id,multipleresults))


## Add Y & X values to support the bracket creation
# Note: still need y values for Qualifier rounds
  results <- results %>%
    left_join(seeds) %>%
    mutate(x=case_when(round=="Round of 32" & grepl("East",coast) ~ 100
                       ,round=="Round of 32" & grepl("West",coast) ~ 0
                       ,round=="Round of 16" & grepl("East",coast) ~ 85
                       ,round=="Round of 16" & grepl("West",coast) ~ 15
                       ,round=="Quarter-final" & grepl("East",coast) ~ 70
                       ,round=="Quarter-final" & grepl("West",coast) ~ 30
                       ,round=="Semi-final" & grepl("East",coast) ~ 60
                       ,round=="Semi-final" & grepl("West",coast) ~ 40
                       ,round=="Final"  ~ 50
                       ,round=="Qualifier final" & grepl("East",coast) ~ 115
                       ,round=="Qualifier final" & grepl("West",coast) ~ -15
                       ,round=="Qualifier semi-final" & grepl("East",coast) ~ 130
                       ,round=="Qualifier semi-final" & grepl("West",coast) ~ -30)
           ,y = case_when(round == "Round of 32" & seed == 8 & region == "A" ~ 30
             ,round == "Round of 32" & seed == 1 & region == "A" ~ 28
             ,round == "Round of 32" & seed == 4 & region == "A" ~ 26
             ,round == "Round of 32" & seed == 5 & region == "A" ~ 24
             ,round == "Round of 32" & seed == 3 & region == "A" ~ 22
             ,round == "Round of 32" & seed == 6 & region == "A" ~ 20
             ,round == "Round of 32" & seed == 2 & region == "A" ~ 18
             ,round == "Round of 32" & seed == 7 & region == "A" ~ 16
             ,round == "Round of 32" & seed == 1 & region == "B" ~ 14
             ,round == "Round of 32" & seed == 8 & region == "B" ~ 12
             ,round == "Round of 32" & seed == 4 & region == "B" ~ 10
             ,round == "Round of 32" & seed == 5 & region == "B" ~ 8
             ,round == "Round of 32" & seed == 3 & region == "B" ~ 6
             ,round == "Round of 32" & seed == 6 & region == "B" ~ 4
             ,round == "Round of 32" & seed == 2 & region == "B" ~ 2
             ,round == "Round of 32" & seed == 7 & region == "B" ~ 0
             ,round == "Round of 16" & seed %in% c(1,8) & region == "A"  ~ 29
             ,round == "Round of 16" & seed %in% c(4,5) & region == "A" ~ 25
             ,round == "Round of 16" & seed %in% c(3,6) & region == "A" ~ 21
             ,round == "Round of 16" & seed %in% c(2,7) & region == "A" ~ 17
             ,round == "Round of 16" & seed %in% c(1,8) & region == "B" ~ 13
             ,round == "Round of 16" & seed %in% c(4,5) & region == "B" ~ 9
             ,round == "Round of 16" & seed %in% c(3,6) & region == "B" ~ 5
             ,round == "Round of 16" & seed %in% c(2,7) & region == "B" ~ 1
             ,round == "Round of 16" & seed == 1 & is.na(region) ~ 14
             ,round == "Round of 16" & seed == 8 & is.na(region)  ~ 12
             ,round == "Round of 16" & seed == 4 & is.na(region) ~ 10
             ,round == "Round of 16" & seed == 5 & is.na(region) ~ 8
             ,round == "Round of 16" & seed == 3 & is.na(region) ~ 6
             ,round == "Round of 16" & seed == 6 & is.na(region) ~ 4
             ,round == "Round of 16" & seed == 2 & is.na(region) ~ 2
             ,round == "Round of 16" & seed == 7 & is.na(region) ~ 0
             ,round == "Quarter-final" & seed %in% c(1,8,4,5) & region == "A" ~ 24
             ,round == "Quarter-final" & seed %in% c(3,6,2,7) & region == "A" ~ 22
             ,round == "Quarter-final" & seed %in% c(1,8,4,5) & region == "B" ~ 8
             ,round == "Quarter-final" & seed %in% c(3,6,2,7) & region == "B" ~ 6
             ,round == "Quarter-final" & seed %in% c(1,8) & is.na(region) ~ 13
             ,round == "Quarter-final" & seed %in% c(4,5) & is.na(region) ~ 9
             ,round == "Quarter-final" & seed %in% c(3,6) & is.na(region) ~ 5
             ,round == "Quarter-final" & seed %in% c(2,7) & is.na(region) ~ 1
             ,round == "Semi-final" & region == "A" ~ 17
             ,round == "Semi-final" & region == "B" ~ 13
             ,round == "Semi-final" & seed %in% c(1,8,4,5) & is.na(region) ~ 11
             ,round == "Semi-final" & seed %in% c(3,6,2,7) & is.na(region) ~ 4
             ,round == "Final" & winner == "Winner" & !(is.na(region)) ~16
             ,round == "Final" & winner == "Loser" & !(is.na(region))~14
             ,round == "Final" & winner == "Winner" & is.na(region) ~10
             ,round == "Final" & winner == "Loser" & is.na(region) ~8)
    ) %>%
    select(!seed)




## save things as RDA

save(seeds, file = "data/seeds.rda")
save(chefs, file = "data/chefs.rda")
save(randomizer, file = "data/randomizer.rda")
save(results, file = "data/results.rda")
save(judges, file = "data/judges.rda")


# Check for CRAN specific requirements
#results <- rhub::check_for_cran()
#results$cran_summary()
#usethis::use_cran_comments()


## update readme: devtools::build_readme()

