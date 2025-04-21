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
#   Document                   devtools::document()

# Check for things that don't yet have documentation library(tools); undoc(touRnamentofchampions)

rm(list=ls())

library(dplyr)
library(tidyr)
library(openxlsx)
library(usethis)
library(rmarkdown)

directory <- "/Users/carlylevitz/Documents/Data/TOC/"

seeds <- as_tibble(read.xlsx(paste(directory,"TOC.xlsx",sep=""),sheet=2))
chefs <- as_tibble(read.xlsx(paste(directory,"TOC.xlsx",sep=""),sheet=3))
randomizer <- as_tibble(read.xlsx(paste(directory,"TOC.xlsx",sep=""),sheet=4))
resultsraw <- as_tibble(read.xlsx(paste(directory,"TOC.xlsx",sep=""),sheet=5))
judges <- as_tibble(read.xlsx(paste(directory,"TOC.xlsx",sep=""),sheet=6))

## for now, remove flag for whether the judge is a person of color
judges <- judges %>%
  select(!personOfColor) %>%
  distinct

## Chefs: add season info (whether they were in main bracket or qualifiers)
  seedstemp <- seeds
  seedstemp$qualifier <- "Main bracket"
  seedstemp$qualifier[seedstemp$seed %in% c("8.2","8.3","8.4","QF") |
                        seedstemp$note %in% "QF winner"] <- "Qualifier"

  mainbracketqualsovertime <- seedstemp %>%
    select(chef,season,qualifier) %>%
    mutate(season=paste0("season",season)) %>%
    group_by(chef) %>%
    mutate(totalseasons = n()) %>%
    group_by(chef,qualifier) %>%
    mutate(seasonstatus = n()) %>%
    ungroup() %>%
    group_by(chef) %>%
    mutate(inqualifiers = max(ifelse(qualifier %in% "Qualifier"
                                     ,seasonstatus,NA), na.rm=T )
          ,inmainbracket = max(ifelse(qualifier %in% "Main bracket"
                                      ,seasonstatus,NA), na.rm=T ))

    # how many times were they in qualifiers and main bracket?
    mainbracketqualsovertime$inqualifiers[is.infinite(
      mainbracketqualsovertime$inqualifiers) | is.nan(
        mainbracketqualsovertime$inqualifiers) ] <- 0
    mainbracketqualsovertime$inmainbracket[is.infinite(
      mainbracketqualsovertime$inmainbracket) | is.nan(
        mainbracketqualsovertime$inmainbracket)] <- 0
    mainbracketqualsovertime$seasonstatus <- NULL
    mainbracketqualsovertime <- mainbracketqualsovertime %>%
      pivot_wider(names_from=season,values_from=qualifier)

    # Combine with chef data
    chefs <- chefs %>%
      full_join(mainbracketqualsovertime)




