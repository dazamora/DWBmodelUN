#' @name 
#' dds
#'  
#' @title
#' DDS algorithm to calibrate the model
#'
#' @description This function allows the user to calibrate the DWB or other model with the Dynamical Dimension Search (DDS) algorithm \cite{(Tolson & Shoemaker, 2007)}.
#' As the calibration is performed based on a single value, one should average or create a scalar with the evaluation made in all
#' the streamflow stations, or other variables, between the observed and the simulated values.
#' 
#' @param xBounds.df must be a dataframe which defines the parameter range for searching, with 1st column as minimum and 2nd column as maximum of the parameter space
#' @param numIter is an integer that defines the total number of simulations so as to calibrate de model
#' @param iniPar is a vector which contains an optional initial parameter set
#' @param r is a double between 0 and 1 which defines the range of searching in the DDS algoritm, the default value is 0.2
#' @param OBJFUN is a function which returns a scalar value, for which we are trying to minimize. In this case the scalar is
#' the Objective Function used to evaluate the model performance
#' @param ... other variables and datasets needed to run the model
#'
#' @return outputs.df is a four entry list, containing X_BEST, Y_BEST, X_TEST and Y_TEST, as they evolve over numIter iterations.
#' X_BEST and Y_BEST are the parameters found by the algoritm, parameters which produce a good value of the Objective Function Y_BEST.
#' X_TEST and Y_TEST are the evaluated parameters and their respective performance value.
#' 
#' @author Nicolas Duque Gardeazabal <nduqueg@unal.edu.co>
#' Pedro Felipe Arboleda Obando <pfarboledao@unal.edu.co> 
#' Carolina Vega Viviescas <cvegav@unal.edu.co> 
#' David Zamora <dazamoraa@unal.edu.co>
#' 
#' Water Resources Engineering Research Group - GIREH
#' Universidad Nacional de Colombia - sede Bogotá
#' 
#' @export
#'
#' @references Tolson, B. A., & Shoemaker, C. A. (2007). Dynamically
#' dimensioned search algorithm for computationally efficient watershed
#' model calibration. Water Resources Research, 43(1), 1-16.
#' https://doi.org/10.1029/2005WR004723
#'
#' @examples
#' 
#' # Load P and PET databases
#' data(P_sogamoso, PET_sogamoso)
#' # Not run {meteo <- upForcing(path_p = "./precip/", path_pet = "./pet/", file_type = "raster", format = "NCDF")}
#' 
#' # Verify that the coordinates of the databases match
#' Coord_comparison(P_sogamoso, PET_sogamoso)
#' 
#' # Load geographic info of GRU and basins where calibration will be performed
#' data(GRU,basins)
#' cellBasins <- cellBasins(GRU, basins)
#' 
#' # Establish the initial modeling conditions
#' # if you would like to upload the initial state variables provided in this example, create a "/in_state/" directory and print the following files in that path
#' # writeRaster(In_storage,"./in_state/in_storage.tif",format="GTiff"); writeRaster(In_ground,"./in_state/in_groundwater.tif",format="GTiff")
#' GRU.maps <- buildGRUmaps(GRU, param)
#' init <- init_state(GRU.maps$smaxR, "/in_state/")
#' g_v <- init$In_ground
#' s_v <- init$In_storage
#' rm(init)
#' 
#' # Load general characteristics of modeling
#' setup_data <- readSetup(Read = TRUE)
#' Dates <- seq(as.Date(colnames(P_sogamoso)[3],format="%Y.%m.%d"), as.Date(tail(colnames(P_sogamoso),1),format="%Y.%m.%d"), by="month")
#' 
#' # For this calibration exercise, the last date of simulation is the same as the final date of calibration
#' Start.sim <- which(Dates==setup_data[8,1]); End.sim <- which(Dates==setup_data[11,1])
#' Sim.Period <- c(Start.sim:End.sim)+2  # the first two columns of the P and PET are the coordinates of the cells
#' Start.cal <- which(Dates==setup_data[9,1]); End.cal <- which(Dates==setup_data[11,1])
#' Cal.Period <- c(Start.cal:End.cal)+2  # the first two columns of the P and PET are the coordinates of the cells
#' 
#' #Load observed runoff
#' data(EscSogObs)
#' 
#' #### Function that runs the DWB model ####
#' NSE_Sogamoso_DWB <- function(parameters, P, PET, g_v,s_v, Sim.Period, EscObs, Cal.Period){
#' 
#' parameters <- as.vector(parameters)
#' param <- matrix(parameters, nrow= cellStats(GRU,stat="max"))  # Transform the parameters to the format that the model needs
#' 
#' # Construction of parameter maps from values by GRU
#' GRU.maps <- buildGRUmaps(GRU, param)
#' alpha1_v <- GRU.maps$alpha1
#' alpha2_v <- GRU.maps$alpha2
#' smax_v <- GRU.maps$smax
#' d_v <- GRU.maps$d
#' DWB.sogamoso <- DWBCalculator(P_sogamoso[, Sim.Period], PET_sogamoso[, Sim.Period], g_v,s_v,alpha1_v,alpha2_v,smax_v,d_v, calibration = T)
#' Esc.Sogamoso <- varBasins(DWB.sogamoso$q_total, cellBasins$cellBasins)
#' 
#' # model evaluation; in case of possible NA results in the simulation, add a conditional assingment to a very high value
#' Perf <- (-1)*hydroGOF::NSE(Esc.Sogamoso$varProm[Cal.Period,],EscSogObs[Cal.Period,])
#' if( !is.na(mean(Perf))){ Mean.Perf <- mean(Perf)} else{ Mean.Perf <- 1e100}
#' return(Mean.Perf)
#' }
#' 
#' # coupling with the DDS algorithm
#' xBounds.df <- data.frame(lower=rep(0,times=40), upper=c(rep(1,times=30),rep(2000,times=10)))
#' result <- dds(xBounds.df = xBounds.df, numIter=200, OBJFUN=NSE_Sogamoso_DWB,
#'         P=P_sogamoso, PET=PET_sogamoso, g_v=g_v,s_v=s_v, Sim.Period=Sim.Period, EscObs=EscSogObs, Cal.Period=Cal.Period)
#' 
dds <- function(xBounds.df, numIter,iniPar=NA, r = 0.2, OBJFUN, ...){

  # Format xBounds.df colnames
  colnames(xBounds.df) <- c("min", "max")
  # Generate initial first guess
  #xBounds.df<-data.frame(col1 = rep(10,10), col2=rep(100, 10))
  if (is.na(iniPar[1])){  # identification of initial parameters
    x_init <- apply(xBounds.df, 1, function(x) runif(1, x[1], x[2]))
  }else{
    x_init <- as.numeric(iniPar)
  }
  
  x_best <- data.frame(x=x_init)
  x_test <- data.frame(x=x_init)
  
  # Evaluate first cost function
  y_init<-OBJFUN(x_init, ...)
  y_test<-y_init
  y_best<-y_init
  
  # Select which entry to peturb at each iteration
  xDims<-nrow(xBounds.df)
  Prob<-matrix(1-log(1:numIter)/log(numIter),ncol=1) # Returns numIter length list of entries to be peturbed
  peturbIdx<-apply(t(apply(Prob,1, function(x) as.logical(rbinom(xDims, 1, x)))), 1, which)
  # identify where it is not changing any parameter and assign one ramdomly
  Correct.Peturb<-which( unlist( lapply(peturbIdx,sum) ) ==0)
  peturbIdx[Correct.Peturb]<-sample(1:xDims, length(Correct.Peturb), replace=T)
  
  # Peturb each entry by N(0,1)*r(x_max - x_min) reflecting if @ boundaries
  sigma<-xBounds.df$max - xBounds.df$min
  
  pb1<-txtProgressBar(style=3)
  for (i in 2:numIter){
    setTxtProgressBar(pb1,i/numIter,title=paste(i/numIter,"% of Calibration"))
    # Set up test x
    x_test[,i]<-as.matrix(x_best)
    
    # Get entries we will peturb
    idx<-peturbIdx[[i]]
    
    # Initialize vector of peturbations initially zeros with same length of x so we will add this vector to peturb x
    peturbVec<-rep(0, nrow(x_test[,i]))
    # Generate the required number of random normal variables
    N<-rnorm(nrow(x_test[,i]), mean=0, sd=1)
    
    # Set up vector of peturbations
    peturbVec[idx]<-r*N[idx]*sigma[idx]
    
    # Temporary resulting x value if we peturbed it
    x_test[,i]<-x_test[,i] + peturbVec  
    
    # Find the values in testPeturb that have boundary violations.
    B.Vio.min.Idx<-which(x_test[,i] < xBounds.df$min)
    B.Vio.max.Idx<-which(x_test[,i] > xBounds.df$max)
    
    # Correct them by mirroring set them to the minimum or maximum values
    x_test[B.Vio.min.Idx,i]<-xBounds.df$min[B.Vio.min.Idx] + ( xBounds.df$min[B.Vio.min.Idx] - x_test[B.Vio.min.Idx,i] )
    set.min<- B.Vio.min.Idx[ x_test[B.Vio.min.Idx,i] > xBounds.df$max[B.Vio.min.Idx] ]  # which are still out of bound
    x_test[ set.min, i]<- xBounds.df$min[set.min]
    
    x_test[B.Vio.max.Idx,i]<-xBounds.df$max[B.Vio.max.Idx] - ( x_test[B.Vio.max.Idx,i] - xBounds.df$max[B.Vio.max.Idx] )
    set.max<- B.Vio.max.Idx[ x_test[B.Vio.max.Idx,i] < xBounds.df$min[B.Vio.max.Idx] ]
    x_test[ set.max, i]<- xBounds.df$max[set.max]
    
    # Evaluate objective function
    y_test[i]<-OBJFUN(x_test[,i], ...)
    
    y_best<-min(c(y_test[i], y_best))
    bestIdx<-which.min(c(y_test[i], y_best))
    x_choices<-cbind(x_test[,i], as.matrix(x_best))
    x_best<-x_choices[,bestIdx]
  }
  close(pb1)
  
  output.list<-list(X_BEST=t(x_best), Y_BEST=y_best, X_TEST=t(x_test), Y_TEST=y_test)
  return(output.list)
}