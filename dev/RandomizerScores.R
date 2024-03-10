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
