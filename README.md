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
#> * checking for file ‘/private/var/folders/0p/_s6v9q110z9fh4y0vq9ml47m0000gp/T/RtmpgbsCjh/remotes16fe6fa5dd22/celevitz-touRnamentofchampions-5352f7f/DESCRIPTION’ ... OK
#> * preparing ‘touRnamentofchampions’:
#> * checking DESCRIPTION meta-information ... OK
#> * checking for LF line-endings in source and make files and shell scripts
#> * checking for empty or unneeded directories
#> * building ‘touRnamentofchampions_0.1.0.tar.gz’
```

## 3. References & Acknowlegements

Data were collected manually while watching each season of Tournament of
Champions.

Huge thanks to <https://github.com/doehm> for all his support!

## 4. Overview of datasets

Across datasets, key joining variables include:

- `chef`
- `season`
- `coast`
- `round`
- `episode`
