# DWBmodelUN 2.0.0

## Breaking changes

* The spatial engine of the package was migrated from `raster`/`rgdal` (retired from CRAN in 2023)
  to `terra`. All functions that receive or return spatial objects now work with `terra` classes:
  * `buildGRUmaps()` returns `SpatRaster` objects (`alpha1R`, `alpha2R`, `dR`, `smaxR`)
    instead of `RasterLayer` objects.
  * `printVar()` builds and returns (invisibly) a `SpatRaster` and writes NetCDF files with
    `terra::writeCDF()`.
  * `cellBasins()` works internally with `SpatRaster`/`SpatVector`.
  * For backwards compatibility, all these functions still accept legacy `raster`/`sp` objects
    (`RasterLayer`, `RasterStack`, `SpatialPolygonsDataFrame`) and convert them internally with
    `terra::rast()`/`terra::vect()`.
* `rgdal` was removed from the dependencies. `raster` and `sp` were moved to `Suggests` and are
  only needed to load the example datasets, which are still stored in the legacy format.
* `cellBasins()` and `varBasins()` now stop with an informative error when mandatory arguments
  are missing, instead of returning `NULL` with a warning.

## Bug fixes

* `upForcing()`: the documented `format = "NetCDF"` option now works (the internal check made it
  unreachable before).
* `init_state()` no longer emits a spurious warning when a single-layer raster (the documented
  and most common use case) is provided.
* `readSetup()`: removed an `exists()` check that could never trigger; the function now validates
  its arguments and fails with informative messages.
* `funFU()` documentation: `P` was incorrectly described as the numerator, and `alpha` can be a
  vector (as used by `DWBCalculator()`), not only a single value.
* Fixed the partially matched argument `star =` (instead of `start =`) in the `ts()` calls of the
  examples and the vignette.

## Improvements

* All exported functions now validate their inputs (dimensions, parameter ranges, file
  availability) and fail early with informative error messages.
* `DWBCalculator()` checks the consistency between forcings and parameter vectors, and the
  physical ranges of the parameters.
* `dds()` validates the search bounds, protects against non-finite objective function values and
  reflects out-of-range candidate parameters back into the search space.
* `varBasins()` validates that the cell indices are consistent with the simulated domain.
* `printVar()` creates the output directory when it does not exist and checks that `ncdf4` is
  available before writing NetCDF files.
* Documentation reviewed and updated: corrected typos, described the accepted spatial classes
  (`terra` and legacy `raster`/`sp`), modernized the CRS notation in the examples
  (`"EPSG:4326"`), and added a runnable example to `upForcing()`.
* The vignette was updated to the `terra` workflow and to the `html_vignette` format.

# DWBmodelUN 1.0.0

* First CRAN release.
