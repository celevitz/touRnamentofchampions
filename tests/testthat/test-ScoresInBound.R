library(testthat)        # load testthat package
library(touRnamentofchampions)
library(tidyverse)

# 1. Check that scores are within the bounds

  ## For some of the finals, we don't have the scores: so exclude those from the Tests
  ## A. Taste: 0 to 50
    test_that("Taste scores are okay",
              {expect_equal(nrow(results[results$score_taste >= 0 &
                                 results$score_taste <= 50 &
                                 !(is.na(results$score_taste)) &
                                 results$round != "Final" &
                                 !(results$order %in% c("DQ","Auto-win")),]),
                            nrow(results[results$round != "Final" &
                                           !(results$order %in% c("DQ","Auto-win")),]))}
               )


  ## B. Randomizer: 0 to 40
    ## It was 0 to 30 in the first 4 seasons
    test_that("Randomizer scores are okay before season 5",
              {expect_equal(nrow(results[results$score_randomizer >= 0 &
                                           results$score_randomizer <= 30 &
                                           !(is.na(results$score_randomizer)) &
                                           results$season < 5 &
                                           results$round != "Final" ,]),
                            nrow(results[results$round != "Final" &
                                           !(results$order %in% c("DQ","Auto-win")) &
                                           results$season <5,]))}
    )

    test_that("Randomizer scores are okay season 5 onward",
              {expect_equal(nrow(results[results$score_randomizer >= 0 &
                                        results$score_randomizer <= 40 &
                                        !(is.na(results$score_randomizer)) &
                                          results$season >= 5 &
                                        results$round != "Final" ,]),
                            nrow(results[results$round != "Final" &
                                           !(results$order %in% c("DQ","Auto-win")) &
                                           results$season >=5,]))}
    )

  ## C. Presentation: 0 to 20
    ## season 5 onward, it's max of 10
    test_that("Presentation scores are okay before season 5",
              {expect_equal(nrow(results[results$score_presentation >= 0 &
                                           results$score_presentation <= 20 &
                                           !(is.na(results$score_presentation)) &
                                           results$season < 5 &
                                           results$round != "Final" ,]),
                            nrow(results[results$round != "Final" &
                                           !(results$order %in% c("DQ","Auto-win")) &
                                           results$season <5,]))}
    )

    test_that("Presentation scores are okay season 5 onward",
              {expect_equal(nrow(results[results$score_presentation >= 0 &
                                           results$score_presentation <= 10 &
                                           !(is.na(results$score_presentation)) &
                                           results$season >= 5 &
                                           results$round != "Final" ,]),
                            nrow(results[results$round != "Final" &
                                           !(results$order %in% c("DQ","Auto-win")) &
                                           results$season >=5,]))}
    )



# 2. Check that scores are numeric
  expect_type(results$score_presentation,"double")
  expect_type(results$score_taste,"double")
  expect_type(results$score_randomizer,"double")
  expect_type(results$total,"double")

  # Do the subscores add up to the total?
  expect_equal(nrow(results[(results$total != results$score_presentation+
            results$score_randomizer+results$score_taste ) &
            !(is.na(results$total)) & !(is.na(results$score_presentation)) &
            !(is.na(results$score_randomizer)) & !(is.na(results$score_taste)),])
            ,0)

  # 3. Check for unique identifiers
  test_that("No duplicates in seeds",{expect_equal(nrow(seeds %>%
                                      group_by(season,chef) %>%
                                      mutate(id=row_number(),issue=max(id)) %>%
                                      filter(issue > 1)),0)} )

  test_that("No duplicates in chefs",{expect_equal(nrow(chefs %>%
                                      group_by(chef) %>%
                                      mutate(id=row_number(),issue=max(id)) %>%
                                      filter(issue > 1)),0) } )


  test_that("No duplicates in randomizer",{expect_equal(nrow(randomizer %>%
                                     group_by(season,episode,round,challenge) %>%
                                     mutate(id=row_number(),issue=max(id)) %>%
                                     filter(issue > 1)),0)})

  test_that("No duplicates in restuls",{expect_equal(nrow(results %>%
                                    group_by(season,episode,round,challenge,chef) %>%
                                    mutate(id=row_number(),issue=max(id)) %>%
                                    filter(issue > 1)),0)})

# 4. check that things aren't NA
  test_that("Chefs: Everyone has a gender",{expect_equal(all(!(is.na(chefs$gender))),TRUE)})
  test_that("Seeds: Everyone has a season",{expect_equal(all(!(is.na(seeds$season))),TRUE)})
  test_that("Seeds: Everyone has a seed",{expect_equal(all(!(is.na(seeds$seed))),TRUE)})
  test_that("Seeds: Everyone has a coast",{expect_equal(all(!(is.na(seeds$coast))),TRUE)})
  test_that("Judge: Everyone has a season",{expect_equal(all(!(is.na(judges$season))),TRUE)})
  test_that("Judge: Everyone has a episode",{expect_equal(all(!(is.na(judges$episode))),TRUE)})
  test_that("Judge: Everyone has a gender",{expect_equal(all(!(is.na(judges$gender))),TRUE)})
  test_that("Judge: Everyone has a round",{expect_equal(all(!(is.na(judges$round))),TRUE)})









