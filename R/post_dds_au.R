#' Under development 
#'
#' @title
#' Algorithm to 
#'
#' @description This function allows the user to calibrate the DWB or other models with the Dynamical Dimension Search (DDS) algorithm \cite{(Tolson & Shoemaker, 2007)}.
#' As the calibration is performed based on a single value, one should average or create a scalar to evaluate the model's performance. The evaluation can be made using all
#' the streamflow stations, or other variables, between the observed and the simulated values.
#' 
#' @param Behavioral is a list containing the first result from the output of the function dds_au.R
#' @param all.sim is a list containing the second result from the output of the function dds_au.R
#' @param obs is a vector containing the streamflow observations.
#' @param dates is a dataframe containing the dates of begining and ending of the observations and simulations, and the time interval
#' @param MODEL.FUN is a function which returns a vector with the simulated streamflow values.
#'
#' @return A list that contains the new behavioral sets of parameters.
#' 
#' @author Nicolas Duque Gardeazabal <nduqueg@unal.edu.co>  \cr
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co>  \cr
#' Carolina Vega Viviescas <cvegav@unal.edu.co>  \cr
#' David Zamora <dazamoraa@unal.edu.co> \cr
#' Camila Garcia-Echeverri <cagarciae@unal.edu.co> \cr
#' 
#' 
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - sede Bogota
#' 
#' @export
#'
#' @references Tolson, B. A., and C. A. Shoemaker (2008), Efficient prediction uncertainty approximation in 
#' the calibration ofenvironmental simulation models, Water Resour. Res., 44, W04411, doi:10.1029/2007WR005869.
#'
#' @examples
#' 
#' 
post_dds_au <- function(Behavioral, all.sim, obs, dates, MODEL.FUN, ...){
  
  ntimes<-length(obs)
  Qsim<-matrix(NA, ncol= nrow(Behavioral[["Param"]]), nrow= ntimes)
  
  # create the simulated timeseries with the behavioral sets of parameters
  for (i in 1:nrow(Behavioral[["Param"]])){
    
    if(sum(is.na(Behavioral[["Param"]][i,]))==0){
      Qsim[,i]<-MODEL.FUN(Behavioral[["Param"]][i,], ...)
    }
  }
  
  
  # calculation of prediction Bounds
  Bounds<-as.data.frame(matrix(NA, nrow=ntimes, ncol=3))
  for (j in 1:ntimes){
    Bounds[j,1]<-min(Qsim[j,],na.rm=T)
    Bounds[j,2]<-mean(Qsim[j,],na.rm=T)
    Bounds[j,3]<-max(Qsim[j,],na.rm=T)
  }
  Bounds.Stats<-list()  # Bounds statistics
  Bounds.Stats[["Mean.Width"]]<-mean(Bounds[,3]-Bounds[,1],na.rm=T)
  Bounds.Stats[["Max.Width"]]<-max(Bounds[,3]-Bounds[,1],na.rm=T)
  Bounds.Stats[["Min.Width"]]<-min(Bounds[,3]-Bounds[,1],na.rm=T)
  Bounds.Stats[["Countaning.R"]]<-sum( obs<=Bounds[,3] & obs>=Bounds[,1], na.rm=T )/ntimes*100
  Bounds.Stats[["Avg.Dev.Amp"]]<-sum( abs( Bounds[,2]-obs ), na.rm=T )/ntimes
  
  # data and bound graphs
  dates.v<-seq(as.Date(dates[1,1]), as.Date(dates[2,1]), by=dates[3,1])
  data<-as.data.frame(cbind(dates.v, Bounds,obs));colnames(data)<-c("Date","Min","Mean","Max","Obs")
  
  
  p<-ggplot(data=data)
  print(p+
          geom_ribbon(aes(x=Date,ymin=Min,ymax=Max,fill="Unc. Bound"),alpha=0.4)+
          scale_fill_manual(values="blue")+
          geom_line(aes(x=Date,y=Obs,col="Qobs"))+scale_color_manual(values="blue")+
          ylim(0,max(obs,na.rm=T))+theme(legend.title = element_blank())+
          ggtitle("Simulations uncertainty bounds and measurements",
                  sub="DDS-AU and observed data")+
          theme_bw()
  )
  
  output<-list(data,Bounds.Stats)
  return(output)
}