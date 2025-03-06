
rm(list=ls())

library(tidyverse)
library(touRnamentofchampions)
library(gt)
devtools::install_github("celevitz/topChef")


seeds <- touRnamentofchampions::seeds
results <- touRnamentofchampions::results
judges <- touRnamentofchampions::judges
chefs <- touRnamentofchampions::chefs
randomizer <- touRnamentofchampions::randomizer
randomizerlong <- touRnamentofchampions::randomizerlongform
topchef <- topChef::chefdetails

# Top chef data
topchef <- topchef %>%
  #filter(series %in% "US") %>%
  select(name,series) %>%
  filter(!(name %in% "Bryan Voltaggio" & series %in% "US Masters")) %>%
  distinct()

## Differentials by round: total scores
  reshaperesults <- results %>%
    select(season,episode,round,challenge,coast,region,total) %>%
    group_by(season,episode,round,challenge,coast,region) %>%
    mutate(id = row_number()
           ,min=min(total,na.rm=T)
           ,max=max(total,na.rm=T)
           ,diff=max-min) %>%
    select(!c(total,id)) %>%
    arrange(desc(diff)) %>%
    distinct()


####################################################################
## Season 5 Qualifying rounds: semi-finals

  temp <- results %>%
    filter(round %in% c("Qualifier semi-final","Qualifier final") )%>%
    select(!c(season,episode,challenge,commentator,order)) %>%
    arrange(round,desc(total),desc(score_taste),desc(score_randomizer)) %>%
    rename(`Taste (0-50)`=score_taste,`Randomizer (0-40)`=score_randomizer
           ,`Presentation (0-10)`=score_presentation,`Total (0-100)`=total)

  temp %>%
    gt(groupname_col = "round") %>%
    #row_group_order(groups=c("Qualifer semi-final","Qualifier final") )%>%
    tab_source_note(source_note = "Data collected manually. /// Instagram @carly.sue.bear /// Twitter @carlylevitz") %>%
    tab_header(
      title = "Tournament of Champions V: Qualifying semi-finals"
      ,subtitle = "16 chefs battle for the final four spots in the Tournament of Champions V bracket"
    ) %>%
    tab_options(data_row.padding = px(1),
                column_labels.padding = px(1),
                row_group.padding = px(1))  %>%
    tab_style(style = cell_text(align = "right"),locations = cells_source_notes()) %>%
    tab_style(style = cell_text(align = "left",weight="bold"),locations = cells_title(groups="title")) %>%
    tab_style(style = cell_text(align = "left",weight="bold"),locations = cells_row_groups() ) %>%
    tab_style(style = cell_text(align = "left"),locations = cells_title(groups="subtitle")) %>%
    tab_style(style = cell_text(align = "center"),locations = cells_body(columns=!c(coast,region,chef))) %>%
    tab_style(style = cell_text(align = "center",weight="bold"),locations = cells_column_labels(columns=!c(coast,region,chef))) %>%
    tab_style(style = cell_text(align = "left",weight="bold"),locations = cells_column_labels(columns=c(coast,region,chef))) %>%
    tab_options(
      row_group.background.color = "gray95",
      table.font.color = "#323232",
      table_body.hlines.color = "#323232",
      table_body.border.top.color = "#323232",
      heading.border.bottom.color = "#323232",
      row_group.border.top.color = "#323232",
      column_labels.border.bottom.color = "#323232",
      row_group.border.bottom.color = "transparent"
      ,table.border.top.style = "transparent"
      ,table.border.bottom.style = "transparent"
      ,source_notes.font.size = 10,
    ) %>%
    opt_all_caps()



