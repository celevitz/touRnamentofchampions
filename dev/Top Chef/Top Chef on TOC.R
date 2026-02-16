
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

# Do Top Chef people win qualifiers more than non-Top Chef people?
  qualifiers <- tcvsnot %>%
    filter(grepl("Qualif",round))
  chisq.test(qualifiers$winner,qualifiers$maintc)

# margin of winning (excluding qualifiers and ties and DQ)
  mainbracket <- tcvsnot %>%
    filter(!(grepl("Qualif",round)) & winner != "Tie" & !(is.na(total))) %>%
    # Classify the round: Top Chef vs Top Chef, Top Chef vs non Top Chef,
    #   or non Top Chef vs non-Top Chef
    group_by(season,episode,round,challenge,coast,region) %>%
      mutate(
        # create a flag for the number of top chef people in that challenge
          # 0 = no Top Chef alum in the challenge
          # 1 = 1 Top Chef alum in the challenge
          # 2 = 2 Top Chef alum in the challenge
          topchefflag = sum(ifelse(maintc == "Top Chef",1,0))
        # Was the winner a Top Chef alum?
        ,tcwinner = max(ifelse(maintc == "Top Chef" & winner == "Winner",1,0))
        # What were the high and low scores for that challenge?
        # Use that to create a differential
        ,loserscore=min(total,na.rm=T)
        ,winnerscore=max(total,na.rm=T)
        ,differential = winnerscore-loserscore
      )

  ## Summary statistics about the Total score
  mainbracket %>%
    group_by(topchefflag,tcwinner) %>%
    summarise(
        mean_total=mean(total,na.rm=T)
        ,mdn_total=median(total,na.rm=T)
        ,sd_total=sd(total,na.rm=T)
  )


  mainbracketmargin <- mainbracket %>%
    # Keep just the variables I need to create the tables
    select(season,episode,round,challenge,coast,region
           ,topchefflag,tcwinner,differential) %>%
    # There are duplicates because there used to be a row for each chef
    # jut have one row per battle
    distinct()

  ## Summary statistics about differential based on whether there
  ##  were Top Chef alum in the battle and whether a Top Chef alum won
  mainbracketmargin %>%
    group_by(topchefflag,tcwinner) %>%
    summarise(mean_diff = mean(differential,na.rm=T)
              ,median_diff= median(differential,na.rm=T)
              ,sd_diff = sd(differential,na.rm=T)
              ,n=n())

  mainbracketmargin %>%
    group_by(tcwinner) %>%
    summarise(mean_diff = mean(differential,na.rm=T)
              ,median_diff= median(differential,na.rm=T)
              ,sd_diff = sd(differential,na.rm=T)
              ,n=n())

  # Is there a significant relationship between having a Top Chef alum
  # in the battle and having a Top Chef winner?
  # I think this is only showing a relationship b/c of the diagonals (0-0 and 2-2)
  table(mainbracketmargin$tcwinner,mainbracketmargin$topchefflag)
  chisq.test(mainbracketmargin$tcwinner,mainbracketmargin$topchefflag)

  table(mainbracket$winner,mainbracket$maintc)


  ## Actual score: did having a Top Chef alum present lead to higher scores?
  summary(lm(mainbracket$total ~ mainbracket$season + mainbracket$round +
       mainbracket$seed + mainbracket$maintc + mainbracket$winner))
  summary(lm(mainbracket$score_taste ~ mainbracket$season + mainbracket$round +
               mainbracket$seed + mainbracket$maintc + mainbracket$winner))

    # What about the scores of the losers? of the winners?
        summary(lm(mainbracket$total[mainbracket$winner == "Loser"] ~
                     mainbracket$season[mainbracket$winner == "Loser"] +
                     mainbracket$round[mainbracket$winner == "Loser"] +
                     mainbracket$seed[mainbracket$winner == "Loser"] +
                     mainbracket$maintc[mainbracket$winner == "Loser"]))
        summary(lm(mainbracket$total[mainbracket$winner == "Winner"] ~
                     mainbracket$season[mainbracket$winner == "Winner"] +
                     mainbracket$round[mainbracket$winner == "Winner"] +
                     mainbracket$seed[mainbracket$winner == "Winner"] +
                     mainbracket$maintc[mainbracket$winner == "Winner"]))


## | ----------------------------------------------------------------- |
##### Original analysis: total scores
## | ----------------------------------------------------------------- |

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

    # Summary stats: average seed (each person only counts 1x)
    # remove qualifiers
      tcvsnot %>%
        filter(!(grepl("Qualifier",round))) %>%
        select(season,chef,seed,maintc) %>%
        distinct() %>%
        group_by(maintc) %>%
        summarise(average=mean(seed,na.rm=T))

  # Straight-up averages by group
  tcvsnot %>%
    group_by(series) %>%
    summarise(averageTotal = mean(total,na.rm=T)
              ,n=n())

  tcvsnot %>%
    group_by(maintc) %>%
    summarise(averageTotal = mean(total,na.rm=T)
              ,n=n()
              # doing seed, but it's not accurate b/c people are in the data
              # more than one time
              ,seed=mean(seed,na.rm=T))


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
      reg <- lm(tcvsnot$total ~ tcvsnot$maintc+ tcvsnot$round + tcvsnot$season +
                  tcvsnot$seed )
      summary(reg)

      reg2 <- lm(tcvsnot$total ~ tcvsnot$maintc + tcvsnot$numericround +
                  tcvsnot$season + tcvsnot$seed)
      summary(reg2)

      reg3 <- lm(tcvsnot$total ~ tcvsnot$maintc+ tcvsnot$round + tcvsnot$season +
                  tcvsnot$seed + tcvsnot$winner)
      summary(reg3)


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
      logitreg <- glm(tcvsnot$winnernumeric ~ tcvsnot$maintc+tcvsnot$round +
                        tcvsnot$season + tcvsnot$seed)
      summary(logitreg)

      chisq.test(tcvsnot$winner[tcvsnot$winner != "Tie"]
                 ,tcvsnot$maintc[tcvsnot$winner != "Tie"])
      table(tcvsnot$winner[tcvsnot$winner != "Tie"]
            ,tcvsnot$maintc[tcvsnot$winner != "Tie"])

## | ----------------------------------------------------------------- |







