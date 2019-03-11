#' Cargar forzamientos
#'
#' @param numerador 
#' @param denominador 
#' @param param 
#'
#'@param precip
#'
#' @return
#' @export
#'
#' @examples
upload_forcings<-function(numerador,denominador,param){
  F_FU <- 1 + numerador/denominador-(1+(numerador/denominador)^(1/(1-param)))^(1-param)
  
  # recordar separar variables
  return(F_FU)
}