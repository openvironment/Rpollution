
# Rpollution <img src="man/figures/logo.png" align="right" width = "15%">

The goal of `Rpollution` is to assemble R functions to analyse air
pollution data.

## Installation

You can install `Rpollution` from github with:

``` r
# install.packages("remotes")
remotes::install_github("williamorim/Rpollution")
```

## CETESB scraper

To scrape data from the CETESB qualar system, use the function
`scraper_cetesb()`.

``` r
library(Rpollution)

scraper_cetesb(
  parameter = 72, 
  station = 63, 
  start = "01/01/2018", 
  end = "31/01/2018", 
  login = "login", 
  password = "password"
)
```

If you substitute the values `login` and `password` by your login and
password from the Qualar system, this example will return the hourly NO
concentrations from the Pinheiros station for January 2018.
