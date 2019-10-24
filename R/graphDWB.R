#' @name 
#' graphDWB
#' 
#' @title
#' Graph for DWB model results
#'
#' @description 
#' This function dynamically graphs the inputs and results of the DWBmodelUN.
#' It has three types of graphs: \cr
#' \itemize{
#'   \item (\emph{tp = 1}): Plots any variable in a continuous format.\cr
#'   \item (\emph{tp = 2}): Compares the runoff result of the model, with the observations.\cr
#'   \item (\emph{tp = 3}): It allows showing a comparison between the observed and simulated runoff, as well as, with a dataset of precipitation.\cr
#'   \item (\emph{tp = 4}): It presents a comparison between a set of precipitation, actual or potential evapotranspiration and runoff.
#'   }
#' 
#' @param var It is a list that contains a time series of type \code{\link{ts}} which you want to graph. \cr
#' For (\emph{tp = 2}), it is recommended to list the simulated runoff series first, followed by the observed.\cr
#' For (\emph{tp = 3}), it must first contain the observed precipitation series, 
#' followed by the simulated runoff series and finally the observed runoff. \cr
#' For (\emph{tp = 4}), it must first contain the observed precipitation series, 
#' followed by the evapotranspiration series and finally the runoff time series. \cr
#' @param tp Variable to choose the type of graph. 
#' @param main Main title for the graph.
#' @param ... Other parameters of the \pkg{dygraphs} package.
#'
#' @return Prints a dynamic graph according to the requirements.
#' 
#' @export
#' 
#' @author 
#' Carolina Vega Viviescas <cvegav@unal.edu.co> \cr
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co> \cr
#' David Zamora <dazamoraa@unal.edu.co> \cr
#' Nicolas Duque Gardeazabal <nduqueg@unal.edu.co> \cr
#' 
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - sede Bogota
#' 
#' @examples
#' # Example 1
#' data(P_sogamoso)
#' P.est <- ts(c(t(P_sogamoso[1, -2:-1])), star = c(2001, 1), frequency = 12)
#' var <- list("Precipitation" = P.est)
#'  
#' graphDWB(var, tp = 1, main = "Precipitation Lat:7.0 Lon:-72.94")
#' 
#' # Example 2
#' data(simDWB.sogamoso, EscSogObs)
#' runoff.sim <- ts(simDWB.sogamoso[ ,1], star = c(2001, 1), frequency = 12)
#' runoff.obs <- ts(EscSogObs[ ,1] , star = c(2001, 1), frequency = 12)
#' var <- list("Runoff.sim" = runoff.sim, "Runoff.obs" = runoff.obs)
#'  
#' graphDWB(var, tp = 2, main = "Runoff: Gauge 23147020")
#' 
#' # Example 3
#' data(P_sogamoso, simDWB.sogamoso, EscSogObs)
#' P.est <- ts(c(t(P_sogamoso[1, -2:-1])), star = c(2001, 1), frequency = 12)
#' runoff.sim <- ts(simDWB.sogamoso[ ,1], star = c(2001, 1), frequency = 12)
#' runoff.obs <- ts(EscSogObs[ ,1] , star = c(2001, 1), frequency = 12)
#' var <- list("Precipitation" = P.est,"Runoff.sim" = runoff.sim, "Runoff.obs" = runoff.obs)
#'  
#' graphDWB(var, tp = 3, main = "DWB results at Sogamoso Basin")
#' 
#' # Example 4
#' data(P_sogamoso, PET_sogamoso, simDWB.sogamoso)
#' P <- ts(c(t(P_sogamoso[1, -2:-1])), star = c(2001, 1), frequency = 12)
#' PET <- ts(c(t(PET_sogamoso[1, -2:-1])), star = c(2001, 1), frequency = 12)
#' runoff.sim <- ts(simDWB.sogamoso[ ,1], star = c(2001, 1), frequency = 12)
#' var <- list("P" = P,"PET" = PET, "Runoff.sim" = runoff.sim)
#'  
#' graphDWB(var, tp = 4, main = "General Comparison Sogamoso Basin")
#' 
graphDWB <- function(var, tp, main, ...){
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
    plot <- dygraphs::dygraph(var[[1]], ylab = paste(names(var)[1], "[mm/mth]", sep =" "), main = main, ...)
    plot <- dygraphs::dySeries(dygraph = plot, "V1", label = names(var)[1], strokeWidth = 1.7, color= "#2c7fb8")
    plot <- dygraphs::dyLegend(dygraph = plot, show = "follow", hideOnMouseOut = FALSE)
    plot <- dygraphs::dyRangeSelector(dygraph = plot)
    plot <- dygraphs::dyCSS(dygraph = plot, system.file("data", "dygraph.css", package = "DWBmodelUN"))
    
  } else if (tp == 2){
    if (nvar < 2){
      stop('An additional variable is required for this type of graph')
    } else if (nvar > 2){
      warning('Only the first two variables in the list will be compared')
    } 
    plot <- dygraphs::dygraph(cbind(var[[1]], var[[2]]), ylab = "[mm/mth]", main = main, ...)
    plot <- dygraphs::dySeries(dygraph = plot, "var[[1]]", label = names(var)[1], strokeWidth = 1.7,  color= "#ef8a62")
    plot <- dygraphs::dySeries(dygraph = plot, "var[[2]]", label = names(var)[2], strokeWidth = 1.7, color= "#404040", 
                               drawPoints = TRUE, pointSize = 2)
    plot <- dygraphs::dyLegend(dygraph = plot, show = "always", width = 400)
    plot <- dygraphs::dyHighlight(dygraph = plot, highlightCircleSize = 3, highlightSeriesBackgroundAlpha = 0.2,
                                  hideOnMouseOut = FALSE)
    plot <- dygraphs::dyRangeSelector(dygraph = plot, height = 30)
    plot <- dygraphs::dyCSS(dygraph = plot, system.file("data", "dygraph.css", package = "DWBmodelUN"))
    
  } else if (tp == 3){
    if (nvar < 3){
      stop('An additional variable is required for this type of graph')
    } else if (nvar > 3){
      warning('Only the first three variables in the list will be compared, assumed as 1. Precipitation 2. Simulated runoff 3. Observed runoff')
    } 
    aux <- c(-0.001, max(var[[1]], na.rm = TRUE))
    plot.1 <- dygraphs::dygraph(var[[1]], group = "A", height = 150, width = "100%",  main = main, ...)
    plot.1 <- dygraphs::dySeries(dygraph = plot.1, "V1", label = names(var)[1], strokeWidth = 1.7, axis = "y", color= "#2c7fb8")
    plot.1 <- dygraphs::dyLegend(dygraph = plot.1, show = "follow", width = 210, hideOnMouseOut = FALSE)
    plot.1 <- dygraphs::dyBarChart(dygraph = plot.1)
    plot.1 <- dygraphs::dyAxis(dygraph = plot.1, name = "y", label = "P [mm/mth]", valueRange = c(max(var[[1]] + 50, na.rm = TRUE),0))
    plot.1 <- dygraphs::dyCSS(dygraph = plot.1, system.file("data", "dygraph.css", package = "DWBmodelUN"))
    
    plot.2 <- dygraphs::dygraph(cbind(var[[2]], var[[3]]), ylab = "Runoff [mm/mth]", group = "A", height = 300, width = "100%", ...)
    plot.2 <- dygraphs::dySeries(dygraph = plot.2, "var[[2]]", label = names(var)[2], strokeWidth = 1.7,  color= "#ef8a62")
    plot.2 <- dygraphs::dySeries(dygraph = plot.2, "var[[3]]", label = names(var)[3], strokeWidth = 1.7, color= "#404040", 
                                 drawPoints = TRUE, pointSize = 2)
    plot.2 <- dygraphs::dyLegend(dygraph = plot.2, show = "follow", width = 210, hideOnMouseOut = FALSE) 
    plot.2 <- dygraphs::dyHighlight(dygraph = plot.2, highlightCircleSize = 3, highlightSeriesBackgroundAlpha = 0.2,
                                    hideOnMouseOut = FALSE)
    plot.2 <- dygraphs::dyRangeSelector(dygraph = plot.2, height = 25)
    plot <- list(plot.1, plot.2)
    plot <- htmltools::browsable(htmltools::tagList(plot))
    
  } else if (tp == 4){
    if (nvar < 3){
      stop('An additional variable is required for this type of graph')
    } else if (nvar > 3){
      warning('Only the first three variables in the list will be compared, assumed as 1. Precipitation 2. Evapotranspiration 3. Runoff')
    }
    plot.1 <- dygraphs::dygraph(cbind(var[[1]], var[[2]]), group = "A", height = 225, width = "100%",  main = main, ...) 
    plot.1 <- dygraphs::dyStackedBarGroup(dygraph = plot.1,name = "var[[1]]", label = names(var)[1], axis = "y", color = "#2c7fb8") 
    plot.1 <- dygraphs::dyAxis(dygraph = plot.1, name = "y", label = "P [mm/mth]", valueRange = c(max(var[[1]] + 50, na.rm = TRUE), 0)) 
    plot.1 <- dygraphs::dyStackedBarGroup(dygraph = plot.1, name = "var[[2]]", label = names(var)[2], axis = "y2", color = "#1a9850") 
    plot.1 <- dygraphs::dyAxis(dygraph = plot.1, name = "y2", label = "ET [mm/mth]", valueRange = c(0, max(var[[1]] + 50))) 
    plot.1 <- dygraphs::dyLegend(dygraph = plot.1, show = "follow", width = 210) 
    plot.1 <- dygraphs::dyHighlight(dygraph = plot.1, highlightCircleSize = 3, highlightSeriesBackgroundAlpha = 0.2,
                                    hideOnMouseOut = FALSE) 
    plot.1 <- dygraphs::dyCSS(dygraph = plot.1, system.file("data", "dygraph.css", package = "DWBmodelUN"))  
    
    plot.2 <- dygraphs::dygraph(var[[3]], ylab = "Runoff [mm/mth]", group = "A", height = 225, width = "92%", ...) 
    plot.2 <- dygraphs::dySeries(dygraph = plot.2, "V1", label = names(var)[3], strokeWidth = 1.7,  color= "#ef8a62") 
    plot.2 <- dygraphs::dyLegend(dygraph = plot.2, show = "follow", width = 210, hideOnMouseOut = FALSE) 
    plot.2 <-  dygraphs::dyRangeSelector(dygraph = plot.2, height = 25)
    
    plot <- list(plot.1, plot.2)
    plot <- htmltools::browsable(htmltools::tagList(plot))
    
  } else {
    stop('Wrong type of graph')
  }
  return(plot)
}
