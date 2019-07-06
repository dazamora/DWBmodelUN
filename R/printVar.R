#' @name 
#' printVar
#'  
#' @title
#' Print variables of interest
#' 
#' @description This function that allows to print some of the variables simulated by the DWB model
#' 
#' @param variable Corresponds to the results of a specific variable of the DWBCalculator
#' @param coor_cells Coordinates of the cells to be extracted the results
#' @param coord_sys Geographic coordinate system
#' @param dates Dates to be extracted
#' @param as Option to print the results as independent 'raster' (\emph{\code{.tif}}) or in a 'NetCDF' file (\emph{\code{.nc}})
#'
#' @author Nicolas Duque Gardeazabal <nduqueg@unal.edu.co>
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co> 
#' Carolina Vega Viviescas <cvegav@unal.edu.co> 
#' David Zamora <dazamoraa@unal.edu.co>
#' Water Resources Engineering Research Group - GIREH
#'
#' @return It saves in a folder previously created a set of raster files with the results of the 
#' variable of interest
#'
#' @export 
#' 
#' @examples
#' library(raster)
#' data(dwb_results)    
#' printVar(dwb_results[[3]], coor_cells, "+init=epsg:4326",dates)
#' 
printVar <- function(variable, coor_cells, coord_sys, dates, as){
  var_name <- as.character(substitute(variable))
  
  if (file.exists(var_name)){
    path_var <- paste("./", var_name, "/", sep="")
  }else{
    stop("There is no folder to save the files. Please create it with the name of the variable")
  }
  
  if (as == 'raster'){
    var_r <- raster::rasterFromXYZ(cbind(coor_cells[,-3], variable), crs = coor_cells)
    for (i in 1:nlayers(var_r)){
      # no se si serria buena idea que si crea un raster y lo guarda, tambien crear una carpeta para este archivo?
      raster::writeRaster(var_r[[i]], filename = paste(path_var, var_name, "_", as.character(dates[i]), ".tif", sep = ""), format="GTiff", overwrite=TRUE)
    }
  }
  if (as == 'NetCDF'){
    raster::writeRaster(var_r[[1:nlayers(var_r)]], filename = paste(path_var, var_name, ".nc", sep = ""), format = 'CDF', overwrite = TRUE)
  } else{ 
    stop("Invalid file extension")
  }
}