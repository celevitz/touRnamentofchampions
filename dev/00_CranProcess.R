# Process for CRAN
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'
#   Knit                       'Cmd + Shift + K'


# Before submitting to cran:
tools::undoc("touRnamentofchampions")
devtools::install_deps()
devtools::test()
devtools::test_coverage()
devtools::run_examples()
devtools::check()

# rhub seems to be deprecated, and rhubv2 doesn't work on my version of R
  results <- rhub::check_for_cran()
  results$cran_summary()

usethis::use_cran_comments()
devtools::check_win_devel()
devtools::document()
roxygen2::roxygenise()
# Update News
usethis::use_news_md()
# Update description
devtools::spell_check()

  # Not available in 4.4.0 R
  # goodpractice::gp()

#install.packages("remotes")
#remotes::install_github("jumpingrivers/inteRgrate")
  inteRgrate::check_pkg()
  inteRgrate::check_lintr()
  inteRgrate::check_tidy_description()
  inteRgrate::check_r_filenames()
  inteRgrate::check_gitignore()

#devtools::release()
