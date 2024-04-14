library(tidyverse)
#library(touRnamentofchampions)
library(ggbump)
library(ggplot2)
library(devtools)

devtools::install_github("celevitz/touRnamentofchampions")

rm(list=ls())


## Set up the data
season5bracket <- touRnamentofchampions::results %>%
  filter(season == 5) %>%
  left_join(touRnamentofchampions::seeds) %>%
  select(!season)

## Bump chart data
bumpdata <- season5bracket %>% select(round,chef,total,seed,coast,challenge,x,y,winner) %>%
  mutate(challengelong=case_when(round %in% c("Qualifier semi-final"
                                              ,"Qualifier final","Round of 32"
                                              ,"Round of 16","Quarter-final") ~ paste(round,coast,challenge,sep="_"),
                                 round %in% c("Semi-final") & grepl("East",coast) ~"Semi-final_East",
                                 round %in% c("Semi-final") & grepl("West",coast) ~"Semi-final_West",
                                 round %in% c("Final") ~ round)
         ,alignment=case_when(grepl("East",coast) & round=="Qualifier semi-final"~ 0
                              ,grepl("East",coast) & round=="Round of 32"~ 0
                              ,grepl("West",coast) & round=="Qualifier semi-final"~ 1
                              ,grepl("West",coast) & round=="Round of 32"~ 1
                              ,TRUE ~ NA)
         #,chefseed=ifelse(grepl("East",coast),paste(chef," (",seed," seed)",sep=""),paste("(",seed," seed) ",chef,sep=""))
  ) %>%
  group_by(challengelong) %>%
  mutate(sizeofdot=case_when(total < 80 & !(is.na(total)) ~ "75 to 79"
                             ,total >= 80 & total <85 ~ "80 to 84"
                             ,total >= 85 & total <90 ~ "85 to 89"
                             ,total >= 90 & !(is.na(total)) ~ "90+")
         ,cheflabelx=ifelse(grepl("East",coast),x+5,x-5)
  ) %>%
  ungroup() %>%
  group_by(sizeofdot) %>%
  mutate(sizeofdot=paste(sizeofdot," (occured ",n()," times)",sep="")) %>%
  ungroup(sizeofdot)

## Vertical data
verticaldata <- bumpdata %>%
  select(challengelong,y) %>%
  arrange(challengelong)%>%
  group_by(challengelong) %>%
  distinct() %>%
  mutate(miny=min(y),maxy=max(y)) %>%
  filter(y == maxy | y == miny) %>%
  ungroup()

verticaldata <- verticaldata %>%
  mutate(yindic=ifelse(as.numeric(row.names(verticaldata)) %% 2 == 0,"Y2","Y1")) %>%
  pivot_wider(names_from="yindic",values_from="y") %>%
  left_join(bumpdata %>% select(challengelong,x,coast) %>% distinct()) %>%
  mutate(X2=x)


## Bump chart visual
bumpdata %>%
  ggplot() +
  # add vertical lines to indicate who competed against whom
  geom_segment(data=verticaldata,aes(x=x,xend=X2,y=Y1,yend=Y2),lty=2,color="#57606c") +
  # bump lines
  geom_bump(aes(x=bumpdata$x,y=bumpdata$y,fill=bumpdata$chef),color="#57606c" ) +
  # dots -- and highlight the winners
  geom_point(data=bumpdata,aes(x=x,y=y,color=sizeofdot,size=sizeofdot,shape=sizeofdot),fill="#1170AA" )+
  geom_point(data=bumpdata %>% filter(winner=="Winner"),
             aes(x=x,y=y),shape=21,color="#57606c",fill="transparent",size=7) +
  annotate("text",x=bumpdata$cheflabelx[bumpdata$round == "Round of 32" & bumpdata$seed < 8]
           ,y=bumpdata$y[bumpdata$round == "Round of 32" & bumpdata$seed < 8]
           ,label=bumpdata$chef[bumpdata$round == "Round of 32" & bumpdata$seed < 8]
           ,hjust=bumpdata$alignment[bumpdata$round == "Round of 32" & bumpdata$seed < 8]
           ,size=2.5) +
  annotate("text",x=bumpdata$cheflabelx[bumpdata$round == "Round of 32" & bumpdata$seed < 8]
           ,y=bumpdata$y[bumpdata$round == "Round of 32" & bumpdata$seed < 8]-.7
           ,label=paste(bumpdata$seed[bumpdata$round == "Round of 32" & bumpdata$seed < 8],"seed",sep=" ")
           ,hjust=bumpdata$alignment[bumpdata$round == "Round of 32" & bumpdata$seed < 8]
           ,size=2) +
  annotate("text",x=bumpdata$cheflabelx[bumpdata$round == "Qualifier semi-final" & bumpdata$seed >= 8]
           ,y=bumpdata$y[bumpdata$round == "Qualifier semi-final" & bumpdata$seed >= 8]
           ,label=bumpdata$chef[bumpdata$round == "Qualifier semi-final" & bumpdata$seed >= 8]
           ,hjust=bumpdata$alignment[bumpdata$round == "Qualifier semi-final" & bumpdata$seed >= 8]
           ,size=2.5) +
  annotate("text",x=bumpdata$cheflabelx[bumpdata$round == "Qualifier semi-final" & bumpdata$seed >= 8]
           ,y=bumpdata$y[bumpdata$round == "Qualifier semi-final" & bumpdata$seed >= 8]-.7
           ,label=paste(bumpdata$seed[bumpdata$round == "Qualifier semi-final" & bumpdata$seed >= 8],"seed",sep=" ")
           ,hjust=bumpdata$alignment[bumpdata$round == "Qualifier semi-final" & bumpdata$seed >= 8]
           ,size=2) +
  scale_x_continuous(limits=c(-90,170),breaks=c(-45,-30,0,15,30,40,50,60,70,85,100,130,145),
                     labels=c("Qualifier\nsemi-final","Qualifier\nfinal"
                              ,"Round\nof 32","Round\nof 16","Quarter-\nfinal"
                              ,"Semi-\nfinal","Final","Semi-\nfinal"
                              ,"Quarter-\nfinal","Round\nof 16","Round\nof 32"
                              ,"Qualifier\nfinal","Qualifier\nsemi-final")) +
  xlab("") + ylab("") +
  theme_minimal() +
  theme(panel.grid = element_blank()
        ,plot.title=element_text(hjust=.5)
        ,plot.subtitle=element_text(hjust=.5)
        ,title=element_text()
        ,axis.text.x=element_text(color="black",size=6)
        ,axis.text.y=element_blank()
        ,legend.text = element_text()
        ,legend.title = element_text() ) +
  scale_color_manual(values=c("#c85200", "#A3ACB9","#a3cce9","#1170AA","green")
                     ,name="Score",labels=sort(unique(bumpdata$sizeofdot)))+
  scale_shape_manual(values=c(20,16,19,21,11),name="Score",labels=sort(unique(bumpdata$sizeofdot))) +
  scale_size_manual(values=c(2,3,4,5,8),name="Score",labels=sort(unique(bumpdata$sizeofdot)) )+
  labs(title="Tournament of Champions V: Winners and scores by round"
       ,subtitle="Winners of each round outlined in black circles"
       ,caption="Data: github.com/celevitz/touRnamentofchampions /// Twitter @carlylevitz /// IG @carly.sue.bear")
