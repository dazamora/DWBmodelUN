# Upload Forcings

This function loads the precipitation and potential evapotranspiration
estimates that will be used to run or force the DWB model
([`DWBCalculator`](https://dazamora.github.io/DWBmodelUN/reference/DWBCalculator.md)).
If files are in raster format, they are read with the terra package and
returned as tables where the first two columns are the cell coordinates.

## Usage

``` r
upForcing(
  path_p = tempdir(),
  path_pet = tempdir(),
  file_type = "raster",
  format = "GTiff"
)
```

## Arguments

- path_p:

  is a character string that specifies the directory where the
  precipitation rasters or the csv file are stored. The csv file must
  have nrows = number of cells and ncol = number of time steps.

- path_pet:

  is a character string that specifies the directory where the potential
  evapotranspiration rasters or the csv file are stored. The csv file
  must have nrows = number of cells and ncol = number of time steps.

- file_type:

  Character string that specifies the forcing file formats, it should be
  "raster" or "csv", the default value is "raster".

- format:

  Character string that specifies the file format of the rasters,
  possible values are "GTiff" and "NetCDF". Default value is "GTiff".

## Value

a list containing two data frames (`Prec` and `PET`). When read from
rasters, the first two columns of each data frame are the x and y
coordinates of the cells, and the remaining columns are the time steps.

## Details

The arguments that control the location of the forcing files can point
either to a directory that contains the raster or csv files, or to a
single file. When reading GTiff files from a directory, all files with
extension *.tif* or *.tiff* are read in alphabetical order, so file
names should be consistent with the chronological order of the time
series. If one's intention is to upload the forcings from NetCDF files,
the path should preferably be the complete path including the name and
extension of the file.

## Author

Nicolas Duque Gardeazabal \<nduqueg@unal.edu.co\>  
Pedro Felipe Arboleda \<pfarboledao@unal.edu.co\>  
Carolina Vega Viviescas \<cvegav@unal.edu.co\>  
David Zamora \<dazamoraa@unal.edu.co\>  

Water Resources Engineering Research Group - GIREH Universidad Nacional
de Colombia - sede Bogota

## Examples

``` r
# Write the example data as GTiff files in a temporal directory and read them back
data(P_sogamoso, PET_sogamoso)
dir_p <- file.path(tempdir(), "precip")
dir_pet <- file.path(tempdir(), "pet")
dir.create(dir_p, showWarnings = FALSE)
dir.create(dir_pet, showWarnings = FALSE)
p_rast <- terra::rast(P_sogamoso[, 1:3], type = "xyz")
pet_rast <- terra::rast(PET_sogamoso[, 1:3], type = "xyz")
terra::writeRaster(p_rast, file.path(dir_p, "P_2001_01.tif"), overwrite = TRUE)
terra::writeRaster(pet_rast, file.path(dir_pet, "PET_2001_01.tif"), overwrite = TRUE)
meteo <- upForcing(path_p = dir_p, path_pet = dir_pet,
                   file_type = "raster", format = "GTiff")
str(meteo)
#> List of 2
#>  $ PET :'data.frame':    677 obs. of  3 variables:
#>   ..$ x             : num [1:677] -72.9 -73.3 -72.9 -72.9 -72.8 ...
#>   ..$ y             : num [1:677] 7.09 7.04 7.04 7.04 7.04 6.99 6.99 6.99 6.99 6.99 ...
#>   ..$ ETP_2001.01.01: num [1:677] 81.9 107.3 91.4 88.5 77.6 ...
#>  $ Prec:'data.frame':    677 obs. of  3 variables:
#>   ..$ x                  : num [1:677] -72.9 -73.3 -72.9 -72.9 -72.8 ...
#>   ..$ y                  : num [1:677] 7.09 7.04 7.04 7.04 7.04 6.99 6.99 6.99 6.99 6.99 ...
#>   ..$ P_CHIRPS_2001.01.01: num [1:677] 28 74 35 24 17 66 69 41 33 26 ...
```
