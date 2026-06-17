# Read the model setup

This function defines the setup features of the model. These include the
dates that define the simulated time period, and also the variables that
will be printed in individual directories. It returns the identified
variables in a tailored dataframe. Optionally, one can build the setup
as a dataframe and pass it to this function for validation and
formatting.

## Usage

``` r
readSetup(Read = TRUE, setup)
```

## Arguments

- Read:

  is a boolean which is used to identify whether the example setup
  included in the package should be returned (*`TRUE`*, the default
  value, matching the `setup_data` dataset), or whether the modeller
  provides its own setup dataframe through the `setup` argument
  (*`FALSE`*).

- setup:

  is an optional dataframe that contains the character strings which
  specifies dates and variables to be printed. The first seven rows must
  be character strings specifying the actions regarding if the modeller
  requires to print the simulated variables. The order is: calibration
  mode, print variables, print total runoff, print soil moisture, print
  actual ET, print direct runoff, print baseflow. Those strings must be
  *YES* or *NO*. The next four rows are: the initial date of simulation,
  the initial date for calibration, the final date of simulation, and
  the final date of calibration. This dates must be in the format
  year-month-day. If calibration is not required, those dates are
  ignored.

## Value

An organized dataframe which defines the model setup.

## Author

Nicolas Duque Gardeazabal \<nduqueg@unal.edu.co\>  
Pedro Felipe Arboleda Obando \<pfarboledao@unal.edu.co\>  
Carolina Vega Viviescas \<cvegav@unal.edu.co\>  
David Zamora \<dazamoraa@unal.edu.co\>  

Water Resources Engineering Research Group - GIREH Universidad Nacional
de Colombia - sede Bogota

## Examples

``` r
setup <- readSetup(Read = TRUE)  # run if you would like to upload the example setup

data(setup_data)
setup <- readSetup(Read = TRUE, setup_data)

# Create your own setup
a <- rep("no",7)
b <- "1990-01-01"
c <- "1991-01-01"
d <- "2012-12-15"
e <- "2012-12-10"
table_setup <- data.frame(set=a,stringsAsFactors = FALSE)
table_setup <- rbind(table_setup, b, c, d, e)
setup <- readSetup(Read = FALSE, table_setup)
```
