#' seeds
#'
#' A dataset containing game-related information on each Chef for each season.
#'
#' @docType data
#'
#' @usage data(seeds)
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{chef}}{Chef name (full name)}
#'   \item{\code{season}}{Season number}
#'   \item{\code{seed}}{Seed within their section of the bracket: values of 1
#'   through 8. Chefs that played in the qualifiers but didn't make the final
#'   bracket will have seeds of 8.2, 8.3, or 8.4.}
#'   \item{\code{coast}}{Are they East or West Coast?}
#'   \item{\code{region}}{The region depends on how many chefs start the
#'   competition. If there are 16 chefs, then the region is left blank. If
#'   there are 32 chefs, then the regions are A or B.}
#' }
#'
#' @import tidyverse
#'
#' @source \url {https://en.wikipedia.org/wiki/Tournament_of_Champions_(TV_series)}
#' @examples
#' library(tidyverse)
#' seeds %>%
#'   filter(season == 1)
"seeds"


#' chefs
#'
#' A dataset containing information on each Chef, which is the same for all
#' seasons
#'
#' @docType data
#'
#' @usage data(chefs)
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{chef}}{Chef name (full name)}
#'   \item{\code{nickname}}{Guy Fieri's nickname for the chef}
#'   \item{\code{handedness}}{Whether the chef is right-handed, left-handed, or
#'   ambidextrous}
#'   \item{\code{gender}}{Whether the chef is male, female, or non-binary}
#' }
#'
#' @import tidyverse
#'
#' @source \url {https://en.wikipedia.org/wiki/Tournament_of_Champions_(TV_series)}
#' @examples
#' library(tidyverse)
#' chefs %>%
#'   filter(gender == "female")
"chefs"


#' randomizer
#'
#' A dataset containing information about each challenge: protein, vegetables,
#' equipment, style, time
#'
#' @docType data
#'
#' @usage data(randomizer)
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{season}}{Season number}
#'   \item{\code{episode}}{Episode number}
#'   \item{\code{round}}{Stage of the tournament: Qualifier semi-final,
#'   Qualifier final, Round of 32, Round of 16, Quarterfinals, Semifinals,
#'   Final}
#'   \item{\code{challenge}}{Variable to help distinguish challenges within the
#'   same Coast & Round}
#'   \item{\code{coast}}{East or West}
#'   \item{\code{region}}{The region depends on how many chefs start the
#'   competition. If there are 16 chefs, then the region is left blank. If
#'   there are 32 chefs, then the regions are A or B.}
#'   \item{\code{randomizer1}}{First wheel of randomizer}
#'   \item{\code{randomizer2}}{Second wheel of randomizer}
#'   \item{\code{randomizer3}}{Third wheel of randomizer}
#'   \item{\code{randomizer4}}{Fourth wheel of randomizer}
#'   \item{\code{time}}{Length of challenge. Unit is minutes}
#'   \item{\code{randomizer5}}{Fifth wheel of randomizer}

#' }
#'
#' @import tidyverse
#'
#' @source \url {https://en.wikipedia.org/wiki/Tournament_of_Champions_(TV_series)}
#' @examples
#' library(tidyverse)
#' randomizer %>%
#'    group_by(season,episode,challenge,coast) %>%
#'    filter(round == "Semi-final")
"randomizer"


#' randomizer long form
#'
#' A dataset containing information about each challenge: protein, vegetables,
#' equipment, style, time
#' However, it's in "long form" so each challenge shows up multiple times
#' It categorizes the randomizer ingredients into categories and subcategories
#'
#' @docType data
#'
#' @usage data(randomizerlongform)
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{season}}{Season number}
#'   \item{\code{episode}}{Episode number}
#'   \item{\code{round}}{Stage of the tournament: Qualifier semi-final,
#'   Qualifier final, Round of 32, Round of 16, Quarterfinals, Semifinals,
#'   Final}
#'   \item{\code{challenge}}{Variable to help distinguish challenges within the
#'   same Coast & Round}
#'   \item{\code{coast}}{East or West}
#'   \item{\code{region}}{The region depends on how many chefs start the
#'   competition. If there are 16 chefs, then the region is left blank. If
#'   there are 32 chefs, then the regions are A or B.}
#'   \item{\code{time}}{Length of challenge. Unit is minutes}
#'   \item{\code{randomizer}}{What wheel was spun (1, 2, 3, 4, or 5)}
#'   \item{\code{value}}{What was the value/item on the randomizer wheel?}
#'   \item{\code{category}}{Categorical variable: protein,produce,equipment,
#'   style,wildcard}
#'   \item{\code{subcategory}}{Subcategories for protein (Beef, Fish, Game,
#'   Other, Pork, Poultry, Shellfish) and style (Region/country, Style, Theme)}


