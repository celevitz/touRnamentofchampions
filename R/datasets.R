#' seeds
#'
#' A dataset containing information on each Chef for each season.
#'
#' @docType data
#'
#' @usage data(seeds)
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{chef}}{Chef name (full name)}
#'   \item{\code{season}}{Season number}
#'   \item{\code{seed}}{Seed within their section of the bracket: values of 1 through 8}
#'   \item{\code{coast}}{Are they East or West Coast? And is it sub-bracket A or B?}
#'   \item{\code{nickname}}{Guy Fieri's nickname for the chef}
#'   \item{\code{handedness}}{Whether the chef is righthanded, lefthanded, or ambidextrous}
#' }
#'
#' @import tidyverse
#'
#' @source \url{https://en.wikipedia.org/wiki/https://en.wikipedia.org/wiki/Tournament_of_Champions_(TV_series)}
#' @examples
#' library(tidyverse)
#' seeds %>%
#'   filter(season == 1)
"seeds"


#' randomizer
#'
#' A dataset containing information about each challenge: protein, vegetables, equipment, style, time
#'
#' @docType data
#'
#' @usage data(randomizer)
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{season}}{Season number}
#'   \item{\code{episode}}{Episode number}
#'   \item{\code{round}}{Stage of the tournament: Round 1, Round 2, Quarterfinals, Semifinals, Final}
#'   \item{\code{challenge}}{Variable to help distinguish rounds within the same Coast & Round}
#'   \item{\code{coast}}{The coast depends on how many chefs start the competition. If there are 16 chefs, then the coasts are: East, West. If there are 32 chefs, then the coasts are: East A, East B, West A, West B}
#'   \item{\code{randomizer1}}{First wheel of randomizer}
#'   \item{\code{randomizer2}}{Second wheel of randomizer}
#'   \item{\code{randomizer3}}{Third wheel of randomizer}
#'   \item{\code{randomizer4}}{Fourth wheel of randomizer}
#'   \item{\code{time}}{Length of challenge. Unit is minutes}

#' }
#'
#' @import tidyverse
#'
#' @source \url{https://en.wikipedia.org/wiki/https://en.wikipedia.org/wiki/Tournament_of_Champions_(TV_series)}
#' @examples
#' library(tidyverse)
#' randomizer %>%
#'    group_by(season,episode,challenge,coast) %>%
#'    filter(round == "Semi-final")
"randomizer"



#' results
#'
#' A dataset containing win and loss data for each chef in each episode
#'
#' @docType data
#'
#' @usage data(results)
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{season}}{Season number}
#'   \item{\code{episode}}{Episode number}
#'   \item{\code{round}}{Stage of the tournament: Round 1, Round 2, Quarterfinals, Semifinals, Final}
#'   \item{\code{challenge}}{Variable to help distinguish rounds within the same Coast & Round}
#'   \item{\code{coast}}{The coast depends on how many chefs start the competition. If there are 16 chefs, then the coasts are: East, West. If there are 32 chefs, then the coasts are: East A, East B, West A, West B}
#'   \item{\code{y}}{ Numeric value to help when creating the bracket}
#'   \item{\code{chef}}{ Name of chef}
#'   \item{\code{commentator}}{ Who presented their food to the judges: Simon Majumdar or Justin Warner? }
#'   \item{\code{order}}{ When did their food get presented to the judges: Presented 1st or Presented 2nd }
#'   \item{\code{score_taste}}{ Score that chef received for the taste of their dish: values of 0- 50}
#'   \item{\code{score_randomizer}}{ Score that chef received for how well they used the Randomizer: values of 0- 30}
#'   \item{\code{score_presentation}}{ Score that chef received for the presentation of their dish: values of 0- 20}
#'   \item{\code{total}}{ Total score that chef received: between 0 and 100 }
#' }
#'
#' @import tidyverse
#'
#' @source \url{https://en.wikipedia.org/wiki/https://en.wikipedia.org/wiki/Tournament_of_Champions_(TV_series)}
#' @examples
#' library(tidyverse)
#' results %>%
#'   group_by(season) %>%
#'   filter(round == "Final") %>%
#'   select(chef,season,coast,total)
"results"




#' judges
#'
#' A dataset containing information about who were the judges for each challenge/episode
#'
#' @docType data
#'
#' @usage data(judges)
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{season}}{Season number}
#'   \item{\code{episode}}{Episode number}
#'   \item{\code{round}}{Stage of the tournament: Round 1, Round 2, Quarterfinals, Semifinals, Final}
#'   \item{\code{judge}}{Name of guest judge}
#' }
#'
#' @import tidyverse
#'
#' @source \url{https://en.wikipedia.org/wiki/https://en.wikipedia.org/wiki/Tournament_of_Champions_(TV_series)}
#' @examples
#' library(tidyverse)
#' judges %>%
#'   filter(judge == "Ming Tsai") %>%
#'   group_by(season,episode,round)
"judges"


