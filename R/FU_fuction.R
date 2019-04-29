#' @name 
#' Fu's function
#' 
#' @title
#' Fu's function for relationship between precipitation and evapotranspiration
#'
#' @param numerator is the variable which will be inserted as numerator in Fu's function. In Fu's original
#' function, the variable used is the potential evapotranspiration. It can be a value or a numeric vector,
#' in which case it must have the same length as the denominator vector.
#' @param denominator is the variable which will be inserted as numerator in Fu's function. In Fu's original
#' function, the variable used is the precipitation. It can be a value or a numeric vector,
#' in which case it must have the same length as the numerator vector.
#' @param param parameter of Fu model which controls the evapotrasnpiration efficiency, yet it is named depending
#' on the variables used as numerator and denominator. It must be an unique value of type double.
#'
#' @return a value or a vector (depending on which kind of data was introduced for numerator and denominator)
#'
#' @author Nicolas Duque Gardeazabal <nduqueg@unal.edu.co> 
#' David Zamora <dazamoraa@unal.edu.co>
#' Water Resources Engineering Research Group - GIREH
#'
#' @examples
#' PET <- 1000
#' P <- 2000
#' alpha <- 0.69  # value used by Zhang et al. (2008) to study the mean anual actual evapotranspiration as a function of Potential ET and Precipitation
#' fun_FU(PET, P, alpha)
#' 
funFU<-function(numerator,denominator,param){
  zerovalues<-which(denominator==0)
  F_FU <- 1 + numerator/denominator-(1+(numerator/denominator)^(1/(1-param)))^(1-param)
  F_FU[zerovalues]<-1
  
  # recordar separar variables
  return(F_FU)
}