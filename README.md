
<!-- README.md is generated from README.Rmd. Please edit that file -->
DWBmodelUN
==========

The R package DWBmodelUN aims to implement Dynamic Water Balance model proposed by L. Zhang et al. (2008) in a monthly time step. It is a tool for hydrologic modelling using the Budyko Framework and the Dynamic Water Balance Model, with other tools to calibrate the model and analyze de outputs.

Concepts behind DWBmodelUN
--------------------------

Two physical laws are taken into account in Dynamic Water Balance model (DWB), mass balance and energy balance. To represent the mass conservation, DWB is based on the equilibrium of water balance shown in equation (1).

$$ \frac{4z^3}{16} $$
*X*<sub>*i*, *j*</sub>

Where S is the total stored water in the basin, P is the precipitation, ET is actual evapotranspiration, Q corresponds to surface runoff and Q to aquifers recharge. To evaluate the water balance of a basin is necessary to know several kind information like climatic variables, catchment physical characteristics and further uniqueness relationships of each study. In the case of water balance models, some information can be replaced by equations and mathematical relations physically based, which makes the models much simpler but functional. To represent energy conservation the model includes a conceptualization made by Budyko (1958) where the energy availability influences over the atmospheric water demand which is represented by potential evapotranspiration (PET). The conceptualization also states that the dominant control of the water balance is atmospheric demand and water availability (P), which impose a limit to how much water can be evapotranspirated. Zhang et al (2008) worked on the mathematical assumption presented by Fu (1981) (equation 2) that is a continuation of Budyko framework.

Installation
------------

You can install the released version of DWBmodelUN from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("DWBmodelUN")
```

Example
-------

This is a basic example which shows you how to solve a common problem:

``` r
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`? You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You'll still need to render `README.Rmd` regularly, to keep `README.md` up-to-date.

You can also embed plots, for example:

In that case, don't forget to commit and push the resulting figure files, so they display on GitHub!

Zhang, Lu, Nick Potter, Klaus Hickel, Yongqiang Zhang, and Quanxi Shao. 2008. “Water balance modeling over variable time scales based on the Budyko framework - Model development and testing.” *Journal of Hydrology* 360 (1-4): 117–31. doi:[10.1016/j.jhydrol.2008.07.021](https://doi.org/10.1016/j.jhydrol.2008.07.021).
