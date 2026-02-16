## Carly Levitz
## Feb 16, 2026
## Create a dataset of comparing scores to average in round
##    Want to model it off of NPT+.
##    (score - population mean)/population mean
## Another way to do it would be to create a Z score
##    (score - population mean)/population SD
## Would I standardize against the round, or the season?
##    Or first the round, then the season?

rm(list=ls())

directory <- "/Users/carlylevitz/Documents/Data/TOC/"
results <- read.csv(paste0(directory,"results.csv"),header=T)

## Means and SDs for each round
popstats <- results %>%
  group_by(season,round) %>%
  summarise(popmean = mean(total,na.rm=T)
            ,popsd = sd(total,na.rm=T)) %>%
  bind_rows(results %>%
              group_by(season) %>%
              summarise(popmean = mean(total,na.rm=T)
                        ,popsd = sd(total,na.rm=T)) %>%
              mutate(round="All"))

## Comparisons
chefstats <- results %>%
  ## For a chef, what is their average score in a season?
  ## Will compare that to the season
  group_by(season,chef) %>%
  summarise(total = mean(total,na.rm=T)
            ,roundsinseason = n_distinct(round)) %>%
  ## Compare each person to Season average
  full_join(popstats %>%
              filter(round == "All") %>%
              select(!round)) %>%
  mutate(percentdiff = (total-popmean)/popmean
         ,zscore = (total-popmean)/popsd
         ,round = "All") %>%
  ## compare each person to Round-Season average
  bind_rows( results %>%
    select(season,round,chef,total,winner) %>%
    ## Compare each person to Season average
    full_join(popstats %>%
                filter(round != "All") ) %>%
    mutate(percentdiff = (total-popmean)/popmean
           ,zscore = (total-popmean)/popsd)    ) %>%
  ## don't need the population data
  select(!c(popmean,popsd))

## Exploring it
seasoncomparison <- chefstats %>%
  filter(round == "All") %>%
  arrange(desc(zscore),desc(percentdiff)) %>%
  select(!c(round,winner))



