# función para extraer las coordenadas de simulación
#' Title
#'
#' @param raster 
#' @param cuencas 
#'
#' @return
#' @export
#'
#' @examples
cellCuencas<-function(raster,cuencas){
  # crear el raster con el numero de celdas
  tabla_celdas<-rasterToPoints(raster)[,c(1,2)]
  tabla_celdas<-cbind(tabla_celdas,seq(from=1,to=nrow(tabla_celdas),by=1))
  celdas<-rasterFromXYZ(tabla_celdas,crs=crs(raster))
  
  # extraer las celdas que se encuentran en cada una de las cuecas
  cuencas_celdas<-extract(celdas,cuencas,na.rm=T)
  names(cuencas_celdas)<-cuencas$Codigo
  
  return(list(cuencas_celdas,tabla_celdas))
}