rm(list=ls())

library(tidyr)

directory <- "/Users/carlylevitz/Documents/Data/TOC/"

chefs <- read.csv(paste0(directory,"chefs.csv"),header=T)
results <- read.csv(paste0(directory,"results.csv"),header=T)
seeds <- read.csv(paste0(directory,"seeds.csv"),header=T)

## Keep just quarter final (elite 8)
elite8 <- results %>%
  filter(round == "Quarter-final") %>%
  select(season,chef) %>%
  # get rid of duplicates (due to Jet/Antonia tie in S2)
  distinct() %>%
  #merge on seed information
  left_join(seeds %>%
              select(chef,season,seed)) %>%
  # merge on gender information
  left_join(chefs %>% select(chef,gender)) %>%
  # are they on top chef?
  group_by(chef) %>%
  mutate(seed = as.numeric(seed)
        ,TopChef = ifelse(chef %in% c("Antonia Lofaso","Brooke Williamson"
                                      ,"Michael Voltaggio","Tiffani Faison"
                                      ,"Shirley Chung","Karen Akunowicz"
                                      ,"Mei Lin","Shota Nakajima"
                                      ,"Kaleena Bliss","Joe Sasto",
                                      "Lee Anne Wong","Sara Bradley"
                                      ,"Nini Nguyen")
                          ,1,0)
         ,seed1 = ifelse(seed == 1,1,0)
        ,seed8 = ifelse(seed == 8,1,0)
        ,female = ifelse(gender == "female",1,0)
         ,temp=1
          ,firstseason=min(season)
        ,lastseason=max(season)
         ,numtimesinelite8 = n()
        ,onlybeeninelite8once = ifelse(firstseason==lastseason,1,0)
        )

  elite8stats <- elite8 %>% ungroup() %>%
  # Season statistics
  group_by(season) %>%
  summarise(numberofTopChefs = sum(TopChef)
            ,percentwomen = mean(female)
            ,numberofNo1seeds=sum(seed1)
            ,numberofNo8seeds=sum(seed8)
            ,averageseed = mean(seed)
            #,avgnumbertimesinelite8 = mean(numtimesinelite8)
            ,numChefsThatonlyBeenInElite8once=sum(onlybeeninelite8once)) %>%
    left_join(chefs %>%
      select(chef,gender,season1,season2,season3,season4,season5,season6) %>%
      pivot_longer(!c(chef,gender),names_to = "season",values_to = "value") %>%
      filter(!is.na(value)) %>%
      select(!value) %>%
      group_by(season) %>%
      mutate(female = ifelse(gender=="female",1,0)) %>%
      summarise(percentWomenInWholeSeason = mean(female)) %>%
      mutate(season = as.numeric(gsub("season","",season)))
    )


