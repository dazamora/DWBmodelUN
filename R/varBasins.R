#' @name 
#' varBasins
#'  
#' @title
#' value of a variable in each subbasin
#'
#' @description This function retrieves the value of a variable in each of the cells that are within a basin boudary.
#' It also returns the time serie average value of the variable.
#' 
#' @param var one of the dataframe results returned from the DWBcalculator function
#' @param cellBasins first entry of the cellBasins function that consists of a list of vectors. Each one of the vectors
#' contains the cell numbers of each basin
#'
#' @return a list of two elements. The first one is the time series average value of the variable, and the second is a
#' list of dataframes each one of them contains the time series of each of the cells that are within a basin
#' 
#' @author Nicolas Duque Gardeazabal <nduqueg@unal.edu.co>
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co> 
#' Carolina Vega Viviescas <cvegav@unal.edu.co> 
#' David Zamora <dazamoraa@unal.edu.co>
#' 
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - sede Bogotá
#' 
#' @export
#'
#' @examples
#' data(dwb_results,GRU,basins)
#' Esc <- dwb_results$q_total
#' cellBasins <- cellBasins(GRU, basins)
#' cellBasins <- cellBasins$cellBasins
#' 
#' Esc.Sogamoso <- varBasins(Esc, cellBasins)
#' 
varBasins<-function(var, cellBasins){
  
  varProm <- data.frame(matrix(data=NA, ncol=length(cellBasins), nrow=ncol(var)))
  colnames(varProm) <- names(cellBasins)
  varCells <- lapply(cellBasins,FUN = function(i,var){ var[i,]}, var)
  names(varCells) <- names(cellBasins)
  
  for (i in 1:length(cellBasins)){
    if(length(cellBasins[[i]])>1){
      varAverage[,i] <- colMeans(varCells[[i]], na.rm = T)
    }else{
      varAverage[,i] <- varCells[[i]]
    }
  }
  return(list(varAverage = varAverage, varCells = varCells))
}