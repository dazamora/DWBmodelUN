#' 
#' @name 
#' FDC_signatures
#' 
#' @title 
#' Values of Flow Duration Curve and Casper et al's Flow Duration Curve signatures.
#'
#' @description 
#' This function retrieves the Flow Duration Curve of observed and simulated values of streamflow.
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
#' @param data A data frame with 4 columns. The first must be the observed values of the streamflow, 
#' the second must be the simulated values of the stream flow, the third must be the ordinal value of
#' the streamflow when ordered from greater to lower and the forth column must be the probability of
#' excedence of the streamflow.
#' @param int_func Optional. An integral function that has as inputs domain and range of the data to be
#' integrated. By defult a Gaussian cuadrature with 2 points is set.
#'
#' @return A 2 dimensioned list. First entry the values of the FDCs. Second entry the values of de
#' FDC sigantures.
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
#' CDC_signatures(data)
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
  if (plot.p!=1){
    sf <- pivot_longer(FDCs, cols=c(1,2), names_to="Leyend", values_to="streamflow")
    ggplot(data = sf, aes(x=F_i, y=streamflow, col=Leyend)) + 
      geom_line() + 
      scale_y_log10()
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
  
  results <- list(FDCs = FDCs, signatures=signatures)
  return(results)
}