################################################
## Repeat chefs: who has commentated for them?

  results <- touRnamentofchampions::results

  results %>%
    filter(!(is.na(total))) %>%
    group_by(chef,commentator) %>%
    mutate(commentator=case_when(commentator == "Hunter Fieri" ~ "Hunter"
                                 ,commentator == "Simon Majumdar" ~ "Simon"
                                 ,commentator == "Justin Warner" ~ "Justin")) %>%
    summarise(n=n()) %>%
    pivot_wider(names_from=commentator,values_from=n) %>%
    mutate(Hunter = ifelse(is.na(Hunter),0,Hunter)
           ,Justin = ifelse(is.na(Justin),0,Justin)
           ,Simon = ifelse(is.na(Simon),0,Simon)
      ,totalbattles=Hunter+Justin+Simon) %>%
    arrange(desc(totalbattles)) %>%
    filter(totalbattles >=10) %>%
    mutate(percentsimon=Simon/totalbattles
           ,percentjustin=Justin/totalbattles)


###############################################################################
## Sweet 16: most common proteins
  randomizerlong %>%
    filter(category == "protein") %>%
    filter(round == "Round of 16") %>%
    group_by(value) %>%
    summarise(n=n()) %>%
    arrange(desc(n))

  randomizerlong %>%
    filter(category == "produce") %>%
    filter(round == "Round of 16") %>%
    group_by(value) %>%
    summarise(n=n()) %>%
    arrange(desc(n))

  randomizerlong %>%
    filter(category == "style") %>%
    #filter(round == "Round of 16") %>%
    group_by(value) %>%
    summarise(n=n()) %>%
    arrange(desc(n))

randomizerlongform %>%
  group_by(value) %>%
  summarise(n=n()) %>%
  filter(n>3) %>%
  arrange(desc(n))



## Elite 8

results %>%
  ungroup() %>%
  filter(chef %in% c("Antonia Lofaso","Kevin Lee","Mei Lin","Jet Tila"
                      ,"Maneet Chauhan","Tobias Dorzon","Britt Rescigno"
                      ,"Amanda Freitag") &
           round == "Quarter-final") %>%
  select(season,chef) %>%
  distinct() %>%
  group_by(chef) %>%
  summarise(n=n())

results %>%
  ungroup() %>%
  filter(chef %in% c("Antonia Lofaso","Kevin Lee","Mei Lin","Jet Tila"
                     ,"Maneet Chauhan","Tobias Dorzon","Britt Rescigno"
                     ,"Amanda Freitag") &
           season == 5 &
           round %in% c("Round of 32","Round of 16")) %>%
  group_by(chef) %>%
  distinct() %>%
  summarise(avg=mean(total,na.rm=T))


#####################
## Average total score for when a judge is present
  judgeaverages <- results %>%
  ungroup() %>%
  left_join(judges %>%
              select(!c(gender,round)) %>%
              distinct() %>%
              group_by(judge) %>%
              mutate(n=n()) %>%
              filter(n>1)
              ,relationship="many-to-many") %>%
  group_by(judge) %>%
  mutate(
    mean=mean(total,na.rm=T)
    ,median=median(total,na.rm=T)) %>%
  select(judge,n,mean,median) %>%
  distinct() %>%
  filter(!(is.na(judge))) %>%
  arrange(desc(mean))

judgeaverages %>% arrange(desc(median))

#############################################
## total score for the final four each season

  finalfour <- results %>%
    filter(round == "Semi-final") %>%
    select(season,chef) %>%
    mutate(finalfourflag = 1)


  results %>%
    left_join(finalfour) %>%
    filter(finalfourflag == 1 |
             (chef %in% c("Jet Tila","Antonia Lofaso","Maneet Chauhan","Britt Rescigno") & season == 5) ) %>%
    filter(round %in% c("Round of 32","Round of 16","Quarter-final")) %>%
    group_by(season,round,chef) %>%
    summarise(total=mean(total,na.rm=T)) %>%
    pivot_wider(names_from = round,values_from = total) %>%
    arrange(chef,season) %>%
    filter(chef %in% c("Jet Tila","Antonia Lofaso","Maneet Chauhan","Britt Rescigno"))


