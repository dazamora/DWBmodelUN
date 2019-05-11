# funcion que permite imprimir alguna de las variables simuladas por el modelo
#' Title
#'
#' @param variable 
#' @param coor_celdas 
#' @param sis_cord 
#' @param fechas 
#'
#' @return
#' @export
#'
#' @examples
printVar<-function(variable,coor_celdas,sis_cord,fechas){
  var_name<-as.character(substitute(variable))
  
  if (file.exists(var_name)){
    path_var<-paste("./",var_name,"/",sep="")
  }else{
    print("No existe la carpeta, por favor creela")
    stop()
  }
  
  var_r<-rasterFromXYZ(cbind(coor_celdas[,-3],variable),crs=sis_cord)
  for (i in 1:nlayers(var_r)){
    writeRaster(var_r[[i]],filename=paste(path_var,var_name,"_",as.character(fechas[i]),".tif",sep=""),format="GTiff",overwrite=T)
  }
}