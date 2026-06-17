# Initial conditions of the model

This function uploads or creates the initial conditions of the two-state
variables present in the DWB model, in raster format.

## Usage

``` r
init_state(raster)
```

## Arguments

- raster:

  a single layer raster (`SpatRaster` from terra, or an object
  convertible to it, such as a `RasterLayer`) containing the maximum
  storage in the root zone, or a two-layer raster with the initial
  conditions of the soil water storage (first layer) and the groundwater
  storage (second layer)

## Value

A list containing initial conditions in storage and in ground.

## Details

It requires the raster composed of the Smax values that were created
using the
[`buildGRUmaps`](https://dazamora.github.io/DWBmodelUN/reference/buildGRUmaps.md)
function, or a two-layer raster previously created with the initial
conditions of the soil water and groundwater storage. If only one layer
is provided, the function creates the two initial conditions using the
values of the provided raster reduced by half.

## References

Budyko. (1974). "Climate and life". New York: Academic Press, INC.

Zhang, L., Potter, N., Hickel, K., Zhang, Y., & Shao, Q. (2008). "Water
balance modeling over variable time scales based on the Budyko
framework - Model development and testing. Journal of Hydrology",
360(1-4), 117-131.

## Author

Nicolas Duque Gardeazabal \<nduqueg@unal.edu.co\>  
Pedro Felipe Arboleda \<pfarboledao@unal.edu.co\>  
Carolina Vega Viviescas \<cvegav@unal.edu.co\>  
David Zamora \<dazamoraa@unal.edu.co\>  

Water Resources Engineering Research Group - GIREH Universidad Nacional
de Colombia - Sede Bogota

## Examples

``` r
# Example 1: build the initial states from the Smax map
data(GRU, param)
gru_maps <- buildGRUmaps(GRU, param)
init <- init_state(gru_maps$smaxR)

# Example 2: use two rasters with previously known initial conditions
data(In_storage, In_ground)
init <- init_state(c(terra::rast(In_storage), terra::rast(In_ground)))
```
