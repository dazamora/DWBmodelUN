#' @name 
#' Upforcing
#'
#' @title
#' Upload Forcings
#'
#' @description This function loads the precipitation and evapotranspiration estimates that will be used
#' to run or force the DWB model. It also creates a directory where stores csv files if the original forcing
#' files are in raster format.
#'
#' @param path_p is a character string that specifies the directory where the precipitation rasters or
#' the csv file are stored. The csv file must have nrows= N° of cells and ncol= N° of time steps.
#' @param path_pet is a character string that specifies the location of the potential evapotranspiration rasters or
#' the csv file are stored. The csv file must have nrows= N° of cells and ncol= N° of time steps.
#' @param file_type Character string that specifies the forcing file formats, it should be "raster" or "csv",
#' the default value is "raster".
#' @param format Character string that specifies the format file of the Rasters, posible values are "GTiff"
#' and "NCDF". Default value is "GTiff"
#' 
#' @details The character strings that control the location of the forcing files are as default "\emph{./precip/}"
#' and "\emph{./pet/}" for precipitation and potential evapotranspiration, but can be change to other directories.
#' However, if one intention is to upload them from NetCDF files, the \bold{strings must be completely changed} to
#' a complete path that includes the name and extension of the file.
#'
#' @return a list containing the two Zoos (P and PET)
#' 
#' @author David Zamora <dazamoraa@unal.edu.co>
#' Nicolas Duque Gardeazabal <nduqueg@unal.edu.co>
#' Water Resources Engineering Research Group - GIREH
#' 
#' @export
#' 
#' @examples
#' meteo <- UpForcing(path_p="./precip/", path_pet="./pet/", file_type="raster", format= "NCDF")
#' meteo <- UpForcing(path_p="./precip/", path_pet="./pet/", file_type="csv")
#' 
upForcing<-function(path_p="./precip/", path_pet="./pet/", file_type="raster", format= "GTiff"){
  
  if (file_type=="raster"){
    # ---- identify raster format and loading----
    if (format=="GTiff"){
      
      pet_files <- list.files(path_pet)
      pet <- raster::stack(paste(path_pet,pet_files,sep = ""))
      
      p_files <- list.files(path_p)
      p <- raster::stack(paste(path_p,p_files,sep = ""))
    }else if(format=="NCDF"){
      
      pet <- raster::stack(path_pet)
      p <- raster::stack(path_p)
    }
    
    # ---- transformation to dataframes ----
    p_v <- raster::rasterToPoints(p)[,-c(1,2)]
    pet_v <- raster::rasterToPoints(pet)[,-c(1,2)]
    
    # ---- print forcings ----
    dir.create("./forcings", showWarnings=F)
    write.csv(p_v, "./forcings/precip.csv")
    write.csv(pet_v, "./forcings/pet.csv")
    
  }else {  # load forcings in csv files
    pet_files <- list.files(path_pet)
    p_files <- list.files(path_p)
    
    p_v <- read.csv(paste(path_p, p_files,sep = ""))
    pet_v <- read.csv(paste(path_pet, pet_files,sep = ""))
  }
  
  meteo <- list(pet <- pet_v, p <- p_v)
  return(meteo)
}
