# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#     Other checks:             rhub::check_for_cran()
#                               devtools::check()
#   Test Package:              'Cmd + Shift + T'
#   Knit                       'Cmd + Shift + K'
#   Load the data              'Cmd + Shift + L'

# Check for things that don't yet have documentation library(tools); undoc(touRnamentofchampions)

rm(list=ls())

library(tidyverse); library(openxlsx); library(usethis); library(rmarkdown)

directory <- "/Users/carlylevitz/Documents/Data/TOC/"

seeds <- as_tibble(read.xlsx(paste(directory,"TOC.xlsx",sep=""),sheet=2))
chefs <- as_tibble(read.xlsx(paste(directory,"TOC.xlsx",sep=""),sheet=3))
randomizer <- as_tibble(read.xlsx(paste(directory,"TOC.xlsx",sep=""),sheet=4))
results <- as_tibble(read.xlsx(paste(directory,"TOC.xlsx",sep=""),sheet=5))
judges <- as_tibble(read.xlsx(paste(directory,"TOC.xlsx",sep=""),sheet=6))

## save things as RDA

save(seeds, file = "data/seeds.rda")
save(chefs, file = "data/chefs.rda")
save(randomizer, file = "data/randomizer.rda")
save(results, file = "data/results.rda")
save(judges, file = "data/judges.rda")


# Check for CRAN specific requirements
#results <- rhub::check_for_cran()
#results$cran_summary()
#usethis::use_cran_comments()


## update readme: devtools::build_readme()

