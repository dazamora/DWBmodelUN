#' @name 
#' Raster coordinates comparison
#' 
#' @Title
#' Raster coordinates comparison
#' 
#' @description This function compares three characteristicas from two rasters: 
#' coordinates, resolution, and number of layers (if the rasters have more than one) 
#' from two different rasters stacks, and let to know if they are using the same geographical info.,
#' or if new set-up should be done
#' 
#' @param r1 raster or data frame. If it is a data frame, it should put in the two first columns, the X, Y 
#' coordinates for every point, in GEOGRAPHIC COORDINATES, the third column and so on should have the variable values,
#' and optinally, the header should have the date, using the format "%m/%Y"
#' @param r2 raster or data frame. If it is a data frame, it should put in the two first columns, the X, Y 
#' coordinates for every point, in GEOGRAPHIC COORDINATES, the third column and so on should have the variable values,
#' and optinally, the header should have the date, using the format "%m/%Y"
#'
#' @return It prints to console if the two rasters are on the same coordinates or not, and return
#' a boolean, TRUE if the rasters are on the same coordinates, and FALSE if not
#' 
#' @export
#'
#' @author 
#' Nicolas Duque Gardeazabal <nduqueg@unal.edu.co> 
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co> 
#' Carolina Vega Viviescas <cvegav@unal.edu.co>
#' David Zamora <dazamoraa@unal.edu.co>
#' 
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - sede Bogotá
#' 
#' @examples
#' # library(raster)
#' data(P_sogamoso,PET_sogamoso)
#' Coord_comparison(P_sogamoso,PET_sogamoso)
#' 
Coord_comparison <- function(r1, r2){
  #Verify if r1 is data frame, if it is, convert to raster
  if (is.data.frame(r1)) {
    print("First data file is a data frame - Converting to raster")
    rummy <- raster::rasterFromXYZ(r1[ ,1:3])
    a1 <- r1
    r1 <- rummy
  }
  
  #Verify if r2 is data frame, if it is, convert to raster
  if (is.data.frame(r2)) {
    print("Second data file is a data frame - Converting to raster")
    rummy <- raster::rasterFromXYZ(r2[ ,1:3])
    a2 <- r2
    r2 <- rummy
  }
  
  # If the two inputs are data frames, the dates in the headers are compared
  # Careful!! The model will keep running even if the two headers does not match, but
  # there will be a warning
  # This code also compares number of columns. If the first date match, and the number of columns match
  # the code assumes that the final data match too
  if (is.data.frame(a2) & is.data.frame(a1)) {
    print("Two data frames - Comparing headers")
    d1 <- colnames(a1)[-(1:2)]
    d2 <- colnames(a2)[-(1:2)]
    if (d1[1] == d2[1]) {
      print("First date is matching")
      if (d1[length(d1)] == d2[length(d2)]) {
        print("First date and final date are matching")
      }else{
        print("First date is matching, but final date is not matching - Please verify")
      }
    }else{
      print("First date is not matching according to the header")
      print("The model will run, but a warning is being raising - Please verify dates")
    }
    
  }
}

