#' @name 
#' graphDWB
#' 
#' @title
#' Graph for DWB model results
#'
#' @description 
#' This function dynamically graphs the inputs and results of the DWBmodelUN.
#' 
#' @details 
#' It has three types of graphs: \cr
#' \itemize{
#'   \item (\emph{tp = 1}): Plots any variable in a continuous format.\cr
#'   \item (\emph{tp = 2}): Compares the runoff result of the model, with the observations.\cr
#'   \item (\emph{tp = 3}): It allows to show a comparison between the observed and simulated runoff, as well as, with a dataset of precipitation.\cr
#'   \item (\emph{tp = 4}): It presents a comparison between a set of precipitation, actual or potential evapotranspiration and runoff.
#'   }
#' 
#' @param var It is a list that contains a time series of type \code{\link{ts}} which you want to graph. \cr
#' For (\emph{tp = 2}), it is recommended to list the simulated runoff series first, followed by the observed.\cr
#' For (\emph{tp = 3}), it must first contain the observed precipitation series, 
#' followed by the simulated runoff series and finally the observed runoff. \cr
#' For (\emph{tp = 4}), it must first contain the observed precipitation series, 
#' followed by the evapotranspiration series and finally the runoff time series. \cr
#' @param tp Variable which is defined to choose the type of graph. 
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
#' P.est <- ts(c(t(P_sogamoso[1, -2:-1])), start = c(2001, 1), frequency = 12)
#' var <- list("Precipitation" = P.est)
#' 
#' graphDWB(var, tp = 1, main = "Precipitation Lat:7.0 Lon:-72.94")
#' 
#' # Example 2
#' data(simDWB.sogamoso, EscSogObs)
#' runoff.sim <- ts(simDWB.sogamoso[,25], start = c(2001, 1), frequency = 12)
#' runoff.obs <- ts(EscSogObs[,25] , start = c(2001, 1), frequency = 12)
#' var <- list("Runoff.sim" = runoff.sim, "Runoff.obs" = runoff.obs)
#' 
#' graphDWB(var, tp = 2, main = "Runoff at basin closure: Gauge 24067010")
#' 
#' # Example 3
#' data(P_sogamoso, simDWB.sogamoso, EscSogObs)
#' P.est <- ts(c(t(P_sogamoso[1, 15:110])), start = c(2002, 1), frequency = 12)
#' runoff.sim <- ts(simDWB.sogamoso[13:108 ,25], start = c(2002, 1), frequency = 12)
#' runoff.obs <- ts(EscSogObs[13:108 ,25] , start = c(2002, 1), frequency = 12)
#' var <- list("Precipitation" = P.est,"Runoff.sim" = runoff.sim, "Runoff.obs" = runoff.obs)
#' 
#' graphDWB(var, tp = 3, main = "DWB results at Sogamoso Basin closure point")
#' 
#' # Example 4
#' data(P_sogamoso, PET_sogamoso, simDWB.sogamoso)
#' P <- ts(c(t(P_sogamoso[1, -2:-1])), start = c(2001, 1), frequency = 12)
#' PET <- ts(c(t(PET_sogamoso[1, -2:-1])), start = c(2001, 1), frequency = 12)
#' runoff.sim <- ts(simDWB.sogamoso[ ,25], start = c(2001, 1), frequency = 12)
#' var <- list("P" = P,"PET" = PET, "Runoff.sim" = runoff.sim)
#' 
#' graphDWB(var, tp = 4, main = "General Comparison Sogamoso Basin")
#' 
graphDWB <- function(var, tp, main = "", ...){
  
  if (!requireNamespace("dygraphs", quietly = TRUE)) {
    stop("The 'dygraphs' package is required. Install it with install.packages('dygraphs').")
  }
  
  if (!requireNamespace("htmltools", quietly = TRUE)) {
    stop("The 'htmltools' package is required. Install it with install.packages('htmltools').")
  }
  
  if (missing(var) || !is.list(var) || length(var) == 0) {
    stop("var must be a list containing at least one time series variable")
  }
  
  if (missing(tp) || !tp %in% c(1, 2, 3, 4)) {
    stop("tp must be one of: 1, 2, 3, or 4")
  }
  
  nvar <- length(var)
  
  if (is.null(names(var)) || any(names(var) == "")) {
    names(var) <- paste0("var", seq_along(var))
  }
  
  for (i in seq_len(nvar)) {
    if (!inherits(var[[i]], "ts")) {
      stop(paste("Variable", i, "must be a time series object of class 'ts'"))
    }
  }
  
  make_series <- function(series, series_names) {
    out <- do.call(cbind, series)
    colnames(out) <- series_names
    out
  }
  
  max_plus <- function(x, add = 50) {
    max(x, na.rm = TRUE) + add
  }  
  if (tp == 1) {
    
    if (nvar > 1) {
      warning("Only the first variable in the list will be used")
    }
    
    y_name <- names(var)[1]
    
    plot <- dygraphs::dygraph(
      var[[1]],
      ylab = paste(y_name, "[mm/mth]"),
      main = main,
      ...
    )
    
    plot <- dygraphs::dySeries(
      dygraph = plot,
      name = "V1",
      label = y_name,
      strokeWidth = 1.7,
      color = "#2c7fb8"
    )
    
    plot <- dygraphs::dyLegend(plot, show = "follow", hideOnMouseOut = FALSE)
    plot <- dygraphs::dyRangeSelector(plot)
    
  } else if (tp == 2) {
    
    if (nvar < 2) {
      stop("Two variables are required for this type of graph")
    }
    
    if (nvar > 2) {
      warning("Only the first two variables in the list will be compared")
    }
    
    series_names <- names(var)[1:2]
    data_plot <- make_series(var[1:2], series_names)
    
    plot <- dygraphs::dygraph(
      data_plot,
      ylab = "[mm/mth]",
      main = main,
      ...
    )
    
    plot <- dygraphs::dySeries(
      plot,
      name = series_names[1],
      label = series_names[1],
      strokeWidth = 1.7,
      color = "#ef8a62"
    )
    
    plot <- dygraphs::dySeries(
      plot,
      name = series_names[2],
      label = series_names[2],
      strokeWidth = 1.7,
      color = "#404040",
      drawPoints = TRUE,
      pointSize = 2
    )
    
    plot <- dygraphs::dyLegend(plot, show = "always", width = 400)
    plot <- dygraphs::dyHighlight(
      plot,
      highlightCircleSize = 3,
      highlightSeriesBackgroundAlpha = 0.2,
      hideOnMouseOut = FALSE
    )
    plot <- dygraphs::dyRangeSelector(plot, height = 30)
    
  } else if (tp == 3) {
    
    if (nvar < 3) {
      stop("Three variables are required for this type of graph")
    }
    
    if (nvar > 3) {
      warning("Only the first three variables in the list will be compared, assumed as 1. Precipitation 2. Simulated runoff 3. Observed runoff")
    }
    
    p_name <- names(var)[1]
    runoff_names <- names(var)[2:3]
    runoff_data <- make_series(var[2:3], runoff_names)
    
    plot.1 <- dygraphs::dygraph(
      var[[1]],
      group = "A",
      height = 150,
      width = "100%",
      main = main,
      ...
    )
    
    plot.1 <- dygraphs::dySeries(
      plot.1,
      name = "V1",
      label = p_name,
      strokeWidth = 1.7,
      axis = "y",
      color = "#2c7fb8"
    )
    
    plot.1 <- dygraphs::dyLegend(plot.1, show = "follow", width = 210, hideOnMouseOut = FALSE)
    plot.1 <- dygraphs::dyBarChart(plot.1)
    plot.1 <- dygraphs::dyAxis(
      plot.1,
      name = "y",
      label = "P [mm/mth]",
      valueRange = c(max_plus(var[[1]]), 0)
    )
    
    plot.2 <- dygraphs::dygraph(
      runoff_data,
      ylab = "Runoff [mm/mth]",
      group = "A",
      height = 300,
      width = "100%",
      ...
    )
    
    plot.2 <- dygraphs::dySeries(
      plot.2,
      name = runoff_names[1],
      label = runoff_names[1],
      strokeWidth = 1.7,
      color = "#ef8a62"
    )
    
    plot.2 <- dygraphs::dySeries(
      plot.2,
      name = runoff_names[2],
      label = runoff_names[2],
      strokeWidth = 1.7,
      color = "#404040",
      drawPoints = TRUE,
      pointSize = 2
    )
    
    plot.2 <- dygraphs::dyLegend(plot.2, show = "follow", width = 210, hideOnMouseOut = FALSE)
    plot.2 <- dygraphs::dyHighlight(
      plot.2,
      highlightCircleSize = 3,
      highlightSeriesBackgroundAlpha = 0.2,
      hideOnMouseOut = FALSE
    )
    plot.2 <- dygraphs::dyRangeSelector(plot.2, height = 25)
    
    plot <- htmltools::browsable(htmltools::tagList(plot.1, plot.2))
    
  } else if (tp == 4) {
    
    if (nvar < 3) {
      stop("Three variables are required for this type of graph")
    }
    
    if (nvar > 3) {
      warning("Only the first three variables in the list will be compared, assumed as 1. Precipitation 2. Evapotranspiration 3. Runoff")
    }
    
    plot.1 <- dygraphs::dygraph(
      var[[1]],
      group = "A",
      height = 160,
      width = "100%",
      main = main,
      ...
    )
    
    plot.1 <- dygraphs::dySeries(
      plot.1,
      name = "V1",
      label = names(var)[1],
      axis = "y",
      color = "#2c7fb8"
    )
    
    plot.1 <- dygraphs::dyLegend(plot.1, show = "follow", width = 210, hideOnMouseOut = FALSE)
    plot.1 <- dygraphs::dyBarChart(plot.1)
    plot.1 <- dygraphs::dyAxis(
      plot.1,
      name = "y",
      label = "P [mm/mth]",
      valueRange = c(max_plus(var[[1]]), 0)
    )
    
    plot.2 <- dygraphs::dygraph(
      var[[2]],
      group = "A",
      height = 140,
      width = "100%",
      ...
    )
    
    plot.2 <- dygraphs::dySeries(
      plot.2,
      name = "V1",
      label = names(var)[2],
      strokeWidth = 1.7,
      axis = "y",
      color = "#1a9850"
    )
    
    plot.2 <- dygraphs::dyLegend(plot.2, show = "follow", width = 210, hideOnMouseOut = FALSE)
    plot.2 <- dygraphs::dyBarChart(plot.2)
    plot.2 <- dygraphs::dyAxis(
      plot.2,
      name = "y",
      label = "ET [mm/mth]",
      valueRange = c(0, max_plus(var[[2]]))
    )
    
    plot.3 <- dygraphs::dygraph(
      var[[3]],
      ylab = "Runoff [mm/mth]",
      group = "A",
      height = 225,
      width = "100%",
      ...
    )
    
    plot.3 <- dygraphs::dySeries(
      plot.3,
      name = "V1",
      label = names(var)[3],
      strokeWidth = 1.7,
      color = "#ef8a62"
    )
    
    plot.3 <- dygraphs::dyLegend(plot.3, show = "follow", width = 210, hideOnMouseOut = FALSE)
    plot.3 <- dygraphs::dyRangeSelector(plot.3, height = 25)
    
    plot <- htmltools::browsable(htmltools::tagList(plot.1, plot.2, plot.3))
  }
  
  return(plot)
}
