#' @name 
#' Coord_comparison
#' 
#' @title
#' Raster coordinates comparison
#' 
#' @description 
#' This function compares three characteristics from two rasters:
#' coordinates, resolution, and number of layers (if the rasters have more than one) 
#' from two different rasters stacks, and let to know if they are using the same geographical information,
#' or if a new set-up should be done.
#' 
#' @param r1 raster (\code{SpatRaster} from \pkg{terra}, or an object convertible to it, such as a \code{RasterLayer})
#' or data frame. If it is a data frame, it should contain in the first two columns, the X, Y
#' coordinates for every point, in GEOGRAPHIC COORDINATES, the third column and so on should have the variable values,
#' and optionally, the header should have the date, using the format \code{\%m/\%Y}.
#' @param r2 raster (\code{SpatRaster} from \pkg{terra}, or an object convertible to it, such as a \code{RasterLayer})
#' or data frame. If it is a data frame, it should contain in the first two columns, the X, Y
#' coordinates for every point, in GEOGRAPHIC COORDINATES, the third column and so on should have the variable values,
#' and optionally, the header should have the date, using the format \code{\%m/\%Y}.
#'
#' @return It prints on console whether the two rasters are on the same coordinates or not, and return
#' a boolean, TRUE if the rasters are on the same coordinates, and FALSE if not.
#' 
#' @export
#' 
#' @author 
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co>  \cr
#' Nicolas Duque Gardeazabal <nduqueg@unal.edu.co>  \cr
#' Carolina Vega Viviescas <cvegav@unal.edu.co> \cr
#' David Zamora <dazamoraa@unal.edu.co> \cr
#' 
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - sede Bogota
#' 
#' @examples
#' data(P_sogamoso, PET_sogamoso)
#' Coord_comparison(P_sogamoso, PET_sogamoso)
#' 
Coord_comparison <- function(r1, r2){
  
  if (missing(r1) || missing(r2)) {
    stop("Both r1 and r2 must be provided")
  }
  
  if (!requireNamespace("terra", quietly = TRUE)) {
    stop("The 'terra' package is required. Install it with install.packages('terra').")
  }
  
  r1_is_df <- is.data.frame(r1)
  r2_is_df <- is.data.frame(r2)
  
  r1_df <- NULL
  r2_df <- NULL
  
  if (r1_is_df) {
    message("First data file is a data frame")
    
    if (ncol(r1) < 3) {
      stop("r1 must have at least three columns: x, y, and one value column")
    }
    
    r1_df <- r1
    r1 <- terra::rast(r1[, 1:3], type = "xyz")
  } else if (!inherits(r1, "SpatRaster")) {
    r1 <- terra::rast(r1)
  }
  
  if (r2_is_df) {
    message("Second data file is a data frame")
    
    if (ncol(r2) < 3) {
      stop("r2 must have at least three columns: x, y, and one value column")
    }
    
    r2_df <- r2
    r2 <- terra::rast(r2[, 1:3], type = "xyz")
  } else if (!inherits(r2, "SpatRaster")) {
    r2 <- terra::rast(r2)
  }
  
  if (r1_is_df && r2_is_df) {
    message("Two data frames - Comparing coordinates and headers")
    
    if (nrow(r1_df) != nrow(r2_df)) {
      warning("The data frames have different numbers of rows")
      return(FALSE)
    }
    
    same_coordinates <- isTRUE(all.equal(r1_df[, 1:2], r2_df[, 1:2], check.attributes = FALSE))
    
    if (same_coordinates) {
      message("Coordinates verified")
    } else {
      warning("Please verify coordinates")
      return(FALSE)
    }
    
    d1 <- colnames(r1_df)[-(1:2)]
    d2 <- colnames(r2_df)[-(1:2)]
    
    if (length(d1) != length(d2)) {
      warning("The data frames have different numbers of value columns")
      return(FALSE)
    }
    
    if (length(d1) > 0 && length(d2) > 0) {
      if (d1[1] == d2[1]) {
        message("First date/header matches")
      } else {
        warning("First date/header does not match - Please verify")
      }
      
      if (d1[length(d1)] == d2[length(d2)]) {
        message("Final date/header matches")
      } else {
        warning("Final date/header does not match - Please verify")
      }
    }
  }
  
  same_extent <- isTRUE(all.equal(
    as.vector(terra::ext(r1)),
    as.vector(terra::ext(r2)),
    tolerance = 1e-9,
    check.attributes = FALSE
  ))
  
  if (same_extent) {
    message("Extent verified")
  } else {
    warning("Please verify raster extent")
    return(FALSE)
  }
  
  same_resolution <- isTRUE(all.equal(
    terra::res(r1),
    terra::res(r2),
    tolerance = 1e-9,
    check.attributes = FALSE
  ))
  
  if (same_resolution) {
    message("Resolution verified")
  } else {
    warning("Please verify raster resolution")
    return(FALSE)
  }
  
  if (terra::nrow(r1) != terra::nrow(r2) || terra::ncol(r1) != terra::ncol(r2)) {
    warning("Please verify raster rows and columns")
    return(FALSE)
  }
  
  message("Rows and columns verified")
  
  if (terra::nlyr(r1) != terra::nlyr(r2)) {
    warning("Please verify number of layers in raster")
    return(FALSE)
  }
  
  message("Number of layers verified")
  
  crs1 <- terra::crs(r1)
  crs2 <- terra::crs(r2)
  
  if (nzchar(crs1) && nzchar(crs2) && crs1 != crs2) {
    warning("Please verify coordinate reference systems")
    return(FALSE)
  }
  
  if (nzchar(crs1) && nzchar(crs2)) {
    message("Coordinate reference system verified")
  }
  
  return(TRUE)
}