#' @name 
#' funFU
#' 
#' @title
#' Fu's function for relationship between precipitation and potential evapotranspiration
#' 
#' @description It is a model based on the postulates of Budyko, which stated that not only does the actual
#' evapotranspiration depend on potential evapotranspiration, but it is also constrained by water availability
#' \cite{(Budyko, 1974)}.
#'
#' @param PET is the variable which will be inserted as the numerator in Fu's function. It can be a value or a numeric vector,
#' in which case it must have the same length as the denominator vector.
#' @param P is the variable which will be inserted as the denominator in Fu's function. It can be a value or a numeric vector,
#' in which case it must have the same length as the numerator vector.
#' @param alpha parameter of Fu's model which controls the evapotranspiration efficiency, yet it is named depending
#' on the variables used as numerator and denominator. It can be a single value of type double or a numeric vector
#' with the same length as \code{PET} and \code{P}. Its values must be between 0 and 1.
#'
#' @return a value or a vector (depending on which kind of data was introduced for numerator and denominator).
#'
#' @author Nicolas Duque Gardeazabal <nduqueg@unal.edu.co>  \cr
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co>  \cr
#' Carolina Vega Viviescas <cvegav@unal.edu.co> \cr
#' David Zamora <dazamoraa@unal.edu.co> \cr
#' 
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - sede Bogota
#' 
#' @references 
#' Zhang, L., Potter, N., Hickel, K., Zhang, Y., & Shao, Q. (2008). 
#' "Water balance modeling over variable time scales based on the 
#' Budyko framework – Model development and testing. Journal of Hydrology", 
#' 360(1-4), 117–131. 
#' 
#' Budyko. (1974). "Climate and life". New York: Academic Press, INC.
#' 
#' @export
#'
#' @examples
#' PET <- 1000
#' P <- 2000
#' alpha <- 0.69  # value used by Zhang et al. (2008) 
#' funFU(PET, P, alpha)
#' 
funFU <- function(PET, P, alpha){
  phi <- PET / P
  k <- 1 / (1 - alpha)
  # for phi > 1 the term (1 + phi^k)^(1/k) is factored as phi * (1 + phi^-k)^(1/k),
  # which avoids the overflow to Inf when P is much smaller than PET
  F_FU <- ifelse(phi > 1,
                 1 + phi - phi * (1 + phi^(-k))^(1/k),
                 1 + phi - (1 + phi^k)^(1/k))
  F_FU[P == 0] <- 1  # it identifies where the limit of the function is not fulfilled and assigns the limit value
  return(F_FU)
}