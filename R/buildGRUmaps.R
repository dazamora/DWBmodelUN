#' @name 
#' buildGRUmaps
#'  
#' @title
#' Build Grouped Response Units in maps
#' 
#' @description This function builds raster maps for each parameter based on a raster file where the location of the
#' Grouped Response Units (\code{GRUs}) are defined. This raster must have the same resolution as the forcing files
#' (i.e., for each cell that is planned to be simulated, there must be forcing time series and a cell assigned to a \code{GRU}).
#' 
#' @param gruLoc raster (\code{SpatRaster} from \pkg{terra}, or an object convertible to it, such as a
#' \code{RasterLayer}) that is comprised by numbers from 1 to the total number of \code{GRUs} that were defined.
#' @param parsValues data frame or matrix that has the values of the four parameters of each \code{GRU}. It must have equal number of
#' rows as number of GRU that were defined, and must have four columns which define the \code{alpha1}, \code{alpha2}, \code{d}
#' and \code{Smax} parameters, in that order.
#'
#' @return a list which consists of four vectors (\code{alpha1}, \code{alpha2}, \code{d}, \code{smax}) and four
#' \code{SpatRaster} objects (\code{alpha1R}, \code{alpha2R}, \code{dR}, \code{smaxR}), each one of them with the values
#' of a parameter spatialized according to the GRU raster layer.
#' 
#' @author 
#' Nicolas Duque Gardeazabal <nduqueg@unal.edu.co> \cr
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co> \cr
#' Carolina Vega Viviescas <cvegav@unal.edu.co> \cr
#' David Zamora <dazamoraa@unal.edu.co> \cr
#' 
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - sede Bogota
#'
#' @export
#' 
#' @examples
#' data(GRU)    
#' data(param)
#' gru_maps <- buildGRUmaps(GRU, param)
#' 
#' 
buildGRUmaps <- function(gruLoc, parsValues){
  
  if (missing(gruLoc) || missing(parsValues)) {
    stop("Either gruLoc or parsValues are missing")
  }
  
  if (!requireNamespace("terra", quietly = TRUE)) {
    stop("The 'terra' package is required. Install it with install.packages('terra').")
  }
  
  if (!inherits(gruLoc, "SpatRaster")) {
    gruLoc <- terra::rast(gruLoc)
  }
  
  if (terra::nlyr(gruLoc) > 1) {
    warning("gruLoc has more than one layer. Only the first layer will be used.")
    gruLoc <- gruLoc[[1]]
  }
  
  if (ncol(parsValues) < 4) {
    stop("parsValues must have at least four columns: alpha1, alpha2, d, and smax")
  }
  
  gru_values <- terra::values(gruLoc, mat = FALSE)
  gruNumber <- max(gru_values, na.rm = TRUE)
  
  if (nrow(parsValues) != gruNumber) {
    stop("There is a mismatch between the GRU defined in \n the raster file and the table which contains the values")
  }
  
  valid_cells <- !is.na(gru_values)
  gru_index <- as.integer(gru_values)
  
  alpha1_values <- alpha2_values <- d_values <- smax_values <- rep(NA_real_, length(gru_values))
  
  alpha1_values[valid_cells] <- parsValues[gru_index[valid_cells], 1]
  alpha2_values[valid_cells] <- parsValues[gru_index[valid_cells], 2]
  d_values[valid_cells] <- parsValues[gru_index[valid_cells], 3]
  smax_values[valid_cells] <- parsValues[gru_index[valid_cells], 4]
  
  alpha1 <- terra::setValues(terra::rast(gruLoc), alpha1_values)
  alpha2 <- terra::setValues(terra::rast(gruLoc), alpha2_values)
  d <- terra::setValues(terra::rast(gruLoc), d_values)
  smax <- terra::setValues(terra::rast(gruLoc), smax_values)
  
  names(alpha1) <- "alpha1"
  names(alpha2) <- "alpha2"
  names(d) <- "d"
  names(smax) <- "smax"
  
  raster_values <- function(x) {
    pts <- as.data.frame(x, xy = TRUE, na.rm = TRUE)
    pts[[ncol(pts)]]
  }
  
  alpha1_v <- raster_values(alpha1)
  alpha2_v <- raster_values(alpha2)
  smax_v <- raster_values(smax)
  d_v <- raster_values(d)
  
  gruMaps <- list(
    alpha1 = alpha1_v,
    alpha2 = alpha2_v,
    d = d_v,
    smax = smax_v,
    alpha1R = alpha1,
    alpha2R = alpha2,
    dR = d,
    smaxR = smax
  )
  
  return(gruMaps)
}