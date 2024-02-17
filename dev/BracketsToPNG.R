## Create brackets to then be made into PNGs
library(touRnamentofchampions)
library(tidyverse)
library(ggbump)

directory <- "/Users/carlylevitz/Documents/Data/TOC/"

resultsraw <- touRnamentofchampions::results
seeds <- touRnamentofchampions::seeds

results <- resultsraw %>%
  left_join(seeds %>% select(chef,season,seed,coast,region)) %>%
  mutate(sizeofdot=case_when(total < 80 & !(is.na(total)) ~ "71 to 79"
                             ,total >= 80 & total <85 ~ "80 to 84"
                             ,total >= 85 & total <90 ~ "85 to 89"
                             ,total >= 90 & !(is.na(total)) ~ "90+"
                             ,is.na(total) ~ "Not scored")
         ,cheflabelx=ifelse(grepl("East",coast),x+10,x-10)
         ,alignment=case_when(grepl("East",coast) & round=="Round of 32"~ 0
                              ,grepl("West",coast) & round=="Round of 32"~ 1
                              ,TRUE ~ NA)
         ,longchall=paste0(season,episode,round,challenge)
  ) %>%
  group_by(season,sizeofdot) %>%
  mutate(sizeofdot=paste(sizeofdot,"\n(occured ",n()," times)",sep="")) %>%
  ungroup()


## Function for bracket:
bracketfunction <- function(seasonnumber,xlimits,xbreaks,xlabs,titlenumber,roundtolabel) {
  ## Bump data
  bumpdata <- results %>% filter(season == seasonnumber)

  ## Vertical data
  verticaldata <- bumpdata %>%
    select(longchall,y) %>%
    arrange(longchall)%>%
    ungroup() %>% group_by(longchall) %>%
    mutate(yindic=row_number()
           ,yindic=paste0("Y",as.character(yindic))) %>%
    pivot_wider(names_from="yindic",values_from="y") %>%
    left_join(bumpdata %>% select(longchall,x,coast,winner) %>% distinct()) %>%
    mutate(X2=x)

  ## Plot
  ggplot() +
    # add vertical lines to indicate who competed against whom
    geom_segment(data=verticaldata,aes(x=x,xend=X2,y=Y1,yend=Y2),lty=2,color="#57606C") +
    # bump lines
    geom_bump(data=bumpdata,aes(x=x,y=y,fill=chef) ,color="#57606C" ) +
    # dots -- and highlight the winners
    geom_point(data=bumpdata,aes(x=x,y=y,color=sizeofdot,size=sizeofdot,shape=sizeofdot),fill="#1170AA" )+
    geom_point(data=bumpdata %>% filter(winner=="Winner"),
               aes(x=x,y=y),shape=21,color="#57606c",fill="transparent",size=12) +
    scale_shape_manual(values=c(20,16,19,21,4),name="Score legend",labels=sort(unique(bumpdata$sizeofdot))) +
    scale_size_manual(values=c(5,6,7,8,5),name="Score legend",labels=sort(unique(bumpdata$sizeofdot)) ) +
    scale_color_manual(values=c("#c85200", "#A3ACB9","#a3cce9","#1170AA","brown")
                       ,name="Score legend",labels=sort(unique(bumpdata$sizeofdot))) +
    annotate("text",x=bumpdata$cheflabelx[bumpdata$round == roundtolabel],y=bumpdata$y[bumpdata$round == roundtolabel]
             ,label=bumpdata$chef[bumpdata$round == roundtolabel]
             ,hjust=bumpdata$alignment[bumpdata$round == roundtolabel]
             ,size=7) +
    annotate("text",x=bumpdata$cheflabelx[bumpdata$round == roundtolabel],y=bumpdata$y[bumpdata$round == roundtolabel]-.7
             ,label=paste(bumpdata$seed[bumpdata$round == roundtolabel],"seed",sep=" ")
             ,hjust=bumpdata$alignment[bumpdata$round == roundtolabel]
             ,size=6) +
    scale_x_continuous(limits=xlimits,breaks=xbreaks,labels=xlabs) +
    xlab("") + ylab("") +
    theme_minimal() +
    theme(panel.grid = element_blank()
          ,plot.title=element_text(hjust=.5,color="black",size=24,face="bold")
          ,plot.subtitle=element_text(hjust=.5,color="black",size=22)
          ,plot.caption =element_text(color="black",size=18)
          ,axis.text.x=element_text(color="black",size=17)
          ,axis.text.y=element_blank()
          ,legend.text = element_text(color="black",size=16)
          ,legend.title = element_text(color="black",size=16,face="bold")
          ,legend.background = element_rect(fill=NA,color=NA)
          ,legend.position="bottom") +
    labs(title=paste0("Tournament of Champions ",titlenumber,": Winners and final scores by round")
         ,subtitle="Winners of each round outlined in dark gray circles"
         ,caption="\nData: github.com/celevitz/touRnamentofchampions /// Twitter @carlylevitz /// Instagram @carly.sue.bear")

}


## set the inputs for the function
  # season 1
    seasonnumber <- 1
    xlimits <- c(0,100)
    xbreaks <- c(15,30,40,50,60,70,85)
    xlabs <- c("Round of 16","Quarter-\nfinal","Semi-\nfinal",
               "Final","Semi-\nfinal","Quarter-\nfinal","Round of 16")
    titlenumber <- "I"
    roundtolabel <- "Round of 16"

    png(paste0(directory,"TOC1Bracket.png"),width=1080,height=1080,unit="px")
    bracketfunction(seasonnumber,xlimits,xbreaks,xlabs,titlenumber,roundtolabel)
    dev.off()

  # season 2
    seasonnumber <- 2
    xlimits <- c(0,100)
    xbreaks <- c(15,30,40,50,60,70,85)
    xlabs <- c("Round of 16","Quarter-\nfinal","Semi-\nfinal",
               "Final","Semi-\nfinal","Quarter-\nfinal","Round of 16")
    titlenumber <- "II"
    roundtolabel <- "Round of 16"

    png(paste0(directory,"TOC2Bracket.png"),width=1080,height=1080,unit="px")
    bracketfunction(seasonnumber,xlimits,xbreaks,xlabs,titlenumber,roundtolabel)
    dev.off()


  # season 3
    seasonnumber <- 3
    xlimits <- c(-40,140)
    xbreaks <- c(0,15,30,40,50,60,70,85,100)
    xlabs <- c("Round\nof 32","Round\nof 16","Quarter-\nfinal","Semi-\nfinal",
               "Final","Semi-\nfinal","Quarter-\nfinal","Round\nof 16","Round\nof 32")
    titlenumber <- "III"
    roundtolabel <- "Round of 32"

    png(paste0(directory,"TOC3Bracket.png"),width=1080,height=1080,unit="px")
    bracketfunction(seasonnumber,xlimits,xbreaks,xlabs,titlenumber,roundtolabel)
    dev.off()

  # season 4
    seasonnumber <- 4
    xlimits <- c(-40,140)
    xbreaks <- c(0,15,30,40,50,60,70,85,100)
    xlabs <- c("Round\nof 32","Round\nof 16","Quarter-\nfinal","Semi-\nfinal",
               "Final","Semi-\nfinal","Quarter-\nfinal","Round\nof 16","Round\nof 32")
    titlenumber <- "IV"
    roundtolabel <- "Round of 32"

    png(paste0(directory,"TOC4Bracket.png"),width=1080,height=1080,unit="px")
    bracketfunction(seasonnumber,xlimits,xbreaks,xlabs,titlenumber,roundtolabel)
    dev.off()

