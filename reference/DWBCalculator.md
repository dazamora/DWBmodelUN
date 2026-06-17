# DWB model function

The function performs the distributed DWB hydrological model
calculations in the defined domain and time period. It is a model based
on the postulates of Budyko, which stated that not only does the actual
evapotranspiration depend on potential evapotranspiration, but it is
also constrained by water availability (Budyko, 1974). The monthly
Dynamic Water Balance is underpinned in the demand and supply limits
demonstrated by
[`funFU`](https://dazamora.github.io/DWBmodelUN/reference/funFU.md),
postulate that is applied to three variables in order to acquire the
values of the fluxes and state variables on a monthly time step. The
named variables affected by
[`funFU`](https://dazamora.github.io/DWBmodelUN/reference/funFU.md) are:
the available storage capacity (*`X`*), the evapotranspiration
opportunity (*`Y`*) and the actual evapotranspiration (*`ET`*). The
model is controlled by four parameters: retention efficiency
(\\\alpha-1\\), evapotranspiration efficiency (\\\alpha-2\\), soil water
storage capacity (*`S_max`*), and a recession parameter in the
groundwater storage that controls the baseflow (*`d`*).

## Usage

``` r
DWBCalculator(
  p_v,
  pet_v,
  g_v,
  s_v,
  alpha1_v,
  alpha2_v,
  smax_v,
  d_v,
  calibration = FALSE
)
```

## Arguments

- p_v:

  matrix comprised by the precipitation records, that has as rows the
  number of cells that will be simulated and as columns the number of
  time steps to be simulated.

- pet_v:

  matrix comprised by the potential evapotranspiration records, that has
  as rows the number of cells that will be simulated and as columns the
  number of time steps to be simulated.

- g_v:

  vector comprised of the initial values of the groundwater storage, it
  must have as many values as cells defined to simulate.

- s_v:

  vector comprised of the initial values of the soil water storage, it
  must have as many values as cells defined to simulate.

- alpha1_v:

  vector comprised of the values of the retention efficiency that must
  be between 0 and 1, it must have as many values as cells defined to
  simulate.

- alpha2_v:

  vector comprised of the values of the evapotranspiration efficiency
  that must be between 0 and 1, it must have as many values as cells
  defined to simulate.

- smax_v:

  vector comprised of the values of the soil water storage capacity that
  must be above 0, it must have as many values as cells defined to
  simulate.

- d_v:

  vector comprised of the values of the recession constant that must be
  between 0 and 1, it must have as many values as cells defined to
  simulate.

- calibration:

  boolean variable which sets the printing of the waitbar that indicates
  the progress of the calculation of the time series results. The
  default value is FALSE, indicating that just one run of the model is
  going to be performed and there is no other waitbar such as the one
  used by a calibration algorithm.

## Value

a list comprised by the time series of the hydrological fluxes
calculated by the model. The time series have the same length as the
forcings that were employed to run the model. The fluxes are:

- `q_total` a numeric matrix of the total runoff - units (mm/month).

- `aet` a numeric matrix of actual evapotranspiration - units
  (mm/month).

- `r` a numeric matrix of groundwater recharge - units (mm/month).

- `qd` a numeric matrix of surface runoff - units (mm/month).

- `qb` a numeric matrix of baseflow - units (mm/month).

- `s` a numeric matrix of soil water storage - units (mm).

- `g` a numeric matrix of groundwater storage - units (mm).

## Details

`DWBCalculator` only performs one simulation of the distributed
hydrological model. The decision to perform other kinds of procedure,
such as calibration or assimilation, is entirely on modelers'
requirements and necessities. A complementary function is available in
the package to calibrate the model using the
([`dds`](https://dazamora.github.io/DWBmodelUN/reference/dds.md))
algorithm, which has proved to be effective in calibrating models with
several GRUs.

To start the model one should set the model features using the
[`readSetup`](https://dazamora.github.io/DWBmodelUN/reference/readSetup.md)
function, load the precipitation and evapotranspiration forcings with
the
[`upForcing`](https://dazamora.github.io/DWBmodelUN/reference/upForcing.md)
function, build the GRU and parameter maps with the
[`buildGRUmaps`](https://dazamora.github.io/DWBmodelUN/reference/buildGRUmaps.md)
function, compare the coordinates of the uploaded datasets with the
[`Coord_comparison`](https://dazamora.github.io/DWBmodelUN/reference/Coord_comparison.md)
(i.e. the forcings and GRU cells), set the initial conditions of the
soil moisture and the groundwater storage, and run the model with
`DWBCalculator` function.

## References

Budyko. (1974). "Climate and life". New York: Academic Press, INC.

Zhang, L., Potter, N., Hickel, K., Zhang, Y., & Shao, Q. (2008). "Water
balance modeling over variable time scales based on the Budyko framework
– Model development and testing". Journal of Hydrology, 360(1-4),
117–131.

## Author

Nicolas Duque Gardeazabal \<nduqueg@unal.edu.co\>  
Pedro Felipe Arboleda Obando \<pfarboledao@unal.edu.co\>  
David Zamora \<dazamoraa@unal.edu.co\>  
Carolina Vega Viviescas \<cvegav@unal.edu.co\>  

Water Resources Engineering Research Group - GIREH Universidad Nacional
de Colombia - sede Bogota

## Examples

``` r

# Load P and PET databases
data(P_sogamoso, PET_sogamoso)
 
# Verify that the coordinates of the databases match
Coord_comparison(P_sogamoso, PET_sogamoso)
#> First data file is a data frame
#> Second data file is a data frame
#> Two data frames - Comparing coordinates and headers
#> Coordinates verified
#> Warning: First date/header does not match - Please verify
#> Warning: Final date/header does not match - Please verify
#> Extent verified
#> Resolution verified
#> Rows and columns verified
#> Number of layers verified
#> [1] TRUE
# Load geographic info of GRU and parameters per cell
data(GRU, param)
# Construction of parameter maps from values by GRU
GRU.maps <- buildGRUmaps(GRU, param)
#> Loading required namespace: raster
alpha1_v <- GRU.maps$alpha1
alpha2_v <- GRU.maps$alpha2
smax_v <- GRU.maps$smax
d_v <- GRU.maps$d

# Establish the initial modeling conditions
init <- init_state(GRU.maps$smaxR)
g_v <- init$In_ground
s_v <- init$In_storage
rm(init)

# Load general characteristics of modeling
setup_data <- readSetup(Read = TRUE)
Dates <- seq(as.Date( gsub('[^0-9.]','',colnames(P_sogamoso)[3]), 
format = "%Y.%m.%d"), 
             as.Date(gsub('[^0-9.]','',tail(colnames(P_sogamoso),1)) , 
             format = "%Y.%m.%d"), by = "month")
Start.sim <- which(Dates == setup_data[8,1]); End.sim <- which(Dates == setup_data[10,1])
# Sim.Period: the 1st two columns of the P and PET are the coordinates of the cells
Sim.Period <- c(Start.sim:End.sim)+2  

# Run DWB model
DWB.sogamoso <- DWBCalculator(P_sogamoso[ ,Sim.Period], 
                    PET_sogamoso[ ,Sim.Period],
                    g_v, s_v, alpha1_v, alpha2_v, smax_v, d_v)
#>   |                                                                              |                                                                      |   0%  |                                                                              |=                                                                     |   2%  |                                                                              |==                                                                    |   2%  |                                                                              |==                                                                    |   3%  |                                                                              |===                                                                   |   4%  |                                                                              |====                                                                  |   5%  |                                                                              |====                                                                  |   6%  |                                                                              |=====                                                                 |   7%  |                                                                              |=====                                                                 |   8%  |                                                                              |======                                                                |   8%  |                                                                              |======                                                                |   9%  |                                                                              |=======                                                               |  10%  |                                                                              |========                                                              |  11%  |                                                                              |========                                                              |  12%  |                                                                              |=========                                                             |  12%  |                                                                              |=========                                                             |  13%  |                                                                              |==========                                                            |  14%  |                                                                              |==========                                                            |  15%  |                                                                              |===========                                                           |  16%  |                                                                              |============                                                          |  17%  |                                                                              |============                                                          |  18%  |                                                                              |=============                                                         |  18%  |                                                                              |=============                                                         |  19%  |                                                                              |==============                                                        |  20%  |                                                                              |===============                                                       |  21%  |                                                                              |===============                                                       |  22%  |                                                                              |================                                                      |  22%  |                                                                              |================                                                      |  23%  |                                                                              |=================                                                     |  24%  |                                                                              |==================                                                    |  25%  |                                                                              |==================                                                    |  26%  |                                                                              |===================                                                   |  27%  |                                                                              |===================                                                   |  28%  |                                                                              |====================                                                  |  28%  |                                                                              |====================                                                  |  29%  |                                                                              |=====================                                                 |  30%  |                                                                              |======================                                                |  31%  |                                                                              |======================                                                |  32%  |                                                                              |=======================                                               |  32%  |                                                                              |=======================                                               |  33%  |                                                                              |========================                                              |  34%  |                                                                              |========================                                              |  35%  |                                                                              |=========================                                             |  36%  |                                                                              |==========================                                            |  37%  |                                                                              |==========================                                            |  38%  |                                                                              |===========================                                           |  38%  |                                                                              |===========================                                           |  39%  |                                                                              |============================                                          |  40%  |                                                                              |=============================                                         |  41%  |                                                                              |=============================                                         |  42%  |                                                                              |==============================                                        |  42%  |                                                                              |==============================                                        |  43%  |                                                                              |===============================                                       |  44%  |                                                                              |================================                                      |  45%  |                                                                              |================================                                      |  46%  |                                                                              |=================================                                     |  47%  |                                                                              |=================================                                     |  48%  |                                                                              |==================================                                    |  48%  |                                                                              |==================================                                    |  49%  |                                                                              |===================================                                   |  50%  |                                                                              |====================================                                  |  51%  |                                                                              |====================================                                  |  52%  |                                                                              |=====================================                                 |  52%  |                                                                              |=====================================                                 |  53%  |                                                                              |======================================                                |  54%  |                                                                              |======================================                                |  55%  |                                                                              |=======================================                               |  56%  |                                                                              |========================================                              |  57%  |                                                                              |========================================                              |  58%  |                                                                              |=========================================                             |  58%  |                                                                              |=========================================                             |  59%  |                                                                              |==========================================                            |  60%  |                                                                              |===========================================                           |  61%  |                                                                              |===========================================                           |  62%  |                                                                              |============================================                          |  62%  |                                                                              |============================================                          |  63%  |                                                                              |=============================================                         |  64%  |                                                                              |==============================================                        |  65%  |                                                                              |==============================================                        |  66%  |                                                                              |===============================================                       |  67%  |                                                                              |===============================================                       |  68%  |                                                                              |================================================                      |  68%  |                                                                              |================================================                      |  69%  |                                                                              |=================================================                     |  70%  |                                                                              |==================================================                    |  71%  |                                                                              |==================================================                    |  72%  |                                                                              |===================================================                   |  72%  |                                                                              |===================================================                   |  73%  |                                                                              |====================================================                  |  74%  |                                                                              |====================================================                  |  75%  |                                                                              |=====================================================                 |  76%  |                                                                              |======================================================                |  77%  |                                                                              |======================================================                |  78%  |                                                                              |=======================================================               |  78%  |                                                                              |=======================================================               |  79%  |                                                                              |========================================================              |  80%  |                                                                              |=========================================================             |  81%  |                                                                              |=========================================================             |  82%  |                                                                              |==========================================================            |  82%  |                                                                              |==========================================================            |  83%  |                                                                              |===========================================================           |  84%  |                                                                              |============================================================          |  85%  |                                                                              |============================================================          |  86%  |                                                                              |=============================================================         |  87%  |                                                                              |=============================================================         |  88%  |                                                                              |==============================================================        |  88%  |                                                                              |==============================================================        |  89%  |                                                                              |===============================================================       |  90%  |                                                                              |================================================================      |  91%  |                                                                              |================================================================      |  92%  |                                                                              |=================================================================     |  92%  |                                                                              |=================================================================     |  93%  |                                                                              |==================================================================    |  94%  |                                                                              |==================================================================    |  95%  |                                                                              |===================================================================   |  96%  |                                                                              |====================================================================  |  97%  |                                                                              |====================================================================  |  98%  |                                                                              |===================================================================== |  98%  |                                                                              |===================================================================== |  99%  |                                                                              |======================================================================| 100%
                    
```
