#' @name 
#' printVar
#'  
#' @title
#' Print or write variables of interest
#' 
#' @description This function allows to print or write some of the variables simulated by the DWB model.
#' 
#' @param variable corresponds to the results of a specific variable of the DWBCalculator.
#' @param coor_cells coordinates of the cells in the same order that were simulated and that will be used to
#' create the results in raster format, this is done from the data frames which contain the simulated results
#' @param var_name name of the variable that will be printed (e.g., q_total, aet, r, qd, qb, s, g)
#' @param coord_sys geographic or projected coordinate system.
#' @param dates dates that were simulated.
#' @param as option to print the results as independent 'raster' (\emph{\code{.tif}}) or in a 'NetCDF' file (\emph{\code{.nc}}).
#' @param path_var path of the directory where one wants to print the files
#' @param var_longname extended name of the variable that will be printed as NetCDF
#' @param unit unit name of the variable that will be printed as NetCDF
#'  
#' @author 
#' Carolina Vega Viviescas <cvegav@unal.edu.co>  \cr
#' Nicolas Duque Gardeazabal <nduqueg@unal.edu.co>  \cr
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co>  \cr
#' David Zamora <dazamoraa@unal.edu.co> \cr
#' 
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - sede Bogota
#'
#' @return It saves in a folder previously created a set of raster files with the results of the 
#' variable of interest.
#'
#' @export 
#' 
#' @examples
#' data(sogamoso)
#' dwb_results <- sogamoso$dwb_results
#' data(cells)
#' dates <- seq(as.Date("2001-01-01"), as.Date("2010-12-01"), by="month")[1:20]
#' coord_sys <- "+init=epsg:4326"
#' r <- dwb_results[[3]][,1:20]
#' printVar(r, cells, var_name = "r", coord_sys, dates, as = "NetCDF", path_var = tempdir(),
#'  var_longname="r output", unit="mm", zname="Month")
#' 
printVar <- function(variable, coor_cells, var_name, coord_sys, dates, as, path_var= "",
                     var_longname="", unit="", zname=""){
  if(path_var ==""){
    stop("There is no path_var, files can not be stored")
  }

  # var_r <- raster::rasterFromXYZ(cbind(coor_cells[ ,-3], variable), crs = coord_sys)
  var_r <- lapply(1:dim(variable)[2], function(x)
    terra::rast(cbind(coor_cells[,-3], variable[,x]), type="xyz"))
  names(var_r) <- dates
  var_r <- terra::rast(var_r)
  crs(var_r) <- crs(coord_sys)
  
  if (as == 'raster'){
    # prints each time step in GTiff format, in the specified directory
    for (i in 1:(terra::nlyr(var_r))){
      terra::writeRaster(var_r[[i]], filename = paste(path_var,"/", var_name, "_", as.character(dates[i]), ".tif", sep = ""), overwrite = TRUE)
    }
  }
  if (as == 'NetCDF'){
    terra::time(var_r) <- dates
    terra::writeCDF(var_r, filename = paste(path_var, "/",var_name, ".nc", sep = ""), 
                    longname=var_longname, unit=unit, zname = zname,
                    overwrite = TRUE)
  }else{ 
    stop("Invalid file extension")
  }
}