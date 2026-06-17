# Package index

## Model

Core functions of the Dynamic Water Balance model

- [`DWBCalculator()`](https://dazamora.github.io/DWBmodelUN/reference/DWBCalculator.md)
  : DWB model function
- [`funFU()`](https://dazamora.github.io/DWBmodelUN/reference/funFU.md)
  : Fu's function for relationship between precipitation and potential
  evapotranspiration
- [`dds()`](https://dazamora.github.io/DWBmodelUN/reference/dds.md) :
  DDS algorithm to calibrate the model

## Pre-processing

Functions to prepare the inputs of the model

- [`readSetup()`](https://dazamora.github.io/DWBmodelUN/reference/readSetup.md)
  : Read the model setup
- [`upForcing()`](https://dazamora.github.io/DWBmodelUN/reference/upForcing.md)
  : Upload Forcings
- [`buildGRUmaps()`](https://dazamora.github.io/DWBmodelUN/reference/buildGRUmaps.md)
  : Build Grouped Response Units in maps
- [`init_state()`](https://dazamora.github.io/DWBmodelUN/reference/init_state.md)
  : Initial conditions of the model
- [`cellBasins()`](https://dazamora.github.io/DWBmodelUN/reference/cellBasins.md)
  : Identification of the Cells within a basin
- [`Coord_comparison()`](https://dazamora.github.io/DWBmodelUN/reference/Coord_comparison.md)
  : Raster coordinates comparison

## Post-processing

Functions to analyze and export the results

- [`varBasins()`](https://dazamora.github.io/DWBmodelUN/reference/varBasins.md)
  : value of a variable in each subbasin
- [`printVar()`](https://dazamora.github.io/DWBmodelUN/reference/printVar.md)
  : Print or write variables of interest
- [`graphDWB()`](https://dazamora.github.io/DWBmodelUN/reference/graphDWB.md)
  : Graph for DWB model results

## Data

Example datasets of the Sogamoso River Basin

- [`sogamoso`](https://dazamora.github.io/DWBmodelUN/reference/sogamoso.md)
  : Sogamoso River Basin data
- [`basins`](https://dazamora.github.io/DWBmodelUN/reference/basins.md)
  : basins
- [`cells`](https://dazamora.github.io/DWBmodelUN/reference/cells.md) :
  cells
- [`GRU`](https://dazamora.github.io/DWBmodelUN/reference/GRU.md) : GRU
- [`In_ground`](https://dazamora.github.io/DWBmodelUN/reference/In_ground.md)
  : In_ground
- [`In_storage`](https://dazamora.github.io/DWBmodelUN/reference/In_storage.md)
  : In_storage
- [`P_sogamoso`](https://dazamora.github.io/DWBmodelUN/reference/P_sogamoso.md)
  : P_sogamoso
- [`PET_sogamoso`](https://dazamora.github.io/DWBmodelUN/reference/PET_sogamoso.md)
  : PET_sogamoso
- [`param`](https://dazamora.github.io/DWBmodelUN/reference/param.md) :
  param
- [`r.cells`](https://dazamora.github.io/DWBmodelUN/reference/r.cells.md)
  : r.cells
- [`setup_data`](https://dazamora.github.io/DWBmodelUN/reference/setup_data.md)
  : setup_data
- [`EscSogObs`](https://dazamora.github.io/DWBmodelUN/reference/EscSogObs.md)
  : EscSogObs
- [`simDWB.sogamoso`](https://dazamora.github.io/DWBmodelUN/reference/simDWB.sogamoso.md)
  : simDWB.sogamoso
- [`gru_maps`](https://dazamora.github.io/DWBmodelUN/reference/gru_maps.md)
  : gru_maps
