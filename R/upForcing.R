#' @name 
#' upForcing
#'
#' @title
#' Upload Forcings
#'
#' @description This function loads the precipitation and potential evapotranspiration estimates that will be used
#' to run or force the DWB model (\code{\link{DWBCalculator}}). If files are in raster format, they are read with
#' the \pkg{terra} package and returned as tables where the first two columns are the cell coordinates.
#'
#' @param path_p is a character string that specifies the directory where the precipitation rasters or
#' the csv file are stored. The csv file must have nrows = number of cells and ncol = number of time steps.
#' @param path_pet is a character string that specifies the directory where the potential evapotranspiration rasters or
#' the csv file are stored. The csv file must have nrows = number of cells and ncol = number of time steps.
#' @param file_type Character string that specifies the forcing file formats, it should be "raster" or "csv",
#' the default value is "raster".
#' @param format Character string that specifies the file format of the rasters, possible values are "GTiff"
#' and "NetCDF". Default value is "GTiff".
#'
#' @details The arguments that control the location of the forcing files can point either to a directory that
#' contains the raster or csv files, or to a single file. When reading GTiff files from a directory, all files
#' with extension \emph{.tif} or \emph{.tiff} are read in alphabetical order, so file names should be consistent
#' with the chronological order of the time series. If one's intention is to upload the forcings from NetCDF
#' files, the path should preferably be the complete path including the name and extension of the file.
#'
#' @return a list containing two data frames (\code{Prec} and \code{PET}). When read from rasters, the first
#' two columns of each data frame are the x and y coordinates of the cells, and the remaining columns are
#' the time steps.
#' 
#' @author
#' Nicolas Duque Gardeazabal <nduqueg@unal.edu.co> \cr
#' Pedro Felipe Arboleda <pfarboledao@unal.edu.co> \cr
#' Carolina Vega Viviescas <cvegav@unal.edu.co> \cr
#' David Zamora <dazamoraa@unal.edu.co> \cr
#' 
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - sede Bogota
#' 
#' @export
#'
#' @examples
#' # Write the example data as GTiff files in a temporal directory and read them back
#' data(P_sogamoso, PET_sogamoso)
#' dir_p <- file.path(tempdir(), "precip")
#' dir_pet <- file.path(tempdir(), "pet")
#' dir.create(dir_p, showWarnings = FALSE)
#' dir.create(dir_pet, showWarnings = FALSE)
#' p_rast <- terra::rast(P_sogamoso[, 1:3], type = "xyz")
#' pet_rast <- terra::rast(PET_sogamoso[, 1:3], type = "xyz")
#' terra::writeRaster(p_rast, file.path(dir_p, "P_2001_01.tif"), overwrite = TRUE)
#' terra::writeRaster(pet_rast, file.path(dir_pet, "PET_2001_01.tif"), overwrite = TRUE)
#' meteo <- upForcing(path_p = dir_p, path_pet = dir_pet,
#'                    file_type = "raster", format = "GTiff")
#' str(meteo)
#'
upForcing <- function(path_p = tempdir(), path_pet = tempdir(), file_type = "raster", format = "GTiff"){
  
  if (missing(path_pet) || is.null(path_pet) || !nzchar(path_pet)) {
    stop("Not filepath to read evapotranspiration data")
  }
  
  if (missing(path_p) || is.null(path_p) || !nzchar(path_p)) {
    stop("Not filepath to read precipitation data")
  }
  
  if (!file_type %in% c("raster", "csv")) {
    stop("file_type must be 'raster' or 'csv'")
  }
  
  if (file_type == "raster") {
    
    if (!requireNamespace("terra", quietly = TRUE)) {
      stop("The 'terra' package is required. Install it with install.packages('terra').")
    }
    
    format <- toupper(format)

    if (!format %in% c("GTIFF", "NCDF", "NETCDF")) {
      stop("format must be 'GTiff' or 'NetCDF'")
    }

    raster_to_table <- function(x) {
      as.data.frame(x, xy = TRUE, na.rm = TRUE)
    }
    
    get_files <- function(path, pattern) {
      if (file.exists(path) && !dir.exists(path)) {
        return(path)
      }
      
      files <- list.files(path, pattern = pattern, full.names = TRUE)
      
      if (length(files) == 0) {
        return(character(0))
      }
      
      sort(files)
    }
    
    if (format == "GTIFF") {
      
      pet_files <- get_files(path_pet, "\\.tif$|\\.tiff$")
      p_files <- get_files(path_p, "\\.tif$|\\.tiff$")
      
      if (length(pet_files) == 0 || length(p_files) == 0) {
        stop("Not available data of precipitation or evapotranspiration")
      }
      
      pet <- terra::rast(pet_files)
      p <- terra::rast(p_files)
      
    } else {

      pet_files <- get_files(path_pet, "\\.nc$")
      p_files <- get_files(path_p, "\\.nc$")

      if (length(pet_files) == 0 || length(p_files) == 0) {
        stop("Not available data of precipitation or evapotranspiration")
      }

      pet <- terra::rast(pet_files)
      p <- terra::rast(p_files)

    }
    
    p_v <- raster_to_table(p)
    pet_v <- raster_to_table(pet)
    
  } else {
    
    get_csv <- function(path) {
      if (file.exists(path) && !dir.exists(path)) {
        return(path)
      }
      
      files <- list.files(path, pattern = "\\.csv$", full.names = TRUE)
      
      if (length(files) == 0) {
        stop("Not available csv data")
      }
      
      sort(files)[1]
    }
    
    p_v <- read.csv(get_csv(path_p))
    pet_v <- read.csv(get_csv(path_pet))
  }
  
  meteo <- list(PET = pet_v, Prec = p_v)
  return(meteo)
}