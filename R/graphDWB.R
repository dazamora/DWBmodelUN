#' @name 
#' graphDWB
#' 
#' @title
#' Graph for DWB model results
#'
#' @description 
#' This function dynamically graphs the inputs and results of the DWBmodelUN.
#' It has three types of graphs: 
#' The first (\emph{tp = 1}) to graph any variable in continuous format.
#' The second (\emph{tp = 2}) is to compare the runoff result of the model, with the observations.
#' Finally, (\emph{tp = 3}) allows to show a comparison between the observed and simulated runoff, as well as, with a set of precipitation.
#' 
#' @param var It is a list that contains time series of type "ts" which you want to graph. 
#' For (\emph{tp = 3}), it must first contain the observed precipitation series, 
#' followed by the simulated runoff series and finally the observed runoff.
#' @param tp Variable to choose the type of graph
#' @param main Main title for the graph
#'
#' @return Prints a dynamic graph according to the requirements.
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
#' # Example 1
#' data(P_sogamoso)
#' P.est <- ts(c(t(P_sogamoso[1, -2:-1])), star = c(2001, 1), frequency = 12)
#' var <- list("Precipitation" = P.est)
#'  
#' graphDWB (var, tp = 1, main = "Precipitation Lat:7.0 Lon:-72.94")
#' 
#' # Example 2
#' data(simDWB.sogamoso, EscSogObs)
#' runoff.sim <- ts(simDWB.sogamoso[ ,1], star = c(2001, 1), frequency = 12)
#' runoff.obs <- ts(EscSogObs[ ,1] , star = c(2001, 1), frequency = 12)
#' var <- list("Runoff.sim" = runoff.sim, "Runoff.obs" = runoff.obs)
#'  
#' graphDWB (var, tp = 2, main = "Runoff: Gauge 23147020")
#' 
#'  
#' 
graphDWB <- function(var, tp, main){
  nvar <- length(var)
  if (nvar == 0){
    stop('The list must contain at least one time series variable')
  }
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
    plot = dygraphs::dygraph(var[[1]], ylab = paste(names(var)[1], "[mm/mth]", sep =" "), main = main) %>%
            dygraphs::dySeries("V1", label = names(var)[1], strokeWidth = 1.7, color= "#2c7fb8") %>%
            dygraphs::dyLegend(show = "follow") %>% 
            dygraphs::dyRangeSelector() %>% 
            dyCSS(system.file("data", "dygraph.css", package = "DWBmodelUN"))
      
  } else if (tp == 2){
    if (nvar < 2){
      stop('An additional variable is required for this type of graph')
    } else{
      plot = dygraphs::dygraph(cbind(var[[1]], var[[2]]), ylab = "Runoff [mm/mth]", main = main) %>%
              dygraphs::dySeries("var[[1]]", label = names(var)[1], strokeWidth = 1.7,  color= "#ef8a62") %>%
              dygraphs::dySeries("var[[2]]", label = names(var)[2], strokeWidth = 1.7, color= "#404040", 
                           drawPoints = TRUE, pointSize = 2) %>%
              dygraphs::dyLegend(show = "always", width = 400) %>% 
              dygraphs::dyHighlight(highlightCircleSize = 3, highlightSeriesBackgroundAlpha = 0.2,
                              hideOnMouseOut = FALSE)  %>% 
              dygraphs::dyRangeSelector(height = 30) %>% 
              dyCSS(system.file("data", "dygraph.css", package = "DWBmodelUN"))
    }
  } else if (tp == 3){
    if (nvar < 3){
      stop('An additional variable is required for this type of graph')
    } else{
      # New function required
      dyBarChart <- function(dygraph) {
        dyPlotter(dygraph = dygraph,
                  name = "BarChart",
                  path = system.file("plotters/barchart.js",
                                     package = "dygraphs"))
      }
    
      plot = dygraphs::dygraph(var[[1]], ylab = "P [mm/mth]", group = "A", height = 150, width = "100%",  main = main) %>%
              dygraphs::dySeries("V1", label = names(var)[1], strokeWidth = 1.7, color= "#2c7fb8") %>%
              dygraphs::dyLegend(show = "follow", width = 400) %>% dyBarChart() %>%
              htmltools::tagList(dygraphs::dygraph(cbind(var[[2]], var[[3]]), ylab = "Runoff [mm/mth]", group = "A", height = 300, width = "100%") %>%
                  dygraphs::dySeries("var[[2]]", label = names(var)[2], strokeWidth = 1.7,  color= "#ef8a62") %>%
                  dygraphs::dySeries("var[[3]]", label = names(var)[3], strokeWidth = 1.7, color= "#404040", 
                                     drawPoints = TRUE, pointSize = 2) %>%
                  dygraphs::dyLegend(show = "follow") %>% 
                  dygraphs::dyHighlight(highlightCircleSize = 3, highlightSeriesBackgroundAlpha = 0.2,
                                        hideOnMouseOut = FALSE)  %>% 
                  dygraphs::dyRangeSelector(height = 25)) %>%
              htmltools::browsable() %>% 
              dyCSS(system.file("data", "dygraph.css", package = "DWBmodelUN"))
        
    }
  } else {
    stop('Wrong type of graph')
  }
  
  return(plot)
}
