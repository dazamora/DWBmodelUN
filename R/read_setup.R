#' @name 
#' readSetup
#'
#' @title Read the model setup
#'
#' @description This function reads the setup features of the model. this includes the dates that defines the simulated time period, and also the variables
#' that will be printed in individual directories. It takes the information from a plain text file, and returns the identified variables in a tailored dataframe.
#' Optionally, one can insert the string setup in a dataframe and hence used it in this function.
#'
#' @param Read is a boolean which is used to identify whether the modeller has created its own dataframe in R or
#' the setup is read from a plain text previously written, the text file must be archived in the main directory
#' of the model and its name must be \emph{DWB_setup.txt}. An example of the file is contained in the package.
#' The default value is \emph{TRUE}, meaning that it will read the plain text file.
#' @param ... is an optinal dataframe that contains the character strings which specifies dates and variables to be printed.
#' The first six rows must be character strings specifying the actions regarding if the modeller requires to print the
#' simulated variables. The order is: print variables, print total runoff, print soil moisture, print actual ET, print direct runoff,
#' print baseflow. Those strings must be \emph{YES} or \emph{NO}. The next four rows are: the initial date of simulation, the initial date for calibration,
#' the final date of simulation, and the final date of calibration. This dates must be in the format year-month-day.
#'
#' @return a organized dataframe which defines the model setups
#' 
#' @author David Zamora <dazamoraa@unal.edu.co>
#' Nicolas Duque Gardeazabal <nduqueg@unal.edu.co> 
#' Water Resources Engineering Research Group - GIREH
#'
#' @examples
#' meteo <- UpForcing(path_p="./precip/", path_pet="./pet/", file_type="raster", format= "NCDF")
#' meteo <- UpForcing(path_p="./precip/", path_pet="./pet/", file_type="csv")
#' 
#' 
readSetup <- function(Read = T, ...){
  
  if (Read == T){
    
    setup <- read.table("./DWB_setup.txt")
    setup_data <- data.frame()
    setup_data[1,1] <- substr(setup[1,], 11, 12)  # print the simulated variables
    setup_data[2,1] <- substr(setup[2,], 10, 11)  # print total runoff
    setup_data[3,1] <- substr(setup[3,], 10, 11)  # print soil moisture
    setup_data[4,1] <- substr(setup[4,], 12, 13)  # print actual ET
    setup_data[5,1] <- substr(setup[5,], 11, 12)  # print direct runoff
    setup_data[6,1] <- substr(setup[6,], 11, 12)  # print baseflow
    setup_data[7,1] <- substr(setup[7,], 8, 17)  # initial date of simulation
    setup_data[8,1] <- substr(setup[8,], 12, 21)  # initial date of calibration
    
    # final date of simulation
    setup_data[9,1] <- paste(substr(setup[9,], 8, 14),"-01",sep="")  # changes the day speficfied to the first day of the month in order to compare it in the model setup
    # final date of calibration
    setup_data[10,1] <- paste(substr(setup[10,], 12, 18),"-01",sep="")
  }else{
    setup_data <- ...  # asigns the dataframe created in the R environment
  }
  
  return(setup_data)
}