
# Rpollution <img src="man/figures/logo.png" align="right" width = "15%">

The goal of `Rpollution` is to assemble R functions to analyse air
pollution data.

## Installation

You can install `Rpollution` from github with:

``` r
# install.packages("remotes")
remotes::install_github("openvironment/Rpollution")
```

## CETESB scraper

To scrape data from the CETESB qualar system, use the function
`scraper_cetesb()`.

``` r
library(Rpollution)

scraper_cetesb(
  parameter = 63, 
  station = 72, 
  start = "01/01/2018", 
  end = "31/01/2018", 
  login = "login", 
  password = "password"
)
```

To see a list of parameter and station IDs, use the objects
`cetesb_param_ids` and `cetesb_station_ids`.

``` r
cetesb_param_ids
#> # A tibble: 20 x 3
#>       id param_abbrev param                              
#>    <int> <chr>        <chr>                              
#>  1    61 BEN          Benzeno                            
#>  2    16 CO           Monóxido de Carbono                
#>  3    23 DV           Direção do Vento                   
#>  4    21 DVG          Direção do Vento Global            
#>  5    19 ERT          Enxofre Reduzido Total             
#>  6    59 HCNM         Hidrocarbonetos Totais menos Metano
#>  7    12 MP10         Partículas Inaláveis               
#>  8    57 MP2.5        Partículas Inaláveis Finas         
#>  9    17 NO           Monóxido de Nitrogênio             
#> 10    15 NO2          Dióxido de Nitrogênio              
#> 11    18 NOx          Óxidos de Nitrogênio               
#> 12    63 O3           Ozônio                             
#> 13    29 PRESS        Pressão Atmosférica                
#> 14    26 RADG         Radiação Solar Global              
#> 15    56 RADUV        Radiação Ultra-violeta             
#> 16    13 SO2          Dióxido de Enxofre                 
#> 17    25 TEMP         Temperatura do Ar                  
#> 18    62 TOL          Tolueno                            
#> 19    28 UR           Umidade Relativa do Ar             
#> 20    24 VV           Velocidade do Vento
```

``` r
cetesb_station_ids
#> # A tibble: 62 x 25
#>       id stationname initial_date BEN   CO    ERT   MP10  MP2.5 NO    NO2  
#>    <int> <chr>       <chr>        <chr> <chr> <chr> <chr> <chr> <chr> <chr>
#>  1    65 Mauá        01/01/1998   <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> 
#>  2    66 Cubatão-V.… 01/01/1998   <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> 
#>  3    67 Sorocaba    01/01/1998   <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> 
#>  4    73 Congonhas   01/01/1998   no    yes   no    yes   yes   yes   yes  
#>  5    87 Cubatão-Ce… 01/01/1998   <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> 
#>  6    88 S.José Cam… 01/01/1998   <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> 
#>  7    89 Campinas-C… 01/01/1998   <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> 
#>  8    91 Cerqueira … 01/01/1998   no    yes   no    yes   no    yes   yes  
#>  9    92 Diadema     01/01/1998   <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> 
#> 10    95 Cid.Univer… 01/01/1998   no    hist  no    no    yes   yes   yes  
#> # … with 52 more rows, and 15 more variables: Nox <chr>, O3 <chr>, SO2 <chr>,
#> #   TOL <chr>, DV <chr>, DVG <chr>, PRESS <chr>, RADG <chr>, RADUV <chr>,
#> #   TEMP <chr>, UR <chr>, VV <chr>, address <chr>, lat <int>, long <int>
```

If you substitute the values `login` and `password` by your login and
password from the Qualar system, this example will return the hourly NO
concentrations from the Pinheiros station for January 2018.
