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
#' @param gruLoc raster (\code{SpatRaster} from \pkg{terra}, or an object convertible to it, such as a
#' \code{RasterLayer}) that was used to build the GRUs. In this function it is used to number each cell
#' from West to East and from North to South.
#' @param basins polygons (\code{SpatVector} from \pkg{terra}, or an object convertible to it, such as a
#' \code{SpatialPolygonsDataFrame}) comprising each one of the basins where the modeller wants to know the runoff.
#' It must be in the same projection as the gruLoc raster.
#'
#' @return
#' a list that comprise two dataframes. The first one, the list of cells in each of the basins contained in the shapefile (\code{cellBasins}), 
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
#' Universidad Nacional de Colombia - sede Bogota
#'
#' @examples
#' data("GRU","basins")
#' cellBasins <- cellBasins(GRU, basins)
#' 
cellBasins <- function(gruLoc, basins){
  
  if(missing(gruLoc) || missing(basins)){
    stop("Either gruLoc or basins are missing")
  }
  
  if (!requireNamespace("terra", quietly = TRUE)) {
    stop("The 'terra' package is required. Install it with install.packages('terra').")
  }
  
  if (!inherits(gruLoc, "SpatRaster")) {
    gruLoc <- terra::rast(gruLoc)
  }
  
  if (!inherits(basins, "SpatVector")) {
    basins <- terra::vect(basins)
  }
  
  if (!terra::same.crs(gruLoc, basins)) {
    warning("gruLoc and basins have different coordinate reference systems. The basins are reprojected to the raster CRS during the extraction, but verify projections before using the results.")
  }
  
  # Build a table with coordinates and a sequential cell identifier.
  valid_cells <- which(!is.na(terra::values(gruLoc[[1]], mat = FALSE)))
  
  cell_table <- data.frame(
    terra::xyFromCell(gruLoc, valid_cells),
    cell = seq_along(valid_cells)
  )
  
  # Build a raster whose values identify each valid cell.
  cells <- terra::rast(gruLoc[[1]])
  cell_values <- rep(NA_real_, terra::ncell(cells))
  cell_values[valid_cells] <- cell_table$cell
  cells <- terra::setValues(cells, cell_values)
  names(cells) <- "cell"
  
  # Extract the cell identifiers inside each basin.
  extracted <- terra::extract(cells, basins, na.rm = TRUE)
  
  cell_basins <- lapply(seq_len(nrow(basins)), function(i) {
    basin_cells <- extracted$cell[extracted$ID == i]
    basin_cells[!is.na(basin_cells)]
  })
  
  basin_data <- as.data.frame(basins)
  
  if(ncol(basin_data) >= 2 && is.character(basin_data[[2]])) {
    names(cell_basins) <- basin_data[[2]]
  }
  
  return(list(cellBasins = cell_basins, cellTable = cell_table))
}