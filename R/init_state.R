#' @name
#' init_state
#' @title
#' Initial conditions of the model
#' @description
#' This function uploads or creates the initial conditions of the two state variables present in the DWB model, in raster format.
#' It requires the raster composed of the Srmax values that was created using the \code{\link{bulidGRUmaps}} function
#' and a path from where the function can read two rasters previously created. If the path or those raster cannot
#' be found, the function creates those two raster using the value of the Srmax reduced by half.
#' 
#' @param srmax Maximum storage in the root zone in Raster format
#' @param path_init Directory to read the raster files \code{\emph{.tif}} of initial storage conditions
#'
#' @return 
#' A list cointaing initial conditions in storage and in ground
#' 
#' @references 
#' Budyko. (1974). Climate and life. New York: Academic Press, INC.
#' 
#' Zhang, L., Potter, N., Hickel, K., Zhang, Y., & Shao, Q. (2008). Water balance modeling over variable time scales based on the Budyko framework - Model development and testing. Journal of Hydrology, 360(1-4), 117-131. https://doi.org/10.1016/j.jhydrol.2008.07.021
#'  
#' @author 
#' Nicolas Duque Gardeazabal <nduqueg@unal.edu.co> \cr
#' Pedro Felipe Arboleda <pfarboledao@unal.edu.co> \cr
#' Carolina Vega Viviescas <cvegav@unal.edu.co> \cr
#' David Zamora <dazamoraa@unal.edu.co> \cr
#' 
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia
#' 
#' @export
#'
#' @examples
#' 
init_state <- function(srmax, path_init){
  if(length(list.files(path_init)) == 2){
    dummy_f <- paste(path_init, "in_storage.tif", sep = '')
    In_storage <- raster::raster(dummy_f)
    dummy_f <- paste(path_init, "in_groundwater.tif", sep = '')
    In_ground <- raster::raster( dummy_f)
  } else{
    if(length(list.files(path_init)) != 2){
      cat("Strange number of initial state files\n Review files of initial states \n Creation by default from Srmax")
    }
    In_storage <- srmax / 2
    In_ground <- srmax / 2
  }
  g_v <- raster::rasterToPoints(In_ground)[,-c(1,2)]
  s_v <- raster::rasterToPoints(In_storage)[,-c(1,2)]
  init <- list(In_storage = s_v, In_ground = g_v)
  return(init)
}
