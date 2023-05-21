touRnamentofchampions
================

## 1. Introduction to touRnamentofchampions

touRnamentofchampions is a collection of data sets detailing events
across all seasons of Tournament of Champions. It includes Chef
information, randomizer information, challenge results, and judge names.

## 2. Installation

Not yet on CRAN. So please use:
*devtools::install.packages(“celevitz/touRnamentofchampions”)*. If it’s
not appearing to be updated, restart your R sessions, install it again,
and call it into your library.

``` r
devtools::install_github("celevitz/touRnamentofchampions")
#> 
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#> * checking for file ‘/private/var/folders/0p/_s6v9q110z9fh4y0vq9ml47m0000gp/T/RtmpdgrWLg/remotes17436774d4c55/celevitz-touRnamentofchampions-e1ff1ec/DESCRIPTION’ ... OK
#> * preparing ‘touRnamentofchampions’:
#> * checking DESCRIPTION meta-information ... OK
#> * checking for LF line-endings in source and make files and shell scripts
#> * checking for empty or unneeded directories
#> * building ‘touRnamentofchampions_0.1.0.tar.gz’
```

## 3. News

Issues to work on:

- Data entry for Seasons 2 and 3
- The Randomizer data set has duplicate rows for the finals, one for
  each coast.
- Complete handedness
- Add gender to seed dataset

## 4. References & Acknowlegements

Data were collected manually while watching each season of Tournament of
Champions.

Huge thanks to <https://github.com/doehm> for all his support!

## 5. Datasets

Across datasets, key joining variables include:

- `chef`
- `season`
- `coast`
- `round`
- `episode`

### 5a. Seeds

- `chef`: Chef name (full name)
- `season`: Season number
- `seed`: Seed within their section of the bracket: values of 1 through
  8
- `coast`: Are they East or West Coast? And is it sub-bracket A or B?
- `nickname`: Guy Fieri’s nickname for the chef
- `handedness`: Whether the chef is righthanded, lefthanded, or
  ambidextrous

``` r
seeds 
#> # A tibble: 96 × 6
#>    chef               season  seed coast nickname         handedness            
#>    <chr>               <dbl> <dbl> <chr> <chr>            <chr>                 
#>  1 Alex Guarnaschelli      1     1 East  N/A              Right-handed          
#>  2 Marc Murphy             1     2 East  N/A              Left-handed (uses kni…
#>  3 Rocco DiSpirito         1     3 East  The Real Deal    Right-handed          
#>  4 Amanda Freitag          1     4 East  Chef AF          Right-handed          
#>  5 Elizabeth Falkner       1     5 East  N/A              Right-handed          
#>  6 Maneet Chauhan          1     6 East  N/A              Right-handed          
#>  7 Christian Petroni       1     7 East  Great Hambino    Right-handed          
#>  8 Darnell Ferguson        1     8 East  Super Chef       Right-handed          
#>  9 Antonia Lofaso          1     1 West  Warrior Princess Right-handed          
#> 10 Michael Voltaggio       1     2 West  N/A              Right-handed          
#> # ℹ 86 more rows
```

### 5b. Randomizer

- `season`: Season number
- `episode`: Episode number
- `round`: Stage of the tournament: Round 1, Round 2, Quarterfinals,
  Semifinals, Final
- `challenge`: Variable to help distinguish rounds within the same Coast
  & Round
- `coast`: The coast depends on how many chefs start the competition. If
  there are 16 chefs, then the coasts are: East, West. If there are 32
  chefs, then the coasts are: East A, East B, West A, West B
- `randomizer1`: First wheel of randomizer
- `randomizer2`: Second wheel of randomizer
- `randomizer3`: Third wheel of randomizer
- `randomizer4`: Fourth wheel of randomizer
- `time`: Length of challenge. Unit is minutes

