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
  pivot_longer(!c(season,episode,round,challenge),names_to="measure",values_to="difference")%>%
  mutate(battle=paste0(round,season,challenge))

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

#################################################################################
## Individual battle differentials
## Issue: I can't get the graph to go in order of the round.

noseed <- results %>%
  filter(!(measure %in% c( "Seed","Total score\n(0 to 100)")))

noseed$measure <- factor(noseed$measure
                          ,levels=c("Taste score\n(0 to 50)"
                                    ,"Randomizer score\n(0 to 30)"
                                    ,"Presentation score\n(0 to 20)")
                         ,labels=c("Taste score (0 to 50)"
                                   ,"Randomizer score (0 to 30)"
                                   ,"Presentation score (0 to 20)")
                          ,ordered=TRUE)

noseed <- noseed %>%
  arrange(round,season,episode,challenge,measure) %>%
  group_by(round,measure) %>%
  mutate(battle = row_number())

png("~/touRnamentofchampions/dev/images/ScoreDifferentials_IndividualBattles.png",width=1080,height=1080,units="px")

ggplot(noseed,aes(x=battle,y=difference,fill=round)) +
  geom_bar(stat="identity",col="gray20") +
  facet_wrap(~measure) +
  coord_flip() +
  ylab("Amount of difference between winner and loser") +
  scale_y_continuous(lim=c(-6,10)) +
  guides(fill=guide_legend(ncol=7)) +
  theme(panel.grid = element_blank()
        ,plot.title=element_text(hjust=.5,color="black",size=22,face="bold")
        ,plot.subtitle=element_text(hjust=.5,color="black",size=20)
        ,plot.caption =element_text(color="black",size=16)
        ,plot.background = element_rect(fill="floralwhite")
        ,axis.text.x = element_text(color="black",size=18)
        ,axis.title.x = element_text(color="black",size=18)
        ,axis.text.y = element_blank()
        ,axis.title.y = element_blank()
        ,axis.ticks.y = element_blank()
        ,legend.text = element_text(color="black",size=13)
        ,legend.title = element_text(color="black",size=15,face="bold")
        ,legend.background = element_rect(fill=NA,color=NA)
        ,legend.position = "bottom"
        ,strip.text = element_text(color="lemonchiffon",size=18)
        ,strip.background = element_rect(fill = "navyblue")) +
  labs(title="Tournament of Champions I, II, III, and IV: Taste Score Differentials by Battle"
       ,subtitle="For scores, a negative differential indicates the winner scored lower than the loser.\nThe total score differential will always be positive or 0."
       ,caption="\nNotes:Ns for rounds are the number of battles across seasons. Antonia/Jet battled in two quarter-finals.\n\nData: github.com/celevitz/touRnamentofchampions /// Twitter @carlylevitz /// Instagram @carly.sue.bear")

dev.off()

#################################################################################
## Differentials: summary

table <- touRnamentofchampions::results %>%
  filter(winner != "Tie" & !(is.na(total))) %>%
  left_join(touRnamentofchampions::seeds) %>%
  select(!c(x,y,coast,region,commentator,order,chef)) %>%
  # because there are some battles with more than two chefs
  # make sure you take the highest and lowest scores
  group_by(season,episode,round,challenge) %>%
  mutate(min_total=min(total,na.rm=T),max_total=max(total,na.rm=T)) %>%
  filter(total==max_total | total == min_total) %>%
  mutate(id=row_number()
         ,maxid=max(id,na.rm=T)
         ,min_taste=min(score_taste,na.rm=T)
         ,min_taste = case_when(is.infinite(min_taste) ~ NA
                          ,TRUE ~ min_taste) ) %>%
  filter( !(winner == "Loser" & maxid > 2 & score_taste != min_taste) ) %>%
  select(!c(min_total,max_total,id,maxid,min_taste)) %>%
  # get the differences
  # first need to reshape the data
  pivot_wider(names_from=c(winner)
              ,values_from =c(score_taste,score_randomizer,score_presentation
                              ,total,seed)  ) %>%
  mutate(tastediff=score_taste_Winner-score_taste_Loser
         ,randomizerdiff=score_randomizer_Winner-score_randomizer_Loser
         ,presentationdiff = score_presentation_Winner-score_presentation_Loser
         ,totaldiff = total_Winner - total_Loser
         ,seeddiff = seed_Winner-seed_Loser) %>%
  group_by(round) %>%
  summarise(tastediff=round(mean(tastediff,na.rm=T),1)
            ,randomizerdiff=round(mean(randomizerdiff,na.rm=T),1)
            ,presentationdiff=round(mean(presentationdiff,na.rm=T),1)
            ,totaldiff=round(mean(totaldiff,na.rm=T),1)
            ,seeddiff=round(mean(seeddiff,na.rm=T),1)
            ,seed_Winner=round(mean(seed_Winner,na.rm=T),1)
            ,seed_Loser=round(mean(seed_Loser,na.rm=T),1)
            ,n=n())

table$round <- factor(table$round
                        ,levels=c("Qualifier semi-final","Qualifier final",
                                  "Round of 32","Round of 16","Quarter-final"
                                  ,"Semi-final","Final")
                        ,labels=c("Qualifier semi-final","Qualifier final",
                                  "Round of 32","Round of 16","Quarter-final"
                                  ,"Semi-final","Final")
                        ,ordered = TRUE
                      )
table <- table %>%
  arrange(round)
table


