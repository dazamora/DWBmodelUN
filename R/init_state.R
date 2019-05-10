#' Title
#'
#' @param srmax 
#' @param path_init 
#'
#' @return
#' @export
#'
#' @examples
#' 
init_state<-function(srmax, path_init){
  if(length(list.files(path_init)==2)){
    dummy_f<-paste(path_init,"in_storage.tif",sep='')
    In_storage<-raster(dummy_f)
    dummy_f<-paste(path_init,"in_groundwater.tif",sep='')
    In_ground<-raster(dummy_f)
  } else{
    if(length(list.files(path_init))!=2){
      cat("Numero extra?o de archivos de estados iniciales \nRevisar archivos de estados iniciales \nCreaci?n por defecto a partir de srmax")
    }
    In_storage <- srmax/2
    In_ground <- srmax/2
  }
  init<-list(In_storage = In_storage, In_ground = In_ground)
  return(init)
}