touRnamentofchampions
================

## 1. Introduction to touRnamentofchampions

touRnamentofchampions is a collection of data sets detailing events
across all seasons of Tournament of Champions. It includes Chef
information, randomizer information, challenge results, and judge names.

## 2. Installation

Not yet on CRAN. So please use:
*devtools::install.github(“celevitz/touRnamentofchampions”)*. If it’s
not appearing to be updated, restart your R sessions, install it again,
and call it into your library.

``` r
devtools::install_github("celevitz/touRnamentofchampions")
#> openssl     (2.1.1 -> 2.2.0) [CRAN]
#> fastmap     (1.1.1 -> 1.2.0) [CRAN]
#> cachem      (1.0.8 -> 1.1.0) [CRAN]
#> tinytex     (0.50  -> 0.51 ) [CRAN]
#> xfun        (0.43  -> 0.44 ) [CRAN]
#> highr       (0.10  -> 0.11 ) [CRAN]
#> rmarkdown   (2.26  -> 2.27 ) [CRAN]
#> fs          (1.6.3 -> 1.6.4) [CRAN]
#> textshaping (0.3.7 -> 0.4.0) [CRAN]
#> systemfonts (1.0.6 -> 1.1.0) [CRAN]
#> backports   (1.4.1 -> 1.5.0) [CRAN]
#> broom       (1.0.5 -> 1.0.6) [CRAN]
#> farver      (2.1.1 -> 2.1.2) [CRAN]
#> gtable      (0.3.4 -> 0.3.5) [CRAN]
#> ragg        (1.3.0 -> 1.3.2) [CRAN]
#> ggplot2     (3.5.0 -> 3.5.1) [CRAN]
#> 
#> The downloaded binary packages are in
#>  /var/folders/0p/_s6v9q110z9fh4y0vq9ml47m0000gp/T//RtmptdqTwn/downloaded_packages
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#>      checking for file ‘/private/var/folders/0p/_s6v9q110z9fh4y0vq9ml47m0000gp/T/RtmptdqTwn/remotes3dce420284f2/celevitz-touRnamentofchampions-7cecc36/DESCRIPTION’ ...  ✔  checking for file ‘/private/var/folders/0p/_s6v9q110z9fh4y0vq9ml47m0000gp/T/RtmptdqTwn/remotes3dce420284f2/celevitz-touRnamentofchampions-7cecc36/DESCRIPTION’
#>   ─  preparing ‘touRnamentofchampions’:
#>      checking DESCRIPTION meta-information ...  ✔  checking DESCRIPTION meta-information
#>   ─  checking for LF line-endings in source and make files and shell scripts
#>   ─  checking for empty or unneeded directories
#>   ─  building ‘touRnamentofchampions_0.1.0.tar.gz’
#>      
#> 
```

## 3. News

Issues to work on:

- Complete handedness and nicknames
- Potentially add information on dish description (long-term goal)

## 4. References & Acknowledgements

Data were collected manually while watching each season of Tournament of
Champions.

Huge thanks to <https://github.com/doehm> for all his support!

## 5. Datasets

Across datasets, key joining variables include:

- `chef`
- `season`
- `coast`
- `region`
- `round`
- `episode`
- `challenge`

See the sections below for additional information on datasets.

<details>
<summary>
<strong>Seeds</strong>
</summary>

### Seeds

The unique identifiers of this dataset are `chef`-`season`.

- `chef`: Chef name (full name)
- `season`: Season number
- `seed`: Seed within their section of the bracket: values of 1
  through 8. Chefs that played in the qualifiers but didn’t make the
  final bracket will have seeds of 8.2, 8.3, or 8.4.
- `coast`: Are they East or West Coast?
- `region`: The region depends on how many chefs start the competition.
  If there are 16 chefs, then the region is left blank. If there are 32
  chefs, then the regions are A or B.

``` r
seeds 
#> # A tibble: 146 × 5
#>    chef               season  seed coast region
#>    <chr>               <dbl> <dbl> <chr> <chr> 
#>  1 Alex Guarnaschelli      1     1 East  <NA>  
#>  2 Marc Murphy             1     2 East  <NA>  
#>  3 Rocco DiSpirito         1     3 East  <NA>  
#>  4 Amanda Freitag          1     4 East  <NA>  
#>  5 Elizabeth Falkner       1     5 East  <NA>  
#>  6 Maneet Chauhan          1     6 East  <NA>  
#>  7 Christian Petroni       1     7 East  <NA>  
#>  8 Darnell Ferguson        1     8 East  <NA>  
#>  9 Antonia Lofaso          1     1 West  <NA>  
#> 10 Michael Voltaggio       1     2 West  <NA>  
#> # ℹ 136 more rows
```

