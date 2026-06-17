# Identification of the Cells within a basin

This function identifies the cells that are within a basin. The runoff
produced by those cells will be used, either to calculate the water
availability or to compare the simulated variable with the observed
runoff in certain streamflow gauges.

## Usage

``` r
cellBasins(gruLoc, basins)
```

## Arguments

- gruLoc:

  raster (`SpatRaster` from terra, or an object convertible to it, such
  as a `RasterLayer`) that was used to build the GRUs. In this function
  it is used to number each cell from West to East and from North to
  South.

- basins:

  polygons (`SpatVector` from terra, or an object convertible to it,
  such as a `SpatialPolygonsDataFrame`) comprising each one of the
  basins where the modeller wants to know the runoff. It must be in the
  same projection as the gruLoc raster.

## Value

a list that comprise two dataframes. The first one, the list of cells in
each of the basins contained in the shapefile (`cellBasins`), and second
a table that associates the coordinates of each cell with the assigned
number (`cellTable`).

## Author

Pedro Felipe Arboleda Obando \<pfarboledao@unal.edu.co\>  
Nicolas Duque Gardeazabal \<nduqueg@unal.edu.co\>  
Carolina Vega Viviescas \<cvegav@unal.edu.co\>  
David Zamora \<dazamoraa@unal.edu.co\>  

Water Resources Engineering Research Group - GIREH Universidad Nacional
de Colombia - sede Bogota

## Examples

``` r
data("GRU","basins")
cellBasins <- cellBasins(GRU, basins)
#> Warning: gruLoc and basins have different coordinate reference systems. The basins are reprojected to the raster CRS during the extraction, but verify projections before using the results.
#> Warning: [extract] transforming vector data to the CRS of the raster
```
