library(testthat)        # load testthat package
library(touRnamentofchampions)
library(tidyverse)

# 1. Check that scores are within the bounds

  ## For some of the finals, we don't have the scores: so exclude those from the Tests
  ## A. Taste: 0 to 50
    #test_that(expect_equal(all(results$score_taste >= 0 & results$score_taste <= 50 & results$round != "Final"),TRUE)  )

    # test_that(expect_equal(nrow(results[results$score_taste >= 0 &
    #                                       results$score_taste <= 50 &
    #                                       results$round != "Final" &
    #                                       !(results$order %in% c("DQ","Auto-win")),]),
    #              nrow(results[results$round != "Final" & !(results$order %in% c("DQ","Auto-win")),])))
    #

  ## B. Randomizer: 0 to 30
   # test_that(expect_equal(all(results$score_randomizer >= 0 & results$score_randomizer <= 30 & results$round != "Final"),TRUE)  )

  ## C. Presentation: 0 to 20
   # test_that(expect_equal(all(results$score_presentation >= 0 & results$score_presentation <= 20 & results$round != "Final"),TRUE)  )

  ## D. Taste + Randomizer + Presentation = total
   # test_that(expect_equal(all(results$score_taste+results$score_randomizer+results$score_presentation = results$total & results$round != "Final"),TRUE))

# 2. Check that scores are numeric
  expect_type(results$score_presentation,"double")
  expect_type(results$score_taste,"double")
  expect_type(results$score_randomizer,"double")
  expect_type(results$total,"double")

# 3. Check for unique identifiers
  expect_equal(nrow(seeds %>% group_by(season,chef) %>% mutate(id=row_number(),issue=max(id)) %>% filter(issue > 1)),0)
  expect_equal(nrow(chefs %>% group_by(chef) %>% mutate(id=row_number(),issue=max(id)) %>% filter(issue > 1)),0)
  expect_equal(nrow(randomizer %>% group_by(season,episode,round,challenge) %>% mutate(id=row_number(),issue=max(id)) %>% filter(issue > 1)),0)
  expect_equal(nrow(results %>% group_by(season,episode,round,challenge,chef) %>% mutate(id=row_number(),issue=max(id)) %>% filter(issue > 1)),0)
