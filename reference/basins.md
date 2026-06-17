# basins

The polygons of the 25 subbasins across the Sogamoso Basin

## Usage

``` r
basins
```

## Format

SpatialPolygonsDataFrame (S4)

- basins:

  Shapefile featuring subbasins across the Sogamoso Basin.

## Details

The object is stored in the legacy sp format, so the sp package must be
installed to load it. The functions of DWBmodelUN convert it internally
to a `SpatVector`; to convert it manually use `terra::vect(basins)`.

## References

Duque-Gardeazabal, N. (2018). Estimation of rainfall fields in data
scarce colombian watersheds, by blending remote sensed and rain gauge
data, using kernel functions. Master thesis. Universidad Nacional de
Colombia, Bogotá, Colombia.
