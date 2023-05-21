% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/datasets.R
\docType{data}
\name{seeds}
\alias{seeds}
\title{seeds}
\format{
This data frame contains the following columns:
\describe{
  \item{\code{chef}}{Chef name (full name)}
  \item{\code{season}}{Season number}
  \item{\code{seed}}{Seed within their section of the bracket: values of 1 through 8}
  \item{\code{coast}}{Are they East or West Coast? And is it sub-bracket A or B?}
  \item{\code{nickname}}{Guy Fieri's nickname for the chef}
  \item{\code{handedness}}{Whether the chef is righthanded, lefthanded, or ambidextrous}
}
}
\source{
\url{https://en.wikipedia.org/wiki/https://en.wikipedia.org/wiki/Tournament_of_Champions_(TV_series)}
}
\usage{
data(seeds)
}
\description{
A dataset containing information on each Chef for each season.
}
\examples{
library(tidyverse)
seeds \%>\%
  filter(season == 1)
}
\keyword{datasets}