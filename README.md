
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hacksaw

<!-- badges: start -->

![](https://camo.githubusercontent.com/ea6e0ff99602c3563e3dd684abf60b30edceaeef/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f6c6966656379636c652d6578706572696d656e74616c2d6f72616e67652e737667)
![CRAN log](http://www.r-pkg.org/badges/version/hacksaw)
![](http://cranlogs.r-pkg.org/badges/last-week/hacksaw) [![Travis build
status](https://travis-ci.org/daranzolin/hacksaw.svg?branch=master)](https://travis-ci.com/daranzolin/hacksaw)
<!-- badges: end -->

hacksaw is as an adhesive between various dplyr and purrr operations,
with some extra tidyverse-like functionality (e.g. keeping NAs, shifting
row values) and shortcuts (e.g. filtering patterns, casting, plucking,
etc.).

## Installation

You can install the released version of hacksaw from CRAN with:

``` r
install.packages("hacksaw")
```

Or install the development version from GitHub with:

``` r
remotes::install_github("daranzolin/hacksaw")
```

## Split operations

hacksaw’s assortment of split operations recycle the original data
frame. This is useful when you want to run slightly different code on
the same object multiple times (e.g. assignment) or you want to take
advantage of some list functionality (e.g. purrr, `lengths()`, `%->%`,
etc.).

The useful`%<-%` and `%->%` operators are re-exported from [the zeallot
package.](https://github.com/r-lib/zeallot)

### precision\_split

`precision_split` splits the mtcars data frame into two: one with mpg
greater than 20, one with mpg less than 20:

``` r
library(hacksaw)
library(tidyverse)
#> ── Attaching packages ──────────────────────────────────────────────────────────────────────────────────── tidyverse 1.3.0 ──
#> ✓ ggplot2 3.3.0     ✓ purrr   0.3.4
#> ✓ tibble  3.0.2     ✓ dplyr   1.0.0
#> ✓ tidyr   1.0.2     ✓ stringr 1.4.0
#> ✓ readr   1.3.1     ✓ forcats 0.5.0
#> Warning: package 'tibble' was built under R version 4.0.2
#> ── Conflicts ─────────────────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()

mtcars %>% 
  precision_split(mpg > 20) %->% c(gt20mpg, lt20mpg)

str(gt20mpg)
#> 'data.frame':    18 obs. of  11 variables:
#>  $ mpg : num  18.7 18.1 14.3 19.2 17.8 16.4 17.3 15.2 10.4 10.4 ...
#>  $ cyl : num  8 6 8 6 6 8 8 8 8 8 ...
#>  $ disp: num  360 225 360 168 168 ...
#>  $ hp  : num  175 105 245 123 123 180 180 180 205 215 ...
#>  $ drat: num  3.15 2.76 3.21 3.92 3.92 3.07 3.07 3.07 2.93 3 ...
#>  $ wt  : num  3.44 3.46 3.57 3.44 3.44 ...
#>  $ qsec: num  17 20.2 15.8 18.3 18.9 ...
#>  $ vs  : num  0 1 0 1 1 0 0 0 0 0 ...
#>  $ am  : num  0 0 0 0 0 0 0 0 0 0 ...
#>  $ gear: num  3 3 3 4 4 3 3 3 3 3 ...
#>  $ carb: num  2 1 4 4 4 3 3 3 4 4 ...
str(lt20mpg)
#> 'data.frame':    14 obs. of  11 variables:
#>  $ mpg : num  21 21 22.8 21.4 24.4 22.8 32.4 30.4 33.9 21.5 ...
#>  $ cyl : num  6 6 4 6 4 4 4 4 4 4 ...
#>  $ disp: num  160 160 108 258 147 ...
#>  $ hp  : num  110 110 93 110 62 95 66 52 65 97 ...
#>  $ drat: num  3.9 3.9 3.85 3.08 3.69 3.92 4.08 4.93 4.22 3.7 ...
#>  $ wt  : num  2.62 2.88 2.32 3.21 3.19 ...
#>  $ qsec: num  16.5 17 18.6 19.4 20 ...
#>  $ vs  : num  0 0 1 1 1 1 1 1 1 1 ...
#>  $ am  : num  1 1 1 0 0 0 1 1 1 0 ...
#>  $ gear: num  4 4 4 3 4 4 4 4 4 3 ...
#>  $ carb: num  4 4 1 1 2 2 1 2 1 1 ...
```

### filter

``` r
iris %>% 
  filter_split(
    large_petals = Petal.Length > 5.1,
    large_sepals = Sepal.Length > 6.4
  ) %>% 
  map(summary)
#> $large_petals
#>   Sepal.Length    Sepal.Width     Petal.Length    Petal.Width   
#>  Min.   :6.100   Min.   :2.500   Min.   :5.200   Min.   :1.400  
#>  1st Qu.:6.400   1st Qu.:2.900   1st Qu.:5.525   1st Qu.:1.900  
#>  Median :6.700   Median :3.000   Median :5.700   Median :2.100  
#>  Mean   :6.862   Mean   :3.071   Mean   :5.826   Mean   :2.094  
#>  3rd Qu.:7.200   3rd Qu.:3.200   3rd Qu.:6.075   3rd Qu.:2.300  
#>  Max.   :7.900   Max.   :3.800   Max.   :6.900   Max.   :2.500  
#>        Species  
#>  setosa    : 0  
#>  versicolor: 0  
#>  virginica :34  
#>                 
#>                 
#>                 
#> 
#> $large_sepals
#>   Sepal.Length    Sepal.Width     Petal.Length    Petal.Width         Species  
#>  Min.   :6.500   Min.   :2.500   Min.   :4.400   Min.   :1.30   setosa    : 0  
#>  1st Qu.:6.700   1st Qu.:3.000   1st Qu.:5.050   1st Qu.:1.65   versicolor: 9  
#>  Median :6.800   Median :3.000   Median :5.700   Median :2.00   virginica :26  
#>  Mean   :6.971   Mean   :3.071   Mean   :5.569   Mean   :1.94                  
#>  3rd Qu.:7.200   3rd Qu.:3.200   3rd Qu.:6.050   3rd Qu.:2.25                  
#>  Max.   :7.900   Max.   :3.800   Max.   :6.900   Max.   :2.50
```

### select

Include multiple columns and select helpers within `c()`:

``` r
iris %>% 
  select_split(
    sepal_data = c(Species, starts_with("Sepal")),
    petal_data = c(Species, starts_with("Petal"))
  ) %>% 
  str()
#> List of 2
#>  $ sepal_data:'data.frame':  150 obs. of  3 variables:
#>   ..$ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ Sepal.Length: num [1:150] 5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
#>   ..$ Sepal.Width : num [1:150] 3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
#>  $ petal_data:'data.frame':  150 obs. of  3 variables:
#>   ..$ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ Petal.Length: num [1:150] 1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
#>   ..$ Petal.Width : num [1:150] 0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
```

### distinct

Easily get the unique values of multiple columns,

``` r
starwars %>% 
  distinct_split(skin_color, eye_color, homeworld) %>% 
  str() # lengths() is also useful
#> List of 3
#>  $ : chr [1:31] "fair" "gold" "white, blue" "white" ...
#>  $ : chr [1:15] "blue" "yellow" "red" "brown" ...
#>  $ : chr [1:49] "Tatooine" "Naboo" "Alderaan" "Stewjon" ...
```

### mutate

``` r
iris %>% 
  mutate_split(
    Sepal.Length2 = Sepal.Length * 2,
    Sepal.Length3 = Sepal.Length * 3
  ) %>% 
  str()
#> List of 2
#>  $ :'data.frame':    150 obs. of  6 variables:
#>   ..$ Sepal.Length : num [1:150] 5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
#>   ..$ Sepal.Width  : num [1:150] 3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
#>   ..$ Petal.Length : num [1:150] 1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
#>   ..$ Petal.Width  : num [1:150] 0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
#>   ..$ Species      : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ Sepal.Length2: num [1:150] 10.2 9.8 9.4 9.2 10 10.8 9.2 10 8.8 9.8 ...
#>  $ :'data.frame':    150 obs. of  6 variables:
#>   ..$ Sepal.Length : num [1:150] 5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
#>   ..$ Sepal.Width  : num [1:150] 3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
#>   ..$ Petal.Length : num [1:150] 1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
#>   ..$ Petal.Width  : num [1:150] 0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
#>   ..$ Species      : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ Sepal.Length3: num [1:150] 15.3 14.7 14.1 13.8 15 16.2 13.8 15 13.2 14.7 ...
```

### transmute

``` r
iris %>% 
  transmute_split(Sepal.Length * 2, Petal.Width + 5) %>% 
  str()
#> List of 2
#>  $ : num [1:150] 10.2 9.8 9.4 9.2 10 10.8 9.2 10 8.8 9.8 ...
#>  $ : num [1:150] 5.2 5.2 5.2 5.2 5.2 5.4 5.3 5.2 5.2 5.1 ...
```

### slice

``` r
iris %>% 
  slice_split(1:10, 11:15, 30:50) %>% 
  str()
#> List of 3
#>  $ :'data.frame':    10 obs. of  5 variables:
#>   ..$ Sepal.Length: num [1:10] 5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9
#>   ..$ Sepal.Width : num [1:10] 3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1
#>   ..$ Petal.Length: num [1:10] 1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5
#>   ..$ Petal.Width : num [1:10] 0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1
#>   ..$ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1
#>  $ :'data.frame':    5 obs. of  5 variables:
#>   ..$ Sepal.Length: num [1:5] 5.4 4.8 4.8 4.3 5.8
#>   ..$ Sepal.Width : num [1:5] 3.7 3.4 3 3 4
#>   ..$ Petal.Length: num [1:5] 1.5 1.6 1.4 1.1 1.2
#>   ..$ Petal.Width : num [1:5] 0.2 0.2 0.1 0.1 0.2
#>   ..$ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1
#>  $ :'data.frame':    21 obs. of  5 variables:
#>   ..$ Sepal.Length: num [1:21] 4.7 4.8 5.4 5.2 5.5 4.9 5 5.5 4.9 4.4 ...
#>   ..$ Sepal.Width : num [1:21] 3.2 3.1 3.4 4.1 4.2 3.1 3.2 3.5 3.6 3 ...
#>   ..$ Petal.Length: num [1:21] 1.6 1.6 1.5 1.5 1.4 1.5 1.2 1.3 1.4 1.3 ...
#>   ..$ Petal.Width : num [1:21] 0.2 0.2 0.4 0.1 0.2 0.2 0.2 0.2 0.1 0.2 ...
#>   ..$ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
```

Use the `var_max` and `var_min` helpers to easily get minimum and
maximum values of a variable:

``` r
iris %>% 
  slice_split(
    largest_sepals = var_max(Sepal.Length, 4),
    smallest_sepals = var_min(Sepal.Length, 4)
  )
#> $largest_sepals
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width   Species
#> 1          7.7         3.8          6.7         2.2 virginica
#> 2          7.7         2.6          6.9         2.3 virginica
#> 3          7.7         2.8          6.7         2.0 virginica
#> 4          7.9         3.8          6.4         2.0 virginica
#> 
#> $smallest_sepals
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          4.4         2.9          1.4         0.2  setosa
#> 2          4.3         3.0          1.1         0.1  setosa
#> 3          4.4         3.0          1.3         0.2  setosa
#> 4          4.4         3.2          1.3         0.2  setosa
```

## eval\_split

Evaluate any expression:

``` r
mtcars %>% 
  eval_split(
    select(hp, mpg),
    filter(mpg > 25),
    mutate(pounds = wt*1000)
  ) %>% 
  str()
#> List of 3
#>  $ :'data.frame':    32 obs. of  2 variables:
#>   ..$ hp : num [1:32] 110 110 93 110 175 105 245 62 95 123 ...
#>   ..$ mpg: num [1:32] 21 21 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 ...
#>  $ :'data.frame':    6 obs. of  11 variables:
#>   ..$ mpg : num [1:6] 32.4 30.4 33.9 27.3 26 30.4
#>   ..$ cyl : num [1:6] 4 4 4 4 4 4
#>   ..$ disp: num [1:6] 78.7 75.7 71.1 79 120.3 ...
#>   ..$ hp  : num [1:6] 66 52 65 66 91 113
#>   ..$ drat: num [1:6] 4.08 4.93 4.22 4.08 4.43 3.77
#>   ..$ wt  : num [1:6] 2.2 1.61 1.83 1.94 2.14 ...
#>   ..$ qsec: num [1:6] 19.5 18.5 19.9 18.9 16.7 ...
#>   ..$ vs  : num [1:6] 1 1 1 1 0 1
#>   ..$ am  : num [1:6] 1 1 1 1 1 1
#>   ..$ gear: num [1:6] 4 4 4 4 5 5
#>   ..$ carb: num [1:6] 1 2 1 1 2 2
#>  $ :'data.frame':    32 obs. of  12 variables:
#>   ..$ mpg   : num [1:32] 21 21 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 ...
#>   ..$ cyl   : num [1:32] 6 6 4 6 8 6 8 4 4 6 ...
#>   ..$ disp  : num [1:32] 160 160 108 258 360 ...
#>   ..$ hp    : num [1:32] 110 110 93 110 175 105 245 62 95 123 ...
#>   ..$ drat  : num [1:32] 3.9 3.9 3.85 3.08 3.15 2.76 3.21 3.69 3.92 3.92 ...
#>   ..$ wt    : num [1:32] 2.62 2.88 2.32 3.21 3.44 ...
#>   ..$ qsec  : num [1:32] 16.5 17 18.6 19.4 17 ...
#>   ..$ vs    : num [1:32] 0 0 1 1 0 1 0 1 1 1 ...
#>   ..$ am    : num [1:32] 1 1 1 0 0 0 0 0 0 0 ...
#>   ..$ gear  : num [1:32] 4 4 4 3 3 3 3 4 4 4 ...
#>   ..$ carb  : num [1:32] 4 4 1 1 2 1 4 2 2 4 ...
#>   ..$ pounds: num [1:32] 2620 2875 2320 3215 3440 ...
```

## Casting

Tired of `mutate(var = as.[character|numeric|logical](var))`?

``` r
starwars %>% cast_character(height, mass) %>% str(max.level = 2) 
#> tibble [87 × 14] (S3: tbl_df/tbl/data.frame)
#>  $ name      : chr [1:87] "Luke Skywalker" "C-3PO" "R2-D2" "Darth Vader" ...
#>  $ height    : chr [1:87] "172" "167" "96" "202" ...
#>  $ mass      : chr [1:87] "77" "75" "32" "136" ...
#>  $ hair_color: chr [1:87] "blond" NA NA "none" ...
#>  $ skin_color: chr [1:87] "fair" "gold" "white, blue" "white" ...
#>  $ eye_color : chr [1:87] "blue" "yellow" "red" "yellow" ...
#>  $ birth_year: num [1:87] 19 112 33 41.9 19 52 47 NA 24 57 ...
#>  $ sex       : chr [1:87] "male" "none" "none" "male" ...
#>  $ gender    : chr [1:87] "masculine" "masculine" "masculine" "masculine" ...
#>  $ homeworld : chr [1:87] "Tatooine" "Tatooine" "Naboo" "Tatooine" ...
#>  $ species   : chr [1:87] "Human" "Droid" "Droid" "Human" ...
#>  $ films     :List of 87
#>  $ vehicles  :List of 87
#>  $ starships :List of 87
iris %>% cast_character(contains(".")) %>% str(max.level = 1)
#> 'data.frame':    150 obs. of  5 variables:
#>  $ Sepal.Length: chr  "5.1" "4.9" "4.7" "4.6" ...
#>  $ Sepal.Width : chr  "3.5" "3" "3.2" "3.1" ...
#>  $ Petal.Length: chr  "1.4" "1.4" "1.3" "1.5" ...
#>  $ Petal.Width : chr  "0.2" "0.2" "0.2" "0.2" ...
#>  $ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
```

hacksaw also includes `cast_numeric` and `cast_logical`.

## Keeping NAs

The reverse of `tidyr::drop_na`, strangely omitted in the original
tidyverse.

``` r
df <- tibble(x = c(1, 2, NA, NA, NA), y = c("a", NA, "b", NA, NA))
df %>% keep_na()
#> # A tibble: 2 x 2
#>       x y    
#>   <dbl> <chr>
#> 1    NA <NA> 
#> 2    NA <NA>
df %>% keep_na(x)
#> # A tibble: 3 x 2
#>       x y    
#>   <dbl> <chr>
#> 1    NA b    
#> 2    NA <NA> 
#> 3    NA <NA>
df %>% keep_na(x, y)
#> # A tibble: 2 x 2
#>       x y    
#>   <dbl> <chr>
#> 1    NA <NA> 
#> 2    NA <NA>
```

## Shifting row values

Shift values across rows in either direction. Sometimes useful when
importing irregularly-shaped tabular data.

``` r
df <- tibble(
  s = c(NA, 1, NA, NA),
  t = c(NA, NA, 1, NA),
  u = c(NA, NA, 2, 5),
  v = c(5, 1, 9, 2),
  x = c(1, 5, 6, 7),
  y = c(NA, NA, 8, NA),
  z = 1:4
)
df
#> # A tibble: 4 x 7
#>       s     t     u     v     x     y     z
#>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <int>
#> 1    NA    NA    NA     5     1    NA     1
#> 2     1    NA    NA     1     5    NA     2
#> 3    NA     1     2     9     6     8     3
#> 4    NA    NA     5     2     7    NA     4

shift_row_values(df)
#> # A tibble: 4 x 7
#>       s     t     u     v     x     y     z
#>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <int>
#> 1     5     1     1    NA    NA    NA    NA
#> 2     1     1     5     2    NA    NA    NA
#> 3     1     2     9     6     8     3    NA
#> 4     5     2     7     4    NA    NA    NA
shift_row_values(df, at = 1:3)
#> # A tibble: 4 x 7
#>       s     t     u     v     x     y     z
#>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <int>
#> 1     5     1     1    NA    NA    NA    NA
#> 2     1     1     5     2    NA    NA    NA
#> 3     1     2     9     6     8     3    NA
#> 4    NA    NA     5     2     7    NA     4
shift_row_values(df, at = 1:2, .dir = "right")
#> # A tibble: 4 x 7
#>       s     t     u     v     x     y     z
#>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <int>
#> 1    NA    NA    NA    NA     5     1     1
#> 2    NA    NA    NA     1     1     5     2
#> 3    NA     1     2     9     6     8     3
#> 4    NA    NA     5     2     7    NA     4
```

## Filtering, keeping, and discarding patterns

A wrapper around `filter(grepl(..., var))`:

``` r
starwars %>% 
  filter_pattern(homeworld, "oo") %>% 
  distinct(homeworld)
#> # A tibble: 2 x 1
#>   homeworld
#>   <chr>    
#> 1 Tatooine 
#> 2 Naboo
```

Use `keep_pattern` and `discard_pattern` for lists and vectors.

## Plucking values

A wrapper around `x[p][i]`:

``` r
df <- tibble(
  id = c(1, 1, 1, 2, 2, 2, 3, 3),
  tested = c("no", "no", "yes", "no", "no", "no", "yes", "yes"),
  year = c(2015:2017, 2010:2012, 2019:2020)
) 

df %>% 
  group_by(id) %>%
  mutate(year_first_tested = pluck_when(year, tested == "yes"))
#> # A tibble: 8 x 4
#> # Groups:   id [3]
#>      id tested  year year_first_tested
#>   <dbl> <chr>  <int>             <int>
#> 1     1 no      2015              2017
#> 2     1 no      2016              2017
#> 3     1 yes     2017              2017
#> 4     2 no      2010                NA
#> 5     2 no      2011                NA
#> 6     2 no      2012                NA
#> 7     3 yes     2019              2019
#> 8     3 yes     2020              2019
```
