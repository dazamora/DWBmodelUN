routing <- function(ndays, qd,qb, q_total, x4_v, cell_Basins){
  x4_v <- cellStats(x4_v, "mean")
  qd_routing <- varBasins(qd, cell_Basins$cellBasins)
  qb_routing <- varBasins(qb, cell_Basins$cellBasins)
  qt_routing <- varBasins(q_total, cell_Basins$cellBasins)
  
   for(x in 1:length(qd_routing$varAverage) ){
     
     for(j in 1:ndays){
      orduh2 <- do.call(cbind,UH(branch = 2, NH = round(x4_v)+5, C=x4_v))
      steps <- max(1, round(2*(max(x4_v)+5)-1))
      h2 <- vector("numeric", length  = steps+1)
      for(k in 1:steps){
        h2[k] <- h2[k+1] + orduh2[k]*qd_routing$varAverage[[x]][j]
      }
      h2[(steps+1)] <- orduh2[steps+1]*qd_routing$varAverage[[x]][j]
      
      qd_routing$varAverage[[x]][j] <- unlist(lapply(h2[1], function(x){max(0,x)}))
      
      orduh1 <- do.call(cbind,UH(branch = 1, NH = round(x4_v)+5, C=x4_v))
      steps <- max(1, (max(x4_v)+5)-1)
      h1 <- vector("numeric", length  = steps+1)
      for(k in 1:steps){
        h1[k] <- h1[k+1] + orduh1[k]* qb_routing$varAverage[[x]][j]
      }
      h1[(steps+1)] <- orduh1[(steps+1)]*qb_routing$varAverage[[x]][j]
      qb_routing$varAverage[[x]][j] <- unlist(lapply(h1[1], function(x){max(0,x)}))
      
      qt_routing$varAverage[[x]][j] <- qb_routing$varAverage[[x]][j] + qd_routing$varAverage[[x]][j]
      
    }
    
  }
  
  q_routing <- list(qd=qd_routing, qb=qb_routing, qt=qt_routing)
  
 return(q_routing)
}
