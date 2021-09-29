#' Under development 

KGE_OF_wapaba_MP <- function(parameters, P, PET, g_v,s_v, Sim.Period, EscObs, Cal.Period,Heat.Period=NA, GRU){
  # Vectorizar parámetros
  parameters <- as.vector(parameters)
  
  # Transform the parameters to the format that the model needs
  param <- matrix(parameters, nrow = raster::cellStats(GRU,stat="max"))  
  
  # Construction of parameter maps from values by GRU
  GRU.maps <- buildGRUmaps_wapaba(GRU, param)
  alpha1_v <- GRU.maps$alpha1
  alpha2_v <- GRU.maps$alpha2
  smax_v   <- GRU.maps$smax
  k_v      <- GRU.maps$k
  beta_v      <- GRU.maps$beta
  
  # Calcular condiciones iniciales de los tanques
  init     <- init_state(raster=GRU.maps$smaxR)
  g_v      <- init$In_ground
  s_v      <- init$In_storage
  rm(init)
  
  # Correr el modelo
  if(is.na(Heat.Period[1])){
  Wapaba.result <- Wapaba(p_v=P[ ,(Cal.Period)], pet_v=PET[ ,(Cal.Period)],
                                g_v,s_v, alpha1_v, alpha2_v, smax_v,k_v, beta_v,calibration = T)
  }else{
  Wapaba.result <- Wapaba(p_v=P[ ,c(Heat.Period,Cal.Period)], pet_v=PET[ ,c(Heat.Period,Cal.Period)],
                                  g_v,s_v, alpha1_v, alpha2_v, smax_v,k_v,beta_v, calibration = T)
  }
  # Agrupar la escorrentía por cada estación
  Esc.result <- varBasins(Wapaba.result$q_total, cell_Basins$cellBasins)

  # Remover fechas del periodo de calentamiento 
  if(is.na(Heat.Period[1])){
    sim <- Esc.result$varAverage
    obs  <- as.data.frame(EscObs[Cal.Period-2,])
  } else{
    a <- length(Heat.Period)
    b <- 1:a
    sim <- Esc.result$varAverage[-b,]
    obs  <- as.data.frame(EscObs[Cal.Period-2-length(Heat.Period),])
  }
  
  
  # PROVISIONAL-PLOTEADO DE HIDROGRAFAS POR CADA ITERACION
  # Para todos puntos de control
  #graf <- data.frame(fecha=Dates[Cal.Period-2], sim=sim$`24037300`, obs=obs$X24037300)
  
  # graf <- graf %>% 
  #   pivot_longer(cols=c(2,3), names_to="tipo", values_to="valor")
  
  # ggplot(data=graf, aes(x=fecha, y=valor, col=tipo))+
  #   geom_line()+
  #   labs(title="estacion 24037300")
  
  # ggsave("/Users/carlos/Desktop/GSUS4/5_Universidad/DWB/TESIS/INSUMOS/temporales/experimento_dos/hidrografas/hidro.png", height=5, width=6)
  
  # Sacar estaciones que no tienen datos en el periodo de análisis
  Sum.NAs <- apply(obs,2, function(x) sum(is.na(x)))
  Comp    <- length(Cal.Period) == Sum.NAs
  ind <- which(Comp == T)
  if(length(ind)!=0){
    sim <- sim[,-ind]
    obs <- obs[,-ind]
  }else{
    sim <- sim
    obs <- obs
  }
  
  # Calculo de la función objetivo
  if (sum(!is.na(sim)) == prod(dim(sim))){
    kge.cof <- vector()
    for (i in 1:length(sim)){
      vec.obs <- dplyr::pull(obs, i)
      vec.sim <- dplyr::pull(sim, i)
      ind <- which(is.na(vec.obs))
      if(length(ind)!=0){
        vec.obs <- vec.obs[-ind]
        vec.sim <- vec.sim[-ind]
      }
      length(vec.sim) == length(vec.obs)
      
      alfa   <- sd(vec.sim)/sd(vec.obs)
      beta   <- mean(vec.sim)/mean(vec.obs)
      erre <- cor(vec.sim, vec.obs, method="pearson")
      
      kge.cof[i] <- 1 - sqrt((erre - 1)^2 + (alfa - 1)^2 + (beta - 1)^2)
      names(kge.cof)[i] <- names(sim)[i]
    }
    
    #kge.cof <- hydroGOF::KGE(sim, obs, na.rm=T)
  } else {
    kge.cof <- NA
  }
  
  if(length(which(is.nan(kge.cof)))!=0){
    warning(paste("Hay", length(which(is.nan(kge.cof))), "estaciones con NaN. Problema de Inf"))
    kge.cof <- kge.cof[-which(is.nan(kge.cof))]
  }
  
  Perf <- (-1)*kge.cof
  if(!is.na(mean(Perf))){ 
    Mean.Perf <- mean(Perf)
  } else {Mean.Perf <- 1e100}
  return(Mean.Perf)
}