``` r
randomizer 
#> # A tibble: 50 × 10
#>    season episode round      challenge coast randomizer1 randomizer2 randomizer3
#>     <dbl>   <dbl> <chr>      <chr>     <chr> <chr>       <chr>       <chr>      
#>  1      1       1 Round 1    A         East  Pork tende… Peas        Waffle iron
#>  2      1       2 Round 1    B         East  Pork blade… Squash      French fry…
#>  3      1       3 Round 1    C         East  Chicken th… Kale        Panini pre…
#>  4      1       2 Round 1    D         East  Shrimp      Carrots     Mandoline  
#>  5      1       1 Round 1    A         West  Cod         Avocado     Microwave  
#>  6      1       2 Round 1    B         West  Ground lamb Broccoli    Fryer      
#>  7      1       1 Round 1    C         West  Top sirloin Mushrooms   Juicer     
#>  8      1       3 Round 1    D         West  Chicken br… Radish      Pastry bag 
#>  9      1       3 Quarter-f… A         West  Quail       Bok choy    Mortar and…
#> 10      1       4 Quarter-f… B         West  Salmon      Bitter mel… Meat grind…
#> # ℹ 40 more rows
#> # ℹ 2 more variables: randomizer4 <chr>, time <dbl>
```

### 5c. Results

- `season`: Season number
- `episode`: Episode number
- `round`: Stage of the tournament: Round 1, Round 2, Quarterfinals,
  Semifinals, Final}
- `challenge`: Variable to help distinguish rounds within the same Coast
  & Round
- `coast`: The coast depends on how many chefs start the competition. If
  there are 16 chefs, then the coasts are: East, West. If there are 32
  chefs, then the coasts are: East A, East B, West A, West B
- `y`: Numeric value to help when creating the bracket
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

``` r
results 
#> # A tibble: 92 × 13
#>    season episode round   challenge     y coast chef           commentator order
#>     <dbl>   <dbl> <chr>   <chr>     <dbl> <chr> <chr>          <chr>       <chr>
#>  1      1       1 Round 1 A            12 East  Darnell Fergu… Justin War… Pres…
#>  2      1       1 Round 1 A            14 East  Alex Guarnasc… Simon Maju… Pres…
#>  3      1       2 Round 1 B             8 East  Elizabeth Fal… Justin War… Pres…
#>  4      1       2 Round 1 B            10 East  Amanda Freitag Simon Maju… Pres…
#>  5      1       3 Round 1 C             4 East  Maneet Chauhan Simon Maju… Pres…
#>  6      1       3 Round 1 C             6 East  Rocco DiSpiri… Justin War… Pres…
#>  7      1       2 Round 1 D             0 East  Christian Pet… Justin War… Pres…
#>  8      1       2 Round 1 D             2 East  Marc Murphy    Simon Maju… Pres…
#>  9      1       1 Round 1 A            12 West  Marcel Vigner… Simon Maju… Pres…
#> 10      1       1 Round 1 A            14 West  Antonia Lofaso Justin War… Pres…
#> # ℹ 82 more rows
#> # ℹ 4 more variables: score_taste <dbl>, score_randomizer <dbl>,
#> #   score_presentation <dbl>, total <dbl>
```

### 5d. Judges

If a judge scores for multiple rounds across one episode, they will
appear more than once in an episode. So unique identifier is
`season`-`episode`-`round`.

- `season`: Season number
- `episode`: Episode number
- `round`: Stage of the tournament: Round 1, Round 2, Quarterfinals,
  Semifinals, Final
- `judge`: Name of guest judge

``` r
judges
#> # A tibble: 52 × 4
#>    season episode round   judge             
#>     <dbl>   <dbl> <chr>   <chr>             
#>  1      4       1 Round 1 Nancy Silverton   
#>  2      4       1 Round 1 Alex Guarnaschelli
#>  3      4       1 Round 1 Andrew Zimmern    
#>  4      4       2 Round 1 Alex Guarnaschelli
#>  5      4       2 Round 1 Scott Conant      
#>  6      4       2 Round 1 Ming Tsai         
#>  7      4       3 Round 1 Scott Conant      
#>  8      4       3 Round 1 Andrew Zimmern    
#>  9      4       3 Round 1 Nancy Silverton   
#> 10      4       4 Round 1 Jonathan Waxman   
#> # ℹ 42 more rows
```
