#' @name
#' init_state
#' @title
#' Initial conditions of the model
#' @description
#' 
#' 
#' @param srmax Maximum storage in the root zone
#' @param path_init Directory to read the raster files \code{\emph{.tif}} file of initial storage conditions
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
#' Nicolas Duque Gardeazabal <nduqueg@unal.edu.co>
#' Pedro Felipe Arboleda <pfarboledao@unal.edu.co>
#' Carolina Vega Viviescas <cvegav@unal.edu.co>
#' David Zamora <dazamoraa@unal.edu.co>
#' 
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia
#' 
#' @export
#'
#' @examples
#' 
init_state <- function(srmax, path_init){
  if(length(list.files(path_init) == 2)){
    dummy_f <- paste(path_init, "in_storage.tif", sep = '')
    In_storage <- raster(dummy_f)
    dummy_f <- paste(path_init, "in_groundwater.tif", sep = '')
    In_ground <- raster( dummy_f)
  } else{
    if(length(list.files(path_init)) != 2){
      cat("Strange number of initial state files\n Review files of initial states \n Creation by default from srmax")
    }
    In_storage <- srmax / 2
    In_ground <- srmax / 2
  }
  init <- list(In_storage = In_storage, In_ground = In_ground)
  return(init)
}