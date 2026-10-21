
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mapuce

<!-- badges: start -->

<!-- badges: end -->

The goal of mapuce is to Convert RP INDCVI detail files to semantic data
input for MAPUCE models.

The mapuce package contains a set of functions to check, extract and
transform variables from the RP INDCVI detail files from the french
census, in order to prepare them for mapuce models.

## Installation

This package is not available on CRAN, to install it please use the
following commands:

From GitHub:

``` r
remotes::install_github("AcidyBee/mapuce")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(mapuce)
## basic example code
```

You can describe model modalities using the following command:

``` r
describe_model_modalities(model_eq)
#> # A tibble: 12 × 4
#>    var_code     class   levels        range
#>    <chr>        <chr>   <fct>         <chr>
#>  1 eq_2g        factor  faible        <NA> 
#>  2 eq_2g        factor  fort          <NA> 
#>  3 couple       factor  oui           <NA> 
#>  4 couple       factor  non           <NA> 
#>  5 typl_ma      factor  maison        <NA> 
#>  6 typl_ma      factor  appartement   <NA> 
#>  7 nperr_123    factor  1             <NA> 
#>  8 nperr_123    factor  2             <NA> 
#>  9 nperr_123    factor  3 ou +        <NA> 
#> 10 stocd_2g     factor  proprietaires <NA> 
#> 11 stocd_2g     factor  autres        <NA> 
#> 12 surf_6g_cont integer <NA>          1-6
```
