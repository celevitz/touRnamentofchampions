library(tidyverse)
library(touRnamentofchampions)

results %>%
  left_join(randomizer) %>%
  select(season,episode,round,challenge,chef
         #,score_taste,score_randomizer,score_presentation
         ,total,winner,randomizer1,randomizer2,randomizer3,randomizer4
         ,time,randomizer5) %>%
  group_by(season,round) %>%
  mutate(mintotal=min(total,na.rm=T)) %>%
  filter(total == mintotal) %>%
  filter(round == "Round of 32")



results %>%
  filter((season ==3 & challenge %in% c("Marcel/Shirley","Christian/Tobias")) |
           (season == 4 & challenge == "Carlos/Jet") |
           (season == 5 & challenge == "Britt/Jonathon")) %>%
  select(season,round,challenge,chef,total,winner)


results %>%
  left_join(randomizer) %>%
  select(season,episode,round,challenge,chef
         #,score_taste,score_randomizer,score_presentation
         ,total,winner,randomizer1,randomizer2,randomizer3,randomizer4
         ,time,randomizer5) %>%
  group_by(season) %>%
  mutate(mintotal=min(total,na.rm=T)) %>%
  select(season,challenge,chef,total,mintotal,randomizer1,randomizer2,randomizer3,randomizer4
         ,time,randomizer5) %>%
  filter(total == mintotal)




#########
## Judges

judges %>%
  select(season,episode,judge) %>%
  distinct() %>%
  group_by(judge) %>%
  mutate(numberofepisodes = n()) %>%
  select(!episode) %>%
  distinct() %>%
  mutate(numberofseasons=n()) %>%
  select(judge,numberofepisodes,numberofseasons) %>%
  distinct() %>%
  arrange(desc(numberofseasons)) %>%
  print(n=30)


judges %>%
  distinct() %>%
  left_join(results %>% filter(!(is.na(total)))) %>%
  # keep just the judges who have judged in at least 4 episodes
  #filter(judge %in% c("Nancy Silverton","Ming Tsai","Jonathan Waxman"
  #                    ,"Traci Des Jardins","Rocco DiSpirito","Scott Conant"
  #                    ,"Marcus Samuelsson","Giada de Laurentiis"
  #                    ,"Alex Guarnaschelli","Lorena Garcia","Cat Cora"
  #                    ,"Andrew Zimmern")) %>%
  group_by(judge) %>%
  summarise(averagescore=mean(total,na.rm=T)) %>%
  arrange(desc(averagescore)) %>%
  print(n=30)


judges %>%
  distinct() %>%
  left_join(results %>% filter(!(is.na(total)))) %>%
  #filter(judge %in% c("Nancy Silverton")) %>%
  group_by(judge) %>%
  select(season,episode,round,judge,chef) %>%
  distinct() %>%
  summarise(numberofchefs =n()) %>%
  arrange(desc(numberofchefs))

####################
## Carlos, Shota, Crista, Michael, Chris Scott, Tiffani, Dale, Karen

results %>%
  filter(chef %in% c("Carlos Anthony","Shota Nakajima","Crista Luedtke"
                     ,"Michael Voltaggio","Chris Scott","Tiffani Faison"
                     ,"Dale Talde","Karen Akunowicz")) %>%
  filter(!(is.na(total)) &
           !(round %in% c("Qualifier final","Qualifier semi-final"))
         & season != 5) %>%
  left_join(seeds) %>%
  group_by(chef) %>%
  mutate(winnernumber = ifelse(winner == "Winner",1,0)
         ,battles=n(),averagescore=mean(total,na.rm=T)
          ,wins=sum(winnernumber,na.rm=T),averageseed=mean(seed,na.rm=T)) %>%
  select(season,chef,battles,averagescore,wins,averageseed) %>%
  distinct() %>%
  mutate(numberofseasons = n()) %>%
  select(chef,battles,averagescore,wins,averageseed,numberofseasons) %>%
  distinct() %>%
  arrange(desc(chef))







