# Changelog

## DWBmodelUN 2.0.1

### CRAN resubmission fixes

- [`graphDWB()`](https://dazamora.github.io/DWBmodelUN/reference/graphDWB.md)
  no longer opens a web browser in non-interactive sessions. For the
  composed graphs (`tp = 3` and `tp = 4`) the returned object is now
  only wrapped in
  [`htmltools::browsable()`](https://rstudio.github.io/htmltools/reference/browsable.html)
  when [`interactive()`](https://rdrr.io/r/base/interactive.html) is
  `TRUE`, so `R CMD check` examples and vignette builds no longer
  trigger a browser call. Interactive use and the knitted vignette keep
  rendering the dygraphs as before.
- Replaced the retired Travis CI badge with a GitHub Actions R-CMD-check
  badge and updated the dead thesis URL (bdigital.unal.edu.co, host no
  longer resolving) to its current location on repositorio.unal.edu.co,
  in the README, the vignette and the bibliography.
- Fixed the `sogamoso` dataset documentation: the `\format` section used
  `\itemize` with labelled items, which produced “Lost braces in ” notes
  under the current `R CMD check`; it now uses `\describe`.
- Updated the codecov badge link to its current address (app.codecov.io)
  to avoid a permanent-redirect URL note.
- Moved `raster` and `sp` from Suggests to Depends. The bundled example
  datasets are stored as `raster`/`sp` S4 objects, so these packages
  must be attached for [`data()`](https://rdrr.io/r/utils/data.html) to
  load them; declaring them only in Suggests caused a
  `checking data for non-ASCII characters` WARNING on the CRAN checks.

## DWBmodelUN 2.0.0

### Breaking changes

- The spatial engine of the package was migrated from `raster`/`rgdal`
  (retired from CRAN in 2023) to `terra`. All functions that receive or
  return spatial objects now work with `terra` classes:
  - [`buildGRUmaps()`](https://dazamora.github.io/DWBmodelUN/reference/buildGRUmaps.md)
    returns `SpatRaster` objects (`alpha1R`, `alpha2R`, `dR`, `smaxR`)
    instead of `RasterLayer` objects.
  - [`printVar()`](https://dazamora.github.io/DWBmodelUN/reference/printVar.md)
    builds and returns (invisibly) a `SpatRaster` and writes NetCDF
    files with
    [`terra::writeCDF()`](https://rspatial.github.io/terra/reference/writeCDF.html).
  - [`cellBasins()`](https://dazamora.github.io/DWBmodelUN/reference/cellBasins.md)
    works internally with `SpatRaster`/`SpatVector`.
  - For backwards compatibility, all these functions still accept legacy
    `raster`/`sp` objects (`RasterLayer`, `RasterStack`,
    `SpatialPolygonsDataFrame`) and convert them internally with
    [`terra::rast()`](https://rspatial.github.io/terra/reference/rast.html)/[`terra::vect()`](https://rspatial.github.io/terra/reference/vect.html).
- `rgdal` was removed from the dependencies. `raster` and `sp` were
  moved to `Suggests` and are only needed to load the example datasets,
  which are still stored in the legacy format.
- [`cellBasins()`](https://dazamora.github.io/DWBmodelUN/reference/cellBasins.md)
  and
  [`varBasins()`](https://dazamora.github.io/DWBmodelUN/reference/varBasins.md)
  now stop with an informative error when mandatory arguments are
  missing, instead of returning `NULL` with a warning.

### Bug fixes

- [`upForcing()`](https://dazamora.github.io/DWBmodelUN/reference/upForcing.md):
  the documented `format = "NetCDF"` option now works (the internal
  check made it unreachable before).
- [`init_state()`](https://dazamora.github.io/DWBmodelUN/reference/init_state.md)
  no longer emits a spurious warning when a single-layer raster (the
  documented and most common use case) is provided.
- [`readSetup()`](https://dazamora.github.io/DWBmodelUN/reference/readSetup.md):
  removed an [`exists()`](https://rdrr.io/r/base/exists.html) check that
  could never trigger; the function now validates its arguments and
  fails with informative messages.
- [`funFU()`](https://dazamora.github.io/DWBmodelUN/reference/funFU.md)
  documentation: `P` was incorrectly described as the numerator, and
  `alpha` can be a vector (as used by
  [`DWBCalculator()`](https://dazamora.github.io/DWBmodelUN/reference/DWBCalculator.md)),
  not only a single value.
- Fixed the partially matched argument `star =` (instead of `start =`)
  in the [`ts()`](https://rdrr.io/r/stats/ts.html) calls of the examples
  and the vignette.

### Improvements

- All exported functions now validate their inputs (dimensions,
  parameter ranges, file availability) and fail early with informative
  error messages.
- [`DWBCalculator()`](https://dazamora.github.io/DWBmodelUN/reference/DWBCalculator.md)
  checks the consistency between forcings and parameter vectors, and the
  physical ranges of the parameters.
- [`dds()`](https://dazamora.github.io/DWBmodelUN/reference/dds.md)
  validates the search bounds, protects against non-finite objective
  function values and reflects out-of-range candidate parameters back
  into the search space.
- [`varBasins()`](https://dazamora.github.io/DWBmodelUN/reference/varBasins.md)
  validates that the cell indices are consistent with the simulated
  domain.
- [`printVar()`](https://dazamora.github.io/DWBmodelUN/reference/printVar.md)
  creates the output directory when it does not exist and checks that
  `ncdf4` is available before writing NetCDF files.
- Documentation reviewed and updated: corrected typos, described the
  accepted spatial classes (`terra` and legacy `raster`/`sp`),
  modernized the CRS notation in the examples (`"EPSG:4326"`), and added
  a runnable example to
  [`upForcing()`](https://dazamora.github.io/DWBmodelUN/reference/upForcing.md).
- The vignette was updated to the `terra` workflow and to the
  `html_vignette` format.

## DWBmodelUN 1.0.0

CRAN release: 2020-08-18

- First CRAN release.
