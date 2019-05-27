#' @name 
#' Build GRU maps
#'  
#' @title
#' Build Grouped Response Units in maps
#' 
#' @description This function builds raster maps for each parameter based on a raster file where the location of the
#' Grouped Response Units (\code{GRUs}) are defined. This raster must have the same resolution as the forcing files
#' (i.e., for each cell that is planned to be simulated, there must be forcing time series and a cell assigned to a \code{GRU}).
#' 
#' @param gruLoc raster file that is comprised by numbers from 1 to the number of total \code{GRUs} that were defined
#' @param parsValues data frame that has the values of the four parameters of each \code{GRU}. It must have equal number of
#' rows as number of GRU that were defined, and must have four columns which define the \code{alpha1}, \code{alpha2}, \code{d}
#' and \code{Smax}
#' 
#' @return a list which is comprised by four raster, each one of them has the values of a parameter spatialized according with
#' the GRU raster layer
#' 
#' @author Nicolas Duque Gardeazabal <nduqueg@unal.edu.co>
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co> 
#' Carolina Vega Viviescas <cvegav@unal.edu.co> 
#' David Zamora <dazamoraa@unal.edu.co>
#' Water Resources Engineering Research Group - GIREH
#'
#' @export
#' 
#' @examples
#' # library(raster)
#' data(GRU)    # GRU <- raster("./directory/gru2_cober_location.tif")
#' data(param)  # param <- read.csv("./directory/param_dwb.csv")
#' gru_maps <- Build_gru_maps(GRU,param)
#' 
buildGRUmaps <- function(gruLoc, parsValues){
  
  gruNumber <- raster::cellStats(gruLoc, 'max')
  if(dim(parsValues)[1] != gruNumber){
    stop("There is a mismatch between the GRU defined in \n the raster file and the table which contains the values") 
  }
  
  alpha1 <- alpha2 <- smax <- d <- raster::raster(gruLoc)
  
  for (i in 1:dim(parsValues)[1]){
    alpha1[gruLoc == i] <- parsValues[i, 1]
    alpha2[gruLoc == i] <- parsValues[i, 2]
    d[gruLoc == i] <- parsValues[i, 3]
    smax[gruLoc == i] <- parsValues[i, 4]
  }
  gruMaps <- list(alpha1 = alpha1, alpha2 = alpha2, smax = smax, d = d)
  
  return(gruMaps)
}