</details>
<details>
<summary>
<strong>Chefs</strong>
</summary>

### Chefs

The unique identifier of this dataset is `chef`.

- `chef`: Chef name (full name)
- `nickname`: Guy Fieri’s nickname for the chef
- `handedness`: Whether the chef is right-handed, left-handed, or
  ambidextrous
- `gender`: male, female, non-binary

``` r
chefs 
#> # A tibble: 71 × 4
#>    chef               nickname         handedness   gender
#>    <chr>              <chr>            <chr>        <chr> 
#>  1 Aaron May          <NA>             <NA>         male  
#>  2 Aarthi Sampath     <NA>             <NA>         female
#>  3 Adam Sobel         Mr. Delicious    <NA>         male  
#>  4 Adriana Urbina     <NA>             <NA>         female
#>  5 Alex Guarnaschelli N/A              Right-handed female
#>  6 Amanda Freitag     Chef AF          Right-handed female
#>  7 Antonia Lofaso     Warrior Princess Right-handed female
#>  8 Beau MacMillan     Beau Mac         Right-handed male  
#>  9 Bobby Marcotte     <NA>             <NA>         male  
#> 10 Brian Malarkey     Shenanigans      Left-handed  male  
#> # ℹ 61 more rows
```

</details>
<details>
<summary>
<strong>Randomizer</strong>
</summary>

### Randomizer

The unique identifiers of this dataset are
`season`-`episode`-`round`-`challenge`. The reason that `episode` is a
unique identifier is because in Season 2, Jet and Antonia tied in all
scores and so had a rematch in the Quarter-finals (episodes 6 and 7).

- `season`: Season number
- `episode`: Episode number
- `round`: Stage of the tournament: Qualifier semi-final, Qualifier
  final, Round of 32, Round of 16, Quarterfinals, Semifinals, Final
- `challenge`: Variable to help distinguish rounds within the same Coast
  & Round
- `coast`: Are they East or West Coast?
- `region`: The region depends on how many chefs start the competition.
  If there are 16 chefs, then the region is left blank. If there are 32
  chefs, then the regions are A or B.
- `randomizer1`: First wheel of randomizer
- `randomizer2`: Second wheel of randomizer
- `randomizer3`: Third wheel of randomizer
- `randomizer4`: Fourth wheel of randomizer
- `time`: Length of challenge. Unit is minutes
- `randomizer5`: Fifth wheel of randomizer

``` r
randomizer 
#> # A tibble: 138 × 12
#>    season episode round         challenge   coast region randomizer1 randomizer2
#>     <dbl>   <dbl> <chr>         <chr>       <chr> <chr>  <chr>       <chr>      
#>  1      1       1 Round of 16   Alex/Darne… East  <NA>   Pork tende… Peas       
#>  2      1       1 Round of 16   Antonia/Ma… West  <NA>   Cod         Avocado    
#>  3      1       1 Round of 16   Eric/Jet    West  <NA>   Top sirloin Mushrooms  
#>  4      1       2 Round of 16   Amanda/Eli… East  <NA>   Pork blade… Squash     
#>  5      1       2 Round of 16   Beau/Richa… West  <NA>   Ground lamb Broccoli   
#>  6      1       2 Round of 16   Christian/… East  <NA>   Shrimp      Carrots    
#>  7      1       3 Quarter-final Antonia/Be… West  <NA>   Quail       Bok choy   
#>  8      1       3 Round of 16   Brooke/Mic… West  <NA>   Chicken br… Radish     
#>  9      1       3 Round of 16   Maneet/Roc… East  <NA>   Chicken th… Kale       
#> 10      1       4 Quarter-final Amanda/Dar… East  <NA>   Rack of la… Nopales    
#> # ℹ 128 more rows
#> # ℹ 4 more variables: randomizer3 <chr>, randomizer4 <chr>, time <dbl>,
#> #   randomizer5 <chr>
```

</details>
<details>
<summary>
<strong>Randomizer (long form)</strong>
</summary>

### Randomizer (long form)

A dataset containing information about each challenge: protein,
vegetables, equipment, style, time. However, it’s in “long form” so each
challenge shows up multiple times. It categorizes the randomizer
ingredients into categories and subcategories. If a value from one
randomizer wheel better fits into another category, it has been
reclassified (e.g., “Habanero” from the “wildcard” randomizer has been
reclassified as “produce.”)

