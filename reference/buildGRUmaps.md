# Build Grouped Response Units in maps

This function builds raster maps for each parameter based on a raster
file where the location of the Grouped Response Units (`GRUs`) are
defined. This raster must have the same resolution as the forcing files
(i.e., for each cell that is planned to be simulated, there must be
forcing time series and a cell assigned to a `GRU`).

## Usage

``` r
buildGRUmaps(gruLoc, parsValues)
```

## Arguments

- gruLoc:

  raster (`SpatRaster` from terra, or an object convertible to it, such
  as a `RasterLayer`) that is comprised by numbers from 1 to the total
  number of `GRUs` that were defined.

- parsValues:

  data frame or matrix that has the values of the four parameters of
  each `GRU`. It must have equal number of rows as number of GRU that
  were defined, and must have four columns which define the `alpha1`,
  `alpha2`, `d` and `Smax` parameters, in that order.

## Value

a list which consists of four vectors (`alpha1`, `alpha2`, `d`, `smax`)
and four `SpatRaster` objects (`alpha1R`, `alpha2R`, `dR`, `smaxR`),
each one of them with the values of a parameter spatialized according to
the GRU raster layer.

## Author

Nicolas Duque Gardeazabal \<nduqueg@unal.edu.co\>  
Pedro Felipe Arboleda Obando \<pfarboledao@unal.edu.co\>  
Carolina Vega Viviescas \<cvegav@unal.edu.co\>  
David Zamora \<dazamoraa@unal.edu.co\>  

Water Resources Engineering Research Group - GIREH Universidad Nacional
de Colombia - sede Bogota

## Examples

``` r
data(GRU)    
data(param)
gru_maps <- buildGRUmaps(GRU, param)

```
