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
#' @param r1 
#' @param r2 
#'
#' @return It prints to console if the two rasters are on the same coordinates or not, and return
#' a boolean, TRUE if the rasters are on the same coordinates, and FALSE if not
#' @export
#'
#' @author 
#' Nicolas Duque Gardeazabal <nduqueg@unal.edu.co> 
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co>
#' David Andres Zamora Avila<dazamoraa@unal.edu.co>
#' Carolina Vega Viviescas <cvegav@unal.edu.co>
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - sede Bogotá
#' @examples
#' 
Coord_comparison<-function(r1, r2){
  er1<-extent(r1)
  er2<-extent(r2)
  if(er1==er2){
    print("Coordinates verified")
    if(res(r1)[1]==res(r2)[1]&res(r1)[2]==res(r2)[2]){
      print("Resolution verified")
      if (nlayers(r1)!=1 & nlayers(r2)!=1)
        if (nlayers(r1)==nlayers(r2)){
        print("Number of layers verified")
        return(TRUE)
        #if(sum(!is.na(r1[[1]]))==sum(!is.na(r2[[1]]))){
        #print("Celdas con valor verificadas")
        
        #}else{
        # print("Verificar celdas con valor")
        #return(FALSE)
        #}
        
        }else{
        print("Please verify number of layers")
        return(FALSE)
      }
      
    }else{
      print("Please verify raster resolution")
      return(FALSE)
    }
    
  }else{
    print("Please verify raster coordinates")
    
  }
}