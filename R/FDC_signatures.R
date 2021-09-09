#' 
#' @name 
#' FDC_signatures
#' 
#' @title 
#' Values and plot of Flow Duration Curve and Casper et al's Flow Duration Curve signatures.
#'
#' @description 
#' This function retrieves a three dimensioned list with the following content:
#'   1. The tabulated Flow Duration Curve of observed and simulated values of streamflow,
#'   2. The plotted Flow Duration Curve of observed and simulated values of streamflow,
#'   3. The computated Casper et al's Flow Duration Curve signatures of observed and simulated values of streamflow
#' 
#' Flow Duration Curves are computed with the following equation:
#'
#' \deqn{F(i) = \frac{m_{i} - a}{N + 1 - 2*a}}{%
#' F(i) = (m_i - a)/(N + 1 - 2*a)}
#' 
#' 
#' Where \eqn{F(i)} is the probability of excedence of the i-th values of streamflow when ordered from greater to
#' lower. \eqn{m_i} is the position of the value in the ranked streamflow. \eqn{N} is the total number of streamflow values.
#' \eqn{a} is a parameter which depends of the probability distribution of the streamflow. 
#' 
#' The value of each of the 5 Flow Duration Curve signatures proposed by Casper et al (2011) are 
#' used to measure the similarity between two Flow Duration Curves
#' (tipycally one observed and one simulated).
#' 
#' 1. BiasRR: Measure of the mean flow.
#' \deqn{BiasRR = (mean(FDC_sim) - mean(FDC_obs))/mean(FDC_obs) * 100}
#' 
#' Where \eqn{mean(FDC_sim)} is the mean value of the simulated values of streamflow 
#' and \eqn{mean(FDC_obs)} is the mean value of the observed values of streamflow
#' 
#' 2. BiasFDCmidslope: Measure of flashiness of the catchment.
#' \deqn{BiasRR = (mean(FDC_sim) - mean(FDC_obs))/mean(FDC_obs) * 100}
#' 
#' 3. BiasFHV: Measure of the higer values in the FDC.
#' *ecuación*
#' 
#' 4. BiasFLV: Measure of the lower values in the FDC.
#' *ecuación*
#' 
#' 5. BiasMM: Measure of the median values in the FDC.
#' *ecuación*
#'
#'
#' @param data A data frame with 2 columns. The first must be the observed values of the streamflow, 
#' the second must be the simulated values of the stream flow. 
#' @param a Is the a parámeter in the excedence probability eqation.
#' @param plot.p Optional. Is a string that contains the path where the user wnats to save the plotted
#' Flow Duration Curve as an image. If not provided the image will not be saved into computers memory.
#' @param int_func Optional. An integral function that has as inputs domain and range of the data to be
#' integrated. By defult a Gaussian cuadrature with 2 points is set.
#'
#' @return A 3 dimensioned list. 
#'
#' @author Christian David Rodríguez <chdrodriguezca@unal.edu.co> \cr
#' David Zamora <dazamoraa@unal.edu.co> \cr
#'
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - Sede Bogota
#' 
#' @export
#'
#' @examples 
#' library(DWBmodelUN)
#'library(raster)
#'library(tidyverse)
#'rm(list=ls())
#'# Load GRU and parameters
#'data(GRU, param)
#'cellBasins <- cellBasins(GRU, basins)
#'# Construction of parameter maps from values by GRU
#'GRU.maps <- buildGRUmaps(GRU, param)
#'alpha1_v <- GRU.maps$alpha1
#'alpha2_v <- GRU.maps$alpha2
#'smax_v <- GRU.maps$smax
#'d_v <- GRU.maps$d
#'# Establish the initial modeling conditions
#'init <- init_state(GRU.maps$smaxR)
#'g_v <- init$In_ground
#'s_v <- init$In_storage
#'rm(init)
#'# Load general characteristics of modeling
#'setup_data <- readSetup(Read = TRUE)
#'Dates <- seq(as.Date( gsub('[^0-9.]','',colnames(P_sogamoso)[3]), format = "%Y.%m.%d"), 
#'             as.Date(gsub('[^0-9.]','',tail(colnames(P_sogamoso),1)) , format = "%Y.%m.%d"), by = "month")
#'Start.sim <- which(Dates == setup_data[8,1]); End.sim <- which(Dates == setup_data[10,1])
#'# Sim.Period: the 1st two columns of the P and PET are the coordinates of the cells
#'Sim.Period <- c(Start.sim:End.sim)+2  
#'# Run DWB model
#'DWB.sogamoso <- DWBCalculator(P_sogamoso[ ,Sim.Period], 
#'                              PET_sogamoso[ ,Sim.Period],
#'                              g_v, s_v, alpha1_v, alpha2_v, smax_v, d_v)
#'# Compute monthly simulated runoff at stations
#'Esc.Sogamoso <- varBasins(DWB.sogamoso$q_total, cellBasins$cellBasins)
#'# Get area of El Tablazo subbasin
#'area       <- basins$AREAKM[which(basins$CODIGO_CAT == 24067010)]
#'# Compute monthly simulated and observed streamflow at ElTablazo
#'esc.sim <- Esc.Sogamoso$varAverage$`24067010`
#'caudal.sim <- esc.sim*area*(100/(3*86400))
#'esc.obs    <- EscSogObs$X24067010
#'caudal.obs <- esc.obs*area*(100/(3*86400))
#'# Acomodate data
#'data <- data.frame(Observed = caudal.obs, Simulated = caudal.sim)
#'# Get signatures
#'signatures <- FDC_signatures(data=data, a=3/8)
#' 
FDC_signatures <- function(data, a, plot.p=1, int_func=1) {
  # If there is no integral function, use defalut.
  if(int_func==1){
    int_func <- function(domain, image){
      a <- min(domain)
      b <- max(domain)
      cons <- (b - a)/2
      w1 <- 1
      w2 <- 1
      z1 <- -0.577350269; z2 <- z1*-1
      f <- splinefun(x=domain, y=image)
      f1 <- w1*f(z1*(b-a)/2 + (a+b)/2); f2 <- w2*f(z2*(b-a)/2 + (a+b)/2)
      I <- cons*(f1+f2)
      return(I)
    }
  }
  
  ##Rank the streamflow
  sorted <- apply(data, 2, sort, decreasing=T)
  
  ##Get the ranikngs
  rankings <- 1:dim(sorted)[1]
  
  ##Compute F(i)
  F_i = (rankings - a)/(tail(rankings,1) + 1 - 2*a)
  
  ##Create a summary data.frame
  FDCs <- data.frame(Obs = sorted[, 1], Sim = sorted[, 2], m = rankings, F_i = F_i)
  
  ## Plot FDC
  sf <- pivot_longer(FDCs, cols=c(1,2), names_to="Leyend", values_to="streamflow")
  plot <-ggplot(data = sf, aes(x=F_i, y=streamflow, col=Leyend)) +
    geom_line() + 
    scale_y_log10() +
    labs(title="Static Flow Duration Curve - Trial1", 
         subtitle="Station: El Tablazo") + 
    xlab("Excedence Probability") + 
    ylab("Streamflow (m3/s)")
    
  if (plot.p!=1){
    ggsave(file=plot.p, width = 4.5, height = 3.5)
  }
  
  
  ##Calculate BiasRR
  mean.val <- apply(FDCs, 2, mean)[c(1:2)]
  biasrr <- (mean.val[2] - mean.val[1])/mean.val[1] * 100
  
  ##Calculate Biasfdcmidslope
  log.flow  <- log10(FDCs[,c(1:2)])
  prob0.2 <- head(log.flow[FDCs[,4]>0.2,],1)
  prob0.7 <- tail(log.flow[FDCs[,4]<0.7,],1)
  diff  <- as.matrix(prob0.2 - prob0.7)
  midslope  <- (diff[2] - diff[1])/diff[1] * 100
  
  ##Calculate BiasFHV
  prob.inf   <- FDCs[FDCs[,4]<0.02, ]
  domain    <- prob.inf[,4]
  I          <- vector()
  for (j in 1:2){
    image <- pull(prob.inf, var=j)
    I[j] <- int_func(domain, image)
    names(I)[j] <- names(prob.inf)[j]
  }
  fhv <- (I[2] - I[1]) /I[1] * 100
  
  ##Calculate BiasFLV
  logq    <- log10(FDCs[FDCs[,4]>0.7,c(1:2)])
  qmin    <- apply(FDCs[,c(1:2)], 2, min)
  qmin.m  <- rep(qmin, dim(logq)[1])
  qmin.ma <- matrix(qmin.m, ncol=2, byrow=T) 
  logdif  <- logq - log10(qmin.ma)
  domain <- FDCs[FDCs[,4]>0.7,4]
  Il      <- vector()
  for (j in 1:2){
    image <- pull(logdif, var=j)
    Il[j] <- int_func(domain, image)
    names(Il)[j] <- names(logq)[j]
  }
  flv <- (Il[2] - Il[1]) /Il[1] * 100 
  
  ##Calculate BiasMM
  median <- apply(data, 2, median)[c(1:2)]
  biasmm <- (median[2] - median[1])/median[1] * 100
  
  signatures <- matrix(c(biasrr, midslope, fhv, flv, biasmm), ncol=1)
  rownames(signatures) <- c("BiasRR", "BiasFDCmidslope", "BiasFHV", "BiasFLV", "BiasMM")
  
  results <- list(FDCs = FDCs, signatures=signatures, static_plot=plot)
  return(results)
}



