# Dependencies installed when Binder builds the environment for DWBmodelUN.
# repo2docker runs this script from the repository root.

# Hard dependencies of the package (Imports) plus the helpers needed to
# install it and to run the vignette interactively.
install.packages(c(
  "remotes",
  "terra",
  "dygraphs",
  "htmltools",
  "ncdf4",
  "raster",
  "sp",
  "knitr",
  "rmarkdown"
))

# Install DWBmodelUN itself from the cloned repository, pulling any remaining
# Suggests so the examples and the vignette run out of the box.
remotes::install_local(".", dependencies = TRUE, upgrade = "never")
