# value of a variable in each subbasin

This function retrieves the value of a variable in each of the cells
that are within a basin boundary. It also returns the average time
series value of the variable.

## Usage

``` r
varBasins(var, cellBasins)
```

## Arguments

- var:

  one of the dataframe results returned from the DWBcalculator function

- cellBasins:

  first entry of the cellBasins function that consists of a list of
  vectors. Each one of the vectors contains the cell numbers of each
  basin

## Value

a list of two elements. The first one is the time series average value
of the variable, and the second is a list of dataframes each one of them
contains the time series of each of the cells that are within a basin

## Author

Nicolas Duque Gardeazabal \<nduqueg@unal.edu.co\>  
Pedro Felipe Arboleda Obando \<pfarboledao@unal.edu.co\>  
Carolina Vega Viviescas \<cvegav@unal.edu.co\>  
David Zamora \<dazamoraa@unal.edu.co\>  

Water Resources Engineering Research Group - GIREH Universidad Nacional
de Colombia - sede Bogota

## Examples

``` r
data(sogamoso,GRU,basins)
dwb_results <- sogamoso$dwb_results
Run <- dwb_results$q_total
cellBasins <- cellBasins(GRU, basins)
#> Warning: gruLoc and basins have different coordinate reference systems. The basins are reprojected to the raster CRS during the extraction, but verify projections before using the results.
#> Warning: [extract] transforming vector data to the CRS of the raster
cellBasins <- cellBasins$cellBasins

Runoff.Sogamoso <- varBasins(Run, cellBasins)
```
