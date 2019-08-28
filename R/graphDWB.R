#' @name 
#' graphDWB
#' 
#' @title
#' Graph for DWB model
#'
#' @description 
#' Function to graph dynamically the results of the DWB model
#' 
#' @param var list of the variables to plot
#' @param tp type of plot
#'
#' @return A plot of precipitation, actual evapotranspiration and runoff
#' 
#' @export
#' 
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
#' data(simDWB.sogamoso, EscSogObs)
#' runoff.sim <- ts(simDWB.sogamoso[ ,1], star = c(2001, 1), frequency = 12)
#' runoff.obs <- ts(EscSogObs[ ,1] , star = c(2001, 1), frequency = 12)
#' var <- list("Runoff.sim" = runoff.sim, "Runoff.obs" = runoff.obs)
#' 
#' 
#' graphDWB (var, tp = 2, main = "Runoff at gauge 23147020")
#' 
#' 
graphDWB <- function(var, tp, main){
  nvar <- length(var)
  # All series must be time series class
  for(i in 1:nvar){
    if(class(var[[i]]) != "ts"){
      warning(paste('The', i, 'variable is not a time series', dQuote(c("ts")) ,'class'))
    }
  }; rm(i)
  # Verification of type of plot
  if(tp == 1){
    if (nvar > 1){
      warning('Only the first variable in the list will be used')
    }
    dygraphs::dygraph(var[[1]], ylab = "Precipitation [mm/mth]", main = main) %>%
      dygraphs::dySeries("V1", label = names(var)[1], strokeWidth = 1.7, color= "#2c7fb8") %>%
      dygraphs::dyLegend(show = "follow") %>% 
      dygraphs::dyRangeSelector()
      
  } else if (tp == 2){
    if (nvar < 2){
      stop('An additional variable is required for this type of graph')
    }else{
      dygraphs::dygraph(cbind(var[[1]], var[[2]]), ylab = "Runoff [mm/mth]", main = main) %>%
        dygraphs::dySeries("var[[1]]", label = names(var)[1], strokeWidth = 1.7,  color= "#ef8a62") %>%
        dygraphs::dySeries("var[[2]]", label = names(var)[2], strokeWidth = 1.7, color= "#404040", 
                           drawPoints = TRUE, pointSize = 2) %>%
        dygraphs::dyLegend(show = "always") %>% 
        dygraphs::dyHighlight(highlightCircleSize = 3, highlightSeriesBackgroundAlpha = 0.2,
                              hideOnMouseOut = FALSE)  %>% 
        dygraphs::dyRangeSelector(height = 30)
    }
  }
  
  return(plot)
}
