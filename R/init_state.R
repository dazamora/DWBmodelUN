#' @name
#' init_state
#' 
#' @title
#' Initial conditions of the model
#' 
#' @description
#' This function uploads or creates the initial conditions of the two-state variables present in the DWB model, in raster format.
#' 
#' @details
#' It requires the raster composed of the Srmax values that were created using the \code{\link{buildGRUmaps}} function
#' or two rasters previously created with the initial conditions of the soil water and groundwater storage. If there is only
#' be one raster found, the function creates those two rasters using the value of the provide raster reduced by half.
#' 
#' @param raster It could be a raster containing the maximum storage in the root zone or two raster with the initial conditions of storage
#'
#' @return 
#' A list containing initial conditions in storage and in ground.
#' 
#' @references 
#' Budyko. (1974). "Climate and life". New York: Academic Press, INC.
#' 
#' Zhang, L., Potter, N., Hickel, K., Zhang, Y., & Shao, Q. (2008). 
#' "Water balance modeling over variable time scales based on the Budyko framework - Model 
#' development and testing. Journal of Hydrology", 360(1-4), 
#' 117-131. 
#'  
#' @author 
#' Nicolas Duque Gardeazabal <nduqueg@unal.edu.co> \cr
#' Pedro Felipe Arboleda <pfarboledao@unal.edu.co> \cr
#' Carolina Vega Viviescas <cvegav@unal.edu.co> \cr
#' David Zamora <dazamoraa@unal.edu.co> \cr
#' 
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - Sede Bogota
#' 
#' @export
#'
#' @examples
#' library(raster)
#' 
#' # Example 1
#' data(gru_maps)
#' init <- init_state(gru_maps$smaxR)
#' 
#' # Example 2
#' data(In_storage, In_ground)
#' init <- init_state(stack(In_storage, In_ground))
#' 
init_state <- function(raster){
  if(raster::nlayers(raster) == 2){
    In_storage <- raster::raster(raster[[1]])
    In_ground <- raster::raster(raster[[2]])
  } else{
    if(raster::nlayers(raster) != 2){
      cat("Strange number of initial state files\n Review files of initial states \n Creation by default from first raster")
    }
    In_storage <- raster[[1]] / 2
    In_ground <- raster[[1]] / 2
  }
  g_v <- raster::rasterToPoints(In_ground)[ ,-c(1,2)]
  s_v <- raster::rasterToPoints(In_storage)[ ,-c(1,2)]
  init <- list(In_storage = s_v, In_ground = g_v)
  return(init)
}