#######################################################################
## repeat chefs:
  # which are in main bracket vs qualifiers
  seeds$qualifier <- "Main bracket"
  seeds$qualifier[seeds$seed %in% c("8.2","8.3","8.4","QF") |
                    seeds$note %in% "QF winner"] <- "Qualifier"

  mainbracketqualsovertime <- seeds %>%
    select(chef,season,qualifier) %>%
    mutate(season=paste0("season",season)) %>%
    group_by(chef) %>%
    mutate(totalseasons = n()) %>%
    group_by(chef,qualifier) %>%
    mutate(seasonstatus = n()) %>%
    ungroup() %>%
    group_by(chef) %>%
    mutate(inqualifiers = max(ifelse(qualifier %in% "Qualifier"
                                     ,seasonstatus
                                     ,NA),
                              na.rm=T
                              )
           ,inmainbracket = max(ifelse(qualifier %in% "Main bracket"
                                      ,seasonstatus
                                      ,NA),
                               na.rm=T
           )) %>%
    arrange(chef)

  mainbracketqualsovertime$inqualifiers[is.infinite(
    mainbracketqualsovertime$inqualifiers)] <- 0

  mainbracketqualsovertime$inmainbracket[is.infinite(
    mainbracketqualsovertime$inmainbracket)] <- 0

  mainbracketqualsovertime$seasonstatus <- NULL


  mainbracketqualsovertime <- mainbracketqualsovertime %>%
    pivot_wider(names_from=season,values_from=qualifier) %>%
    full_join(chefs)


