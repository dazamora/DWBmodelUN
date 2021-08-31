#' Under development 
#'
#' @title
#' DDS algorithm to calibrate the model with approximation of uncertainty
#'
#' @description This function allows the user to calibrate the DWB or other models with the Dynamical Dimension Search (DDS) algorithm \cite{(Tolson & Shoemaker, 2007)}.
#' As the calibration is performed based on a single value, one should average or create a scalar to evaluate the model's performance. The evaluation can be made using all
#' the streamflow stations, or other variables, between the observed and the simulated values.
#' 
#' @param xBounds.df must be a dataframe which defines the parameter range for searching, with 1st column as the minimum and 2nd column as the maximum of the parameter space.
#' @param numIter is an integer that defines the total number of simulations so as to calibrate the model.
#' @param numBeh is an integer which defines the number of independent DDS and the maximum number of behavioural threshold.
#' @param per.m.dds is a double which indicates the percentage that affects the computational budget of each independent DDS.
#' @param threshold is a double which classifies the parameter sets in non-behavioural or behavioural.
#' @param r is a double between 0 and 1 which defines the range of searching in the DDS algorithm, the default value is 0.2. 
#' @param OBJFUN is a function which returns a scalar value which one is trying to minimize. In this case, the scalar is
#' the Objective Function used to evaluate the model performance.
#' @param ... other variables and datasets needed to run the model.
#'
#' @return A list that cointains two more list. The first one contains the behavioural sets of parameters and their respective
#' objective function value, and the second one contains all the simulations classified by the independent DDS number.
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
dds_au<-function(xBounds.df, numIter, numBeh, per.m.dds, threshold, r = 0.2, OBJFUN, ...){
  # Format xBounds.df and BoundsIter.df colnames
  colnames(xBounds.df)<-c("min", "max")
   
  # Define the number of models evaluations per DDS and ramdomize them around a general number
  m.dds<-round(numIter/numBeh)
  numSearch<-runif(numBeh, m.dds - per.m.dds*m.dds , m.dds + per.m.dds*m.dds)
  
  # Smart Round the values for the m.dds randomly generated
  numSearch <- round(numSearch / sum(numSearch) * numIter)
  deviation <- numIter - sum(numSearch)
  for (. in seq_len(abs(deviation))) {  # adds one to some entries to complete the values
    numSearch[i] <- numSearch[i <- sample(numBeh, 1)] + sign(deviation)
  } 

  all.sim<-list() # initialize the variable where all results will be
  Behavioural<-list()  # initialize the variable wehere only the behavioural will be
  Behavioural[["Param"]]<-as.data.frame(matrix(NA, ncol=nrow(xBounds.df), nrow=numBeh))
  Behavioural[["Obj.Fun."]]<-vector()
  
  # initialize the initial first guess
  x_init<-apply(xBounds.df, 1, function(x) runif(numBeh, x[1], x[2]))  
  
  for (i in 1:numBeh){
    print(paste("Percentage of independent DDS excecuted",i/numBeh*100,"% done"))
    
    all.sim[[i]]<-dds(xBounds.df, numSearch[i], iniPar= as.vector(x_init[i,]), r = r, OBJFUN, ...)  # Perform the independent DDS
    
    # Identification of the behavioral sets of parameters
    if (tail(all.sim[[i]][[2]],1) <= threshold){
      Behavioural[["Param"]][i,]<-tail(all.sim[[i]][[1]],1)
      Behavioural[["Obj.Fun."]][i]<-tail(all.sim[[i]][[2]],1)
    }else{
      Behavioural[["Param"]][i,]<-matrix(NA, ncol=ncol(all.sim[[i]][[1]]), nrow=1)
      Behavioural[["Obj.Fun."]][i]<-NA
    }
    
  }
  
  output<-list(Behavioural= Behavioural, all.sim= all.sim)
  return(output)

}