## Add variable to results for the winner
results <- resultsraw %>%
  group_by(season,episode,round,challenge) %>%
  mutate(highesttotal = max(total,na.rm=T)
         ,highesttaste = max(score_taste,na.rm=T)
         ,highestpresentation=max(score_presentation,na.rm=T)
         ,highestrandomizer=max(score_randomizer,na.rm=T)
         ,winner = case_when(total == highesttotal ~ "Winner"
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
  # Antonia/Jet was a true tie, that was then rematched
  # Aarthi/Karen was tied in total score & taste, so went to randomizer score
  # Carlos/Jet total tied, Jet won in taste
  # qualifier semi-finals had two winners
  mutate(winner = case_when(season == 2 & challenge == "Aarthi/Karen" &
                              chef == "Aarthi Sampath" ~ "Winner"
                            ,season == 2 & challenge == "Aarthi/Karen" &
                              chef == "Karen Akunowicz" ~ "Loser"
                            ,season == 5 & challenge == "Carlos/Jet" &
                              chef == "Jet Tila" ~ "Winner"
                            ,season == 5 & challenge == "Carlos/Jet" &
                              chef == "Carlos Anthony" ~ "Loser"
                            ,season == 5 & round == "Qualifier semi-final" &
                              chef %in% c("Leah Cohen","Michael Reed"
                                          ,"Chris Scott","Bruce Kalman") ~ "Winner"
                            ,TRUE ~ winner)) %>%
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
                       ,round=="Qualifier final" & grepl("East",coast) ~ 130
                       ,round=="Qualifier final" & grepl("West",coast) ~ -30
                       ,round=="Qualifier semi-final" & grepl("East",coast) ~ 145
                       ,round=="Qualifier semi-final" & grepl("West",coast) ~ -45)
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
             ,round == "Semi-final" & is.na(region) ~ 17
             ,round == "Semi-final" & is.na(region) ~ 13
             ,round == "Semi-final" & seed %in% c(1,8,4,5) & is.na(region) ~ 11
             ,round == "Semi-final" & seed %in% c(3,6,2,7) & is.na(region) ~ 4
             ,round == "Final" & winner == "Winner" & !(is.na(region)) ~16
             ,round == "Final" & winner == "Loser" & !(is.na(region))~14
             ,round == "Final" & winner == "Winner" & is.na(region) ~10
             ,round == "Final" & winner == "Loser" & is.na(region) ~8)
    ) %>%
    select(!seed)

    ## add y values for qualifiers
        # A region winners
        results$y[results$round %in% c("Qualifier semi-final","Qualifier final") &
                    results$season == 5 &
                    results$chef %in% c("Kevin Lee","Nini Nguyen")] <- 29

        # B region winners
        results$y[results$round %in% c("Qualifier semi-final","Qualifier final") &
                    results$season == 5 &
                    results$chef %in% c("Michael Reed","Chris Scott")] <- 11

        # A region runner-ups
        results$y[results$round %in% c("Qualifier semi-final","Qualifier final") &
                    results$season == 5 &
                    results$chef %in% c("Bruce Kalman","Leah Cohen")] <- 27

        # B region runner-ups
        results$y[results$round %in% c("Qualifier semi-final","Qualifier final") &
                    results$season == 5 &
                    results$chef %in% c("Demetrio Zavala","Ray Garcia")] <- 9

        # A region 3rd placers
        results$y[results$round %in% c("Qualifier semi-final") &
                    results$season == 5 &
                    results$chef %in% c("Ilan Hall","Maria Mazon")] <- 25

        # B region 3rd placers
        results$y[results$round %in% c("Qualifier semi-final") &
                    results$season == 5 &
                    results$chef %in% c("Justin Sutherland","Claudia Sandoval")] <- 7

        # A region last place
        results$y[results$round %in% c("Qualifier semi-final") &
                    results$season == 5 &
                    results$chef %in% c("Gerald Sombright","Aaron May")] <- 23

        # B region last place
        results$y[results$round %in% c("Qualifier semi-final") &
                    results$season == 5 &
                    results$chef %in% c("Adriana Urbina","Pyet Despain")] <- 5

    ## Fix y values for semi-finals
      results$y[results$round == "Semi-final" & results$season == 1 &
                  results$chef %in% c("Antonia Lofaso","Amanda Freitag")] <- 11

      results$y[results$round == "Semi-final" & results$season == 1 &
                  results$chef %in% c("Brooke Williamson","Maneet Chauhan")] <- 3

      results$y[results$round == "Semi-final" & results$season == 2 &
                  results$chef %in% c("Brooke Williamson","Darnell Ferguson")] <- 11

      results$y[results$round == "Semi-final" & results$season == 2 &
                  results$chef %in% c("Jet Tila","Maneet Chauhan")] <- 3

      results$y[results$round == "Semi-final" & results$season == 3 &
                  results$chef %in% c("Jet Tila","Tobias Dorzon")] <- 14

      results$y[results$round == "Semi-final" & results$season == 5 &
                  results$chef %in% c("Antonia Lofaso","Maneet Chauhan")] <- 20

      results$y[results$round == "Semi-final" & results$season == 5 &
                  results$chef %in% c("Jet Tila","Britt Rescigno")] <- 14

    # fix y values for final
      results$y[results$round == "Final" & results$season == 5 &
                  results$chef %in% c("Antonia Lofaso")] <- 15

      results$y[results$round == "Final" & results$season == 5 &
                  results$chef %in% c("Maneet Chauhan")] <- 19

