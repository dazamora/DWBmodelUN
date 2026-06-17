# setup_data

Data.frame with the initial configuration of the model run

## Usage

``` r
setup_data
```

## Format

data.frame

- setup_data:

  Data frame, contains the set-up and print options to run the
  DWBmodelUN. It consists of 11 parameters: the first seven are
  configurations of orders whose values can be 'yes' or 'no',
  indicating 1) If the model must be calibrated, 2) If the variables
  must be saved in raster format and which variables 3) R - Total runoff
  , 4) S - Soil moisture storage, 5) AET - Actual evapotranspiration, 6)
  Qd - Surface runoff , and 7) Qb - Base flow. The last four variables
  are dates and refer to the times of the input series, and the start
  and end times of the simulation and calibration of the model.