####################################################################
## Top Chef vs not
  tcvsnot <- results %>%
    select(season,episode,round,challenge,coast,region,chef,total
           ,score_taste,score_randomizer,score_presentation
           ,winner) %>%
    left_join(topchef %>%
                rename(chef=name) ) %>%
    # Fix some things that didn't merge exactly from Top Chef data
    mutate(series=ifelse(chef %in% c("Graham Elliot"),"US Masters",series)
           ,series=ifelse(chef %in% c("Kelsey Barnard-Clark"),"US",series)
           # Create variable for rounds as numeric
           ,numericround = case_when(
             round %in% "Qualifier semi-final" ~ 1
             ,round %in% "Qualifier final" ~ 2
             ,round %in% "Round of 32" ~ 3
             ,round %in% "Round of 16" ~ 4
             ,round %in% "Quarter-final" ~ 5
             ,round %in% "Semi-final" ~ 6
             ,round %in% "Final" ~ 7
           )
           # Create variable for winning as numeric
           ,winnernumeric = ifelse(winner %in% "Winner",1,0)
           ) %>%
    # merge on Seed information
    left_join(seeds %>%
                select(chef,season,seed) %>%
                mutate(seed=as.numeric(seed)))

  # Check that those who didn't merge are indeed non Top Chef people
  table(tcvsnot$chef[is.na(tcvsnot$series)])

  tcvsnot <- tcvsnot %>%
    # categorize the people who aren't on top chef
    mutate(series=ifelse(is.na(series),"Not in Top Chef",series)) %>%
    # drop season 6 cuz I want to base it on what has happened in the post
    filter(season != 6) %>%
    # consolidate main TC vs not
    mutate(maintc = ifelse(series %in% "US","Top Chef","Not Top Chef"))
    # recent TV vs not??

  # Summary stats: how many people in each group per season?
  # People can count more than once
    tcvsnot %>%
      select(season,chef,series) %>%
      distinct() %>%
      group_by(series,season) %>%
      summarise(n=n()) %>%
      pivot_wider(names_from=series,values_from=n)

    # Summary stats: how many people in each group? Each person only counts 1x
      tcvsnot %>%
        select(chef,series) %>%
        distinct() %>%
        group_by(series) %>%
        summarise(n=n())

  # Straight-up averages by group
  tcvsnot %>%
    group_by(series) %>%
    summarise(average = mean(total,na.rm=T)
              ,n=n())

  tcvsnot %>%
    group_by(maintc) %>%
    summarise(average = mean(total,na.rm=T)
              ,n=n())

  # T-test comparing groups
      # Note - VERY small sample size for US Masters
      t.test(tcvsnot$total[tcvsnot$series %in% c("US","US Masters")] ~
               tcvsnot$series[tcvsnot$series %in% c("US","US Masters")])
      t.test(tcvsnot$total[tcvsnot$series %in% c("US","Not in Top Chef")] ~
               tcvsnot$series[tcvsnot$series %in% c("US","Not in Top Chef")])
      t.test(tcvsnot$total[tcvsnot$series %in% c("US Masters","Not in Top Chef")] ~
               tcvsnot$series[tcvsnot$series %in% c("US Masters","Not in Top Chef")])

      # Comparing consolidated groups
      t.test(tcvsnot$total ~ tcvsnot$maintc)



      ## This shows us that there is a relationship between TC and TOC

  ## But what else is related?
      reg <- lm(tcvsnot$total ~ tcvsnot$maintc+tcvsnot$round + tcvsnot$season + tcvsnot$seed)
      summary(reg)

      reg2 <- lm(tcvsnot$total ~ tcvsnot$maintc + tcvsnot$numericround +
                  tcvsnot$season + tcvsnot$seed)
      summary(reg2)


  ## Change things into factor variables with levels
      tcvsnotfactors <- tcvsnot
      tcvsnotfactors$maintc <- factor(tcvsnotfactors$maintc
                                         ,levels=c("Top Chef","Not Top Chef"))
      tcvsnotfactors$round <- factor(tcvsnotfactors$round
                                        ,levels=c("Qualifier semi-final"
                                                  ,"Qualifier final"
                                                  ,"Round of 32","Round of 16"
                                                  ,"Quarter-final","Semi-final"
                                                  ,"Final"))
      regWithFactors <- lm(tcvsnotfactors$total ~ tcvsnotfactors$maintc +
                             tcvsnotfactors$round +
                             tcvsnotfactors$season)
      summary(regWithFactors)

      regWithFactorsTaste <- lm(tcvsnotfactors$score_taste ~ tcvsnotfactors$maintc +
                                  tcvsnotfactors$round +
                                  tcvsnotfactors$season)
      summary(regWithFactorsTaste)
      regWithFactorsPresentation <- lm(tcvsnotfactors$score_presentation ~ tcvsnotfactors$maintc +
                                  tcvsnotfactors$round +
                                  tcvsnotfactors$season)
      summary(regWithFactorsPresentation)
      regWithFactorsGameplay <- lm(tcvsnotfactors$score_randomizer ~ tcvsnotfactors$maintc +
                                         tcvsnotfactors$round +
                                         tcvsnotfactors$season)
      summary(regWithFactorsGameplay)


  ## What about how far chefs go in the rounds?
  ## Exclude qualifiers because not all seasons have them
  ## Exclude round of 32 because firs ttwo seasons didn't have that many chefs
      round16onward <- tcvsnot %>%
        filter(round %in% c("Round of 16","Semi-final","Final"))

      table(round16onward$round,round16onward$maintc)
      chisq.test(round16onward$round,round16onward$maintc)

      roundreg <- lm(round16onward$numericround ~ round16onward$maintc+
                       round16onward$season +
                       round16onward$seed)
      summary(roundreg)


  ## comparing number of rounds that chefs go through
      round16onward <- round16onward %>%
        # how many rounds are they in per season?
        ungroup() %>%
        group_by(season,chef) %>%
        mutate(numberofrounds=n())
      t.test(round16onward$numberofrounds ~ round16onward$maintc)

  ## Winning or losing: logistic regression
      logitreg <- glm(tcvsnot$winnernumeric ~ tcvsnot$maintc+tcvsnot$round + tcvsnot$season + tcvsnot$seed)
      summary(logitreg)

      chisq.test(tcvsnot$winner[tcvsnot$winner != "Tie"]
                 ,tcvsnot$maintc[tcvsnot$winner != "Tie"])
      table(tcvsnot$winner[tcvsnot$winner != "Tie"]
            ,tcvsnot$maintc[tcvsnot$winner != "Tie"])