## Create long-form randomizer data
      randomizerlongform <- randomizer %>%
        pivot_longer(!c(season,episode,round,challenge,coast,region,time)
                     ,names_to = "randomizer"
                     ,values_to = "value") %>%
        mutate(category = case_when(randomizer == "randomizer1" ~ "protein"
                                    ,randomizer == "randomizer2" ~ "produce"
                                    ,randomizer == "randomizer3" ~ "equipment"
                                    ,randomizer == "randomizer4" ~ "style"
                                    ,randomizer == "randomizer5" ~ "wildcard" )
               ,subcategory = case_when(
                 # protein subcategories
                 grepl("beef",tolower(value)) ~ "Beef"
                 ,grepl("veal",tolower(value)) ~ "Beef"
                 ,grepl("rabbit",tolower(value)) ~ "Game"
                 ,grepl("lamb",tolower(value)) ~ "Game"
                 ,grepl("goat",tolower(value)) ~ "Game"
                 ,grepl("venison",tolower(value)) ~ "Game"
                 ,grepl("bison",tolower(value)) ~ "Game"
                 ,grepl("goose",tolower(value)) ~ "Game"
                 ,grepl("quail",tolower(value)) ~ "Game"
                 ,grepl("pheasant",tolower(value)) ~ "Game"
                 ,grepl("squab",tolower(value)) ~ "Game"
                 ,grepl("chicken",tolower(value)) ~ "Poultry"
                 ,grepl("duck",tolower(value)) ~ "Poultry"
                 ,grepl("turkey",tolower(value)) ~ "Poultry"
                 ,grepl("cornish game",tolower(value)) ~ "Poultry"
                 ,grepl("pork",tolower(value)) ~ "Pork"
                 ,value %in% c("Bacon","Bratwurst","Double-cut pork chops","Ham","Italian sausage","Pancetta","Porcelet loin","Scrapple") ~ "Pork"
                 ,value %in% c("Boneless ribeye","Denver steak","Filet mignon","Flank steak","Flanken short ribs","Flat iron steaks","Hangar steak","Longbone ribeye","New York strip","Picanha","Porterhouse steak","Skirt steak","Stew meat","Strip steak","Top round steak","Top sirloin","Top sirloin steak","Tri-tip") ~ "Beef"
                 ,value %in% c("Alligator","Wild partridge","Guinea hen") ~ "Game"
                 ,value %in% c("Arctic char","Blowfish tails","Calamari steak","Calamari tubes & tentacles","Canned sardines","Catfish","Cod","Dover sole","Grouper","Halibut","Halibut cheeks","Hamachi collars","Lingcod collar","Mahi mahi","Mackerel","Red snapper","Rockfish","Salmon","Sea trout","Skate","Sturgeon","Swordfish","Tilapia","Whole branzino","Whole halibut","Whole kanpachi","Whole pompano","Yellowfin tuna") ~ "Fish"
                 ,value %in% c("Crab meat","Dungeness crab","Langoustine","Littleneck clams","Lobster tail","Mussels","Oysters","Razor clams","Scallops","Shrimp","Stone crab claws","Tiger prawns","Whole lobster") ~ "Shellfish"
                 ,value %in% c("Chapulines","Eggs","Tempeh","Tofu") ~ "Other"
                 # style sub categories
                 ,value %in% c("Caribbean","European","Greek","Italian dinner","Latin American","Mediterranean","Middle Eastern","North African") ~ "Region/country"
                 ,value %in% c("Breaded","Breakfast, lunch, and dinner","Candlelit dinner","Champagne brunch","Comfort classic","Date night dinner","Decadent dish","Destination dinner","Fast food favorite","Game day feast","Go-to takeout","Guilty pleasure","High-end lunch","High-end and low-end","Hot lunch","Lunch special","New Year's Eve dinner","One ingredient three ways","Reinvented classic","Romantic dinner","Soup & sandwich","Steakhouse dinner","Sunday brunch","Sunday supper","Updated classic","Weeknight dinner") ~ "Theme"
                 ,value %in% c("Spice grinder","Toaster") ~ "Equipment"
                 ,category == "style" ~ "Style"
                 ,category == "produce" ~ "Produce"
                 ,category == "equipment" ~ "Equipment"
                 # wildcard subcategories
                 ,value %in% c("Black garlic","Canned carrots","Canned green beans","Canned mushroom","Canned pineapple","Green grapes","Habanero","Vanilla beans") ~ "Produce"
                 ,value %in% c("Bread and butter pickles","Camel milk","Graham crackers","Instant coffee","Pepper jelly","Pretzel sticks","Sourkraut","Steel-cut oats","Star pasta","Strawberry jam","Tapioca malodextrin","Wildcard ingredient: camel milk","Xanthan gum","Yellow mustard") ~ "Other"
                 ,value %in% c("Two envelopes: spicy and layered") ~ "Style"
               )
               # update the category based on value
               ,category = case_when(subcategory == "Produce" ~ "produce"
                                     ,subcategory == "Equipment" ~ "equipment"
                                     ,subcategory %in% c("Region/country","Style","Theme") ~ "style"
                                  ,subcategory %in% c("Beef","Fish","Game","Pork","Poultry","Shellfish") ~ "protein"
                                  ,TRUE ~ category)
               ) %>%
        filter(!(is.na(value)))

## remove grouping variables because it was causing problems for me in analysis
      seeds <- seeds %>% ungroup()
      chefs <- chefs %>% ungroup()
      randomizer <- randomizer %>% ungroup()
      randomizerlongform <- randomizerlongform %>% ungroup()
      results <- results %>% ungroup()
      judges <- judges %>% ungroup()
## save things as RDA

save(seeds, file = "data/seeds.rda")
save(chefs, file = "data/chefs.rda")
save(randomizer, file = "data/randomizer.rda")
save(randomizerlongform, file = "data/randomizerlongform.rda")
save(results, file = "data/results.rda")
save(judges, file = "data/judges.rda")

## Save things to my desktop for Tableau
      write.csv(seeds,paste0(directory,"/seeds.csv"),row.names=F)
      write.csv(results ,paste0(directory,"/results.csv"),row.names=F)
      write.csv(judges,paste0(directory,"judges.csv"),row.names=F)
      write.csv(chefs,paste0(directory,"/chefs.csv"),row.names=F)
      write.csv(randomizer,paste0(directory,"randomizer.csv"),row.names=F)
      write.csv(randomizerlongform,paste0(directory,"randomizerlongform.csv"),row.names=F)



# Check for CRAN specific requirements
#results <- rhub::check_for_cran()
#results$cran_summary()
#usethis::use_cran_comments()

## Pushing to CRAN
## devtools::build_readme()
## devtools::document()
## cmd shift b
## cmd shift e
## devtools::spell_check()
## devtools::check()
## devtools::check_rhub()
## devtools::check_win_devel()
## devtools::release()

