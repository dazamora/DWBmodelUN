#' @name
#' init_state
#' 
#' @title
#' Initial conditions of the model
#' 
#' @description
#' This function uploads or creates the initial conditions of the two-state variables present in the DWB model, in raster format.
#' 
#' @details
#' It requires the raster composed of the Smax values that were created using the \code{\link{buildGRUmaps}} function,
#' or a two-layer raster previously created with the initial conditions of the soil water and groundwater storage.
#' If only one layer is provided, the function creates the two initial conditions using the values of the provided
#' raster reduced by half.
#'
#' @param raster a single layer raster (\code{SpatRaster} from \pkg{terra}, or an object convertible to it, such as a
#' \code{RasterLayer}) containing the maximum storage in the root zone, or a two-layer raster with the initial
#' conditions of the soil water storage (first layer) and the groundwater storage (second layer)
#'
#' @return 
#' A list containing initial conditions in storage and in ground.
#' 
#' @references 
#' Budyko. (1974). "Climate and life". New York: Academic Press, INC.
#' 
#' Zhang, L., Potter, N., Hickel, K., Zhang, Y., & Shao, Q. (2008). 
#' "Water balance modeling over variable time scales based on the Budyko framework - Model 
#' development and testing. Journal of Hydrology", 360(1-4), 
#' 117-131. 
#'  
#' @author 
#' Nicolas Duque Gardeazabal <nduqueg@unal.edu.co> \cr
#' Pedro Felipe Arboleda <pfarboledao@unal.edu.co> \cr
#' Carolina Vega Viviescas <cvegav@unal.edu.co> \cr
#' David Zamora <dazamoraa@unal.edu.co> \cr
#' 
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - Sede Bogota
#' 
#' @export
#'
#' @examples
#' # Example 1: build the initial states from the Smax map
#' data(GRU, param)
#' gru_maps <- buildGRUmaps(GRU, param)
#' init <- init_state(gru_maps$smaxR)
#'
#' # Example 2: use two rasters with previously known initial conditions
#' data(In_storage, In_ground)
#' init <- init_state(c(terra::rast(In_storage), terra::rast(In_ground)))
#'
init_state <- function(raster){
  
  if (missing(raster)) {
    stop("The raster parameter is missing")
  }
  
  if (!requireNamespace("terra", quietly = TRUE)) {
    stop("The 'terra' package is required. Install it with install.packages('terra').")
  }
  
  if (!inherits(raster, "SpatRaster")) {
    raster <- terra::rast(raster)
  }
  
  raster_values <- function(x) {
    pts <- as.data.frame(x, xy = TRUE, na.rm = TRUE)
    pts[[ncol(pts)]]
  }
  
  if (terra::nlyr(raster) == 2) {
    In_storage <- raster[[1]]
    In_ground <- raster[[2]]
  } else {
    if (terra::nlyr(raster) > 2) {
      warning("Strange number of initial state layers\n Review files of initial states \n Creation by default from first layer")
    }

    In_storage <- raster[[1]] / 2
    In_ground <- raster[[1]] / 2
  }
  
  g_v <- raster_values(In_ground)
  s_v <- raster_values(In_storage)
  
  init <- list(In_storage = s_v, In_ground = g_v)
  return(init)
}