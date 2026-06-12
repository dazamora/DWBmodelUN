#' @name 
#' readSetup
#'
#' @title
#' Read the model setup
#'
#' @description This function defines the setup features of the model. These include the dates that define the simulated time period, and also the variables
#' that will be printed in individual directories. It returns the identified variables in a tailored dataframe.
#' Optionally, one can build the setup as a dataframe and pass it to this function for validation and formatting.
#'
#' @param Read is a boolean which is used to identify whether the example setup included in the package should be
#' returned (\emph{\code{TRUE}}, the default value, matching the \code{setup_data} dataset), or whether the modeller
#' provides its own setup dataframe through the \code{setup} argument (\emph{\code{FALSE}}).
#' @param setup is an optional dataframe that contains the character strings which specifies dates and variables to be printed.
#' The first seven rows must be character strings specifying the actions regarding if the modeller requires to print the
#' simulated variables. The order is: calibration mode, print variables, print total runoff, print soil moisture, print actual ET, print direct runoff,
#' print baseflow. Those strings must be \emph{YES} or \emph{NO}. The next four rows are: the initial date of simulation, the initial date for calibration,
#' the final date of simulation, and the final date of calibration. This dates must be in the format year-month-day. If calibration is not
#' required, those dates are ignored.
#' 
#' @return An organized dataframe which defines the model setup.
#'  
#' @author Nicolas Duque Gardeazabal <nduqueg@unal.edu.co> \cr
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co> \cr
#' Carolina Vega Viviescas <cvegav@unal.edu.co> \cr
#' David Zamora <dazamoraa@unal.edu.co> \cr
#'  
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - sede Bogota
#' 
#' @export
#' 
#' @examples
#' setup <- readSetup(Read = TRUE)  # run if you would like to upload the example setup
#' 
#' data(setup_data)
#' setup <- readSetup(Read = TRUE, setup_data)
#' 
#' # Create your own setup
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

  if (!is.logical(Read) || length(Read) != 1 || is.na(Read)) {
    stop("Read must be TRUE or FALSE")
  }

  if (Read) {
    setup <- data.frame(v1 = c(rep("no", 7), "2001-01-01", "2001-07-01", "2010-12-01", "2007-12-01"),
                        stringsAsFactors = FALSE)
    rownames(setup) <- c("calibration", "print", "print_R", "print_S", "print_AET", "print_Qd",
                         "print_Qb", "D.ini", "D.ini.cal", "D.end", "D.end.cal")
  } else {
    if (missing(setup) || !is.data.frame(setup) || nrow(setup) < 11) {
      stop("When Read = FALSE, setup must be a data frame with at least 11 rows. See the function help for its structure.")
    }

    setup[10, 1] <- paste(substr(setup[10, 1], 1, 7), "-01", sep = "")
    setup[11, 1] <- paste(substr(setup[11, 1], 1, 7), "-01", sep = "")
  }

  return(setup)
}