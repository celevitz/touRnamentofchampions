library(testthat)        # load testthat package

# 1. Check that scores are within the bounds
  ## A. Taste: 0 to 50
    test_that(expect_equal(all(results$score_taste >= 0 & results$score_taste <= 50),TRUE)  )

  ## B. Randomizer: 0 to 30
    test_that(expect_equal(all(results$score_randomizer >= 0 & results$score_randomizer <= 30),TRUE)  )

  ## C. Presentation: 0 to 20
    test_that(expect_equal(all(results$score_presentation >= 0 & results$score_presentation <= 20),TRUE)  )

  ## D. Taste + Randomizer + Presentation = total
    test_that(expect_equal(all(results$score_taste+results$score_randomizer+results$score_presentation = results$total),TRUE))
