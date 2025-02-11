library(tidyverse)
library(touRnamentofchampions)
library(gt)

rm(list=ls())

seeds <- touRnamentofchampions::seeds
results <- touRnamentofchampions::results
judges <- touRnamentofchampions::judges
chefs <- touRnamentofchampions::chefs
randomizer <- touRnamentofchampions::randomizer
randomizerlong <- touRnamentofchampions::randomizerlongform

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














