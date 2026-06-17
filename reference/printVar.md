# Print or write variables of interest

This function allows to print or write some of the variables simulated
by the DWB model.

## Usage

``` r
printVar(variable, coor_cells, var_name, coord_sys, dates, as, path_var = "")
```

## Arguments

- variable:

  corresponds to the results of a specific variable of the
  DWBCalculator.

- coor_cells:

  coordinates of the cells in the same order that were simulated and
  that will be used to create the results in raster format, this is done
  from the data frames which contain the simulated results

- var_name:

  name of the variable that will be printed (e.g., q_total, aet, r, qd,
  qb, s, g)

- coord_sys:

  geographic or projected coordinate system, in any notation accepted by
  terra (e.g., `"EPSG:4326"` or a WKT string).

- dates:

  dates that were simulated.

- as:

  option to print the results as independent 'raster' (*`.tif`*) files
  or in a single 'NetCDF' (*`.nc`*) file. Writing NetCDF files requires
  the ncdf4 package.

- path_var:

  path of the directory where one wants to print the files. It is
  created if it does not exist.

## Value

It writes in the requested folder a set of raster files (or a NetCDF
file) with the results of the variable of interest, and returns
(invisibly) the written `SpatRaster`.

## Author

Carolina Vega Viviescas \<cvegav@unal.edu.co\>  
Nicolas Duque Gardeazabal \<nduqueg@unal.edu.co\>  
Pedro Felipe Arboleda Obando \<pfarboledao@unal.edu.co\>  
David Zamora \<dazamoraa@unal.edu.co\>  

Water Resources Engineering Research Group - GIREH Universidad Nacional
de Colombia - sede Bogota

## Examples

``` r
data(sogamoso)
dwb_results <- sogamoso$dwb_results
data(cells)
dates <- seq(as.Date("2001-01-01"), as.Date("2010-12-01"), by="month")
coord_sys <- "EPSG:4326"
r <- dwb_results[[3]][,1:20]
printVar(r, cells, var_name = "r", coord_sys, dates, as = "NetCDF", path_var = tempdir())
```
