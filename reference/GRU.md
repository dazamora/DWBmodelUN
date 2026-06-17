# GRU

Raster data of Group Response Units in Sogamoso River Basin

## Usage

``` r
GRU
```

## Format

RasterLayer

- GRU:

  Raster, it represents the ten (10) Group Response Units across the
  Sogamoso River Basin.

## Details

The object is stored in the legacy raster format, so the raster package
must be installed to load it. The functions of DWBmodelUN convert it
internally to a `SpatRaster`; to convert it manually use
`terra::rast(GRU)`.