The unique identifiers of this dataset are
`season`-`episode`-`round`-`challenge`-`randomizer`.

- `season`: Season number
- `episode`: Episode number
- `round`: Stage of the tournament: Qualifier semi-final, Qualifier
  final, Round of 32, Round of 16, Quarterfinals, Semifinals, Final
- `challenge`: Variable to help distinguish challenges within the same
  Coast & Round
- `coast`: East or West
- `region`: The region depends on how many chefs start the competition.
  If there are 16 chefs, then the region is left blank. If there are 32
  chefs, then the regions are A or B.
- `time`: Length of challenge. Unit is minutes
- `randomizer`: What wheel was spun (1, 2, 3, 4, or 5)
- `value`: What was the value/item on the randomizer wheel?
- `category`: Categorical variable:
  protein,produce,equipment,style,wildcard
- `subcategory`: Subcategories for protein (Beef, Fish, Game, Other,
  Pork, Poultry, Shellfish) and style (Region/country, Style, Theme)

``` r
randomizerlongform 
#> # A tibble: 615 × 11
#>    season episode round   challenge coast region  time randomizer value category
#>     <dbl>   <dbl> <chr>   <chr>     <chr> <chr>  <dbl> <chr>      <chr> <chr>   
#>  1      1       1 Round … Alex/Dar… East  <NA>      35 randomize… Pork… protein 
#>  2      1       1 Round … Alex/Dar… East  <NA>      35 randomize… Peas  produce 
#>  3      1       1 Round … Alex/Dar… East  <NA>      35 randomize… Waff… equipme…
#>  4      1       1 Round … Alex/Dar… East  <NA>      35 randomize… Glaz… style   
#>  5      1       1 Round … Antonia/… West  <NA>      30 randomize… Cod   protein 
#>  6      1       1 Round … Antonia/… West  <NA>      30 randomize… Avoc… produce 
#>  7      1       1 Round … Antonia/… West  <NA>      30 randomize… Micr… equipme…
#>  8      1       1 Round … Antonia/… West  <NA>      30 randomize… Sweet style   
#>  9      1       1 Round … Eric/Jet  West  <NA>      35 randomize… Top … protein 
#> 10      1       1 Round … Eric/Jet  West  <NA>      35 randomize… Mush… produce 
#> # ℹ 605 more rows
#> # ℹ 1 more variable: subcategory <chr>
```

</details>
<details>
<summary>
<strong>Results</strong>
</summary>

### Results

The unique identifiers of this dataset are
`season`-`episode`-`round`-`challenge`-`chef`.

- `season`: Season number
- `episode`: Episode number
- `round`: Stage of the tournament: Qualifier semi-final, Qualifier
  final, Round of 32, Round of 16, Quarterfinals, Semifinals, Final
- `challenge`: Variable to help distinguish rounds within the same Coast
  & Round
- `coast`: Are they East or West Coast?
- `region`: The region depends on how many chefs start the competition.
  If there are 16 chefs, then the region is left blank. If there are 32
  chefs, then the regions are A or B.
- `chef`: Name of chef
- `commentator`: Who presented their food to the judges: Simon Majumdar
  or Justin Warner?
- `order`: When did their food get presented to the judges: Presented
  first or Presented second
- `score_taste`: Score that chef received for the taste of their dish:
  values of 0- 50
- `score_randomizer`: Score that chef received for how well they used
  the Randomizer: values of 0- 30
- `score_presentation`: Score that chef received for the presentation of
  their dish: values of 0- 20
- `total`: Total score that chef received: between 0 and 100
- `winner`: Winner, loser, or tie
- `x`: Numeric X value to help when creating the bracket
- `y`: Numeric Y value to help when creating the bracket

