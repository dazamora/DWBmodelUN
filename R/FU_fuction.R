#' ESTA ES LA FUCION DE NICO
#'
#' @param numerador 
#' @param denominador 
#' @param param 
#'
#' @return
#' @export
#'
#' @examples
#' 
fun_FU<-function(numerador,denominador,param){
  F_FU <- 1 + numerador/denominador-(1+(numerador/denominador)^(1/(1-param)))^(1-param)
  
  X <- rnorm(100)
  return(F_FU)
}