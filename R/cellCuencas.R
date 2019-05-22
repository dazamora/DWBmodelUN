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
#' 
cellBasins <- function(raster, basins){
  # crear el raster con el numero de celdas
  cell_table <- rasterToPoints(raster)[ ,c(1,2)]
  cell_table <- cbind(cell_table, seq(from = 1,to = nrow(cell_table), by = 1))
  cells <- rasterFromXYZ(cell_table, crs = crs(raster))
  
  # extraer las celdas que se encuentran en cada una de las cuecas
  cell_basins<-extract(cells, basins, na.rm = T)
  names(cell_basins) <- basins$cod
  
  return(list(cellBasins = cell_basins, cellTable = cell_table))
}