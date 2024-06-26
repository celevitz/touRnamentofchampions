% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/datasets.R
\docType{data}
\name{judges}
\alias{judges}
\title{judges}
\format{
This data frame contains the following columns:
\describe{
  \item{\code{season}}{Season number}
  \item{\code{episode}}{Episode number}
  \item{\code{judge}}{Name of guest judge}
  \item{\code{gender}}{Whether the chef is male, female, or non-binary}
  \item{\code{round}}{Stage of the tournament: Qualifier semi-final,
  Qualifier final, Round of 32, Round of 16, Quarterfinals, Semifinals,
  Final}
}
}
\source{
\url{https://en.wikipedia.org/wiki/Tournament_of_Champions_(TV_series)}
}
\usage{
data(judges)
}
\description{
A dataset containing information about who were the judges for each
challenge/episode
}
\examples{
library(tidyverse)
judges \%>\%
  filter(judge == "Ming Tsai") \%>\%
  group_by(season,episode)
}
\keyword{datasets}
