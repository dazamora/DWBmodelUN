#' @name 
#' readSetup
#'
#' @title
#' Read the model setup
#'
#' @description This function reads the setup features of the model. These include the dates that define the simulated time period, and also the variables
#' that will be printed in individual directories. It reads the information from a \emph{\code{RData}} file, and returns the identified variables in a tailored dataframe.
#' Optionally, one can insert the string setup in a dataframe and hence use it in this function.
#'
#' @param Read is a boolean which is used to identify whether the modeller has created its own dataframe in R or
#' the setup is read from file previously written in the \code{data} directory. An example of the file is contained in the package.
#' The default value is \emph{\code{TRUE}}, meaning that it will read the plain file from the \code{data} directory.
#' @param setup is an optinal dataframe that contains the character strings which specifies dates and variables to be printed.
#' The first seven rows must be character strings specifying the actions regarding if the modeller requires to print the
#' simulated variables. The order is: calibration mode, print variables, print total runoff, print soil moisture, print actual ET, print direct runoff,
#' print baseflow. Those strings must be \emph{YES} or \emph{NO}. The next four rows are: the initial date of simulation, the initial date for calibration,
#' the final date of simulation, and the final date of calibration. This dates must be in the format year-month-day. If calibration is not
#' required, those dates are ignored.
#' 
#' @return An organized dataframe which defines the model setups.
#'  
#' @author Nicolas Duque Gardeazabal <nduqueg@unal.edu.co> \cr
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co> \cr
#' Carolina Vega Viviescas <cvegav@unal.edu.co> \cr
#' David Zamora <dazamoraa@unal.edu.co> \cr
#'  
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - sede Bogotá
#' 
#' @export
#' 
#' @examples
#' setup <- readSetup(Read = TRUE)  # run if you would like to upload the example setup
#' 
#' # example on how to create your own setup
#' a <- rep("no",7)
#' b <- "1990-01-01"
#' c <- "1991-01-01"
#' d <- "2012-12-15"
#' e <- "2012-12-10"
#' table_setup <- data.frame(set=a,stringsAsFactors = FALSE)
#' table_setup <- rbind(table_setup, b, c, d, e)
#' setup <- readSetup(Read = FALSE, table_setup)
#' 
readSetup <- function(Read = TRUE, setup){
  
  if(!exists("Read") & !exists("setup")){
    warning("Read and setup parameters are missing")
  }else{
    if (Read == TRUE){
      setup <- data(setup_data, envir = environment())  # "setup_data" is a rdata file that is available in the "data" directory, which can be loaded by just typing the name of the variable
      setup <- setup_data
    }else{
      # asigns the dataframe created in the R environment
      # final date of simulation
      setup[10,1] <- paste(substr(setup[10, ], 1, 7), "-01", sep = "")  # changes the day speficfied to the first day of the month
      # final date of calibration
      setup[11,1] <- paste(substr(setup[11, ], 1, 7), "-01", sep = "")
    }
    return(setup)
  }
}