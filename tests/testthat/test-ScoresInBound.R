library(testthat)        # load testthat package
library(touRnamentofchampions)

# 1. Check that scores are within the bounds
  ## For some of the finals, we don't have the scores: so exclude those from the Tests
  ## A. Taste: 0 to 50
    #test_that(expect_equal(all(results$score_taste >= 0 & results$score_taste <= 50 & results$round != "Final"),TRUE)  )

    test_that(expect_equal(nrow(results[results$score_taste >= 0 & results$score_taste <= 50 & results$round != "Final",]),
                 nrow(results[results$round != "Final",])))


  ## B. Randomizer: 0 to 30
   # test_that(expect_equal(all(results$score_randomizer >= 0 & results$score_randomizer <= 30 & results$round != "Final"),TRUE)  )

  ## C. Presentation: 0 to 20
   # test_that(expect_equal(all(results$score_presentation >= 0 & results$score_presentation <= 20 & results$round != "Final"),TRUE)  )

  ## D. Taste + Randomizer + Presentation = total
   # test_that(expect_equal(all(results$score_taste+results$score_randomizer+results$score_presentation = results$total & results$round != "Final"),TRUE))
