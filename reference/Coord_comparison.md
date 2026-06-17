# Raster coordinates comparison

This function compares three characteristics from two rasters:
coordinates, resolution, and number of layers (if the rasters have more
than one) from two different rasters stacks, and let to know if they are
using the same geographical information, or if a new set-up should be
done.

## Usage

``` r
Coord_comparison(r1, r2)
```

## Arguments

- r1:

  raster (`SpatRaster` from terra, or an object convertible to it, such
  as a `RasterLayer`) or data frame. If it is a data frame, it should
  contain in the first two columns, the X, Y coordinates for every
  point, in GEOGRAPHIC COORDINATES, the third column and so on should
  have the variable values, and optionally, the header should have the
  date, using the format `%m/%Y`.

- r2:

  raster (`SpatRaster` from terra, or an object convertible to it, such
  as a `RasterLayer`) or data frame. If it is a data frame, it should
  contain in the first two columns, the X, Y coordinates for every
  point, in GEOGRAPHIC COORDINATES, the third column and so on should
  have the variable values, and optionally, the header should have the
  date, using the format `%m/%Y`.

## Value

It prints on console whether the two rasters are on the same coordinates
or not, and return a boolean, TRUE if the rasters are on the same
coordinates, and FALSE if not.

## Author

Pedro Felipe Arboleda Obando \<pfarboledao@unal.edu.co\>  
Nicolas Duque Gardeazabal \<nduqueg@unal.edu.co\>  
Carolina Vega Viviescas \<cvegav@unal.edu.co\>  
David Zamora \<dazamoraa@unal.edu.co\>  

Water Resources Engineering Research Group - GIREH Universidad Nacional
de Colombia - sede Bogota

## Examples

``` r
data(P_sogamoso, PET_sogamoso)
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
```
