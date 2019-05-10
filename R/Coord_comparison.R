#' Title
#'
#' @param r1 
#' @param r2 
#'
#' @return
#' @export
#'
#' @examples
#' 
Coord_comparison<-function(r1, r2){
  er1<-extent(r1)
  er2<-extent(r2)
  if(er1==er2){
    print("Extensi?n verificada")
    if(res(r1)[1]==res(r2)[1]&res(r1)[2]==res(r2)[2]){
      print("Resoluci?n verificada")
      if (nlayers(r1)==nlayers(r2)){
        print("Longitud verificada")
        return(TRUE)
        #if(sum(!is.na(r1[[1]]))==sum(!is.na(r2[[1]]))){
        #print("Celdas con valor verificadas")
        
        #}else{
        # print("Verificar celdas con valor")
        #return(FALSE)
        #}
        
      }else{
        print("Verificar la longitud de las series")
        return(FALSE)
      }
      
    }else{
      print("Info. geogr?fica no est? en la misma resoluci?n")
      return(FALSE)
    }
    
  }else{
    print("Informaci?n geogr?fica no est? en las mismas coordenadas")
    
  }
}