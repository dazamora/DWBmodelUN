#' @name
#' cellBasins
#' 
#' @title
#' Identification of the Cells within a basin
#' 
#' @description This function identifies the cells that are within a basin. The runoff produced by those cells
#' will be used, either to calculate the water availability or to compare the simulated with the observed runoff
#' in certain streamflow gauges.
#'
#' @param gruLoc raster file that was used to build GRUs. In this function will be used to number each cell
#' from West to East and from North to South.
#' @param basins a shapefile that is comprised each one of the basins where the modeler wants to know the runoff.
#' It must be in the same projection of the gruLoc raster.
#'
#' @return
#' a list comprised two dataframes. The first one, the list of cells in each of the basins contained in the shapefile (\code{cellBasins}), 
#' and second a table that associates the coordinates of each cell with the assigned number (\code{cellTable}).
#' 
#' @export
#' 
#' @author 
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co> \cr
#' Nicolas Duque Gardeazabal <nduqueg@unal.edu.co> \cr
#' Carolina Vega Viviescas <cvegav@unal.edu.co> \cr
#' David Zamora <dazamoraa@unal.edu.co> \cr
#'  
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - sede Bogotá
#'
#' @examples
#' data("GRU","basins")
#' cellBasins <- cellBasins(GRU, basins)
#' 
cellBasins <- function(gruLoc, basins){
  
  if(!exists("gruLoc") | !exists("basins")){
    warning("Either gruLoc or basins are missing")
  }else{
    # build the raster that consist of the number of each cell
    cell_table <- raster::rasterToPoints(gruLoc)[ ,c(1,2)]
    cell_table <- cbind(cell_table, seq(from = 1,to = nrow(cell_table), by = 1))
    cells <- raster::rasterFromXYZ(cell_table, crs = raster::crs(gruLoc))
    
    # extract the cells that are within each basin
    cell_basins <- raster::extract(cells, basins, na.rm = T)
    if(is.character(basins@data[[2]])) names(cell_basins) <- basins[[2]]
      
    return(list(cellBasins = cell_basins, cellTable = cell_table))
      
  }
}