
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hacksaw

<!-- badges: start -->

![](https://camo.githubusercontent.com/ea6e0ff99602c3563e3dd684abf60b30edceaeef/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f6c6966656379636c652d6578706572696d656e74616c2d6f72616e67652e737667)
![CRAN log](http://www.r-pkg.org/badges/version/hacksaw)
<!-- badges: end -->

hacksaw is as an adhesive between various dplyr and purrr operations.

## Installation

You can install the released version of hacksaw from GitHub with:

``` r
remotes::install_github("daranzolin/hacksaw")
```

## Split operations

### filter

``` r
library(hacksaw)
library(dplyr)

iris %>% 
  filter_split(Petal.Length > 5.1,
               Sepal.Length > 6.4) %>% 
  str()
#> List of 2
#>  $ :'data.frame':    34 obs. of  5 variables:
#>   ..$ Sepal.Length: num [1:34] 6.3 7.1 6.3 6.5 7.6 7.3 6.7 7.2 6.4 6.8 ...
#>   ..$ Sepal.Width : num [1:34] 3.3 3 2.9 3 3 2.9 2.5 3.6 2.7 3 ...
#>   ..$ Petal.Length: num [1:34] 6 5.9 5.6 5.8 6.6 6.3 5.8 6.1 5.3 5.5 ...
#>   ..$ Petal.Width : num [1:34] 2.5 2.1 1.8 2.2 2.1 1.8 1.8 2.5 1.9 2.1 ...
#>   ..$ Species     : Factor w/ 3 levels "setosa","versicolor",..: 3 3 3 3 3 3 3 3 3 3 ...
#>  $ :'data.frame':    35 obs. of  5 variables:
#>   ..$ Sepal.Length: num [1:35] 7 6.9 6.5 6.6 6.7 6.6 6.8 6.7 6.7 7.1 ...
#>   ..$ Sepal.Width : num [1:35] 3.2 3.1 2.8 2.9 3.1 3 2.8 3 3.1 3 ...
#>   ..$ Petal.Length: num [1:35] 4.7 4.9 4.6 4.6 4.4 4.4 4.8 5 4.7 5.9 ...
#>   ..$ Petal.Width : num [1:35] 1.4 1.5 1.5 1.3 1.4 1.4 1.4 1.7 1.5 2.1 ...
#>   ..$ Species     : Factor w/ 3 levels "setosa","versicolor",..: 2 2 2 2 2 2 2 2 2 3 ...
```

### select

``` r
iris %>% 
  select_split(starts_with("Sepal"),
               starts_with("Petal")) %>% 
  str()
#> List of 2
#>  $ :'data.frame':    150 obs. of  2 variables:
#>   ..$ Sepal.Length: num [1:150] 5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
#>   ..$ Sepal.Width : num [1:150] 3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
#>  $ :'data.frame':    150 obs. of  2 variables:
#>   ..$ Petal.Length: num [1:150] 1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
#>   ..$ Petal.Width : num [1:150] 0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
```

### distinct

``` r
df <- tibble(
  x = sample(10, 100, rep = TRUE),
  y = sample(10, 100, rep = TRUE)
)

starwars %>% 
  distinct_split(skin_color, eye_color, homeworld) %>% 
  str()
#> List of 3
#>  $ : Named chr [1:31] "fair" "gold" "white, blue" "white" ...
#>   ..- attr(*, "names")= chr [1:31] "skin_color1" "skin_color2" "skin_color3" "skin_color4" ...
#>  $ : Named chr [1:15] "blue" "yellow" "red" "brown" ...
#>   ..- attr(*, "names")= chr [1:15] "eye_color1" "eye_color2" "eye_color3" "eye_color4" ...
#>  $ : Named chr [1:49] "Tatooine" "Naboo" "Alderaan" "Stewjon" ...
#>   ..- attr(*, "names")= chr [1:49] "homeworld1" "homeworld2" "homeworld3" "homeworld4" ...

iris %>% 
  transmute_split(Sepal.Length * 2, Petal.Width + 5) %>% 
  str()
#> List of 2
#>  $ :'data.frame':    150 obs. of  1 variable:
#>   ..$ Sepal.Length * 2: num [1:150] 10.2 9.8 9.4 9.2 10 10.8 9.2 10 8.8 9.8 ...
#>  $ :'data.frame':    150 obs. of  1 variable:
#>   ..$ Petal.Width + 5: num [1:150] 5.2 5.2 5.2 5.2 5.2 5.4 5.3 5.2 5.2 5.1 ...
```

## Casting

Tired of `mutate(... = as....(...))`?

``` r
starwars %>% cast_character(height, mass) %>% str(max.level = 2) 
#> tibble [87 × 13] (S3: tbl_df/tbl/data.frame)
#>  $ name      : chr [1:87] "Luke Skywalker" "C-3PO" "R2-D2" "Darth Vader" ...
#>  $ height    : chr [1:87] "172" "167" "96" "202" ...
#>  $ mass      : chr [1:87] "77" "75" "32" "136" ...
#>  $ hair_color: chr [1:87] "blond" NA NA "none" ...
#>  $ skin_color: chr [1:87] "fair" "gold" "white, blue" "white" ...
#>  $ eye_color : chr [1:87] "blue" "yellow" "red" "yellow" ...
#>  $ birth_year: num [1:87] 19 112 33 41.9 19 52 47 NA 24 57 ...
#>  $ gender    : chr [1:87] "male" NA NA "male" ...
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

The reverse of `tidyr::drop_na`.

``` r
df <- tibble(x = c(1, 2, NA, NA), y = c("a", NA, "b", NA))
df %>% keep_na(x)
#> # A tibble: 2 x 2
#>       x y    
#>   <dbl> <chr>
#> 1    NA b    
#> 2    NA <NA>
df %>% keep_na(x, y)
#> # A tibble: 1 x 2
#>       x y    
#>   <dbl> <chr>
#> 1    NA <NA>
```