``` r
results 
#> # A tibble: 284 × 16
#>    season episode round       challenge     coast region chef  commentator order
#>     <dbl>   <dbl> <chr>       <chr>         <chr> <chr>  <chr> <chr>       <chr>
#>  1      1       1 Round of 16 Alex/Darnell  East  <NA>   Darn… Justin War… Pres…
#>  2      1       1 Round of 16 Alex/Darnell  East  <NA>   Alex… Simon Maju… Pres…
#>  3      1       1 Round of 16 Antonia/Marc… West  <NA>   Marc… Simon Maju… Pres…
#>  4      1       1 Round of 16 Antonia/Marc… West  <NA>   Anto… Justin War… Pres…
#>  5      1       1 Round of 16 Eric/Jet      West  <NA>   Jet … Justin War… Pres…
#>  6      1       1 Round of 16 Eric/Jet      West  <NA>   Eric… Simon Maju… Pres…
#>  7      1       2 Round of 16 Amanda/Eliza… East  <NA>   Eliz… Justin War… Pres…
#>  8      1       2 Round of 16 Amanda/Eliza… East  <NA>   Aman… Simon Maju… Pres…
#>  9      1       2 Round of 16 Beau/Richard  West  <NA>   Rich… Justin War… Pres…
#> 10      1       2 Round of 16 Beau/Richard  West  <NA>   Beau… Simon Maju… Pres…
#> # ℹ 274 more rows
#> # ℹ 7 more variables: score_taste <dbl>, score_randomizer <dbl>,
#> #   score_presentation <dbl>, total <dbl>, winner <chr>, x <dbl>, y <dbl>
```

</details>
<details>
<summary>
<strong>Judges</strong>
</summary>

### Judges

The unique identifier is `season`-`episode`-`round`, because
occasionally a judge will only judge for one round within an episode.

- `season`: Season number
- `episode`: Episode number
- `judge`: Name of guest judge
- `gender`: Gender of guest judge
- `round`: Stage of the tournament: Qualifier semi-final, Qualifier
  final, Round of 32, Round of 16, Quarterfinals, Semifinals, Final

``` r
judges
#> # A tibble: 165 × 5
#>    season episode judge             gender round        
#>     <dbl>   <dbl> <chr>             <chr>  <chr>        
#>  1      1       1 Curtis Stone      male   Round of 16  
#>  2      1       1 Marcus Samuelsson male   Round of 16  
#>  3      1       1 Nancy Silverton   female Round of 16  
#>  4      1       2 Marcus Samuelsson male   Round of 16  
#>  5      1       2 Ming Tsai         male   Round of 16  
#>  6      1       2 Nancy Silverton   female Round of 16  
#>  7      1       3 Marcus Samuelsson male   Round of 16  
#>  8      1       3 Marcus Samuelsson male   Quarter-final
#>  9      1       3 Ming Tsai         male   Round of 16  
#> 10      1       3 Ming Tsai         male   Quarter-final
#> # ℹ 155 more rows
```

</details>

## 6. Examples

See the sections below for examples of how to use the data

<details>
<summary>
<strong>Brackets</strong>
</summary>

### Brackets

![](README_files/figure-gfm/Brackets%20-1.png)<!-- -->![](README_files/figure-gfm/Brackets%20-2.png)<!-- -->![](README_files/figure-gfm/Brackets%20-3.png)<!-- -->![](README_files/figure-gfm/Brackets%20-4.png)<!-- -->

</details>
<details>
<summary>
<strong>Gender distribution by season: Seasons 1 through 5</strong>
</summary>

### Gender distribution by season: Season 1 through 5

``` r
seeds %>% left_join(chefs) %>%
  group_by(season,gender) %>%
  summarise(n=n()) %>%
  pivot_wider(names_from=gender,values_from=n) 
#> Joining with `by = join_by(chef)`
#> `summarise()` has grouped output by 'season'. You can override using the
#> `.groups` argument.
#> # A tibble: 5 × 3
#> # Groups:   season [5]
#>   season female  male
#>    <dbl>  <int> <int>
#> 1      1      6    10
#> 2      2      8    14
#> 3      3     13    19
#> 4      4     15    17
#> 5      5     20    24
```

</details>
<details>
<summary>
<strong>Subcategories of proteins used in battles</strong>
</summary>

### Subcategories of proteins used in battles

``` r
randomizerlongform %>% 
  group_by(category,subcategory) %>% 
  filter(category %in% c("protein")) %>% 
  summarise(number_of_battles=n())
#> `summarise()` has grouped output by 'category'. You can override using the
#> `.groups` argument.
#> # A tibble: 7 × 3
#> # Groups:   category [1]
#>   category subcategory number_of_battles
#>   <chr>    <chr>                   <int>
#> 1 protein  Beef                       23
#> 2 protein  Fish                       31
#> 3 protein  Game                       27
#> 4 protein  Other                       4
#> 5 protein  Pork                       25
#> 6 protein  Poultry                    23
#> 7 protein  Shellfish                  15
```

</details>
