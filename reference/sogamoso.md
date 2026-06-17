# Sogamoso River Basin data

Sogamoso River Basin data

## Usage

``` r
sogamoso
```

## Format

The list contains

- basins:Shapefile featuring subbasins across the Sogamoso Basin.

- cells:Data frame (3 columns by 677 rows), cells coordinates and its ID
  number.

- dwb_results:List, it contains the DWB model's outputs in matrix
  format, q_total- total runoff, aet- actual evapotranspiration, r-
  recharge, qd- Surface runoff, qd- baseflow, s- soil storage, g-
  groundwater storage.

- GRU:Raster, it represents the ten (10) Grouped Response Units across
  the Sogamoso River Basin.

- In_ground:Raster, initial conditions in the groundwater storage.

- In_storage:Raster, initial conditions in the soil storage.

- P_sogamoso:Data frame, it should represent the cells in each row, and
  the precipitation info. by month in each column. The cell rank should
  match the cell ID in the cells data frame. The first two columns are
  the coordinates of the cells

- param:Data frame, it should represent a GRU in each row, and parameter
  values in each column. GRU rank should match the GRU number used in
  the GRU raster.

- PET_sogamoso:Data frame, it contains evapotranspiration data,
  representing the cells in each row, and the evapotranspiration info.
  by month in each column. The cell rank should match the cell ID in the
  cells data frame.The first two columns are the coordinates of the
  cells

- r.cells:Raster, data frame Cells converted to raster format.

- setup_data:Data frame, it contains the set-up and printing options to
  run the DWBmodelUN. It consists of 11 parameters: the first seven are
  configurations of orders whose values can be 'yes' or 'no',
  indicating 1) If the model must be calibrated, 2) If the variables
  must be saved in raster format and which variables 3) R - Total runoff
  , 4) S - Soil moisture storage, 5) AET - Actual evapotranspiration, 6)
  Qd - Surface runoff , and 7) Qb - Base flow. The last four variables
  are dates and refer to the times of the input series, and the start
  and end times of the simulation and calibration of the model.

- EscSogObs:Data frame, it contains runoff time series measured at 32
  stations within the basin. These gauges belong to the IDEAM monitoring
  network.

- simDWB.sogamoso:Data frame, it contains simulated runoff time series
  at the same 32 stations within the basin.
