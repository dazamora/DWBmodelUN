#' @name 
#' graphDWB
#' 
#' @title
#' Graph for DWB model
#'
#' @description 
#' Function to graph dynamically the results of the DWB model
#' 
#' @param date.ini 
#' @param ... 
#' @param q_total 
#'
#' @param  
#'
#' @return A plot of precipitation, actual evapotranspiration and runoff
#' 
#' @export
#' #'
#' @author 
#' Nicolas Duque Gardeazabal <nduqueg@unal.edu.co> 
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co> 
#' Carolina Vega Viviescas <cvegav@unal.edu.co>
#' David Zamora <dazamoraa@unal.edu.co>
#' 
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - sede Bogotá
#' 
#' @examples
#' # Load DWB model results
#' data(dwb_results)
#' runoff <- colMeans(dwb_results$q_total)
#' graphDWB (runoff)
#' 
#' data(P_sogamoso, dwb_results)
#' 
graphDWB <- function(q_total, date.ini,  ...){
  # q_total<-colMeans(dwb_results$q_total); date.ini <- c(2001, 1)
  q <- ts(q_total, date.ini, frequency = 12)
  dygraphs::dygraph(q, ylab = "Runoff") %>% dyRangeSelector()
  
  return(plot)
}

# lungDeaths <- cbind(mdeaths, fdeaths)
# dygraph(lungDeaths)