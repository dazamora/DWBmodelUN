#' @name 
#' printVar
#'  
#' @title
#' Print variables of interest
#' 
#' @description This function that allows to print some of the variables simulated by the DWB model
#' 
#' @param variable Corresponds to the results of a specific variable of the DWBCalculator
#' @param coor_cells Coordinates of the cells in the same order that were simulated and that will be used to
#' create the results in raster format from the dataframes which contain the simulated results
#' @param coord_sys Geographic coordinate system
#' @param dates Dates that were simulated
#' @param as Option to print the results as independent 'raster' (\emph{\code{.tif}}) or in a 'NetCDF' file (\emph{\code{.nc}})
#'
#' @author 
#' Carolina Vega Viviescas <cvegav@unal.edu.co>  \cr
#' Nicolas Duque Gardeazabal <nduqueg@unal.edu.co>  \cr
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co>  \cr
#' David Zamora <dazamoraa@unal.edu.co> \cr
#' Water Resources Engineering Research Group - GIREH
#'
#' @return It saves in a folder previously created a set of raster files with the results of the 
#' variable of interest
#'
#' @export 
#' 
#' @examples
#' data(dwb_results)
#' data(cells)
#' dates <- seq(as.Date("2001-01-01"), as.Date("2016-12-01"), by="month")
#' coor_cells <- "+init=epsg:4326"
#' printVar(dwb_results[[3]], cells, coor_cells, dates, "NetCDF")
#' 
printVar <- function(variable, coor_cells, coord_sys, dates, as){
  var_name <- as.character(substitute(variable))
  
  if (file.exists(var_name)){
    path_var <- paste("./", var_name, "/", sep="")
  }else{
    stop("There is no folder to save the files. Please create it with the name of the variable")
  }
  
  var_r <- raster::rasterFromXYZ(cbind(coor_cells[,-3], variable), crs = coor_cells)
  if (as == 'raster'){
    # prints each time step in GTiff format, in the specified directory
    for (i in 1:raster::nlayers(var_r)){
      raster::writeRaster(var_r[[i]], filename = paste(path_var, var_name, "_", as.character(dates[i]), ".tif", sep = ""), format="GTiff", overwrite=TRUE)
    }
  }
  if (as == 'NetCDF'){
    raster::writeRaster(var_r, filename = paste(path_var, var_name, ".nc", sep = ""), format = 'CDF', overwrite = TRUE)
  }else{ 
    stop("Invalid file extension")
  }
}