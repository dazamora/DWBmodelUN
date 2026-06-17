# Fu's function for relationship between precipitation and potential evapotranspiration

It is a model based on the postulates of Budyko, which stated that not
only does the actual evapotranspiration depend on potential
evapotranspiration, but it is also constrained by water availability
(Budyko, 1974).

## Usage

``` r
funFU(PET, P, alpha)
```

## Arguments

- PET:

  is the variable which will be inserted as the numerator in Fu's
  function. It can be a value or a numeric vector, in which case it must
  have the same length as the denominator vector.

- P:

  is the variable which will be inserted as the denominator in Fu's
  function. It can be a value or a numeric vector, in which case it must
  have the same length as the numerator vector.

- alpha:

  parameter of Fu's model which controls the evapotranspiration
  efficiency, yet it is named depending on the variables used as
  numerator and denominator. It can be a single value of type double or
  a numeric vector with the same length as `PET` and `P`. Its values
  must be between 0 and 1.

## Value

a value or a vector (depending on which kind of data was introduced for
numerator and denominator).

## References

Zhang, L., Potter, N., Hickel, K., Zhang, Y., & Shao, Q. (2008). "Water
balance modeling over variable time scales based on the Budyko framework
– Model development and testing. Journal of Hydrology", 360(1-4),
117–131.

Budyko. (1974). "Climate and life". New York: Academic Press, INC.

## Author

Nicolas Duque Gardeazabal \<nduqueg@unal.edu.co\>  
Pedro Felipe Arboleda Obando \<pfarboledao@unal.edu.co\>  
Carolina Vega Viviescas \<cvegav@unal.edu.co\>  
David Zamora \<dazamoraa@unal.edu.co\>  

Water Resources Engineering Research Group - GIREH Universidad Nacional
de Colombia - sede Bogota

## Examples

``` r
PET <- 1000
P <- 2000
alpha <- 0.69  # value used by Zhang et al. (2008) 
funFU(PET, P, alpha)
#> [1] 0.4680175
```
