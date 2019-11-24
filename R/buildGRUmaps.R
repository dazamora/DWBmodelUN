#' @name 
#' buildGRUmaps
#'  
#' @title
#' Build Grouped Response Units in maps
#' 
#' @description This function builds raster maps for each parameter based on a raster file where the location of the
#' Grouped Response Units (\code{GRUs}) are defined. This raster must have the same resolution as the forcing files
#' (i.e., for each cell that is planned to be simulated, there must be forcing time series and a cell assigned to a \code{GRU}).
#' 
#' @param gruLoc raster file that is comprised by numbers from 1 to the total number of \code{GRUs} that were defined.
#' @param parsValues data frame that has the values of the four parameters of each \code{GRU}. It must have equal number of
#' rows as number of GRU that were defined, and must have four columns which define the \code{alpha1}, \code{alpha2}, \code{d}
#' and \code{Smax} parameters.
#' 
#' @return a list which consists of four vectors and four raster, each one of them has the values of a parameter spatialized according with
#' the GRU raster layer.
#' 
#' @author 
#' Nicolas Duque Gardeazabal <nduqueg@unal.edu.co> \cr
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co> \cr
#' Carolina Vega Viviescas <cvegav@unal.edu.co> \cr
#' David Zamora <dazamoraa@unal.edu.co> \cr
#' 
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - sede Bogota
#'
#' @export
#' 
#' @examples
#' # library(raster)
#' data(GRU)    
#' data(param)
#' gru_maps <- buildGRUmaps(GRU, param)
#' 
#' # Not run, this an example on how to upload your own files
#' # GRU <- raster("./directory/gru2_cober_location.tif")
#' # param <- read.csv("./directory/param_dwb.csv")
#' # gru_maps <- buildGRUmaps(GRU, param)
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
  
  alpha1_v <- raster::rasterToPoints(alpha1)[,-c(1,2)]
  alpha2_v <- raster::rasterToPoints(alpha2)[,-c(1,2)]
  smax_v <- raster::rasterToPoints(smax)[,-c(1,2)]
  d_v <- raster::rasterToPoints(d)[,-c(1,2)]
  gruMaps <- list(alpha1 = alpha1_v, alpha2 = alpha2_v, smax = smax_v, d = d_v,
                  alpha1R = alpha1, alpha2R = alpha2, smaxR = smax, dR = d)
  return(gruMaps)
}
