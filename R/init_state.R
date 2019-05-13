#' @name
#' init_state
#' @title
#' Initial conditions of the model
#' @description
#' 
#' 
#' @param srmax 
#' @param path_init 
#'
#' @return 
#' A list cointaing initial conditions in storage and in ground
#' 
#' @author 
#' Nicolas Duque Gardeazabal <nduqueg@unal.edu.co>
#' Pedro Felipe Arboleda <pfarboledao@unal.edu.co>
#' David Zamora <dazamoraa@unal.edu.co>
#' Carolina Vega Viviescas <cvegav@unal.edu.co>
#' Grupo de Investigación en Ingeniería de los Recursos Hídricos - GIREH
#' Universidad Nacional de Colombia
#' 
#' @export
#'
#' @examples
#' 
init_state <- function(srmax, path_init){
  if(length(list.files(path_init) == 2)){
    dummy_f <- paste(path_init, "in_storage.tif", sep='')
    In_storage <- raster(dummy_f)
    dummy_f <- paste(path_init, "in_groundwater.tif", sep='')
    In_ground <- raster( dummy_f)
  } else{
    if(length(list.files(path_init)) != 2){
      cat("Strange number of initial state files \n
          Review files of initial states \n
          Creation by default from srmax")
    }
    In_storage <- srmax / 2
    In_ground <- srmax / 2
  }
  init <- list(In_storage = In_storage, In_ground = In_ground)
  return(init)
}