#' }
#'
#' @import tidyverse
#'
#' @source \url {https://en.wikipedia.org/wiki/Tournament_of_Champions_(TV_series)}
#' @examples
#' library(tidyverse)
#' randomizerlongform %>%
#'    filter(category == "protein") %>%
#'    group_by(subcategory) %>%
#'    summarise(n=n())
"randomizerlongform"



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
#'   \item{\code{round}}{Stage of the tournament: Qualifier semi-final,
#'   Qualifier final, Round of 32, Round of 16, Quarterfinals, Semifinals,
#'   Final}
#'   \item{\code{challenge}}{Variable to help distinguish rounds within the
#'   same Coast & Round}
#'   \item{\code{coast}}{East or West}
#'   \item{\code{region}}{The region depends on how many chefs start the
#'   competition. If there are 16 chefs, then the region is left blank. If
#'   there are 32 chefs, then the regions are A or B.}
#'   \item{\code{chef}}{ Name of chef}
#'   \item{\code{commentator}}{ Who presented their food to the judges: Simon
#'   Majumdar or Justin Warner? In Qualifying rounds, it could be presented by
#'   Hunter Fieri}
#'   \item{\code{order}}{ When did their food get presented to the judges:
#'   Presented first or Presented second. In Qualifying rounds, it could be
#'   presented third or fourth. }
#'   \item{\code{score_taste}}{ Score that chef received for the taste of their
#'   dish: values of 0- 50}
#'   \item{\code{score_randomizer}}{ Score that chef received for how well they
#'   used the Randomizer: values of 0- 30. (Except in Season 5 Qualifying
#'   rounds, the values are 0-40.)}
#'   \item{\code{score_presentation}}{ Score that chef received for the
#'   presentation of their dish: values of 0- 20. (Except in Season 5
#'   Qualifying rounds, the values are 0-10.)}
#'   \item{\code{total}}{ Total score that chef received: between 0 and 100 }
#'   \item{\code{winner}}{ Categorical variable: Winner, Loser, Tie  }
#'   \item{\code{x}}{ Numeric X value to help with visualizing bracket }
#'   \item{\code{y}}{ Numeric Y value to help with visualizing bracket  }
#' }
#'
#' @import tidyverse
#'
#' @source \url {https://en.wikipedia.org/wiki/Tournament_of_Champions_(TV_series)}
#' @examples
#' library(tidyverse)
#' results %>%
#'   group_by(season) %>%
#'   filter(round == "Final") %>%
#'   select(chef,season,coast,total)
"results"




#' judges
#'
#' A dataset containing information about who were the judges for each
#' challenge/episode
#'
#' @docType data
#'
#' @usage data(judges)
#'
#' @format This data frame contains the following columns:
#' \describe{
#'   \item{\code{season}}{Season number}
#'   \item{\code{episode}}{Episode number}
#'   \item{\code{judge}}{Name of guest judge}
#'   \item{\code{gender}}{Whether the chef is male, female, or non-binary}
#'   \item{\code{round}}{Stage of the tournament: Qualifier semi-final,
#'   Qualifier final, Round of 32, Round of 16, Quarterfinals, Semifinals,
#'   Final}
#' }
#'
#' @import tidyverse
#'
#' @source \url {https://en.wikipedia.org/wiki/Tournament_of_Champions_(TV_series)}
#' @examples
#' library(tidyverse)
#' judges %>%
#'   filter(judge == "Ming Tsai") %>%
#'   group_by(season,episode)
"judges"


