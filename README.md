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
#> htmltools (0.5.8 -> 0.5.8.1) [CRAN]
#> knitr     (1.45  -> 1.46   ) [CRAN]
#> 
#>   There is a binary version available but the source version is later:
#>       binary source needs_compilation
#> knitr   1.45   1.46             FALSE
#> 
#> 
#> The downloaded binary packages are in
#>  /var/folders/0p/_s6v9q110z9fh4y0vq9ml47m0000gp/T//RtmpcAtusj/downloaded_packages
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#>      checking for file ‘/private/var/folders/0p/_s6v9q110z9fh4y0vq9ml47m0000gp/T/RtmpcAtusj/remotese14b7da2d3b/celevitz-touRnamentofchampions-4f25069/DESCRIPTION’ ...  ✔  checking for file ‘/private/var/folders/0p/_s6v9q110z9fh4y0vq9ml47m0000gp/T/RtmpcAtusj/remotese14b7da2d3b/celevitz-touRnamentofchampions-4f25069/DESCRIPTION’
#>   ─  preparing ‘touRnamentofchampions’:
#>   ✔  checking DESCRIPTION meta-information
#>   ─  checking for LF line-endings in source and make files and shell scripts
#>   ─  checking for empty or unneeded directories
#>   ─  building ‘touRnamentofchampions_0.1.0.tar.gz’
#>      
#> 
```

## 3. News

Issues to work on:

- Data entry for Season 5 as it airs
- Complete handedness and nicknames

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
- `handedness`: Whether the chef is righthanded, lefthanded, or
  ambidextrous
- `gender`: male, female, nonbinary

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
#> # A tibble: 137 × 12
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
#> # ℹ 127 more rows
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
ingredients into categories and subcategories.

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
- `value`: What was the value/item on the randomzier wheel?
- `category`: Categorical variable:
  protein,produce,equipment,style,wildcard
- `subcategory`: Subcategories for protein (Beef, Fish, Game, Other,
  Pork, Poultry, Shellfish) and style (Region/country, Style, Theme)

``` r
randomizerlongform 
#> # A tibble: 600 × 11
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
#> # ℹ 590 more rows
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
  1st or Presented 2nd
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
#> # A tibble: 282 × 16
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
#> # ℹ 272 more rows
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
#> # A tibble: 155 × 5
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
#> # ℹ 145 more rows
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
<strong>Gender distribution by season: Seasons 1 through 4</strong>
</summary>

### Gender distribution by season: Season 1 through 4

``` r
seeds %>% left_join(chefs) %>%
  # keep only seasons 1 through 4
  filter(season < 5) %>%
  group_by(season,gender) %>%
  summarise(n=n()) %>%
  pivot_wider(names_from=gender,values_from=n) 
#> Joining with `by = join_by(chef)`
#> `summarise()` has grouped output by 'season'. You can override using the
#> `.groups` argument.
#> # A tibble: 4 × 3
#> # Groups:   season [4]
#>   season female  male
#>    <dbl>  <int> <int>
#> 1      1      6    10
#> 2      2      8    14
#> 3      3     13    19
#> 4      4     15    17
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
#> # A tibble: 8 × 3
#> # Groups:   category [1]
#>   category subcategory number_of_battles
#>   <chr>    <chr>                   <int>
#> 1 protein  Beef                       22
#> 2 protein  Fish                       27
#> 3 protein  Game                       25
#> 4 protein  Other                       4
#> 5 protein  Pork                       24
#> 6 protein  Poultry                    23
#> 7 protein  Shellfish                  15
#> 8 protein  <NA>                        3
```

</details>
