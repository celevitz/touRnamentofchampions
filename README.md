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
#> * checking for file ‘/private/var/folders/0p/_s6v9q110z9fh4y0vq9ml47m0000gp/T/RtmpYtjatG/remotesc473e42038f/celevitz-touRnamentofchampions-935acd2/DESCRIPTION’ ... OK
#> * preparing ‘touRnamentofchampions’:
#> * checking DESCRIPTION meta-information ... OK
#> * checking for LF line-endings in source and make files and shell scripts
#> * checking for empty or unneeded directories
#> * building ‘touRnamentofchampions_0.1.0.tar.gz’
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
#> # A tibble: 122 × 5
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
#> # ℹ 112 more rows
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
#> # A tibble: 69 × 4
#>    chef               nickname         handedness   gender
#>    <chr>              <chr>            <chr>        <chr> 
#>  1 Aaron May          <NA>             <NA>         male  
#>  2 Aarthi Sampath     <NA>             <NA>         female
#>  3 Adam Sobel         <NA>             <NA>         male  
#>  4 Adriana Urbina     <NA>             <NA>         female
#>  5 Alex Guarnaschelli N/A              Right-handed female
#>  6 Amanda Freitag     Chef AF          Right-handed female
#>  7 Antonia Lofaso     Warrior Princess Right-handed female
#>  8 Beau MacMillan     Beau Mac         Right-handed male  
#>  9 Bobby Marcotte     <NA>             <NA>         male  
#> 10 Brian Malarkey     <NA>             Left-handed  male  
#> # ℹ 59 more rows
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
#> # A tibble: 107 × 12
#>    season episode round         challenge   coast region randomizer1 randomizer2
#>     <dbl>   <dbl> <chr>         <chr>       <chr> <chr>  <chr>       <chr>      
#>  1      1       1 Round of 16   Alex/Darne… East  <NA>   Pork tende… Peas       
#>  2      1       2 Round of 16   Amanda/Eli… East  <NA>   Pork blade… Squash     
#>  3      1       3 Round of 16   Maneet/Roc… East  <NA>   Chicken th… Kale       
#>  4      1       2 Round of 16   Christian/… East  <NA>   Shrimp      Carrots    
#>  5      1       1 Round of 16   Antonia/Ma… West  <NA>   Cod         Avocado    
#>  6      1       2 Round of 16   Beau/Richa… West  <NA>   Ground lamb Broccoli   
#>  7      1       1 Round of 16   Eric/Jet    West  <NA>   Top sirloin Mushrooms  
#>  8      1       3 Round of 16   Brooke/Mic… West  <NA>   Chicken br… Radish     
#>  9      1       3 Quarter-final Antonia/Be… West  <NA>   Quail       Bok choy   
#> 10      1       4 Quarter-final Brooke/Jet  West  <NA>   Salmon      Bitter mel…
#> # ℹ 97 more rows
#> # ℹ 4 more variables: randomizer3 <chr>, randomizer4 <chr>, time <dbl>,
#> #   randomizer5 <dbl>
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
#> # A tibble: 222 × 16
#> # Groups:   season, episode, round, challenge, winner [175]
#>    season episode round       challenge     coast region chef  commentator order
#>     <dbl>   <dbl> <chr>       <chr>         <chr> <chr>  <chr> <chr>       <chr>
#>  1      1       1 Round of 16 Alex/Darnell  East  <NA>   Darn… Justin War… Pres…
#>  2      1       1 Round of 16 Alex/Darnell  East  <NA>   Alex… Simon Maju… Pres…
#>  3      1       2 Round of 16 Amanda/Eliza… East  <NA>   Eliz… Justin War… Pres…
#>  4      1       2 Round of 16 Amanda/Eliza… East  <NA>   Aman… Simon Maju… Pres…
#>  5      1       3 Round of 16 Maneet/Rocco  East  <NA>   Mane… Simon Maju… Pres…
#>  6      1       3 Round of 16 Maneet/Rocco  East  <NA>   Rocc… Justin War… Pres…
#>  7      1       2 Round of 16 Christian/Ma… East  <NA>   Chri… Justin War… Pres…
#>  8      1       2 Round of 16 Christian/Ma… East  <NA>   Marc… Simon Maju… Pres…
#>  9      1       1 Round of 16 Antonia/Marc… West  <NA>   Marc… Simon Maju… Pres…
#> 10      1       1 Round of 16 Antonia/Marc… West  <NA>   Anto… Justin War… Pres…
#> # ℹ 212 more rows
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
- `round`: Stage of the tournament: Qualifier semi-final, Qualifier
  final, Round of 32, Round of 16, Quarterfinals, Semifinals, Final

``` r
judges
#> # A tibble: 134 × 4
#>    season episode judge             round        
#>     <dbl>   <dbl> <chr>             <chr>        
#>  1      1       1 Curtis Stone      Round of 16  
#>  2      1       1 Marcus Samuelsson Round of 16  
#>  3      1       1 Nancy Silverton   Round of 16  
#>  4      1       2 Marcus Samuelsson Round of 16  
#>  5      1       2 Ming Tsai         Round of 16  
#>  6      1       2 Nancy Silverton   Round of 16  
#>  7      1       3 Marcus Samuelsson Round of 16  
#>  8      1       3 Ming Tsai         Round of 16  
#>  9      1       3 Nancy Silverton   Quarter-final
#> 10      1       3 Marcus Samuelsson Quarter-final
#> # ℹ 124 more rows
```

</details>

## 6. Examples

See the sections below for examples of how to use the data

<details>
<summary>
<strong>Gender distribution by season: Seasons 1 through 4</strong>
</summary>

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

</details>
