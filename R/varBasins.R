#' @name 
#' varBasins
#'  
#' @title
#' value of a variable in each subbasin
#'
#' @description This function retrieves the value of a variable in each of the cells that are within a basin boundary.
#' It also returns the average time series value of the variable.
#' 
#' @param var one of the dataframe results returned from the DWBcalculator function
#' @param cellBasins first entry of the cellBasins function that consists of a list of vectors. Each one of the vectors
#' contains the cell numbers of each basin
#'
#' @return a list of two elements. The first one is the time series average value of the variable, and the second is a
#' list of dataframes each one of them contains the time series of each of the cells that are within a basin
#' 
#' @author Nicolas Duque Gardeazabal <nduqueg@unal.edu.co>  \cr
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co>  \cr
#' Carolina Vega Viviescas <cvegav@unal.edu.co>  \cr
#' David Zamora <dazamoraa@unal.edu.co> \cr
#' 
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - sede Bogota
#' 
#' @export
#'
#' @examples
#' data(sogamoso,GRU,basins)
#' dwb_results <- sogamoso$dwb_results
#' Run <- dwb_results$q_total
#' cellBasins <- cellBasins(GRU, basins)
#' cellBasins <- cellBasins$cellBasins
#' 
#' Runoff.Sogamoso <- varBasins(Run, cellBasins)
#' 
varBasins<-function(var, cellBasins){
  
  varAverage <- data.frame(matrix(data=NA, ncol=length(cellBasins), nrow=ncol(var)))
  colnames(varAverage) <- names(cellBasins)
  varCells <- lapply(cellBasins,FUN = function(i,var){ var[i,]}, var)
  names(varCells) <- names(cellBasins)
  
  for (i in 1:length(cellBasins)){
    if(length(cellBasins[[i]])>1){
      varAverage[,i] <- colMeans(varCells[[i]], na.rm = TRUE)
    }else{
      varAverage[,i] <- varCells[[i]]
    }
  }
  return(list(varAverage = varAverage, varCells = varCells))
}