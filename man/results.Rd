% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/datasets.R
\docType{data}
\name{results}
\alias{results}
\title{results}
\format{
This data frame contains the following columns:
\describe{
  \item{\code{season}}{Season number}
  \item{\code{episode}}{Episode number}
  \item{\code{round}}{Stage of the tournament: Qualifier semi-final,
  Qualifier final, Round of 32, Round of 16, Quarterfinals, Semifinals,
  Final}
  \item{\code{challenge}}{Variable to help distinguish rounds within the
  same Coast & Round}
  \item{\code{coast}}{East or West}
  \item{\code{region}}{The region depends on how many chefs start the
  competition. If there are 16 chefs, then the region is left blank. If
  there are 32 chefs, then the regions are A or B.}
  \item{\code{chef}}{ Name of chef}
  \item{\code{commentator}}{ Who presented their food to the judges: Simon
  Majumdar or Justin Warner? In Qualifying rounds, it could be presented by
  Hunter Fieri}
  \item{\code{order}}{ When did their food get presented to the judges:
  Presented first or Presented second. In Qualifying rounds, it could be
  presented third or fourth. }
  \item{\code{score_taste}}{ Score that chef received for the taste of their
  dish: values of 0- 50}
  \item{\code{score_randomizer}}{ Score that chef received for how well they
  used the Randomizer: values of 0- 30. (Except in Season 5 Qualifying
  rounds, the values are 0-40.)}
  \item{\code{score_presentation}}{ Score that chef received for the
  presentation of their dish: values of 0- 20. (Except in Season 5
  Qualifying rounds, the values are 0-10.)}
  \item{\code{total}}{ Total score that chef received: between 0 and 100 }
  \item{\code{winner}}{ Categorical variable: Winner, Loser, Tie  }
  \item{\code{x}}{ Numeric X value to help with visualizing bracket }
  \item{\code{y}}{ Numeric Y value to help with visualizing bracket  }
}
}
\source{
\url{https://en.wikipedia.org/wiki/Tournament_of_Champions_(TV_series)}
}
\usage{
data(results)
}
\description{
A dataset containing win and loss data for each chef in each episode
}
\examples{
library(tidyverse)
results \%>\%
  group_by(season) \%>\%
  filter(round == "Final") \%>\%
  select(chef,season,coast,total)
}
\keyword{datasets}
