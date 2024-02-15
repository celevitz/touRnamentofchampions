library(tidyverse)
library(touRnamentofchampions)
library(gt)

rm(list=ls())

seeds <- touRnamentofchampions::seeds
results <- touRnamentofchampions::results
judges <- touRnamentofchampions::judges
chefs <- touRnamentofchampions::chefs
randomizer <- touRnamentofchampions::randomizer

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

