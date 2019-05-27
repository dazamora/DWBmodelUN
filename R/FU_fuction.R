#' @name 
#' Fu's function
#' 
#' @title
#' Fu's function for relationship between precipitation and potential evapotranspiration
#'
#' @param PET is the variable which will be inserted as numerator in Fu's function. In Fu's original
#' function, the variable used is the potential evapotranspiration. It can be a value or a numeric vector,
#' in which case it must have the same length as the denominator vector.
#' @param P is the variable which will be inserted as numerator in Fu's function. In Fu's original
#' function, the variable used is the precipitation. It can be a value or a numeric vector,
#' in which case it must have the same length as the numerator vector.
#' @param alpha parameter of Fu model which controls the evapotranspiration efficiency, yet it is named depending
#' on the variables used as numerator and denominator. It must be an unique value of type double.
#'
#' @return a value or a vector (depending on which kind of data was introduced for numerator and denominator)
#'
#' @author Nicolas Duque Gardeazabal <nduqueg@unal.edu.co> 
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co> 
#' Carolina Vega Viviescas <cvegav@unal.edu.co>
#' David Zamora <dazamoraa@unal.edu.co>
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co> 
#' Carolina Vega Viviescas <cvegav@unal.edu.co>
#' Water Resources Engineering Research Group - GIREH
#' 
#' @references 
#' Zhang, L., Potter, N., Hickel, K., Zhang, Y., & Shao, Q. (2008). 
#' Water balance modeling over variable time scales based on the 
#' Budyko framework – Model development and testing. Journal of Hydrology, 
#' 360(1-4), 117–131. doi:10.1016/j.jhydrol.2008.07.021 
#' 
#' @export
#'
#' @examples
#' PET <- 1000
#' P <- 2000
#' alpha <- 0.69  # value used by Zhang et al. (2008) to study the mean anual actual evapotranspiration as a function of Potential ET and Precipitation
#' fun_FU(PET, P, alpha)
#' 
funFU <- function(PET, P, alpha){
  
  F_FU <- 1 + PET/P - (1 + (PET/P)^(1/(1 - alpha)))^(1 - alpha)
  F_FU[P == 0] <- 1  # it identifies where the limit of the function is not fulfilled and assigns the limit value
  
  return(F_FU)
}