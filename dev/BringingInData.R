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

# Check for things that don't yet have documentation library(tools); undoc(touRnamentofchampions)

rm(list=ls())

library(tidyverse); library(openxlsx); library(usethis); library(rmarkdown)

directory <- "/Users/carlylevitz/Documents/Data/"

seeds <- read.xlsx(paste(directory,"TOC.xlsx",sep=""),sheet=2)
randomizer <- read.xlsx(paste(directory,"TOC.xlsx",sep=""),sheet=3)
results <- read.xlsx(paste(directory,"TOC.xlsx",sep=""),sheet=4)
judges <- read.xlsx(paste(directory,"TOC.xlsx",sep=""),sheet=5)

## save things as RDA

save(seeds, file = "data/seeds.rda")
save(randomizer, file = "data/randomizer.rda")
save(results, file = "data/results.rda")
save(judges, file = "data/judges.rda")


# Check for CRAN specific requirements
#results <- rhub::check_for_cran()
#results$cran_summary()
#usethis::use_cran_comments()

