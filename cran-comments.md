## Resubmission

This is a resubmission of DWBmodelUN, addressing the issues raised in the
incoming pre-tests of version 2.0.0.

* `graphDWB()` no longer opens a web browser in non-interactive mode. For the
  composed graphs (`tp = 3` and `tp = 4`) the result is now only wrapped in
  `htmltools::browsable()` when `interactive()` is `TRUE`, so running the
  examples and building the vignette no longer trigger a browser call. The
  interactive behaviour and the knitted vignette output are unchanged.
* Fixed invalid/dead URLs: replaced the retired Travis CI badge with a GitHub
  Actions badge and updated the thesis URL that no longer resolves
  (bdigital.unal.edu.co) to its current location on repositorio.unal.edu.co.

This version also completes the migration away from the retired 'rgdal' and
'raster' packages (which caused the previous CRAN archival) to 'terra'.

## Test environments

* local Ubuntu 24.04, R 4.3.3
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

* The note is the standard "New submission" note (the package was archived on
  CRAN in 2023 after the retirement of 'rgdal').
