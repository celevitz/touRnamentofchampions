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
```

## 3. News

Issues to work on:

- Data entry for Season 5 as it airs
- Complete handedness and nicknames

## 4. References & Acknowlegements

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

### 5a. Seeds

-   `chef`: Chef name (full name)
-   `season`: Season number
-   `seed`: Seed within their section of the bracket: values of 1 through 8. 
Chefs that played in the play-in but didn't make the final bracket will have 
letters in their seeds.
-   `coast`: Are they East or West Coast?
-   `region`: The region depends on how many chefs start the competition. If 
there are 16 chefs, then the region is left blank. If there are 32 chefs, then 
the regions are A or B.

``` r
seeds 
# # A tibble: 122 × 5
#    chef               season seed  coast region
#    <chr>               <dbl> <chr> <chr> <chr> 
#  1 Alex Guarnaschelli      1 1.0   East  NA    
#  2 Marc Murphy             1 2.0   East  NA    
#  3 Rocco DiSpirito         1 3.0   East  NA    
#  4 Amanda Freitag          1 4.0   East  NA    
#  5 Elizabeth Falkner       1 5.0   East  NA    
#  6 Maneet Chauhan          1 6.0   East  NA    
#  7 Christian Petroni       1 7.0   East  NA    
#  8 Darnell Ferguson        1 8.0   East  NA    
#  9 Antonia Lofaso          1 1.0   West  NA    
# 10 Michael Voltaggio       1 2.0   West  NA    
# # ℹ 112 more rows
# # ℹ Use `print(n = ...)` to see more rows
```

### 5b. Chefs

-   `chef`: Chef name (full name)
-   `nickname`: Guy Fieri's nickname for the chef
-   `handedness`: Whether the chef is righthanded, lefthanded, or ambidextrous
-   `gender`: male, female, nonbinary

``` r
chefs
# A tibble: 69 × 4
#    chef               nickname         handedness   gender
#    <chr>              <chr>            <chr>        <chr> 
#  1 Aaron May          NA               NA           male  
#  2 Aarthi Sampath     NA               NA           female
#  3 Adam Sobel         NA               NA           male  
#  4 Adriana Urbina     NA               NA           female
#  5 Alex Guarnaschelli N/A              Right-handed female
#  6 Amanda Freitag     Chef AF          Right-handed female
#  7 Antonia Lofaso     Warrior Princess Right-handed female
#  8 Beau MacMillan     Beau Mac         Right-handed male  
#  9 Bobby Marcotte     NA               NA           male  
# 10 Brian Malarkey     NA               Left-handed  male  
# # ℹ 59 more rows
# # ℹ Use `print(n = ...)` to see more rows
```

### 5c. Randomizer

-   `season`: Season number
-   `episode`: Episode number
-   `round`: Stage of the tournament: Play-in, Qualifier semi-final, Qualifier 
final, Round of 32, Round of 16, Quarterfinals, Semifinals, Final
-   `challenge`: Variable to help distinguish rounds within the same Coast & 
Round
-   `coast`: Are they East or West Coast?
-   `region`: The region depends on how many chefs start the competition. If 
there are 16 chefs, then the region is left blank. If there are 32 chefs, then 
the regions are A or B.
-   `randomizer1`: First wheel of randomizer
-   `randomizer2`: Second wheel of randomizer
-   `randomizer3`: Third wheel of randomizer
-   `randomizer4`: Fourth wheel of randomizer
-   `time`: Length of challenge. Unit is minutes
-   `randomizer5`: Fifth wheel of randomizer

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

### 5d. Results

-   `season`: Season number
-   `episode`: Episode number
-   `round`: Stage of the tournament: Play-in, Qualifier semi-final, Qualifier 
final, Round of 32, Round of 16, Quarterfinals, Semifinals, Final
-   `challenge`: Variable to help distinguish rounds within the same Coast & 
Round
-   `coast`: Are they East or West Coast?
-   `region`: The region depends on how many chefs start the competition. If 
there are 16 chefs, then the region is left blank. If there are 32 chefs, then 
the regions are A or B.
-   `y`: Numeric value to help when creating the bracket
-   `chef`: Name of chef
-   `commentator`: Who presented their food to the judges: Simon Majumdar or 
Justin Warner?
-   `order`: When did their food get presented to the judges: Presented 1st or 
Presented 2nd
-   `score_taste`: Score that chef received for the taste of their dish: values 
of 0- 50
-   `score_randomizer`: Score that chef received for how well they used the 
Randomizer: values of 0- 30
-   `score_presentation`: Score that chef received for the presentation of 
their dish: values of 0- 20
-   `total`: Total score that chef received: between 0 and 100

``` r
results 
# # A tibble: 109 × 12
#    season episode round      challenge coast region randomizer1 randomizer2 randomizer3
#     <dbl>   <dbl> <chr>      <chr>     <chr> <chr>  <chr>       <chr>       <chr>      
#  1      1       1 Round of … A         East  NA     Pork tende… Peas        Waffle iron
#  2      1       2 Round of … B         East  NA     Pork blade… Squash      French fry…
#  3      1       3 Round of … C         East  NA     Chicken th… Kale        Panini pre…
#  4      1       2 Round of … D         East  NA     Shrimp      Carrots     Mandoline  
#  5      1       1 Round of … A         West  NA     Cod         Avocado     Microwave  
#  6      1       2 Round of … B         West  NA     Ground lamb Broccoli    Fryer      
#  7      1       1 Round of … C         West  NA     Top sirloin Mushrooms   Juicer     
#  8      1       3 Round of … D         West  NA     Chicken br… Radish      Pastry bag 
#  9      1       3 Quarter-f… A         West  NA     Quail       Bok choy    Mortar and…
# 10      1       4 Quarter-f… B         West  NA     Salmon      Bitter mel… Meat grind…
# # ℹ 99 more rows
# # ℹ 3 more variables: randomizer4 <chr>, time <dbl>, randomizer5 <dbl>
# # ℹ Use `print(n = ...)` to see more rows
```

### 5e. Judges

The unique identifier is `season`-`episode`-`round`, because occasionally judges
only judge for one round within an episode.

- `season`: Season number
- `episode`: Episode number
- `judge`: Name of guest judge
-   `round`: Stage of the tournament: Play-in, Qualifier semi-final, Qualifier final , Round of 32, Round of 16, Quarterfinals, Semifinals, Final

``` r
judges
# # A tibble: 134 × 4
#    season episode judge             round        
#     <dbl>   <dbl> <chr>             <chr>        
#  1      1       1 Curtis Stone      Round of 16  
#  2      1       1 Marcus Samuelsson Round of 16  
#  3      1       1 Nancy Silverton   Round of 16  
#  4      1       2 Marcus Samuelsson Round of 16  
#  5      1       2 Ming Tsai         Round of 16  
#  6      1       2 Nancy Silverton   Round of 16  
#  7      1       3 Marcus Samuelsson Round of 16  
#  8      1       3 Ming Tsai         Round of 16  
#  9      1       3 Nancy Silverton   Quarter-final
# 10      1       3 Marcus Samuelsson Quarter-final
# # ℹ 124 more rows
# # ℹ Use `print(n = ...)` to see more rows
```

## 6. Examples

### 6a. Season 1 Bracket

![](README_files/figure-gfm/Viz_Season1Bracket%20-1.png)<!-- -->

### 6b. Season 4 Bracket

![](README_files/figure-gfm/Viz_Season4Bracket%20-1.png)<!-- -->
