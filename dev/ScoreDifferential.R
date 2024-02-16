library(tidyverse)
library(ggbump)
library(touRnamentofchampions)

rm(list=ls())


## Score differential in each category
## Seed differential

results<- touRnamentofchampions::results %>%
  filter(season !=5 & winner != "Tie") %>%
  left_join(touRnamentofchampions::seeds %>% filter(season !=5)) %>%
  select(!c(x,y,coast,region,commentator,order,chef)) %>%
  pivot_wider(names_from=c(winner)
              ,values_from =c(score_taste,score_randomizer,score_presentation
                              ,total,seed)
  ) %>%
  mutate(tastediff=score_taste_Winner-score_taste_Loser
         ,randomizerdiff=score_randomizer_Winner-score_randomizer_Loser
         ,presentationdiff = score_presentation_Winner-score_presentation_Loser
         ,totaldiff = total_Winner - total_Loser
         ,seeddiff = seed_Winner-seed_Loser) %>%
  select(c(season,episode,round,challenge,tastediff,randomizerdiff
           ,presentationdiff,totaldiff,seeddiff)) %>%
  pivot_longer(!c(season,episode,round,challenge),names_to="measure",values_to="difference")

results$round <- factor(results$round
                        ,levels=c("Qualifier semi-final","Qualifier final",
                                  "Round of 32","Round of 16","Quarter-final"
                                  ,"Semi-final","Final")
                        ,labels=c("Qualifier\nsemi-final (n=4)","Qualifier\nfinal (n=2)",
                                  "Round of 32\n(n=32)","Round of 16\n(n=32) ","Quarter-final\n(n=17)"
                                  ,"Semi-final\n(n=8)","Final\n(n=4)")
                        ,ordered=TRUE)
results$measure <- factor(results$measure
                          ,levels=c("totaldiff","tastediff","randomizerdiff"
                                    ,"presentationdiff","seeddiff")
                          ,labels=c("Total score\n(0 to 100)","Taste score\n(0 to 50)"
                                    ,"Randomizer score\n(0 to 30)","Presentation score\n(0 to 20)"
                                    ,"Seed")
                          ,ordered=TRUE)

summary <- results %>%
  group_by(round,measure,difference) %>%
  summarise(n=n())

dropseed <- summary %>%
  filter(measure != "Seed")

#results[results$measure == "Taste score (0 to 50)" & results$difference < 0,]
#touRnamentofchampions::results %>% filter(challenge %in% c("Alex/Darnell","Christian/Marc","Amanda/Darnell","Britt/Tiffani","Antonia/Shota","Manett/Richard","Christian/Tobias","Tiffani/Tobias"))


## Graphs of differentials
png("~/touRnamentofchampions/dev/images/ScoreDifferentials.png",width=1080,height=1080,units="px")

  ggplot(data=dropseed,aes(x=difference,y=n)) +
    geom_vline(xintercept=0,col="gray74") +
    geom_bar(stat="identity",fill="navyblue",col="lemonchiffon") +
    facet_grid(round ~ measure) +
    xlab("Amount of difference between winner and loser") +
    ylab("Number of battles") +
    #theme_minimal() +
    theme(panel.grid = element_blank()
          ,plot.title=element_text(hjust=.5,color="black",size=22,face="bold")
          ,plot.subtitle=element_text(hjust=.5,color="black",size=20)
          ,plot.caption =element_text(color="black",size=16)
          ,plot.background = element_rect(fill="floralwhite")
          ,axis.text = element_text(color="black",size=18)
          ,axis.title = element_text(color="black",size=18)
          ,legend.text = element_text(color="black",size=13)
          ,legend.title = element_text(color="black",size=15,face="bold")
          ,legend.background = element_rect(fill=NA,color=NA)
          ,legend.position="bottom"
          ,strip.text = element_text(color="lemonchiffon",size=15)
          ,strip.background = element_rect(fill = "navyblue")) +
    labs(title="Tournament of Champions I, II, III, and IV: Score Differentials by Round"
         ,subtitle="For scores, a negative differential indicates the winner scored lower than the loser.\nThe total score differential will always be positive or 0."
         ,caption="\nNotes:Ns for rounds are the number of battles across seasons. Antonia/Jet battled in two quarter-finals.\n\nData: github.com/celevitz/touRnamentofchampions /// Twitter @carlylevitz /// Instagram @carly.sue.bear")


dev.off()









