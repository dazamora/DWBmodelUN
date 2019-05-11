#' Title
#'
#' @param p_v 
#' @param etp_v 
#' @param g_v 
#' @param s_v 
#' @param alpha1_v 
#' @param alpha2_v 
#' @param smax_v 
#' @param d_v 
#'
#' @return
#' @export
#'
#' @examples
dwbCalculator<-function(p_v,etp_v,g_v,s_v,alpha1_v,alpha2_v,smax_v,d_v){
  # se reciben todas las variables en formato vectorial, incluso los parametros del modelo
  
  
  #Definición del xo para el tiempo 0
  xo<-matrix(nrow=NROW(p_v),ncol = NCOL(p_v))
  ## Definición de X para el tiempo 0
  x<-matrix(nrow=NROW(p_v),ncol = NCOL(p_v))
  #Definición de escorrentía directa para el tiempo 0
  qd<-matrix(nrow=NROW(p_v),ncol = NCOL(p_v))
  # Definición de disponibilidad de agua para el tiempo 0
  w<-matrix(nrow=NROW(p_v),ncol = NCOL(p_v))
  # Definición de oportunidad de transpiración max para el tiempo 0
  yo<-matrix(nrow=NROW(p_v),ncol = NCOL(p_v))
  #Definición de oportunidad de transpiración para el tiempo 0
  y<-matrix(nrow=NROW(p_v),ncol = NCOL(p_v))
  #Definición de recarga para el tiempo 0
  r<-matrix(nrow=NROW(p_v),ncol = NCOL(p_v))
  #Definición de ET real
  et_r<-matrix(nrow=NROW(p_v),ncol = NCOL(p_v))
  #Definición de humedad de la zona de raices para el t 0
  s<-matrix(nrow=NROW(p_v),ncol = NCOL(p_v))
  #Definición de escorrentía base para el tiempo 0
  qb<-matrix(nrow=NROW(p_v),ncol = NCOL(p_v))
  #Definición de almac. subterran. para el tiempo 0
  g<-matrix(nrow=NROW(p_v),ncol = NCOL(p_v))
  #Definición de escorrentía total para el tiempo 0
  q_total<-matrix(nrow=NROW(p_v),ncol = NCOL(p_v))
  #Definición Celdas y Días
  nceldas<-NROW(p_v)
  nmeses<-NCOL(p_v)
  
  #Calculo de Escorrentía y ET para t=1
  dummy<-smax_v-s_v
  xo[,1]<-dummy+etp_v[,1]
  x[,1]<-p_v[,1]*fun_FU(numerador = xo[,1],denominador = p_v[,1],param = alpha1_v)
  qd[,1]<-p_v[,1]-x[,1]
  w[,1]<-x[,1]+s_v
  yo[,1]<-etp_v[,1]+smax_v
  y[,1]<-w[,1]*fun_FU(numerador = yo[,1],denominador = w[,1],param = alpha2_v)
  r[,1]<-w[,1]-y[,1]
  et_r[,1]<-w[,1]*fun_FU(numerador = etp_v[,1],denominador = w[,1],param = alpha2_v)
  s[,1]<-y[,1]-et_r[,1]
  qb[,1]<-d_v*g_v
  g[,1]<-(1-d_v)*g_v+r[,1]
  q_total[,1]<-qb[,1]+qd[,1]
  
  #Loop para terminar cálculo de escorrentía para el resto de días
  pb <- txtProgressBar(min = 0, max = nmeses, style = 3)
  for(i in 2:nmeses){
    
    dummy<-smax_v-s[,(i-1)]
    xo[,i]<-dummy+etp_v[,i]
    x[,i]<-p_v[,i]*fun_FU(numerador = xo[,i],denominador = p_v[,i],param = alpha1_v)
    qd[,i]<-p_v[,i]-x[,i]
    w[,i]<-x[,i]+s[,(i-1)]
    yo[,i]<-etp_v[,i]+smax_v
    y[,i]<-w[,i]*fun_FU(numerador = yo[,i],denominador = w[,i],param = alpha2_v)
    r[,i]<-w[,i]-y[,i]
    et_r[,i]<-w[,i]*fun_FU(numerador = etp_v[,i],denominador = w[,i],param = alpha2_v)
    s[,i]<-y[,i]-et_r[,i]
    qb[,i]<-d_v*g[,(i-1)]
    g[,i]<-(1-d_v)*g_v+r[,i]
    q_total[,i]<-qb[,i]+qd[,i]
    
    
    setTxtProgressBar(pb, i)
  }
  close(pb)
  dwb_aux<-list(q_total,et_r,r,qd,qb,s)
  return(dwb_aux)
  
  
}