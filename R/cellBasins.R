#' @name
#' cellBasins
#' 
#' @title
#' Identification of the Cells within a basin
#' 
#' @description This function identifies the cells that are within a basin. The runoff produced by those cells
#' will be used, either to calculate the water availability or to compare the simulated variable with the observed runoff
#' in certain streamflow gauges.
#'
#' @param gruLoc raster file that was used to build GRUs. In this function will be used to number each cell
#' from West to East and from North to South.
#' @param basins a shapefile that is comprised each one of the basins where the modeller wants to know the runoff.
#' It must be in the same projection of the gruLoc raster.
#'
#' @return
#' a list that comprise two dataframes. The first one, the list of cells in each of the basins contained in the shapefile (\code{cellBasins}), 
#' and second a table that associates the coordinates of each cell with the assigned number (\code{cellTable}).
#' 
#' @export
#' 
#' @author 
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co> \cr
#' Camila Garcia Echeverri <cagarciae@unal.edu.co> \cr
#' Nicolas Duque Gardeazabal <nduqueg@unal.edu.co> \cr
#' Carolina Vega Viviescas <cvegav@unal.edu.co> \cr
#' David Zamora <dazamoraa@unal.edu.co> \cr
#'  
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - sede Bogota
#'
#' @examples
#' data("GRU","basins")
#' GRU <- terra::rast(GRU)
#' basins <- terra::vect(basins)
#' cellBasins <- cellBasins(GRU, basins)
#' 
cellBasins <- function(gruLoc, basins){
  
  if(!exists("gruLoc") | !exists("basins")){
    warning("Either gruLoc or basins are missing")
  }else{
    # build the raster that consist of the number of each cell
    cell_table <- terra::crds(gruLoc, df=FALSE, na.rm=TRUE, na.all=FALSE)
    cell_table <- cbind(cell_table, seq(from = 1,to = nrow(cell_table), by = 1))
    cells <- terra::rast(cell_table,  type="xyz")
    crs(cells) <-  as.character(terra::crs(gruLoc))
    
    # extract the cells that are within each basin
    cell_basins <- lapply(1:length(basins), function(x){
      terra::extract(cells, basins[x,], na.rm = T)[,2]})
    if(is.character(as.data.frame(basins)[[2]])){
      names(cell_basins) <- basins[[2]][,1]
      } 
      
    return(list(cellBasins = cell_basins, cellTable = cell_table))
      
  }
}
